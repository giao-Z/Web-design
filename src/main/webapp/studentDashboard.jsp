<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生面板</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            display: flex;
            background-color: #f5f9ff;
            color: #333;
        }
        
        .sidebar {
            width: 250px;
            background-color: #1a5f9e;
            color: white;
            height: 100vh;
            padding: 20px 0;
            position: fixed;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .main-content {
            margin-left: 250px;
            padding: 30px;
            width: calc(100% - 250px);
            background-color: white;
            min-height: 100vh;
        }
        
        .welcome-header {
            color: #1a5f9e;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ffc107;
        }
        
        .sidebar-header {
            padding: 20px;
            background-color: #13487a;
            margin-bottom: 20px;
            border-bottom: 2px solid #ffc107;
        }
        
        .sidebar-header h2 {
            color: #ffc107;
            margin-bottom: 5px;
        }
        
        .sidebar-header p {
            color: rgba(255,255,255,0.8);
            font-size: 14px;
        }
        
        .menu-section {
            margin-bottom: 15px;
        }
        
        .menu-title {
            color: white;
            padding: 15px 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
            background-color: #1a5f9e;
        }
        
        .menu-title:hover {
            background-color: #13487a;
        }
        
        .menu-items {
            display: none;
            background-color: #e9f2fb;
        }
        
        .menu-items a {
            display: block;
            color: #1a5f9e;
            padding: 12px 30px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }
        
        .menu-items a:hover {
            background-color: #ffc107;
            color: #1a5f9e;
            border-left: 4px solid #1a5f9e;
        }
        
        .user-actions {
            position: absolute;
            bottom: 20px;
            width: 100%;
            padding: 0 20px;
        }
        
        .user-actions a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            margin-bottom: 5px;
            border-radius: 4px;
            transition: all 0.3s;
            text-align: center;
        }
        
        .user-actions a:first-child {
            background-color: #ffc107;
            color: #1a5f9e;
        }
        
        .user-actions a:first-child:hover {
            background-color: #e0a800;
        }
        
        .user-actions a:last-child {
            background-color: #dc3545;
            color: white;
        }
        
        .user-actions a:last-child:hover {
            background-color: #c82333;
        }
        
        .active .menu-items {
            display: block;
        }
        
        .menu-icon {
            transition: transform 0.3s;
            color: #ffc107;
            font-weight: bold;
        }
        
        .active .menu-icon {
            transform: rotate(90deg);
        }
        
        .dashboard-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-top: 4px solid #ffc107;
        }
        
        .dashboard-card h3 {
            color: #1a5f9e;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- 侧边导航栏 -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>欢迎, <%= session.getAttribute("name") %></h2>
            <p>学生</p>
        </div>
        
        <!-- 成绩查询菜单 -->
        <div class="menu-section" onclick="toggleMenu(this)">
            <div class="menu-title">
                <span>成绩查询</span>
                <span class="menu-icon">›</span>
            </div>
            <div class="menu-items">
                <a href="viewMyScores.jsp">我的成绩</a>
            </div>
        </div>
        
        <!-- 论坛菜单 -->
        <div class="menu-section" onclick="toggleMenu(this)">
            <div class="menu-title">
                <span>论坛</span>
                <span class="menu-icon">›</span>
            </div>
            <div class="menu-items">
                <a href="forum.jsp">进入论坛</a>
            </div>
        </div>
        
        <!-- 用户操作 -->
        <div class="user-actions">
            <a href="editProfile.jsp">修改个人信息</a>
            <a href="logout.jsp">退出登录</a>
        </div>
    </div>
    
    <!-- 主内容区 -->
    <div class="main-content">
        <h1 class="welcome-header">学生控制面板</h1>
        
        <div class="dashboard-card">
            <h3>我的学习概览</h3>
            <p>欢迎使用学生成绩管理系统。请从左侧菜单中选择您要执行的操作。</p>
        </div>
        
        <div class="dashboard-card">
            <h3>最近成绩</h3>
            <p>您可以查看您最近的考试成绩和平时成绩。</p>
        </div>
    </div>
    
    <script>
        // 切换菜单显示/隐藏
        function toggleMenu(element) {
            element.classList.toggle('active');
        }
        
        // 默认展开第一个菜单
        document.querySelector('.menu-section').classList.add('active');
    </script>
</body>
</html>