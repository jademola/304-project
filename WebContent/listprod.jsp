<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group95 Grocery - Our Products</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <!-- Heading -->
    <div class="text-center mb-4">
        <h1 class="display-4">Our Products</h1>
    </div>

    <!-- Return to Home Button -->
    <div class="mb-4 text-center">
        <a href="index.jsp" class="btn btn-primary">Return to Home</a>
    </div>

    <!-- Search Form -->
    <div class="card p-4 shadow-sm">
        <h5 class="card-title">Search for the products you want to buy:</h5>
        <form method="get" action="listprod.jsp" class="form-inline justify-content-center">
            <input type="text" name="productName" class="form-control mr-2" placeholder="Enter product name...">
            <button type="submit" class="btn btn-success mr-2">Search</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
        </form>
        <p class="text-muted text-center mt-2">Leave blank to view all products.</p>
    </div>

    <% // Get product name to search for
    String name = request.getParameter("productName");

    // Note: Forces loading of SQL Server driver
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("<div class='alert alert-danger text-center'>ClassNotFoundException: " + e + "</div>");
    }

    // Database variables
    String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        if (name == null) name = "";

        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        String sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, "%" + name + "%");
        rs = stmt.executeQuery();

        %>
        <div class="mt-4">
            <p class="text-center font-italic">Showing results for: <strong><%= name.isEmpty() ? "All Products" : name %></strong></p>
        </div>

        <div class="table-responsive mt-4">
            <table class="table table-bordered table-hover">
                <thead class="thead-dark">
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    int id = rs.getInt("productId");
                    String name1 = rs.getString("productName");
                    double price = rs.getDouble("productPrice");

                    String addToCartLink = "addcart.jsp?id=" + id + "&name=" + URLEncoder.encode(name1, "UTF-8") + "&price=" + price;
                    String productLink = "product.jsp?id=" + id;
                %>
                <tr>
                    <td><%= id %></td>
                    <td><a href="<%= productLink %>"><%= name1 %></a></td>
                    <td><%= currFormat.format(price) %></td>
                    <td><a href="<%= addToCartLink %>" class="btn btn-sm btn-outline-primary">Add to Cart</a></td>
                </tr>
                <% } %>
                <% if (!hasResults) { %>
                <tr>
                    <td colspan="4" class="text-center">No items match your search for "<%= name %>".</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger text-center'>Error: " + e + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    } %>

</div>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
