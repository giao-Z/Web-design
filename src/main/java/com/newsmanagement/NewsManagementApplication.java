package com.newsmanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * 新闻发布管理系统主启动类
 * 
 * @author NewsManagement Team
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
public class NewsManagementApplication {

    public static void main(String[] args) {
        SpringApplication.run(NewsManagementApplication.class, args);
        System.out.println("=================================");
        System.out.println("新闻发布管理系统启动成功！");
        System.out.println("访问地址: http://localhost:8080");
        System.out.println("H2数据库控制台: http://localhost:8080/h2-console");
        System.out.println("=================================");
    }
}

