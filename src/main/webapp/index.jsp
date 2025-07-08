<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生成绩管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f9ff 0%, #e6f0ff 100%);
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #333;
        }
        
        h1 {
            color: #1a5f9e;
            margin-bottom: 30px;
            font-size: 2.2em;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.1);
            position: relative;
        }
        
        h1::after {
            content: "";
            display: block;
            width: 60px;
            height: 4px;
            background: #ffc107;
            margin: 10px auto;
            border-radius: 2px;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(26, 95, 158, 0.15);
            padding: 40px;
            width: 380px;
            text-align: center;
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
        
        h2 {
            color: #1a5f9e;
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 1.5em;
        }
        
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .input-group {
            width: 100%;
            margin-bottom: 15px;
            position: relative;
        }
        
        .input-group i {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #1a5f9e;
        }
        
        input[type="text"], 
        input[type="password"] {
            width: 100%;
            padding: 12px 12px 12px 40px;
            margin: 8px 0;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            box-sizing: border-box;
            transition: all 0.3s;
            font-size: 15px;
        }
        
        input[type="text"]:focus, 
        input[type="password"]:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
            border: none;
            padding: 14px 30px;
            margin-top: 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
            letter-spacing: 1px;
        }
        
        input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 95, 158, 0.3);
        }
        
        hr {
            border: 0;
            height: 1px;
            background: linear-gradient(to right, transparent, #e0e6ed, transparent);
            margin: 25px 0;
            width: 100%;
        }
        
        .register-link {
            color: #1a5f9e;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
            padding: 8px 15px;
            border-radius: 4px;
        }
        
        .register-link:hover {
            color: #13487a;
            background-color: rgba(255, 193, 7, 0.2);
            transform: translateY(-1px);
        }
        
        .register-link::before {
            content: "→";
            margin-right: 5px;
            color: #ffc107;
            font-weight: bold;
        }
        
        .logo {
            margin-bottom: 20px;
            color: #1a5f9e;
            font-size: 24px;
            font-weight: bold;
        }
        
        .logo span {
            color: #ffc107;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <div class="logo">学生成绩<span>管理系统</span></div>
    <h1>欢迎登录</h1>
    
    <%-- 显示错误消息 --%>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error-message"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
    <% } %>
    
    <div class="container">
        <%-- 登录表单 --%>
        <form action="login.jsp" method="post">
            <h2>用户登录</h2>
            
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" placeholder="用户名" required>
            </div>
            
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="密码" required>
            </div>
            
            <input type="submit" value="登 录">
        </form>
        <hr>
        <%-- 注册链接 --%>
        <p>还没有账号? <a href="register.jsp" class="register-link">立即注册</a></p>
    </div>
</body>
</html>