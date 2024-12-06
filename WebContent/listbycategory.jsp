<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Group95 Grocery</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <h1 class="text-center mb-4">Our Products</h1>
    
    <form method="get" action="listbycategory.jsp" class="mb-4">
        <div class="mb-3">
            <label for="categoryName" class="form-label">Select a category:</label>
            <select name="categoryName" id="categoryName" class="form-select">
                <%
                    // Get the selected category from the request
                    String selectedCategory = request.getParameter("categoryName");
                %>
                <option value="" <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "selected" : "" %>>All Products</option>
                <option value="Beverages" <%= "Beverages".equals(selectedCategory) ? "selected" : "" %>>Beverages</option>
                <option value="Condiments" <%= "Condiments".equals(selectedCategory) ? "selected" : "" %>>Condiments</option>
                <option value="Dairy Products" <%= "Dairy Products".equals(selectedCategory) ? "selected" : "" %>>Dairy Products</option>
                <option value="Produce" <%= "Produce".equals(selectedCategory) ? "selected" : "" %>>Produce</option>
                <option value="Meat/Poultry" <%= "Meat/Poultry".equals(selectedCategory) ? "selected" : "" %>>Meat/Poultry</option>
                <option value="Seafood" <%= "Seafood".equals(selectedCategory) ? "selected" : "" %>>Seafood</option>
                <option value="Confections" <%= "Confections".equals(selectedCategory) ? "selected" : "" %>>Confections</option>
                <option value="Grains/Cereals" <%= "Grains/Cereals".equals(selectedCategory) ? "selected" : "" %>>Grains/Cereals</option>
            </select>
        </div>
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">Submit</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
        </div>
    </form>

    <%
    // Load driver class
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("<div class='alert alert-danger'>ClassNotFoundException: " + e + "</div>");
    }

    // Initialize database variables
    String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        // Get search parameter
        String name = request.getParameter("categoryName");
        if (name == null || name.isEmpty()) name = "null";

        // Connect to database
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Prepare SQL query
        String sql = "SELECT productId, productName, productPrice FROM product p "
                   + "WHERE (? = 'null' OR p.categoryId = (SELECT categoryId FROM category WHERE categoryName = ?))";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.setString(2, name);
        rs = stmt.executeQuery();

        // Display the ResultSet
    %>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                while (rs.next()) {
                    int id = rs.getInt("productId");
                    String name1 = rs.getString("productName");
                    double price = rs.getDouble("productPrice");

                    // Create links
                    String addToCartLink = "addcart.jsp?id=" + id + "&name=" + URLEncoder.encode(name1, "UTF-8") + "&price=" + price;
                    String productLink = "product.jsp?id=" + id;
                %>
                    <tr>
                        <td><%= id %></td>
                        <td><a href="<%= productLink %>" class="text-decoration-none"><%= name1 %></a></td>
                        <td><%= currFormat.format(price) %></td>
                        <td><a href="<%= addToCartLink %>" class="btn btn-sm btn-success">Add to Cart</a></td>
                    </tr>
                <%
                }
                %>
                </tbody>
            </table>
        </div>
    <%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e + "</div>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
    %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
