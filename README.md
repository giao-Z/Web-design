<<<<<<< HEAD
# 新闻发布管理系统

基于Spring Boot的新闻发布管理系统，采用MVC分层架构，使用Thymeleaf模板引擎和Bootstrap框架实现响应式设计。

## 项目特性

### 核心功能
- ✅ **用户管理**：用户注册、登录认证、个人信息修改
- ✅ **新闻管理**：管理员发布、查询、修改、删除新闻信息
- ✅ **信息查询**：注册用户可按标题/类型等关键字查询新闻
- ✅ **简易论坛**：用户交流讨论功能
- ✅ **实时聊天**：在线聊天室功能

### 技术架构
- **后端框架**：Spring Boot 2.7.0
- **安全框架**：Spring Security
- **数据访问**：Spring Data JPA + Hibernate
- **数据库**：H2 Database（内存数据库）
- **模板引擎**：Thymeleaf
- **前端框架**：Bootstrap 5 + jQuery
- **构建工具**：Maven

## 项目结构

```
news-management-system/
├── src/
│   ├── main/
│   │   ├── java/com/newsmanagement/
│   │   │   ├── NewsManagementApplication.java    # 主启动类
│   │   │   ├── config/                           # 配置类
│   │   │   │   ├── SecurityConfig.java          # 安全配置
│   │   │   │   └── DataInitializer.java         # 数据初始化
│   │   │   ├── controller/                      # 控制器层
│   │   │   │   ├── HomeController.java          # 首页控制器
│   │   │   │   ├── UserController.java          # 用户控制器
│   │   │   │   └── NewsController.java          # 新闻控制器
│   │   │   ├── service/                         # 服务层
│   │   │   │   ├── UserService.java             # 用户服务
│   │   │   │   └── NewsService.java             # 新闻服务
│   │   │   ├── repository/                      # 数据访问层
│   │   │   │   └── UserRepository.java          # 用户数据访问
│   │   │   └── entity/                          # 实体类
│   │   │       ├── User.java                    # 用户实体
│   │   │       ├── News.java                    # 新闻实体
│   │   │       ├── ForumPost.java               # 论坛帖子实体
│   │   │       ├── ForumReply.java              # 论坛回复实体
│   │   │       └── ChatMessage.java             # 聊天消息实体
│   │   ├── resources/
│   │   │   ├── static/                          # 静态资源
│   │   │   │   ├── css/style.css                # 主样式文件
│   │   │   │   └── js/main.js                   # 主JavaScript文件
│   │   │   ├── templates/                       # Thymeleaf模板
│   │   │   │   ├── layout/base.html             # 基础布局模板
│   │   │   │   ├── index.html                   # 首页模板
│   │   │   │   └── auth/                        # 认证相关页面
│   │   │   │       ├── login.html               # 登录页面
│   │   │   │       └── register.html            # 注册页面
│   │   │   └── application.properties           # 应用配置
│   │   └── test/                                # 测试代码
└── pom.xml                                      # Maven配置
```

## 数据库设计

### 用户表 (users)
- id: 主键
- username: 用户名（唯一）
- email: 邮箱（唯一）
- password: 密码（加密存储）
- real_name: 真实姓名
- phone: 手机号码
- role: 用户角色（USER/ADMIN）
- enabled: 是否启用
- created_at/updated_at: 创建/更新时间

### 新闻表 (news)
- id: 主键
- title: 新闻标题
- content: 新闻内容
- summary: 新闻摘要
- category: 新闻分类
- author_id: 作者ID（外键）
- image_url: 图片链接
- source_url: 来源链接
- published: 是否发布
- view_count: 浏览次数
- created_at/updated_at: 创建/更新时间

### 论坛帖子表 (forum_posts)
- id: 主键
- title: 帖子标题
- content: 帖子内容
- author_id: 作者ID（外键）
- view_count: 浏览次数
- reply_count: 回复数量
- created_at/updated_at: 创建/更新时间

### 论坛回复表 (forum_replies)
- id: 主键
- content: 回复内容
- post_id: 帖子ID（外键）
- author_id: 作者ID（外键）
- parent_reply_id: 父回复ID（外键，可为空）
- created_at: 创建时间

### 聊天消息表 (chat_messages)
- id: 主键
- content: 消息内容
- sender_id: 发送者ID（外键）
- message_type: 消息类型
- created_at: 创建时间

## 启动说明

### 环境要求
- Java 11+
- Maven 3.6+

### 启动步骤
1. 克隆或下载项目代码
2. 进入项目根目录
3. 执行编译：`mvn clean compile`
4. 启动应用：`mvn spring-boot:run`
5. 访问应用：http://localhost:8080

### 默认账号
- **管理员账号**：admin / admin123
- **普通用户**：user / user123

### 数据库控制台
- 访问地址：http://localhost:8080/h2-console
- JDBC URL：jdbc:h2:mem:newsdb
- 用户名：sa
- 密码：（空）

## 功能说明

### 首页功能
- 新闻轮播图展示
- 推荐新闻链接
- 用户登录/注册入口
- 响应式设计，支持移动端

### 用户管理
- 用户注册：支持用户名、邮箱、密码等信息注册
- 用户登录：支持用户名或邮箱登录
- 密码加密：使用BCrypt加密存储
- 权限控制：区分普通用户和管理员权限
- 个人信息：支持修改个人资料

### 新闻管理
- 新闻发布：管理员可发布新闻，支持富文本编辑
- 新闻分类：支持多种新闻分类（科技、教育、娱乐等）
- 新闻搜索：支持按标题、内容、分类搜索
- 新闻审核：管理员可审核和发布新闻
- 浏览统计：记录新闻浏览次数

### 论坛功能
- 发帖功能：用户可发布论坛帖子
- 回复功能：支持对帖子进行回复
- 嵌套回复：支持对回复进行再次回复
- 浏览统计：记录帖子浏览和回复数量

### 聊天功能
- 实时聊天：支持用户在线聊天
- 消息类型：支持文本、系统消息等类型
- 历史记录：保存聊天历史记录

## 安全特性

### 认证授权
- Spring Security集成
- 密码加密存储
- 会话管理
- 记住我功能

### 数据安全
- SQL注入防护
- XSS攻击防护
- CSRF令牌验证
- 输入数据验证

## 扩展功能

### 已实现
- 响应式设计
- 数据库自动初始化
- 示例数据创建
- 错误处理机制

### 可扩展
- 文件上传功能
- 邮件通知系统
- 更多新闻分类
- 用户头像上传
- 评论点赞功能
- 新闻推荐算法

## 开发说明

### 代码规范
- 采用MVC分层架构
- 遵循RESTful API设计
- 使用JPA注解进行ORM映射
- 统一异常处理
- 代码注释完整

### 配置说明
- `application.properties`：应用主配置文件
- `SecurityConfig.java`：安全配置
- `DataInitializer.java`：数据初始化配置

### 模板说明
- 使用Thymeleaf模板引擎
- Bootstrap 5响应式框架
- jQuery JavaScript库
- Font Awesome图标库

## 部署说明

### 开发环境
- 使用H2内存数据库
- 热部署支持
- 详细日志输出

### 生产环境建议
- 更换为MySQL/PostgreSQL数据库
- 配置外部配置文件
- 启用HTTPS
- 配置日志文件
- 设置JVM参数

## 故障排除

### 常见问题
1. **端口占用**：修改`application.properties`中的`server.port`
2. **数据库连接**：检查H2数据库配置
3. **模板错误**：检查Thymeleaf模板语法
4. **权限问题**：检查Spring Security配置

### 日志查看
- 应用日志：控制台输出
- 数据库日志：启用`spring.jpa.show-sql=true`
- 安全日志：启用`logging.level.org.springframework.security=DEBUG`

## 技术支持

如有问题，请检查：
1. Java版本是否为11+
2. Maven是否正确安装
3. 端口8080是否被占用
4. 项目依赖是否正确下载

---

**项目状态**：开发完成，基础功能可用
**最后更新**：2025年7月5日

=======
# Web-design
自学过程中所作的项目
>>>>>>> 13da6347466ab18d41475d8c01e4112160d5ecf6
