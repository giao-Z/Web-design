<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // 登录成功，设置session
            session.setAttribute("user_id", rs.getInt("id"));
            session.setAttribute("username", username);
            session.setAttribute("name", rs.getString("name"));
            session.setAttribute("role", rs.getString("role"));
            
            // 根据角色跳转到不同页面
            if ("admin".equals(rs.getString("role"))) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.sendRedirect("studentDashboard.jsp");
            }
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "数据库错误: " + e.getMessage());
        request.getRequestDispatcher("index.jsp").forward(request, response);
    } finally {
        DBUtil.close(conn, pstmt, rs);
    }
%>