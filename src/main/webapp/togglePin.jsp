<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil"%>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    int postId = Integer.parseInt(request.getParameter("id"));
    boolean isPinned = Boolean.parseBoolean(request.getParameter("isPinned"));
    boolean newPinStatus = !isPinned; // 反转当前置顶状态

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DBUtil.getConnection();
        String sql = "UPDATE forum_posts SET is_pinned = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setBoolean(1, newPinStatus);
        pstmt.setInt(2, postId);
        pstmt.executeUpdate();
        response.sendRedirect("manageForum.jsp"); // 更新成功后重定向回论坛管理页面
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert(\'操作失败: " + e.getMessage() + "\'); window.location.href=\'manageForum.jsp\';</script>");
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>


