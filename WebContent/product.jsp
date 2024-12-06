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
        .reviews-section {
            margin-top: 30px;
            border-top: 1px solid #e0e0e0;
            padding-top: 20px;
        }
        .review-card {
            background-color: #f9f9f9;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .star-rating {
            color: #ffc107;
        }
        .submit-review-form {
            background-color: #f1f3f5;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="product-container">
    <%
    PreparedStatement pstmt = null;
    ResultSet rstProduct = null;
    ResultSet rstReviews = null;

    String productId = request.getParameter("id");

    try {
        getConnection();

        // Fetch Product Details
        String sqlProduct = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE productId = ?";
        pstmt = con.prepareStatement(sqlProduct);
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

    <!-- Reviews Section -->
    <div class="reviews-section">
        <h3>Customer Reviews</h3>
        
        <%
        // Fetch Reviews for this Product
        String sqlReviews = "SELECT r.reviewId, r.reviewRating, r.reviewDate, r.reviewComment, c.firstName, c.lastName " +
                            "FROM review r " +
                            "JOIN customer c ON r.customerId = c.customerId " +
                            "WHERE r.productId = ? " +
                            "ORDER BY r.reviewDate DESC";
        pstmt = con.prepareStatement(sqlReviews);
        pstmt.setInt(1, Integer.parseInt(productId));
        rstReviews = pstmt.executeQuery();

        boolean hasReviews = false;
        while (rstReviews.next()) {
            hasReviews = true;
            int rating = rstReviews.getInt("reviewRating");
            String comment = rstReviews.getString("reviewComment");
            String reviewerName = rstReviews.getString("firstName") + " " + rstReviews.getString("lastName");
            Timestamp reviewDate = rstReviews.getTimestamp("reviewDate");
        %>
            <div class="review-card">
                <div class="star-rating">
                    <% for(int i = 1; i <= 5; i++) { %>
                        <span style="color: <%= i <= rating ? "#ffc107" : "#e0e0e0" %>">&#9733;</span>
                    <% } %>
                </div>
                <p class="review-text"><%= comment %></p>
                <small class="text-muted">
                    By <%= reviewerName %> on <%= new java.text.SimpleDateFormat("MMMM d, yyyy").format(reviewDate) %>
                </small>
            </div>
        <% } %>

        <% if (!hasReviews) { %>
            <p class="text-center text-muted">No reviews yet. Be the first to review!</p>
        <% } %>

        <!-- Submit Review Form -->
        <div class="submit-review-form">
            <h4>Write a Review</h4>
            <form action="submitReview.jsp" method="post">
                <input type="hidden" name="productId" value="<%= productId %>">
                <div class="mb-3">
                    <label for="reviewRating" class="form-label">Rating</label>
                    <select class="form-select" id="reviewRating" name="reviewRating" required>
                        <option value="">Select a Rating</option>
                        <option value="5">5 - Excellent</option>
                        <option value="4">4 - Very Good</option>
                        <option value="3">3 - Good</option>
                        <option value="2">2 - Fair</option>
                        <option value="1">1 - Poor</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="reviewComment" class="form-label">Review</label>
                    <textarea class="form-control" id="reviewComment" name="reviewComment" rows="4" required placeholder="Tell us about your experience"></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
        </div>
    </div>
    <%
        }
    } catch (SQLException e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (pstmt != null) pstmt.close();
        if (rstReviews != null) rstReviews.close();
        if (con != null) closeConnection();
    }
    %>
</div>

<!-- Include Bootstrap JS (optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

