<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int userId = Integer.parseInt(request.getParameter("id"));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 开启事务
        conn.setAutoCommit(false);
        
        try {
            // 先删除该用户的成绩记录
            String deleteScoresSql = "DELETE FROM scores WHERE student_id = ?";
            pstmt = conn.prepareStatement(deleteScoresSql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            DBUtil.close(null, pstmt);
            
            // 删除该用户的论坛帖子
            String deletePostsSql = "DELETE FROM forum_posts WHERE user_id = ?";
            pstmt = conn.prepareStatement(deletePostsSql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            DBUtil.close(null, pstmt);
            
            // 最后删除用户
            String deleteUserSql = "DELETE FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(deleteUserSql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            
            // 提交事务
            conn.commit();
            
            response.sendRedirect("viewUsers.jsp?deleted=true");
        } catch (SQLException e) {
            // 回滚事务
            conn.rollback();
            throw e;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("viewUsers.jsp?error=删除失败");
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>