package com.newsmanagement.controller;

import com.newsmanagement.entity.News;
import com.newsmanagement.entity.User;
import com.newsmanagement.service.NewsService;
import com.newsmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.Optional;

/**
 * 新闻控制器
 */
@Controller
@RequestMapping("/news")
public class NewsController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private UserService userService;

    /**
     * 新闻列表页面
     */
    @GetMapping
    public String newsList(@RequestParam(value = "category", required = false) String category,
                          @RequestParam(value = "page", defaultValue = "0") int page,
                          @RequestParam(value = "size", defaultValue = "10") int size,
                          Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<News> newsPage;

        if (category != null && !category.isEmpty()) {
            try {
                News.NewsCategory newsCategory = News.NewsCategory.valueOf(category.toUpperCase());
                newsPage = newsService.findPublishedNewsByCategory(newsCategory, pageable);
                model.addAttribute("selectedCategory", newsCategory);
            } catch (IllegalArgumentException e) {
                newsPage = newsService.findPublishedNews(pageable);
            }
        } else {
            newsPage = newsService.findPublishedNews(pageable);
        }

        model.addAttribute("newsPage", newsPage);
        model.addAttribute("categories", News.NewsCategory.values());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", newsPage.getTotalPages());
        model.addAttribute("categoryStats", newsService.getCategoryStatistics());

        return "news/list";
    }

    /**
     * 新闻详情页面
     */
    @GetMapping("/{id}")
    public String newsDetail(@PathVariable Long id, Model model) {
        try {
            News news = newsService.viewNews(id);
            if (!news.getPublished()) {
                // 未发布的新闻只有作者和管理员可以查看
                return "error/404";
            }
            
            model.addAttribute("news", news);
            
            // 获取相关新闻（同分类的其他新闻）
            Pageable pageable = PageRequest.of(0, 5, Sort.by("createdAt").descending());
            Page<News> relatedNews = newsService.findPublishedNewsByCategory(news.getCategory(), pageable);
            model.addAttribute("relatedNews", relatedNews.getContent());
            
            return "news/detail";
        } catch (RuntimeException e) {
            return "error/404";
        }
    }

    /**
     * 创建新闻页面
     */
    @GetMapping("/create")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public String createNewsForm(Model model) {
        model.addAttribute("news", new News());
        model.addAttribute("categories", News.NewsCategory.values());
        return "news/create";
    }

    /**
     * 处理新闻创建
     */
    @PostMapping("/create")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public String createNews(@Valid @ModelAttribute("news") News news,
                            BindingResult result,
                            Authentication authentication,
                            RedirectAttributes redirectAttributes,
                            Model model) {
        
        if (result.hasErrors()) {
            model.addAttribute("categories", News.NewsCategory.values());
            return "news/create";
        }

        try {
            String username = authentication.getName();
            Optional<User> userOpt = userService.findByUsernameOrEmail(username);
            
            if (userOpt.isPresent()) {
                User author = userOpt.get();
                News createdNews = newsService.createNews(
                    news.getTitle(),
                    news.getContent(),
                    news.getSummary(),
                    news.getCategory(),
                    news.getImageUrl(),
                    news.getSourceUrl(),
                    author
                );
                
                redirectAttributes.addFlashAttribute("success", "新闻创建成功，等待管理员审核");
                return "redirect:/news/" + createdNews.getId();
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "创建失败: " + e.getMessage());
        }

        return "redirect:/news/create";
    }

    /**
     * 编辑新闻页面
     */
    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('ADMIN') or @newsService.findById(#id).orElse(new com.newsmanagement.entity.News()).author.username == authentication.name")
    public String editNewsForm(@PathVariable Long id, Model model) {
        Optional<News> newsOpt = newsService.findById(id);
        if (newsOpt.isPresent()) {
            model.addAttribute("news", newsOpt.get());
            model.addAttribute("categories", News.NewsCategory.values());
            return "news/edit";
        }
        return "error/404";
    }

    /**
     * 处理新闻编辑
     */
    @PostMapping("/edit/{id}")
    @PreAuthorize("hasRole('ADMIN') or @newsService.findById(#id).orElse(new com.newsmanagement.entity.News()).author.username == authentication.name")
    public String editNews(@PathVariable Long id,
                          @Valid @ModelAttribute("news") News news,
                          BindingResult result,
                          RedirectAttributes redirectAttributes,
                          Model model) {
        
        if (result.hasErrors()) {
            model.addAttribute("categories", News.NewsCategory.values());
            return "news/edit";
        }

        try {
            newsService.updateNews(
                id,
                news.getTitle(),
                news.getContent(),
                news.getSummary(),
                news.getCategory(),
                news.getImageUrl(),
                news.getSourceUrl()
            );
            
            redirectAttributes.addFlashAttribute("success", "新闻更新成功");
            return "redirect:/news/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
            return "redirect:/news/edit/" + id;
        }
    }

    /**
     * 删除新闻
     */
    @PostMapping("/delete/{id}")
    @PreAuthorize("hasRole('ADMIN') or @newsService.findById(#id).orElse(new com.newsmanagement.entity.News()).author.username == authentication.name")
    public String deleteNews(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            newsService.deleteNews(id);
            redirectAttributes.addFlashAttribute("success", "新闻删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "删除失败: " + e.getMessage());
        }
        return "redirect:/news";
    }

    /**
     * 管理员新闻管理页面
     */
    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminNewsList(@RequestParam(value = "page", defaultValue = "0") int page,
                               @RequestParam(value = "size", defaultValue = "15") int size,
                               Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<News> newsPage = newsService.findAllNews(pageable);
        
        model.addAttribute("newsPage", newsPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", newsPage.getTotalPages());
        
        return "admin/news";
    }

    /**
     * 切换新闻发布状态
     */
    @PostMapping("/admin/toggle/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String togglePublishStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            newsService.toggleNewsPublishStatus(id);
            redirectAttributes.addFlashAttribute("success", "新闻状态已更新");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "操作失败: " + e.getMessage());
        }
        return "redirect:/news/admin";
    }

    /**
     * 我的新闻页面
     */
    @GetMapping("/my")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public String myNews(@RequestParam(value = "page", defaultValue = "0") int page,
                        @RequestParam(value = "size", defaultValue = "10") int size,
                        Authentication authentication,
                        Model model) {
        
        String username = authentication.getName();
        Optional<User> userOpt = userService.findByUsernameOrEmail(username);
        
        if (userOpt.isPresent()) {
            Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
            Page<News> newsPage = newsService.findNewsByAuthor(userOpt.get(), pageable);
            
            model.addAttribute("newsPage", newsPage);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", newsPage.getTotalPages());
            
            return "news/my";
        }
        
        return "redirect:/login";
    }
}

