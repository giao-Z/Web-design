<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 获取当前用户信息
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT * FROM users WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, (Integer)session.getAttribute("user_id"));
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("index.jsp");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改个人信息</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f9ff 0%, #e6f0ff 100%);
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(26, 95, 158, 0.15);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            border-top: 5px solid #ffc107;
        }
        
        h1 {
            color: #1a5f9e;
            margin-bottom: 30px;
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
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        input[type="text"][readonly] {
            background-color: #f8f9fa;
            color: #666;
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
            padding: 10px 20px;
            border-radius: 6px;
            transition: all 0.3s;
            display: inline-block;
            border: 2px solid #1a5f9e;
        }
        
        .nav-links a:hover {
            background-color: #ffc107;
            color: #1a5f9e;
            border-color: #ffc107;
            transform: translateY(-2px);
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
    <div class="container">
        <h1>修改个人信息</h1>
        
        <%-- 显示错误消息 --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <%-- 显示成功消息 --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <form action="doEditProfile.jsp" method="post">
            <div class="form-group">
                <label for="username">用户名:</label>
                <input type="text" id="username" name="username" value="<%= rs.getString("username") %>" readonly>
            </div>
            
            <div class="form-group">
                <label for="name">姓名:</label>
                <input type="text" id="name" name="name" value="<%= rs.getString("name") %>" required>
            </div>
            
            <div class="form-group">
                <label for="new_password">新密码 (留空则不修改):</label>
                <input type="password" id="new_password" name="new_password" placeholder="输入新密码">
            </div>
            
            <div class="form-group">
                <label for="confirm_password">确认新密码:</label>
                <input type="password" id="confirm_password" name="confirm_password" placeholder="再次输入新密码">
            </div>
            
            <div class="form-group">
                <label for="current_password">当前密码:</label>
                <input type="password" id="current_password" name="current_password" placeholder="输入当前密码" required>
            </div>
            
            <input type="submit" value="保存更改">
        </form>
        
        <div class="nav-links">
            <%
                if ("admin".equals(session.getAttribute("role"))) {
            %>
                <a href="adminDashboard.jsp">返回管理员面板</a>
            <%
                } else {
            %>
                <a href="studentDashboard.jsp">返回学生面板</a>
            <%
                }
                DBUtil.close(conn, pstmt, rs);
            %>
        </div>
    </div>
</body>
</html>