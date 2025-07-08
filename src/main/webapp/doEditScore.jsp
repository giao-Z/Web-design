<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    request.setCharacterEncoding("UTF-8");
    int scoreId = Integer.parseInt(request.getParameter("id"));
    String term = request.getParameter("term");
    String subject = request.getParameter("subject");
    double dailyScore = Double.parseDouble(request.getParameter("daily_score"));
    double examScore = Double.parseDouble(request.getParameter("exam_score"));
    String remark = request.getParameter("remark");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "UPDATE scores SET term = ?, subject = ?, daily_score = ?, exam_score = ?, remark = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, term);
        pstmt.setString(2, subject);
        pstmt.setDouble(3, dailyScore);
        pstmt.setDouble(4, examScore);
        pstmt.setString(5, remark);
        pstmt.setInt(6, scoreId);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("adminViewScores.jsp?updated=true");
        } else {
            request.setAttribute("error", "更新失败，记录不存在或未更改");
            request.getRequestDispatcher("editScore.jsp?id=" + scoreId).forward(request, response);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "数据库错误: " + e.getMessage());
        request.getRequestDispatcher("editScore.jsp?id=" + scoreId).forward(request, response);
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>