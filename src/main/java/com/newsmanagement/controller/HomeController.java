package com.newsmanagement.controller;

import com.newsmanagement.entity.News;
import com.newsmanagement.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Arrays;
import java.util.List;

/**
 * 主页控制器
 */
@Controller
public class HomeController {

    @Autowired
    private NewsService newsService;

    /**
     * 首页
     */
    @GetMapping({"/", "/home"})
    public String home(Model model) {
        // 获取最新的推荐新闻（轮播图用）
        List<String> carouselNews = Arrays.asList(
            "美国名嘴：美国不是将输给中国 是已经输了",
            "官媒：炮舰外交都已作古 对华口诛笔伐能管用？",
            "美日印澳谋划联合对抗中国 却不想显得过于反华",
            "美防长称要与盟友合作 打造针对中国的可信威慑",
            "中国制造业何以连续11年位居全球第一",
            "境外学者：正在被孤立于世界之外的是美国 而非中国"
        );
        
        List<String> carouselLinks = Arrays.asList(
            "https://www.sohu.com/a/848510390_121450400",
            "https://www.thepaper.cn/newsDetail_forward_30924540",
            "https://www.ckhq.net/arc/hqck/jsck/2023/0212/583319.html",
            "https://www.163.com/dy/article/K12B6E5D05568PJ3.html",
            "https://m.163.com/dy/article/GKG53OLI0514R9NP.html",
            "https://mil.news.sina.com.cn/2021-03-14/doc-ikkntiam1192541.shtml"
        );

        model.addAttribute("carouselNews", carouselNews);
        model.addAttribute("carouselLinks", carouselLinks);

        // 获取最新发布的新闻
        try {
            Pageable pageable = PageRequest.of(0, 6, Sort.by("createdAt").descending());
            Page<News> latestNews = newsService.findPublishedNews(pageable);
            model.addAttribute("latestNews", latestNews.getContent());
        } catch (Exception e) {
            // 如果NewsService还未实现，先忽略错误
            model.addAttribute("latestNews", Arrays.asList());
        }

        return "index";
    }

    /**
     * 关于我们页面
     */
    @GetMapping("/about")
    public String about() {
        return "about";
    }

    /**
     * 联系我们页面
     */
    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }

    /**
     * 搜索页面
     */
    @GetMapping("/search")
    public String search(@RequestParam(value = "q", required = false) String query,
                        @RequestParam(value = "category", required = false) String category,
                        @RequestParam(value = "page", defaultValue = "0") int page,
                        Model model) {
        
        if (query != null && !query.trim().isEmpty()) {
            try {
                Pageable pageable = PageRequest.of(page, 10, Sort.by("createdAt").descending());
                Page<News> searchResults = newsService.searchNews(query, category, pageable);
                
                model.addAttribute("searchResults", searchResults);
                model.addAttribute("query", query);
                model.addAttribute("category", category);
                model.addAttribute("currentPage", page);
                model.addAttribute("totalPages", searchResults.getTotalPages());
            } catch (Exception e) {
                // 如果NewsService还未实现，先显示空结果
                model.addAttribute("searchResults", null);
                model.addAttribute("error", "搜索功能暂时不可用");
            }
        }

        return "search";
    }
}

