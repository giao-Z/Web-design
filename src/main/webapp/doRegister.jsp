<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String role = request.getParameter("role");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 检查用户名是否已存在
        String checkSql = "SELECT * FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // 插入新用户
        String insertSql = "INSERT INTO users (username, password, name, role) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        pstmt.setString(3, name);
        pstmt.setString(4, role);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("index.jsp?register=success");
        } else {
            request.setAttribute("error", "注册失败，请重试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "数据库错误: " + e.getMessage());
        request.getRequestDispatcher("register.jsp").forward(request, response);
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>