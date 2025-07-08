<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil, java.net.URLEncoder" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 获取参数
    String term = request.getParameter("term");
    String studentName = request.getParameter("student_name");
    String subject = request.getParameter("subject");
    String studentId = request.getParameter("student_id");
    
    // 分页参数 - 设置每页10条记录
    int pageSize = 10;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * pageSize;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement countStmt = null;
    ResultSet rs = null;
    ResultSet countRs = null;
    
    // 获取总记录数
    int totalRecords = 0;
    try {
        conn = DBUtil.getConnection();
        String countSql = "SELECT COUNT(*) FROM scores s JOIN users u ON s.student_id = u.id WHERE 1=1";
        
        if (studentId != null && !studentId.isEmpty()) {
            countSql += " AND s.student_id = ?";
        }
        if (term != null && !term.isEmpty()) {
            countSql += " AND s.term LIKE ?";
        }
        if (studentName != null && !studentName.isEmpty()) {
            countSql += " AND u.name LIKE ?";
        }
        if (subject != null && !subject.isEmpty()) {
            countSql += " AND s.subject LIKE ?";
        }
        
        countStmt = conn.prepareStatement(countSql);
        
        int paramIndex = 1;
        if (studentId != null && !studentId.isEmpty()) {
            try {
                countStmt.setInt(paramIndex++, Integer.parseInt(studentId));
            } catch (NumberFormatException e) {
                throw new ServletException("无效的学生ID格式: " + studentId);
            }
        }
        if (term != null && !term.isEmpty()) {
            countStmt.setString(paramIndex++, "%" + term + "%");
        }
        if (studentName != null && !studentName.isEmpty()) {
            countStmt.setString(paramIndex++, "%" + studentName + "%");
        }
        if (subject != null && !subject.isEmpty()) {
            countStmt.setString(paramIndex++, "%" + subject + "%");
        }
        
        countRs = countStmt.executeQuery();
        if (countRs.next()) {
            totalRecords = countRs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(null, countStmt, countRs);
    }
    
    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
    
    // 构建查询参数字符串，用于分页链接
    StringBuilder queryParams = new StringBuilder();
    if (studentId != null && !studentId.isEmpty()) queryParams.append("&student_id=").append(URLEncoder.encode(studentId, "UTF-8"));
    if (term != null && !term.isEmpty()) queryParams.append("&term=").append(URLEncoder.encode(term, "UTF-8"));
    if (studentName != null && !studentName.isEmpty()) queryParams.append("&student_name=").append(URLEncoder.encode(studentName, "UTF-8"));
    if (subject != null && !subject.isEmpty()) queryParams.append("&subject=").append(URLEncoder.encode(subject, "UTF-8"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生成绩查询</title>
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
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1a5f9e;
            font-weight: 600;
        }
        
        .form-group input[type="text"],
        .form-group input[type="number"] {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .form-actions input[type="submit"],
        .form-actions input[type="button"],
        .form-actions a.button {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
        }
        
        .form-actions input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
        }
        
        .form-actions input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 95, 158, 0.3);
        }
        
        .form-actions input[type="button"] {
            background-color: #e0e6ed;
            color: #333;
        }
        
        .form-actions input[type="button"]:hover {
            background-color: #d0d6dd;
            transform: translateY(-2px);
        }
        
        .form-actions a.button {
            background-color: #ffc107;
            color: #1a5f9e;
            display: inline-block;
        }
        
        .form-actions a.button:hover {
            background-color: #e0a800;
            transform: translateY(-2px);
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
        
        .pagination {
            margin: 20px 0;
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
        
        .pagination .current-page {
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
        
        .no-results {
            text-align: center;
            padding: 20px;
            color: #666;
        }
        
        .error {
            color: #e74c3c;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>学生成绩查询</h1>
        
        <form action="adminViewScores.jsp" method="get" class="search-form">
            <input type="hidden" name="page" value="1">
            <div class="form-row">
                <div class="form-group" style="flex: 1; margin-right: 15px;">
                    <label for="student_id">学生ID:</label>
                    <input type="text" id="student_id" name="student_id" value="<%= studentId == null ? "" : studentId %>">
                </div>
                
                <div class="form-group" style="flex: 1;">
                    <label for="student_name">学生姓名:</label>
                    <input type="text" id="student_name" name="student_name" value="<%= studentName == null ? "" : studentName %>">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group" style="flex: 1; margin-right: 15px;">
                    <label for="term">学期:</label>
                    <input type="text" id="term" name="term" value="<%= term == null ? "" : term %>" placeholder="如: 2023-2024-1">
                </div>
                
                <div class="form-group" style="flex: 1;">
                    <label for="subject">科目:</label>
                    <input type="text" id="subject" name="subject" value="<%= subject == null ? "" : subject %>">
                </div>
            </div>
            
            <div class="form-actions">
                <input type="submit" value="查询">
                <input type="button" value="重置" onclick="location.href='adminViewScores.jsp'">
                <% if ((studentId != null && !studentId.isEmpty()) || (term != null && !term.isEmpty())) { %>
                <a href="adminExportScores.jsp?student_id=<%= studentId %>&term=<%= term %>" class="button">导出查询结果</a>
                <% } %>
            </div>
        </form>
        
        <table>
            <thead>
                <tr>
                    <th>学生ID</th>
                    <th>学生姓名</th>
                    <th>学期</th>
                    <th>科目</th>
                    <th>平时成绩</th>
                    <th>期末成绩</th>
                    <th>总成绩</th>
                    <th>备注</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        conn = DBUtil.getConnection();
                        String sql = "SELECT s.*, u.name as student_name FROM scores s JOIN users u ON s.student_id = u.id WHERE 1=1";
                        
                        if (studentId != null && !studentId.isEmpty()) {
                            sql += " AND s.student_id = ?";
                        }
                        if (studentName != null && !studentName.isEmpty()) {
                            sql += " AND u.name LIKE ?";
                        }
                        if (term != null && !term.isEmpty()) {
                            sql += " AND s.term LIKE ?";
                        }
                        if (subject != null && !subject.isEmpty()) {
                            sql += " AND s.subject LIKE ?";
                        }
                        
                        sql += " ORDER BY s.term DESC, u.name, s.subject";
                        // 添加分页限制
                        sql += " LIMIT ?, ?";
                        
                        pstmt = conn.prepareStatement(sql);
                        
                        int paramIndex = 1;
                        if (studentId != null && !studentId.isEmpty()) {
                            try {
                                pstmt.setInt(paramIndex++, Integer.parseInt(studentId));
                            } catch (NumberFormatException e) {
                                throw new ServletException("无效的学生ID格式: " + studentId);
                            }
                        }
                        if (studentName != null && !studentName.isEmpty()) {
                            pstmt.setString(paramIndex++, "%" + studentName + "%");
                        }
                        if (term != null && !term.isEmpty()) {
                            pstmt.setString(paramIndex++, "%" + term + "%");
                        }
                        if (subject != null && !subject.isEmpty()) {
                            pstmt.setString(paramIndex++, "%" + subject + "%");
                        }
                        
                        // 设置分页参数
                        pstmt.setInt(paramIndex++, offset);
                        pstmt.setInt(paramIndex++, pageSize);
                        
                        rs = pstmt.executeQuery();
                        
                        if (!rs.isBeforeFirst()) {
                %>
                            <tr>
                                <td colspan="9" class="no-results">没有找到匹配的成绩记录</td>
                            </tr>
                <%
                        } else {
                            while (rs.next()) {
                %>
                                <tr>
                                    <td><%= rs.getInt("student_id") %></td>
                                    <td><%= rs.getString("student_name") %></td>
                                    <td><%= rs.getString("term") %></td>
                                    <td><%= rs.getString("subject") %></td>
                                    <td><%= rs.getDouble("daily_score") %></td>
                                    <td><%= rs.getDouble("exam_score") %></td>
                                    <td><%= rs.getDouble("score") %></td>
                                    <td><%= rs.getString("remark") == null ? "" : rs.getString("remark") %></td>
                                    <td class="action-links">
                                        <a href="editScore.jsp?id=<%= rs.getInt("id") %>">编辑</a>
                                        <a href="deleteScore.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('确定删除吗?')">删除</a>
                                    </td>
                                </tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                %>
                        <tr>
                            <td colspan="9" class="error">查询出错: <%= e.getMessage() %></td>
                        </tr>
                <%
                    } finally {
                        DBUtil.close(conn, pstmt, rs);
                    }
                %>
            </tbody>
        </table>
        
        <%-- 分页导航 --%>
        <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="adminViewScores.jsp?page=1<%= queryParams %>">首页</a>
                    <a href="adminViewScores.jsp?page=<%= currentPage-1 %><%= queryParams %>">上一页</a>
                <% } %>
                
                <% 
                // 显示页码范围（最多显示5个页码）
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, startPage + 4);
                if (endPage - startPage < 4) {
                    startPage = Math.max(1, endPage - 4);
                }
                
                for (int i = startPage; i <= endPage; i++) { 
                %>
                    <% if (i == currentPage) { %>
                        <span class="current-page"><%= i %></span>
                    <% } else { %>
                        <a href="adminViewScores.jsp?page=<%= i %><%= queryParams %>"><%= i %></a>
                    <% } %>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="adminViewScores.jsp?page=<%= currentPage+1 %><%= queryParams %>">下一页</a>
                    <a href="adminViewScores.jsp?page=<%= totalPages %><%= queryParams %>">末页</a>
                <% } %>
            </div>
            <div class="page-info">
                显示 <%= (currentPage-1)*pageSize+1 %> 到 <%= Math.min(currentPage*pageSize, totalRecords) %> 条记录，共 <%= totalRecords %> 条 | 每页 <%= pageSize %> 条
            </div>
        <% } %>
        
        <div class="nav-links">
            <a href="adminDashboard.jsp">返回管理员面板</a>
        </div>
    </div>
</body>
</html>