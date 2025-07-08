/*
 Navicat Premium Dump SQL

 Source Server         : MySQL80
 Source Server Type    : MySQL
 Source Server Version : 80026 (8.0.26)
 Source Host           : localhost:3306
 Source Schema         : student_management

 Target Server Type    : MySQL
 Target Server Version : 80026 (8.0.26)
 File Encoding         : 65001

 Date: 22/06/2025 22:22:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for forum_posts
-- ----------------------------
DROP TABLE IF EXISTS `forum_posts`;
CREATE TABLE `forum_posts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `post_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_pinned` tinyint(1) NULL DEFAULT 0 COMMENT '是否置顶',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_time`(`post_time` ASC) USING BTREE,
  CONSTRAINT `forum_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of forum_posts
-- ----------------------------
INSERT INTO `forum_posts` VALUES (1, 5, '张三', '关于高等数学期中考试的问题', '请问老师，期中考试的范围是否包含第三章的所有内容？还有课后习题会占多大比例？', '2024-03-10 14:25:00', 0);
INSERT INTO `forum_posts` VALUES (2, 2, '张老师', '高等数学期中考试说明', '期中考试范围是第一章到第三章，重点复习课后习题中的奇数题。考试题型包括选择、填空和解答题，课后习题类似题约占30%。', '2024-03-10 15:10:00', 0);
INSERT INTO `forum_posts` VALUES (3, 6, '李四', '寻找编程比赛队友', '下个月有ACM校赛，想找2名队友一起参加。我擅长算法实现，希望找前端和数据库方面的小伙伴！', '2024-03-12 09:30:00', 0);
INSERT INTO `forum_posts` VALUES (4, 3, '李老师', '图书馆新书通知', '图书馆新进了一批计算机类和物理类的参考书，包括《算法导论》《现代物理导论》等，欢迎同学们前来借阅。', '2024-03-15 10:00:00', 1);
INSERT INTO `forum_posts` VALUES (5, 7, '王五', '物理学习资源分享', '发现一个很好的物理学习网站：www.physics-learning.com，里面有丰富的实验视频和习题讲解，推荐给大家！', '2024-03-18 16:45:00', 0);
INSERT INTO `forum_posts` VALUES (6, 4, '王老师', '关于实验报告提交', '请同学们注意，本周的实验报告最迟周五下午5点前提交到实验室门口的信箱，逾期将扣分。', '2024-03-20 08:15:00', 1);
INSERT INTO `forum_posts` VALUES (7, 8, '赵六', '英语学习小组招募', '想组建一个英语学习小组，每周两次集中练习听力和口语，有意向的同学请私信我！', '2024-03-22 19:30:00', 0);
INSERT INTO `forum_posts` VALUES (8, 9, '钱七', '数据结构作业问题', '在做数据结构作业的二叉树遍历时遇到问题，有没有同学可以帮忙看看我的代码？', '2024-03-25 20:10:00', 0);
INSERT INTO `forum_posts` VALUES (10, 10, '孙八', '二手教材转让', '转让《大学物理(上册)》和《线性代数》，几乎全新，价格面议。', '2024-04-01 14:40:00', 0);
INSERT INTO `forum_posts` VALUES (11, 6, '李四', '数据结构课程疑问', '请问二叉树的前序、中序和后序遍历在实际应用中各有什么优势？考试会要求手写遍历过程吗？', '2024-03-13 10:15:00', 0);
INSERT INTO `forum_posts` VALUES (12, 2, '张老师', '数据库原理实验课通知', '下周三的实验课将学习SQL优化，请同学们提前安装好MySQL 8.0并预习相关章节。实验报告模板已上传至课程平台。', '2024-03-14 08:45:00', 0);
INSERT INTO `forum_posts` VALUES (13, 8, '赵六', '二手教材转让', '现有《计算机网络：自顶向下方法》一本，九成新，价格面议。有意者请联系QQ12345678。', '2024-03-15 16:20:00', 0);
INSERT INTO `forum_posts` VALUES (14, 9, '钱七', '关于Python作业的问题', '作业第三题的pandas数据处理部分不太明白，有没有同学可以帮忙讲解一下？', '2024-03-16 19:30:00', 0);
INSERT INTO `forum_posts` VALUES (15, 3, '李老师', '软件工程课程项目分组', '请各班班长于本周五前将项目分组名单发送至我的邮箱。每组4-5人，需包含不同专业方向的同学。', '2024-03-17 11:05:00', 1);
INSERT INTO `forum_posts` VALUES (16, 9, '钱七', '校园网速度慢的问题', '最近宿舍区校园网晚上特别卡，看视频经常缓冲，是只有我这样还是普遍现象？', '2024-03-18 21:40:00', 0);
INSERT INTO `forum_posts` VALUES (17, 5, '张三', '感谢老师的解答', '谢谢张老师对期中考试范围的详细说明，我会按照您说的重点好好复习！', '2024-03-19 09:25:00', 0);
INSERT INTO `forum_posts` VALUES (18, 10, '孙八', '寻找考研自习伙伴', '准备2025考研，想在图书馆找几位志同道合的同学一起复习，互相监督。', '2024-03-20 14:10:00', 0);
INSERT INTO `forum_posts` VALUES (20, 6, '李四', '编程比赛组队成功', '感谢各位响应，已找到队友。我们会每周三晚上在计算机楼302教室练习，欢迎其他同学来交流！', '2024-03-22 18:20:00', 0);
INSERT INTO `forum_posts` VALUES (35, 11, 'stu20230007', 'web课设答辩', '论坛发帖操作', '2025-06-22 14:54:21', 1);

-- ----------------------------
-- Table structure for forum_replies
-- ----------------------------
DROP TABLE IF EXISTS `forum_replies`;
CREATE TABLE `forum_replies`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reply_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `post_id`(`post_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `forum_replies_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `forum_replies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of forum_replies
-- ----------------------------
INSERT INTO `forum_replies` VALUES (1, 1, 2, '张老师', '张三同学，考试范围确实包含第三章全部内容，课后习题占比约为30%。建议重点复习第1、3、5节的例题。', '2024-03-10 15:05:00');
INSERT INTO `forum_replies` VALUES (2, 3, 9, '钱七', '李四，我擅长前端开发，可以加入你的团队。我们可以约时间讨论比赛策略。', '2024-03-12 10:15:00');
INSERT INTO `forum_replies` VALUES (3, 3, 11, '孙八', '我对数据库比较熟悉，可以负责这部分。我们三人组队应该很有竞争力！', '2024-03-12 11:30:00');
INSERT INTO `forum_replies` VALUES (4, 5, 4, '王老师', '王五同学，这个网站资源确实不错。实验室已经购买了部分教材的电子版，同学们可以登录校园网免费访问。', '2024-03-18 17:30:00');
INSERT INTO `forum_replies` VALUES (5, 8, 2, '张老师', '钱七同学，你可以把代码发到我的邮箱，我帮你看看哪里有问题。记得附上具体的错误信息。', '2024-03-25 21:45:00');
INSERT INTO `forum_replies` VALUES (24, 35, 11, 'stu20230007', '回复该贴操作', '2025-06-22 14:54:41');

-- ----------------------------
-- Table structure for scores
-- ----------------------------
DROP TABLE IF EXISTS `scores`;
CREATE TABLE `scores`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `term` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '格式: 2023-2024-1表示2023-2024学年第一学期',
  `subject` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `daily_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '平时成绩',
  `exam_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '期末成绩',
  `score` decimal(5, 2) GENERATED ALWAYS AS (((`daily_score` * 0.5) + (`exam_score` * 0.5))) STORED COMMENT '总成绩(平时50%+期末50%)' NULL,
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '教师评语',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_term`(`term` ASC) USING BTREE,
  INDEX `idx_subject`(`subject` ASC) USING BTREE,
  CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores
-- ----------------------------
INSERT INTO `scores` VALUES (1, 5, '2023-2024-1', '高等数学', 85.00, 86.00, DEFAULT, '期中考试进步明显，继续保持', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (2, 5, '2023-2024-1', '大学英语', 78.00, 78.00, DEFAULT, '需要加强听力训练', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (3, 5, '2023-2024-1', '大学物理', 92.00, 92.00, DEFAULT, '表现优秀，实验能力突出', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (4, 6, '2023-2024-1', '高等数学', 76.00, 77.00, DEFAULT, '基础知识有待加强', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (5, 6, '2023-2024-1', '大学英语', 88.00, 88.00, DEFAULT, '口语表达优秀，写作需提高', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (6, 6, '2023-2024-1', '线性代数', 82.00, 83.00, DEFAULT, '课堂表现积极', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (7, 7, '2023-2024-1', '高等数学', 95.00, 95.00, DEFAULT, '年级前十名，数学竞赛潜力', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (8, 7, '2023-2024-1', '有机化学', 89.00, 90.00, DEFAULT, '实验操作规范，报告完整', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (9, 7, '2023-2024-1', '大学物理', 91.00, 91.00, DEFAULT, '理论掌握扎实', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (10, 8, '2023-2024-1', '高等数学', 68.00, 68.00, DEFAULT, '需要课后辅导，基础薄弱', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (11, 8, '2023-2024-1', '大学英语', 72.00, 73.00, DEFAULT, '词汇量不足，需加强记忆', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (12, 9, '2023-2024-1', '程序设计', 94.00, 94.00, DEFAULT, '编程能力突出，算法思维好', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (13, 9, '2023-2024-1', '离散数学', 87.00, 88.00, DEFAULT, '逻辑推理能力强', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (14, 10, '2023-2024-1', '大学英语', 81.00, 81.00, DEFAULT, '听力部分需加强', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (15, 11, '2023-2024-1', '数据结构', 90.00, 91.00, DEFAULT, '算法实现能力强', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (16, 12, '2023-2024-1', '数据库原理', 85.00, 85.00, DEFAULT, 'SQL编写规范', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (17, 5, '2023-2024-2', '高等数学', 88.00, 88.00, DEFAULT, '保持稳定，解题思路清晰', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (18, 5, '2023-2024-2', '概率统计', 85.00, 86.00, DEFAULT, '概念理解准确', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (19, 6, '2023-2024-2', '高等数学', 81.00, 81.00, DEFAULT, '进步明显，继续努力', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (20, 6, '2023-2024-2', '大学物理', 79.00, 80.00, DEFAULT, '实验报告需更详细', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (21, 7, '2023-2024-2', '大学物理', 94.00, 95.00, DEFAULT, '推荐参加物理竞赛', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (22, 7, '2023-2024-2', '分析化学', 92.00, 92.00, DEFAULT, '实验数据准确', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (23, 8, '2023-2024-2', '高等数学', 75.00, 75.00, DEFAULT, '有进步，仍需加强', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (24, 9, '2023-2024-2', '操作系统', 89.00, 89.00, DEFAULT, '项目完成质量高', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (25, 10, '2023-2024-2', '计算机网络', 87.00, 88.00, DEFAULT, '协议理解深入', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `scores` VALUES (26, 11, '2023-2024-2', '软件工程', 91.00, 91.00, DEFAULT, '', '2025-06-18 19:13:45', '2025-06-22 12:31:41');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` enum('student','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'admin123', '系统管理员', 'admin', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (2, 'teacher_zhang', '123456', '张老师', 'admin', '2025-06-18 19:13:45', '2025-06-18 19:22:43');
INSERT INTO `users` VALUES (3, 'teacher_li', 'admin123', '李老师', 'admin', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (4, 'teacher_wang', 'admin123', '王老师', 'admin', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (5, 'stu20230001', '123456', '张三', 'student', '2025-06-18 19:13:45', '2025-06-18 19:26:46');
INSERT INTO `users` VALUES (6, 'stu20230002', '123456', '李四', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (7, 'stu20230003', '123456', '王五', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (8, 'stu20230004', '123456', '赵六', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (9, 'stu20230005', '123456', '钱七', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (10, 'stu20230006', '123456', '孙八', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (11, 'stu20230007', '123456', '周九', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');
INSERT INTO `users` VALUES (12, 'stu20230008', '123456', '吴十', 'student', '2025-06-18 19:13:45', '2025-06-18 19:13:45');

SET FOREIGN_KEY_CHECKS = 1;
