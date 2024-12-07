<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*, java.text.NumberFormat, java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp"%>
<%@ include file="auth.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>95AJ Industries: KeyGalaxy - Product Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-green': '#2ecc71',
                        'brand-gray': '#95a5a6'
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 min-h-screen">
    <%@ include file="header.jsp" %>
    
    <div class="container mx-auto px-4 py-8">
        <%
        PreparedStatement pstmt = null;
        ResultSet rstProduct = null;
        String productId = request.getParameter("id");
        
        try {
            getConnection();
            String sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, p.productDesc, c.categoryName FROM product p JOIN category c ON p.categoryId = c.categoryId WHERE p.productId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(productId));
            rstProduct = pstmt.executeQuery();
            
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            
            if (rstProduct.next()) {
                String productName = rstProduct.getString("productName");
                Double price = rstProduct.getDouble("productPrice");
                String priceFormatted = currFormat.format(price);
                String url = rstProduct.getString("productImageURL");
                String description = rstProduct.getString("productDesc");
                String category = rstProduct.getString("categoryName");
                int productIdDB = rstProduct.getInt("productId");
        %>
        <div class="grid md:grid-cols-2 gap-8 bg-white shadow-lg rounded-lg p-6">
            <div class="flex justify-center items-center">
                <% if (url != null && !url.isEmpty()) { %>
                    <img src="<%= url %>" alt="<%= productName %>" 
                         class="max-w-full max-h-96 object-contain rounded-lg shadow-md">
                <% } else if (productIdDB == 1) { %>
                    <img src="displayImage.jsp?id=<%= productId %>" 
                         class="max-w-full max-h-96 object-contain rounded-lg shadow-md">
                <% } else { %>
                    <div class="w-full h-96 bg-gray-200 flex items-center justify-center rounded-lg">
                        <span class="text-gray-500">No Image Available</span>
                    </div>
                <% } %>
            </div>
            
            <div class="space-y-4">
                <h1 class="text-3xl font-bold text-gray-800"><%= productName %></h1>
                
                <div class="flex items-center space-x-4">
                    <span class="text-2xl font-semibold text-brand-green"><%= priceFormatted %></span>
                    <span class="text-sm text-gray-500 bg-gray-100 px-2 py-1 rounded">
                        Product ID: <%= productId %>
                    </span>
                </div>
                
                <div class="text-sm text-gray-600">
                    <strong>Category:</strong> <%= category %>
                </div>
                
                <% if (description != null && !description.isEmpty()) { %>
                    <div class="text-gray-700 leading-relaxed">
                        <%= description %>
                    </div>
                <% } %>
                
                <div class="flex space-x-4 pt-4">
                    <% 
                    String encodedProductName = URLEncoder.encode(productName, "UTF-8");
                    String addToCartLink = "addcart.jsp?id=" + productId + 
                                           "&name=" + encodedProductName + 
                                           "&price=" + price; 
                    %>
                    <a href="<%= addToCartLink %>" 
                       class="flex-1 bg-brand-green hover:bg-green-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300 text-center">
                        Add to Cart
                    </a>
                    <a href="listprod.jsp" 
                       class="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-3 px-6 rounded-lg transition duration-300 text-center">
                        Continue Shopping
                    </a>
                </div>
            </div>
        </div>
        
        <% 
            // Fetch and display reviews section
            String reviewSql = "SELECT r.reviewRating, r.reviewComment, c.firstName, r.reviewDate FROM review r JOIN customer c ON r.customerId = c.customerId WHERE r.productId = ? ORDER BY r.reviewDate DESC";
            PreparedStatement reviewStmt = con.prepareStatement(reviewSql);
            reviewStmt.setInt(1, Integer.parseInt(productId));
            ResultSet reviewRs = reviewStmt.executeQuery();
        %>
        <div class="mt-8 bg-white shadow-lg rounded-lg p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-4">Customer Reviews</h2>
            <% 
            boolean hasReviews = false;
            while (reviewRs.next()) { 
                hasReviews = true;
            %>
                <div class="border-b pb-4 mb-4">
                    <div class="flex justify-between items-center mb-2">
                        <div class="flex items-center space-x-2">
                            <strong class="text-gray-700"><%= reviewRs.getString("firstName") %></strong>
                            <span class="text-sm text-gray-500">
                                <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(reviewRs.getTimestamp("reviewDate")) %>
                            </span>
                        </div>
                        <div class="text-yellow-500">
                            <% 
                            int rating = reviewRs.getInt("reviewRating");
                            for (int i = 0; i < 5; i++) { 
                                if (i < rating) { 
                            %>
                                ★
                            <% } else { %>
                                ☆
                            <% } 
                            } %>
                        </div>
                    </div>
                    <p class="text-gray-600"><%= reviewRs.getString("reviewComment") %></p>
                </div>
            <% } 
            
            if (!hasReviews) { %>
                <p class="text-gray-500 italic">No reviews yet for this product.</p>
            <% } %>
        </div>
        <div class="mt-8 bg-white shadow-lg rounded-lg p-6">
    <h2 class="text-2xl font-bold text-gray-800 mb-4">Write a Review</h2>
    <%
    // Check if the customer has already reviewed this product
    String checkReviewSql = "SELECT COUNT(*) AS reviewCount FROM review WHERE productId = ? AND customerId = ?";
    PreparedStatement checkReviewStmt = con.prepareStatement(checkReviewSql);
    checkReviewStmt.setInt(1, Integer.parseInt(productId));
    checkReviewStmt.setInt(2, Integer.parseInt((String) session.getAttribute("customerId")));
    ResultSet checkReviewRs = checkReviewStmt.executeQuery();
    
    boolean canReview = true;
    if (checkReviewRs.next() && checkReviewRs.getInt("reviewCount") > 0) {
        canReview = false;
    }
    
    if (canReview) {
    %>
    <form method="post" action="submitReview.jsp" class="space-y-4">
        <input type="hidden" name="productId" value="<%= productId %>">
        <div>
            <label for="reviewRating" class="block text-gray-700 font-bold mb-2">Rating (1 to 5)</label>
            <select id="reviewRating" name="reviewRating" required 
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-green">
                <option value="">-- Select a Rating --</option>
                <option value="1">1 - Very Bad</option>
                <option value="2">2 - Bad</option>
                <option value="3">3 - Average</option>
                <option value="4">4 - Good</option>
                <option value="5">5 - Excellent</option>
            </select>
        </div>
        <div>
            <label for="reviewComment" class="block text-gray-700 font-bold mb-2">Comment</label>
            <textarea id="reviewComment" name="reviewComment" rows="4" required 
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-green"></textarea>
        </div>
        <button type="submit" 
                class="bg-brand-green hover:bg-green-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300">
            Submit Review
        </button>
    </form>
    <%
    } else {
    %>
    <p class="text-gray-500 italic">You have already reviewed this product.</p>
    <% } %>
</div>
        <%
            } // end product result if
        } catch (SQLException e) {
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) closeConnection();
        }
        %>
    </div>
</body>
</html>