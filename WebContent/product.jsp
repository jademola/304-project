<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Group95's Grocery - Product Information</title>
    <!-- Link to Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .product-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-title {
            color: #007bff;
        }
        .product-image {
            text-align: center;
            margin-bottom: 20px;
        }
        .product-image img {
            max-width: 100%;
            border-radius: 10px;
        }
        .product-details p {
            margin: 10px 0;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        .actions a {
            margin: 5px;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            color: white;
            background-color: #007bff;
        }
        .actions a:hover {
            background-color: #0056b3;
        }
        .actions a.continue-shopping {
            background-color: #6c757d;
        }
        .actions a.continue-shopping:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="product-container">
    <%
    PreparedStatement pstmt = null;
    ResultSet rstProduct = null;

    String productId = request.getParameter("id");

    try {
        getConnection();

        String sql = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(productId));
        rstProduct = pstmt.executeQuery();

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        while (rstProduct.next()) {
            String productName = rstProduct.getString("productName");
            Double price = rstProduct.getDouble("productPrice");
            String priceFormatted = currFormat.format(price);
            String url = rstProduct.getString("productImageURL");

    %>
    <h2 class="product-title"><%= productName %></h2>

    <div class="product-image">
        <% if (url != null && !url.isEmpty()) { %>
            <img src="<%= url %>" alt="<%= productName %>">
        <% } else { %>
            <p>No image available for this product.</p>
        <% } %>
    </div>

    <div class="product-details">
        <p><strong>Product ID:</strong> <%= rstProduct.getInt("productId") %></p>
        <p><strong>Price:</strong> <%= priceFormatted %></p>
    </div>

    <div class="actions">
        <% 
        String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + price;
        %>
        <a href="<%= addToCartLink %>">Add to Cart</a>
        <a href="listprod.jsp" class="continue-shopping">Continue Shopping</a>
    </div>
    <%
        }
    } catch (SQLException e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (pstmt != null) pstmt.close();
        if (con != null) closeConnection();
    }
    %>
</div>

<!-- Include Bootstrap JS (optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
