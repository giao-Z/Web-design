<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int replyId = Integer.parseInt(request.getParameter("id"));
    int postId = Integer.parseInt(request.getParameter("postId"));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "DELETE FROM forum_replies WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, replyId);
        pstmt.executeUpdate();
        
        response.sendRedirect("manageForum.jsp?deletedReply=true&postId=" + postId);
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("manageForum.jsp?error=删除回复失败&postId=" + postId);
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>

