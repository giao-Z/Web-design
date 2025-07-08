<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
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
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(26, 95, 158, 0.15);
            padding: 30px;
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
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        
        table th {
            background-color: #1a5f9e;
            color: white;
            padding: 12px 15px;
            text-align: left;
        }
        
        table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e6ed;
        }
        
        table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        table tr:hover {
            background-color: #f0f5ff;
        }
        
        .action-links a {
            color: #1a5f9e;
            text-decoration: none;
            margin-right: 10px;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .action-links a:hover {
            background-color: #ffc107;
            color: #1a5f9e;
        }
        
        .nav-links {
            text-align: center;
            margin-top: 30px;
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
        
        .no-results {
            text-align: center;
            padding: 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>用户管理</h1>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>角色</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        conn = DBUtil.getConnection();
                        String sql = "SELECT * FROM users";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                        
                        boolean hasResults = false;
                        
                        while (rs.next()) {
                            // 不显示当前登录的管理员自己
                            if (rs.getInt("id") == (Integer)session.getAttribute("user_id")) continue;
                            
                            hasResults = true;
                %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("username") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("role") %></td>
                                <td class="action-links">
                                    <a href="deleteUser.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('确定删除用户 <%= rs.getString("name") %> 吗?')">删除</a>
                                </td>
                            </tr>
                <%
                        }
                        
                        if (!hasResults) {
                %>
                            <tr>
                                <td colspan="5" class="no-results">没有找到其他用户</td>
                            </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                %>
                        <tr>
                            <td colspan="5" class="no-results">查询出错: <%= e.getMessage() %></td>
                        </tr>
                <%
                    } finally {
                        DBUtil.close(conn, pstmt, rs);
                    }
                %>
            </tbody>
        </table>
        
        <div class="nav-links">
            <a href="adminDashboard.jsp">返回管理员面板</a>
        </div>
    </div>
</body>
</html>