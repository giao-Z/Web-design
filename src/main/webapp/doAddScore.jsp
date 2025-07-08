<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    request.setCharacterEncoding("UTF-8");
    int studentId = Integer.parseInt(request.getParameter("student_id"));
    String term = request.getParameter("term");
    String subject = request.getParameter("subject");
    double dailyScore = Double.parseDouble(request.getParameter("daily_score"));
    double examScore = Double.parseDouble(request.getParameter("exam_score"));
    String remark = request.getParameter("remark");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "INSERT INTO scores (student_id, term, subject, daily_score, exam_score, remark) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);
        pstmt.setString(2, term);
        pstmt.setString(3, subject);
        pstmt.setDouble(4, dailyScore);
        pstmt.setDouble(5, examScore);
        pstmt.setString(6, remark);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("adminViewScores.jsp?added=true");
        } else {
            request.setAttribute("error", "添加失败");
            request.getRequestDispatcher("addScore.jsp").forward(request, response);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "数据库错误: " + e.getMessage());
        request.getRequestDispatcher("addScore.jsp").forward(request, response);
    } finally {
        DBUtil.close(conn, pstmt);
    }
%>