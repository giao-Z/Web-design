<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int scoreId = Integer.parseInt(request.getParameter("id"));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT s.*, u.name as student_name FROM scores s JOIN users u ON s.student_id = u.id WHERE s.id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, scoreId);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("adminViewScores.jsp?error=记录不存在");
            return;
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑成绩</title>
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
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(26, 95, 158, 0.15);
            padding: 30px;
            width: 100%;
            max-width: 800px;
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
        
        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            text-align: center;
        }
        
        .error {
            background-color: #fdecea;
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }
        
        .form-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .form-table tr {
            border-bottom: 1px solid #e0e6ed;
        }
        
        .form-table tr:last-child {
            border-bottom: none;
        }
        
        .form-table td {
            padding: 15px 10px;
            vertical-align: top;
        }
        
        .form-table td:first-child {
            width: 150px;
            font-weight: 600;
            color: #1a5f9e;
        }
        
        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px 15px;
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
        
        .hint {
            font-size: 0.9em;
            color: #666;
            margin-left: 10px;
        }
        
        .form-actions {
            text-align: center;
            padding-top: 20px;
        }
        
        input[type="submit"],
        .button {
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        input[type="submit"] {
            background-color: #1a5f9e;
            color: white;
        }
        
        input[type="submit"]:hover {
            background-color: #13487a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 95, 158, 0.3);
        }
        
        .button {
            background-color: #ffc107;
            color: #1a5f9e;
            margin-left: 15px;
        }
        
        .button:hover {
            background-color: #e0a800;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>编辑成绩</h1>
        
        <%-- 显示错误消息 --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="message error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="doEditScore.jsp" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            
            <table class="form-table">
                <tr>
                    <td>学生ID:</td>
                    <td><%= rs.getInt("student_id") %></td>
                </tr>
                <tr>
                    <td>学生姓名:</td>
                    <td><%= rs.getString("student_name") %></td>
                </tr>
                <tr>
                    <td>学期:</td>
                    <td><input type="text" name="term" value="<%= rs.getString("term") %>" required></td>
                </tr>
                <tr>
                    <td>科目:</td>
                    <td><input type="text" name="subject" value="<%= rs.getString("subject") %>" required></td>
                </tr>
                <tr>
                    <td>平时成绩:</td>
                    <td>
                        <input type="number" name="daily_score" step="0.1" min="0" max="100" 
                               value="<%= rs.getDouble("daily_score") %>" required>
                    </td>
                </tr>
                <tr>
                    <td>期末成绩:</td>
                    <td>
                        <input type="number" name="exam_score" step="0.1" min="0" max="100" 
                               value="<%= rs.getDouble("exam_score") %>" required>
                    </td>
                </tr>
                <tr>
                    <td>总成绩:</td>
                    <td>
                        <input type="number" step="0.1" min="0" max="100" 
                               value="<%= (rs.getDouble("daily_score") * 0.5 + rs.getDouble("exam_score") * 0.5) %>" 
                               readonly>
                        <span class="hint">(自动计算: 平时50% + 期末50%)</span>
                    </td>
                </tr>
                <tr>
                    <td>备注:</td>
                    <td>
                        <textarea name="remark" rows="3"><%= rs.getString("remark") == null ? "" : rs.getString("remark") %></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="form-actions">
                        <input type="submit" value="保存修改">
                        <a href="adminViewScores.jsp" class="button">取消</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
<%
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("adminViewScores.jsp?error=数据库错误：" + e.getMessage());
    } finally {
        DBUtil.close(conn, pstmt, rs);
    }
%>