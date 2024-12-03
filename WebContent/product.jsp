<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>



<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// Initialize the database connection
    PreparedStatement pstmt = null;
    ResultSet rstProduct = null;

String productId = request.getParameter("id");

try {
    // Connect to database
	getConnection();
    
    String sql = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE product.productId = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(productId));
    rstProduct = pstmt.executeQuery();

    // Format for currency
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    while(rstProduct.next()) {
    String productName = rstProduct.getString("productName");
    Double price = rstProduct.getDouble("productPrice");
    String priceFormatted = currFormat.format(rstProduct.getDouble("productPrice"));
    String url = rstProduct.getString("productImageURL");
    int productIdDB = rstProduct.getInt("productId");

    out.println("<h2>" + productName + "</h2>");
    // TODO: If there is a productImageURL, display using IMG tag
    if (url != null && !url.isEmpty()) {
        out.println("<img src='" + url + "' alt='" + productName + "' style='max-width: 300px; max-height: 300px;'/>");
    }
    
		
    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    if(productIdDB == 1)
    out.println("<img src='displayImage.jsp?id=" + productId + "'style='max-width: 300px; max-height: 300px;'/>");

    // TODO: Display product ID and price
    out.println("<p><strong>ID: </strong>" + productId + "</p>");
    out.println("<p><strong>Price: </strong>" + priceFormatted + "</p>");

		
    // TODO: Add links to Add to Cart and Continue Shopping
    String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + price;
    out.println("<h3><a href='" + addToCartLink + "'>Add to Cart</a></h3>");
    out.println("<h3><a href='listprod.jsp'>Continue Shopping</a></h3>");
    }
} catch (SQLException e) {
    e.printStackTrace(new java.io.PrintWriter(out));
} finally {
    if (pstmt != null) pstmt.close();
    if (con != null) closeConnection();
}



%>

</body>
</html>

