package com.newsmanagement.config;

import com.newsmanagement.entity.News;
import com.newsmanagement.entity.User;
import com.newsmanagement.service.NewsService;
import com.newsmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * 数据初始化器
 * 在应用启动时创建一些测试数据
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserService userService;

    @Autowired
    private NewsService newsService;

    @Override
    public void run(String... args) throws Exception {
        initializeData();
    }

    private void initializeData() {
        try {
            // 创建管理员用户
            if (!userService.findByUsernameOrEmail("admin").isPresent()) {
                User admin = userService.registerUser("admin", "admin123", "admin@newsmanagement.com");
                admin.setRole(User.Role.ADMIN);
                admin.setRealName("系统管理员");
                userService.updateUser(admin);
                System.out.println("管理员账号创建成功: admin / admin123");
            }

            // 创建普通用户
            if (!userService.findByUsernameOrEmail("user").isPresent()) {
                User user = userService.registerUser("user", "user123", "user@newsmanagement.com");
                user.setRealName("测试用户");
                userService.updateUser(user);
                System.out.println("测试用户创建成功: user / user123");
            }

            // 创建示例新闻
            User admin = userService.findByUsernameOrEmail("admin").orElse(null);
            if (admin != null) {
                createSampleNews(admin);
            }

        } catch (Exception e) {
            System.err.println("数据初始化失败: " + e.getMessage());
        }
    }

    private void createSampleNews(User author) {
        try {
            // 新闻1
            News news1 = newsService.createNews(
                "Spring Boot新闻管理系统正式上线",
                "经过精心开发和测试，基于Spring Boot的新闻发布管理系统正式上线。该系统采用了现代化的技术架构，包括Spring Boot、Spring Security、JPA、Thymeleaf等技术栈，为用户提供了完整的新闻发布、管理和交流平台。\n\n系统主要功能包括：\n1. 用户注册和登录认证\n2. 新闻发布和管理\n3. 分类浏览和搜索\n4. 论坛交流功能\n5. 实时聊天室\n\n我们致力于为用户提供最佳的使用体验，欢迎大家注册使用并提出宝贵意见。",
                "全新的新闻管理平台正式发布，提供完整的内容管理和社区交流功能。",
                News.NewsCategory.TECHNOLOGY,
                null,
                null,
                author
            );
            newsService.toggleNewsPublishStatus(news1.getId());

            // 新闻2
            News news2 = newsService.createNews(
                "如何使用新闻管理系统发布内容",
                "本文将详细介绍如何在新闻管理系统中发布和管理新闻内容。\n\n发布新闻的步骤：\n1. 登录系统账号\n2. 点击发布新闻按钮\n3. 填写新闻标题和内容\n4. 选择合适的分类\n5. 添加摘要和图片（可选）\n6. 提交等待审核\n\n管理员审核通过后，新闻将在首页和新闻列表中显示。用户可以通过搜索功能快速找到感兴趣的内容。",
                "详细介绍新闻发布流程和注意事项，帮助用户快速上手。",
                News.NewsCategory.EDUCATION,
                null,
                null,
                author
            );
            newsService.toggleNewsPublishStatus(news2.getId());

            // 新闻3
            News news3 = newsService.createNews(
                "系统安全和隐私保护措施",
                "我们高度重视用户数据安全和隐私保护，采用了多层次的安全防护措施：\n\n技术安全措施：\n1. 密码加密存储\n2. HTTPS安全传输\n3. SQL注入防护\n4. XSS攻击防护\n5. CSRF令牌验证\n\n隐私保护政策：\n1. 最小化数据收集\n2. 透明的隐私政策\n3. 用户数据控制权\n4. 定期安全审计\n\n我们承诺不会未经授权分享用户个人信息，所有数据处理都严格遵循相关法律法规。",
                "详细介绍系统的安全防护措施和隐私保护政策。",
                News.NewsCategory.OTHER,
                null,
                null,
                author
            );
            newsService.toggleNewsPublishStatus(news3.getId());

            System.out.println("示例新闻创建成功");

        } catch (Exception e) {
            System.err.println("创建示例新闻失败: " + e.getMessage());
        }
    }
}

