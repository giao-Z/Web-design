<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加学生成绩</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f9ff 0%, #e6f0ff 100%);
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }
        
        h1 {
            color: #1a5f9e;
            margin-bottom: 30px;
            font-size: 2em;
            text-align: center;
            position: relative;
            padding-bottom: 15px;
        }
        
        h1::after {
            content: "";
            display: block;
            width: 80px;
            height: 4px;
            background: #ffc107;
            margin: 15px auto 0;
            border-radius: 2px;
        }
        
        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(26, 95, 158, 0.15);
            padding: 40px;
            width: 100%;
            max-width: 600px;
            border-top: 5px solid #ffc107;
        }
        
        .error-message {
            color: #e74c3c;
            margin-bottom: 20px;
            padding: 12px;
            background-color: #fdecea;
            border-radius: 6px;
            border-left: 4px solid #e74c3c;
        }
        
        .success-message {
            color: #28a745;
            margin-bottom: 20px;
            padding: 12px;
            background-color: #e8f5e9;
            border-radius: 6px;
            border-left: 4px solid #28a745;
        }
        
        form {
            display: flex;
            flex-direction: column;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #1a5f9e;
            font-weight: 600;
        }
        
        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            margin-top: 10px;
            width: 100%;
        }
        
        input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 95, 158, 0.3);
        }
        
        .nav-links {
            margin-top: 30px;
            text-align: center;
        }
        
        .nav-links a {
            color: #1a5f9e;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 4px;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .nav-links a:hover {
            color: #13487a;
            background-color: rgba(255, 193, 7, 0.2);
            transform: translateY(-1px);
        }
        
        .nav-links a::before {
            content: "←";
            margin-right: 5px;
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>添加学生成绩</h1>
        
        <%-- 显示错误消息 --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <%-- 显示成功消息 --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <form action="doAddScore.jsp" method="post">
            <div class="form-group">
                <label for="student_id">学生ID:</label>
                <input type="number" id="student_id" name="student_id" required>
            </div>
            
            <div class="form-group">
                <label for="term">学期:</label>
                <input type="text" id="term" name="term" required placeholder="如: 2023-2024-1">
            </div>
            
            <div class="form-group">
                <label for="subject">科目:</label>
                <input type="text" id="subject" name="subject" required>
            </div>
            
            <div class="form-group">
                <label for="daily_score">平时成绩:</label>
                <input type="number" id="daily_score" name="daily_score" step="0.1" min="0" max="100" required>
            </div>
            
            <div class="form-group">
                <label for="exam_score">期末成绩:</label>
                <input type="number" id="exam_score" name="exam_score" step="0.1" min="0" max="100" required>
            </div>
            
            <div class="form-group">
                <label for="remark">备注:</label>
                <textarea id="remark" name="remark"></textarea>
            </div>
            
            <input type="submit" value="添加成绩">
        </form>
        
        <div class="nav-links">
            <a href="adminDashboard.jsp">返回管理员面板</a>
        </div>
    </div>
</body>
</html>