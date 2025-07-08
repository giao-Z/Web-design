<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil, java.text.SimpleDateFormat" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 分页参数
    int currentPage = 1;
    int recordsPerPage = 5; // 每页显示的记录数
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement countStmt = null;
    ResultSet rs = null;
    ResultSet countRs = null;
    
    int totalRecords = 0;
    int totalPages = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>论坛管理</title>
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
        
        .search-form {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #e0e6ed;
        }
        
        .search-form input[type="text"] {
            padding: 10px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
            width: 300px;
        }
        
        .search-form input[type="text"]:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        .search-form input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .search-form input[type="submit"]:hover {
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
            display: flex;
            justify-content: space-between;
        }
        
        .reply-content {
            line-height: 1.5;
        }
        
        .action-link {
            color: #1a5f9e;
            text-decoration: none;
            margin-left: 10px;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .action-link:hover {
            background-color: #ffc107;
            color: #1a5f9e;
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
        <h1>论坛管理</h1>

        <form action="manageForum.jsp" method="get" class="search-form">
            搜索用户: 
            <input type="text" name="searchUser" value="<%= request.getParameter("searchUser") != null ? request.getParameter("searchUser") : "" %>">
            <input type="submit" value="搜索">
            <input type="hidden" name="page" value="1">
        </form>
        
        <%
            String searchUser = request.getParameter("searchUser");
            try {
                conn = DBUtil.getConnection();
                
                // 首先获取总记录数
                String countSql = "SELECT COUNT(*) AS total FROM forum_posts";
                if (searchUser != null && !searchUser.isEmpty()) {
                    countSql += " WHERE username LIKE ?";
                }
                
                countStmt = conn.prepareStatement(countSql);
                
                if (searchUser != null && !searchUser.isEmpty()) {
                    countStmt.setString(1, "%" + searchUser + "%");
                }
                
                countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    totalRecords = countRs.getInt("total");
                }
                
                // 计算总页数
                totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                
                // 确保当前页在有效范围内
                if (currentPage > totalPages) {
                    currentPage = totalPages;
                }
                if (currentPage < 1) {
                    currentPage = 1;
                }
                
                // 获取当前页的数据
                String sql = "SELECT * FROM forum_posts";
                
                if (searchUser != null && !searchUser.isEmpty()) {
                    sql += " WHERE username LIKE ?";
                }
                
                sql += " ORDER BY is_pinned DESC, post_time DESC LIMIT ?, ?";
                
                pstmt = conn.prepareStatement(sql);
                
                int paramIndex = 1;
                if (searchUser != null && !searchUser.isEmpty()) {
                    pstmt.setString(paramIndex++, "%" + searchUser + "%");
                }
                
                pstmt.setInt(paramIndex++, (currentPage - 1) * recordsPerPage);
                pstmt.setInt(paramIndex, recordsPerPage);
                
                rs = pstmt.executeQuery();
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                
                while (rs.next()) {
                    int postId = rs.getInt("id");
                    boolean isPinned = rs.getBoolean("is_pinned");
        %>
            <div class="post <%= isPinned ? "pinned-post" : "" %>">
                <div class="post-header">
                    <span>
                        <%= rs.getString("username") %> - <%= sdf.format(rs.getTimestamp("post_time")) %>
                        <% if (isPinned) { %>
                            <span class="pinned-badge">已置顶</span>
                        <% } %>
                    </span>
                    <div>
                        <a href="togglePin.jsp?id=<%= postId %>&isPinned=<%= isPinned ? "true" : "false" %>" class="action-link">
                            <%= isPinned ? "取消置顶" : "置顶" %>
                        </a>
                        <a href="deletePost.jsp?id=<%= postId %>" class="action-link" onclick="return confirm('确定删除此帖子吗?')">
                            删除
                        </a>
                    </div>
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
                                        <span><%= replyRs.getString("username") %> - <%= sdf.format(replyRs.getTimestamp("reply_time")) %></span>
                                        <a href="deleteReply.jsp?id=<%= replyRs.getInt("id") %>&postId=<%= postId %>" class="action-link" onclick="return confirm('确定删除此回复吗?')">
                                            删除
                                        </a>
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
            </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
                DBUtil.close(null, countStmt, countRs);
            }
        %>
        
        <%-- 分页导航 --%>
        <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="manageForum.jsp?page=<%= currentPage-1 %><%= searchUser != null ? "&searchUser=" + searchUser : "" %>">上一页</a>
                <% } %>
                
                <% 
                    // 显示页码链接
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    
                    if (startPage > 1) {
                %>
                    <a href="manageForum.jsp?page=1<%= searchUser != null ? "&searchUser=" + searchUser : "" %>">1</a>
                    <% if (startPage > 2) { %>...<% } %>
                <% } %>
                
                <% for (int i = startPage; i <= endPage; i++) { %>
                    <a href="manageForum.jsp?page=<%= i %><%= searchUser != null ? "&searchUser=" + searchUser : "" %>" <%= i == currentPage ? "class=\"active\"" : "" %>><%= i %></a>
                <% } %>
                
                <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %>...<% } %>
                    <a href="manageForum.jsp?page=<%= totalPages %><%= searchUser != null ? "&searchUser=" + searchUser : "" %>"><%= totalPages %></a>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="manageForum.jsp?page=<%= currentPage+1 %><%= searchUser != null ? "&searchUser=" + searchUser : "" %>">下一页</a>
                <% } %>
            </div>
            <div class="page-info">
                共 <%= totalRecords %> 条记录，当前显示第 <%= (currentPage-1)*recordsPerPage+1 %> - 
                <%= Math.min(currentPage*recordsPerPage, totalRecords) %> 条
            </div>
        <% } %>
        
        <div class="nav-links">
            <a href="adminDashboard.jsp">返回管理员面板</a>
        </div>
    </div>
</body>
</html>