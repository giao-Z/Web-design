package com.newsmanagement.service;

import com.newsmanagement.entity.News;
import com.newsmanagement.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * 新闻数据访问层接口
 */
@Repository
interface NewsRepository extends JpaRepository<News, Long> {

    /**
     * 查找已发布的新闻
     */
    Page<News> findByPublishedTrue(Pageable pageable);

    /**
     * 根据分类查找已发布的新闻
     */
    Page<News> findByPublishedTrueAndCategory(News.NewsCategory category, Pageable pageable);

    /**
     * 根据作者查找新闻
     */
    Page<News> findByAuthor(User author, Pageable pageable);

    /**
     * 根据标题搜索已发布的新闻
     */
    @Query("SELECT n FROM News n WHERE n.published = true AND n.title LIKE %:keyword%")
    Page<News> findByTitleContaining(@Param("keyword") String keyword, Pageable pageable);

    /**
     * 根据标题和分类搜索已发布的新闻
     */
    @Query("SELECT n FROM News n WHERE n.published = true AND n.title LIKE %:keyword% AND n.category = :category")
    Page<News> findByTitleContainingAndCategory(@Param("keyword") String keyword, 
                                               @Param("category") News.NewsCategory category, 
                                               Pageable pageable);

    /**
     * 获取热门新闻（按浏览量排序）
     */
    @Query("SELECT n FROM News n WHERE n.published = true ORDER BY n.viewCount DESC")
    List<News> findTopByViewCount(Pageable pageable);

    /**
     * 获取最新新闻
     */
    @Query("SELECT n FROM News n WHERE n.published = true ORDER BY n.createdAt DESC")
    List<News> findLatestNews(Pageable pageable);

    /**
     * 根据分类统计新闻数量
     */
    long countByPublishedTrueAndCategory(News.NewsCategory category);
}

/**
 * 新闻服务层
 */
@Service
@Transactional
public class NewsService {

    @Autowired
    private NewsRepository newsRepository;

    /**
     * 创建新闻
     */
    public News createNews(String title, String content, String summary, 
                          News.NewsCategory category, String imageUrl, 
                          String sourceUrl, User author) {
        News news = new News();
        news.setTitle(title);
        news.setContent(content);
        news.setSummary(summary);
        news.setCategory(category);
        news.setImageUrl(imageUrl);
        news.setSourceUrl(sourceUrl);
        news.setAuthor(author);
        news.setPublished(false); // 默认未发布，需要管理员审核
        news.setViewCount(0L);

        return newsRepository.save(news);
    }

    /**
     * 更新新闻
     */
    public News updateNews(Long newsId, String title, String content, String summary,
                          News.NewsCategory category, String imageUrl, String sourceUrl) {
        Optional<News> newsOpt = newsRepository.findById(newsId);
        if (newsOpt.isPresent()) {
            News news = newsOpt.get();
            news.setTitle(title);
            news.setContent(content);
            news.setSummary(summary);
            news.setCategory(category);
            news.setImageUrl(imageUrl);
            news.setSourceUrl(sourceUrl);
            return newsRepository.save(news);
        }
        throw new RuntimeException("新闻不存在");
    }

    /**
     * 发布/取消发布新闻
     */
    public void toggleNewsPublishStatus(Long newsId) {
        Optional<News> newsOpt = newsRepository.findById(newsId);
        if (newsOpt.isPresent()) {
            News news = newsOpt.get();
            news.setPublished(!news.getPublished());
            newsRepository.save(news);
        } else {
            throw new RuntimeException("新闻不存在");
        }
    }

    /**
     * 删除新闻
     */
    public void deleteNews(Long newsId) {
        if (newsRepository.existsById(newsId)) {
            newsRepository.deleteById(newsId);
        } else {
            throw new RuntimeException("新闻不存在");
        }
    }

    /**
     * 根据ID查找新闻
     */
    public Optional<News> findById(Long id) {
        return newsRepository.findById(id);
    }

    /**
     * 查看新闻详情（增加浏览量）
     */
    public News viewNews(Long newsId) {
        Optional<News> newsOpt = newsRepository.findById(newsId);
        if (newsOpt.isPresent()) {
            News news = newsOpt.get();
            news.incrementViewCount();
            return newsRepository.save(news);
        }
        throw new RuntimeException("新闻不存在");
    }

    /**
     * 获取已发布的新闻
     */
    public Page<News> findPublishedNews(Pageable pageable) {
        return newsRepository.findByPublishedTrue(pageable);
    }

    /**
     * 根据分类获取已发布的新闻
     */
    public Page<News> findPublishedNewsByCategory(News.NewsCategory category, Pageable pageable) {
        return newsRepository.findByPublishedTrueAndCategory(category, pageable);
    }

    /**
     * 根据作者获取新闻
     */
    public Page<News> findNewsByAuthor(User author, Pageable pageable) {
        return newsRepository.findByAuthor(author, pageable);
    }

    /**
     * 搜索新闻
     */
    public Page<News> searchNews(String keyword, String categoryStr, Pageable pageable) {
        if (categoryStr != null && !categoryStr.isEmpty()) {
            try {
                News.NewsCategory category = News.NewsCategory.valueOf(categoryStr.toUpperCase());
                return newsRepository.findByTitleContainingAndCategory(keyword, category, pageable);
            } catch (IllegalArgumentException e) {
                // 如果分类无效，忽略分类条件
            }
        }
        return newsRepository.findByTitleContaining(keyword, pageable);
    }

    /**
     * 获取所有新闻（管理员用）
     */
    public Page<News> findAllNews(Pageable pageable) {
        return newsRepository.findAll(pageable);
    }

    /**
     * 获取热门新闻
     */
    public List<News> getPopularNews(int limit) {
        return newsRepository.findTopByViewCount(
            org.springframework.data.domain.PageRequest.of(0, limit)
        );
    }

    /**
     * 获取最新新闻
     */
    public List<News> getLatestNews(int limit) {
        return newsRepository.findLatestNews(
            org.springframework.data.domain.PageRequest.of(0, limit)
        );
    }

    /**
     * 根据分类统计新闻数量
     */
    public long countNewsByCategory(News.NewsCategory category) {
        return newsRepository.countByPublishedTrueAndCategory(category);
    }

    /**
     * 获取所有分类的统计信息
     */
    public java.util.Map<News.NewsCategory, Long> getCategoryStatistics() {
        java.util.Map<News.NewsCategory, Long> stats = new java.util.HashMap<>();
        for (News.NewsCategory category : News.NewsCategory.values()) {
            stats.put(category, countNewsByCategory(category));
        }
        return stats;
    }
}

