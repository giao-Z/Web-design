<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="none"%>
<%@ page import="java.sql.*, util.DBUtil, java.io.*, java.text.SimpleDateFormat" %>
<%@ page import="org.apache.poi.ss.usermodel.*, org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%
    // 检查登录状态
    if (session.getAttribute("username") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    int studentId = (Integer)session.getAttribute("user_id");
    String term = request.getParameter("term");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Workbook workbook = null;
    ServletOutputStream outputStream = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT * FROM scores WHERE student_id = ?";
        
        if (term != null && !term.trim().isEmpty()) {
            sql += " AND term LIKE ?";
        }
        
        sql += " ORDER BY term, subject";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);
        
        if (term != null && !term.trim().isEmpty()) {
            pstmt.setString(2, "%" + term.trim() + "%");
        }
        
        rs = pstmt.executeQuery();
        
        // 重置响应
        response.reset();
        // 设置响应内容类型为Excel
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        
        // 设置文件名（处理中文文件名）
        String fileName = "我的成绩_" + 
                         (term != null && !term.trim().isEmpty() ? term.trim() : "全部") + "_" + 
                         new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".xlsx";
        String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);
        
        // 创建Excel工作簿
        workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("成绩单");
        
        // 创建标题行样式
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 创建标题行
        Row headerRow = sheet.createRow(0);
        String[] headers = {"学期", "科目", "平时成绩", "期末成绩", "总成绩", "备注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 填充数据
        int rowNum = 1;
        while (rs.next()) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rs.getString("term"));
            row.createCell(1).setCellValue(rs.getString("subject"));
            row.createCell(2).setCellValue(rs.getDouble("daily_score"));
            row.createCell(3).setCellValue(rs.getDouble("exam_score"));
            row.createCell(4).setCellValue(rs.getDouble("score"));
            row.createCell(5).setCellValue(rs.getString("remark") == null ? "" : rs.getString("remark"));
        }
        
        // 自动调整列宽
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // 获取输出流并写入Excel
        outputStream = response.getOutputStream();
        workbook.write(outputStream);
        
    } catch (SQLException e) {
        e.printStackTrace();
        if (!response.isCommitted()) {
            response.sendRedirect("viewMyScores.jsp?error=" + java.net.URLEncoder.encode("导出失败: " + e.getMessage(), "UTF-8"));
        }
    } catch (Exception e) {
        e.printStackTrace();
        if (!response.isCommitted()) {
            response.sendRedirect("viewMyScores.jsp?error=" + java.net.URLEncoder.encode("导出失败: " + e.getMessage(), "UTF-8"));
        }
    } finally {
        // 关闭资源（按正确顺序关闭）
        try {
            if (workbook != null) {
                workbook.close();
            }
            if (outputStream != null) {
                outputStream.flush();
                outputStream.close();
            }
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>