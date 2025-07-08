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
    
    try {
        conn = DBUtil.getConnection();
        String sql = "DELETE FROM scores WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, scoreId);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("adminViewScores.jsp?deleted=true");
        } else {
            response.sendRedirect("adminViewScores.jsp?error=删除失败，记录不存在");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("adminViewScores.jsp?error=数据库错误：" + e.getMessage());
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>