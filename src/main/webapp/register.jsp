<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册</title>
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
        
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .form-group {
            width: 100%;
            margin-bottom: 20px;
            text-align: left;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #1a5f9e;
            font-weight: 600;
        }
        
        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus,
        select:focus {
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
        
        .login-link {
            margin-top: 25px;
            color: #666;
        }
        
        .login-link a {
            color: #1a5f9e;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
            padding: 8px 15px;
            border-radius: 4px;
        }
        
        .login-link a:hover {
            color: #13487a;
            background-color: rgba(255, 193, 7, 0.2);
            transform: translateY(-1px);
        }
        
        .login-link a::after {
            content: "→";
            margin-left: 5px;
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>用户注册</h1>
        
        <%-- 显示错误消息 --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="doRegister.jsp" method="post">
            <div class="form-group">
                <label for="username">用户名:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">密码:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="name">姓名:</label>
                <input type="text" id="name" name="name" required>
            </div>
            
            <div class="form-group">
                <label for="role">角色:</label>
                <select id="role" name="role">
                    <option value="student">学生</option>
                    <option value="admin">管理员</option>
                </select>
            </div>
            
            <input type="submit" value="注 册">
        </form>
        
        <div class="login-link">
            已有账号? <a href="index.jsp">返回登录</a>
        </div>
    </div>
</body>
</html>