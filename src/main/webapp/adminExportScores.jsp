<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="none"%>
<%@ page import="java.sql.*, util.DBUtil, java.io.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="org.apache.poi.ss.usermodel.*, org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%
    // 检查登录状态和角色
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentIdParam = request.getParameter("student_id");
    String term = request.getParameter("term");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Workbook workbook = null;
    ServletOutputStream outputStream = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT s.*, u.name as student_name FROM scores s JOIN users u ON s.student_id = u.id WHERE 1=1";
        
        if (studentIdParam != null && !studentIdParam.isEmpty()) {
            sql += " AND s.student_id = ?";
        }
        if (term != null && !term.isEmpty()) {
            sql += " AND s.term = ?";
        }
        
        // 修改排序条件：先按学生ID升序，再按学期降序，最后按科目
        sql += " ORDER BY s.student_id ASC, s.term DESC, s.subject";
        
        pstmt = conn.prepareStatement(sql);
        
        int paramIndex = 1;
        if (studentIdParam != null && !studentIdParam.isEmpty()) {
            pstmt.setInt(paramIndex++, Integer.parseInt(studentIdParam));
        }
        if (term != null && !term.isEmpty()) {
            pstmt.setString(paramIndex++, term);
        }
        
        rs = pstmt.executeQuery();
        
        // 设置响应头为Excel格式
        response.reset();
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String filename = "成绩导出_" + 
                         (studentIdParam != null ? "学生" + studentIdParam : "全部学生") + "_" +
                         (term != null ? term : "全部学期") + "_" + 
                         new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xlsx";
        String encodedFilename = java.net.URLEncoder.encode(filename, "UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename);
        
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
        String[] headers = {"学生ID", "学生姓名", "学期", "科目", "平时成绩", "期末成绩", "总成绩", "备注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 填充数据
        int rowNum = 1;
        while (rs.next()) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rs.getInt("student_id"));
            row.createCell(1).setCellValue(rs.getString("student_name"));
            row.createCell(2).setCellValue(rs.getString("term"));
            row.createCell(3).setCellValue(rs.getString("subject"));
            row.createCell(4).setCellValue(rs.getDouble("daily_score"));
            row.createCell(5).setCellValue(rs.getDouble("exam_score"));
            row.createCell(6).setCellValue(rs.getDouble("score"));
            row.createCell(7).setCellValue(rs.getString("remark") == null ? "" : rs.getString("remark"));
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
            response.sendRedirect("adminViewScores.jsp?error=" + java.net.URLEncoder.encode("导出失败：" + e.getMessage(), "UTF-8"));
        }
    } catch (Exception e) {
        e.printStackTrace();
        if (!response.isCommitted()) {
            response.sendRedirect("adminViewScores.jsp?error=" + java.net.URLEncoder.encode("导出失败：" + e.getMessage(), "UTF-8"));
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