<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBUtil"%>
<% 
    // 检查用户是否登录
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8"); // Add this line

    int postId = Integer.parseInt(request.getParameter("postId"));
    String content = request.getParameter("content");
    int userId = (Integer) session.getAttribute("user_id");
    String username = (String) session.getAttribute("username");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DBUtil.getConnection();
        String sql = "INSERT INTO forum_replies (post_id, user_id, username, content) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postId);
        pstmt.setInt(2, userId);
        pstmt.setString(3, username);
        pstmt.setString(4, content);
        pstmt.executeUpdate();
        response.sendRedirect("forum.jsp"); // 回复成功后重定向回论坛页面
    } catch (SQLException e) {
        e.printStackTrace();
        // 可以添加错误处理，例如重定向到错误页面或在当前页面显示错误信息
        out.println("<script>alert(\'回复失败: " + e.getMessage() + "\'); window.location.href=\'forum.jsp\';</script>");
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>


