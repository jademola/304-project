<%@ page import="java.sql.*, java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<%
String customerId = (String) session.getAttribute("customerId");
if (customerId == null || customerId.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

String productId = request.getParameter("productId");
String reviewRating = request.getParameter("reviewRating");
String reviewComment = request.getParameter("reviewComment");

if (productId == null || reviewRating == null || reviewComment == null) {
    response.sendRedirect("product.jsp?id=" + productId);
    return;
}

PreparedStatement pstmt = null;

try {
    getConnection();

    // Check if the customer has already reviewed this product
    String checkReviewSql = "SELECT COUNT(*) AS reviewCount FROM review WHERE productId = ? AND customerId = ?";
    pstmt = con.prepareStatement(checkReviewSql);
    pstmt.setInt(1, Integer.parseInt(productId));
    pstmt.setInt(2, Integer.parseInt(customerId));
    ResultSet rs = pstmt.executeQuery();

    if (rs.next() && rs.getInt("reviewCount") > 0) {
        session.setAttribute("errorMessage", "You have already reviewed this product.");
        response.sendRedirect("product.jsp?id=" + productId);
        return;
    }

    // Insert the new review
    String insertReviewSql = "INSERT INTO review (productId, customerId, reviewRating, reviewComment, reviewDate) VALUES (?, ?, ?, ?, ?)";
    pstmt = con.prepareStatement(insertReviewSql);
    pstmt.setInt(1, Integer.parseInt(productId));
    pstmt.setInt(2, Integer.parseInt(customerId));
    pstmt.setInt(3, Integer.parseInt(reviewRating));
    pstmt.setString(4, reviewComment);
    pstmt.setTimestamp(5, new java.sql.Timestamp(new Date().getTime()));

    int rowsAffected = pstmt.executeUpdate();
    if (rowsAffected > 0) {
        session.setAttribute("successMessage", "Thank you for your review!");
    } else {
        session.setAttribute("errorMessage", "Failed to submit your review. Please try again.");
    }

    response.sendRedirect("product.jsp?id=" + productId);
} catch (SQLException e) {
    e.printStackTrace(new java.io.PrintWriter(out));
    session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
    response.sendRedirect("product.jsp?id=" + productId);
} finally {
    if (pstmt != null) pstmt.close();
    if (con != null) closeConnection();
}
%>
