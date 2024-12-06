<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
// Get parameters from the form
int productId = Integer.parseInt(request.getParameter("productId"));
int rating = Integer.parseInt(request.getParameter("reviewRating"));
String comment = request.getParameter("reviewComment");

Integer customerId = (Integer)session.getAttribute("customerId");

if (customerId == null) {
    response.sendRedirect("login.jsp?error=Please log in to submit a review");
    return;
}

PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    getConnection();
    
    // Check if the user has purchased this product
    String sqlCheckPurchase = "SELECT orderproduct.orderId " +
                               "FROM orderproduct " +
                               "JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId " +
                               "WHERE ordersummary.customerId = ? AND orderproduct.productId = ?";
    pstmt = con.prepareStatement(sqlCheckPurchase);
    pstmt.setInt(1, customerId);
    pstmt.setInt(2, productId);
    rs = pstmt.executeQuery();
    
    if (!rs.next()) {
        // User has not purchased the product
        response.sendRedirect("product.jsp?id=" + productId + "&reviewError=You must purchase this product to leave a review");
        return;
    }
    
    // Check if user has already reviewed this product
    rs.close();
    pstmt.close();
    
    String sqlCheckReview = "SELECT reviewId FROM review " +
                             "WHERE customerId = ? AND productId = ?";
    pstmt = con.prepareStatement(sqlCheckReview);
    pstmt.setInt(1, customerId);
    pstmt.setInt(2, productId);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        // User has already reviewed this product
        response.sendRedirect("product.jsp?id=" + productId + "&reviewError=You have already reviewed this product");
        return;
    }
    
    // If we've made it this far, insert the review
    rs.close();
    pstmt.close();
    
    String sqlInsertReview = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) " +
                              "VALUES (?, GETDATE(), ?, ?, ?)";
    
    pstmt = con.prepareStatement(sqlInsertReview);
    pstmt.setInt(1, rating);
    pstmt.setInt(2, customerId);
    pstmt.setInt(3, productId);
    pstmt.setString(4, comment);
    
    int rowsAffected = pstmt.executeUpdate();
    
    if (rowsAffected > 0) {
        // Redirect back to the product page with a success message
        response.sendRedirect("product.jsp?id=" + productId + "&reviewSubmitted=true");
    } else {
        // Handle submission failure
        response.sendRedirect("product.jsp?id=" + productId + "&reviewSubmitted=false");
    }
} catch (SQLException e) {
    e.printStackTrace(new java.io.PrintWriter(out));
    response.sendRedirect("product.jsp?id=" + productId + "&reviewSubmitted=false&error=" + e.getMessage());
} finally {
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (con != null) closeConnection();
    } catch (SQLException e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
}
%>