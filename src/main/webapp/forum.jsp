<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil, java.text.SimpleDateFormat, java.util.Date" %>
<%
    // 检查登录状态
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    request.setCharacterEncoding("UTF-8");

    // 分页参数
    int currentPage = 1;
    int recordsPerPage = 5; // 每页显示的帖子数量
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // 处理发帖
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        if (title != null && !title.trim().isEmpty() && content != null && !content.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                conn = DBUtil.getConnection();
                String sql = "INSERT INTO forum_posts (user_id, username, title, content, post_time) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, (Integer)session.getAttribute("user_id"));
                pstmt.setString(2, (String)session.getAttribute("username"));
                pstmt.setString(3, title);
                pstmt.setString(4, content);
                pstmt.setTimestamp(5, new Timestamp(new Date().getTime()));
                pstmt.executeUpdate();
                
                // 发帖后重定向到第一页
                response.sendRedirect("forum.jsp?page=1");
                return;
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt);
            }
        }
    }
    
    // 获取帖子总数
    int totalRecords = 0;
    int totalPages = 0;
    Connection countConn = null;
    PreparedStatement countStmt = null;
    ResultSet countRs = null;
    
    try {
        countConn = DBUtil.getConnection();
        String countSql = "SELECT COUNT(*) AS total FROM forum_posts";
        countStmt = countConn.prepareStatement(countSql);
        countRs = countStmt.executeQuery();
        if (countRs.next()) {
            totalRecords = countRs.getInt("total");
        }
        
        // 计算总页数
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // 确保当前页在有效范围内
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(countConn, countStmt, countRs);
    }
    
    // 获取当前页的帖子
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>论坛</title>
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
            max-width: 1000px;
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
        
        .post-form {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #e0e6ed;
        }
        
        .post-form input[type="text"],
        .post-form textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .post-form input[type="text"]:focus,
        .post-form textarea:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        .post-form textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .post-form input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .post-form input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 95, 158, 0.3);
        }
        
        .post {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            margin: 20px 0;
            padding: 20px;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .pinned-post {
            border-left: 4px solid #ffc107;
            background-color: #f8f9fa;
        }
        
        .post-header {
            font-weight: bold;
            margin-bottom: 15px;
            color: #1a5f9e;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .post-content {
            margin-left: 10px;
            padding: 15px 0;
        }
        
        .post-content h3 {
            color: #1a5f9e;
            margin-bottom: 10px;
        }
        
        .post-content p {
            line-height: 1.6;
        }
        
        .replies {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px dashed #e0e6ed;
        }
        
        .replies h4 {
            color: #1a5f9e;
            margin-bottom: 15px;
        }
        
        .reply {
            border-left: 3px solid #ffc107;
            margin-left: 20px;
            padding-left: 15px;
            margin-bottom: 15px;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 0 6px 6px 0;
        }
        
        .reply-header {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }
        
        .reply-content {
            line-height: 1.5;
        }
        
        .reply-form {
            margin-top: 15px;
        }
        
        .reply-form textarea {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            margin-bottom: 10px;
            font-size: 14px;
            transition: all 0.3s;
            resize: vertical;
            min-height: 60px;
        }
        
        .reply-form textarea:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        .reply-form input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .reply-form input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
        }
        
        .pinned-badge {
            background-color: #ffc107;
            color: #1a5f9e;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.8em;
            font-weight: bold;
            margin-left: 10px;
        }
        
        .pagination {
            margin: 30px 0;
            text-align: center;
        }
        
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 3px;
            border: 1px solid #e0e6ed;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #1a5f9e;
        }
        
        .pagination .active {
            background-color: #1a5f9e;
            color: white;
            border-color: #1a5f9e;
        }
        
        .pagination .disabled {
            color: #ccc;
            pointer-events: none;
        }
        
        .page-info {
            text-align: center;
            margin: 10px 0;
            color: #666;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>论坛</h1>
        
        <%-- 发帖表单 --%>
        <form action="forum.jsp" method="post" class="post-form">
            <input type="text" name="title" placeholder="帖子标题" required>
            <textarea name="content" placeholder="帖子内容" required></textarea>
            <input type="submit" value="发帖">
        </form>
        
        <%-- 显示所有帖子 --%>
        <h2 style="color: #1a5f9e; margin-bottom: 20px;">所有帖子</h2>
        <%
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM forum_posts ORDER BY is_pinned DESC, post_time DESC LIMIT ?, ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, (currentPage - 1) * recordsPerPage);
                pstmt.setInt(2, recordsPerPage);
                rs = pstmt.executeQuery();
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                
                while (rs.next()) {
                    int postId = rs.getInt("id");
        %>
            <div class="post <%= rs.getBoolean("is_pinned") ? "pinned-post" : "" %>">
                <div class="post-header">
                    <span>
                        <%= rs.getString("username") %> - <%= sdf.format(rs.getTimestamp("post_time")) %>
                        <% if (rs.getBoolean("is_pinned")) { %>
                            <span class="pinned-badge">置顶</span>
                        <% } %>
                    </span>
                </div>
                <div class="post-content">
                    <h3><%= rs.getString("title") %></h3>
                    <p><%= rs.getString("content") %></p>
                </div>
                
                <%-- 显示回复 --%>
                <div class="replies">
                    <h4>回复:</h4>
                    <%
                        Connection replyConn = null;
                        PreparedStatement replyPstmt = null;
                        ResultSet replyRs = null;
                        try {
                            replyConn = DBUtil.getConnection();
                            String replySql = "SELECT * FROM forum_replies WHERE post_id = ? ORDER BY reply_time ASC";
                            replyPstmt = replyConn.prepareStatement(replySql);
                            replyPstmt.setInt(1, postId);
                            replyRs = replyPstmt.executeQuery();
                            while (replyRs.next()) {
                    %>
                                <div class="reply">
                                    <div class="reply-header">
                                        <%= replyRs.getString("username") %> - <%= sdf.format(replyRs.getTimestamp("reply_time")) %>
                                    </div>
                                    <div class="reply-content">
                                        <%= replyRs.getString("content") %>
                                    </div>
                                </div>
                    <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            DBUtil.close(replyConn, replyPstmt, replyRs);
                        }
                    %>
                </div>
                
                <%-- 回复表单 --%>
                <form action="doReply.jsp" method="post" class="reply-form">
                    <input type="hidden" name="postId" value="<%= postId %>">
                    <textarea name="content" placeholder="发表回复" required></textarea>
                    <input type="submit" value="回复">
                </form>
            </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        %>
        
        <%-- 分页导航 --%>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="forum.jsp?page=<%= currentPage - 1 %>">上一页</a>
            <% } else { %>
                <span class="disabled">上一页</span>
            <% } %>
            
            <% 
                // 显示页码链接
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                if (startPage > 1) {
            %>
                <a href="forum.jsp?page=1">1</a>
                <% if (startPage > 2) { %>...<% } %>
            <% } %>
            
            <% for (int i = startPage; i <= endPage; i++) { %>
                <% if (i == currentPage) { %>
                    <span class="active"><%= i %></span>
                <% } else { %>
                    <a href="forum.jsp?page=<%= i %>"><%= i %></a>
                <% } %>
            <% } %>
            
            <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>...<% } %>
                <a href="forum.jsp?page=<%= totalPages %>"><%= totalPages %></a>
            <% } %>
            
            <% if (currentPage < totalPages) { %>
                <a href="forum.jsp?page=<%= currentPage + 1 %>">下一页</a>
            <% } else { %>
                <span class="disabled">下一页</span>
            <% } %>
        </div>
        
        <div class="page-info">
            共 <%= totalRecords %> 条帖子，当前显示第 <%= (currentPage - 1) * recordsPerPage + 1 %> - 
            <%= Math.min(currentPage * recordsPerPage, totalRecords) %> 条
        </div>
        
        <%
            if ("admin".equals(session.getAttribute("role"))) {
        %>
        <div class="nav-links"><a href="adminDashboard.jsp">返回管理员面板</a></div>
        <%
            } else {
        %>
        <div class="nav-links"><a href="studentDashboard.jsp">返回学生面板</a></div>
        <%
            }
        %>
    </div>
</body>
</html>