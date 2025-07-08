<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<%
    // 检查登录状态
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String name = request.getParameter("name");
    String newPassword = request.getParameter("new_password");
    String confirmPassword = request.getParameter("confirm_password");
    String currentPassword = request.getParameter("current_password");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 验证当前密码
        String checkSql = "SELECT * FROM users WHERE id = ? AND password = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, (Integer)session.getAttribute("user_id"));
        pstmt.setString(2, currentPassword);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            request.setAttribute("error", "当前密码错误");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }
        
        // 更新信息
        String updateSql;
        if (newPassword != null && !newPassword.isEmpty()) {
            // 验证新密码和确认密码是否一致
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "新密码和确认密码不一致");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                return;
            }
            updateSql = "UPDATE users SET name = ?, password = ? WHERE id = ?";
        } else {
            updateSql = "UPDATE users SET name = ? WHERE id = ?";
        }
        
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, name);
        if (newPassword != null && !newPassword.isEmpty()) {
            pstmt.setString(2, newPassword);
            pstmt.setInt(3, (Integer)session.getAttribute("user_id"));
        } else {
            pstmt.setInt(2, (Integer)session.getAttribute("user_id"));
        }
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 更新session中的name
            session.setAttribute("name", name);
            request.setAttribute("success", "个人信息更新成功");
        } else {
            request.setAttribute("error", "更新失败");
        }
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "数据库错误: " + e.getMessage());
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
    } finally {
        DBUtil.close(conn, pstmt, rs);
    }
%>