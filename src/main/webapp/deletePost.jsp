<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int postId = Integer.parseInt(request.getParameter("id"));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "DELETE FROM forum_posts WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postId);
        pstmt.executeUpdate();
        
        response.sendRedirect("manageForum.jsp?deleted=true");
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("manageForum.jsp?error=删除失败");
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>