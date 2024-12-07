<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <!-- Page Heading -->
    <div class="text-center mb-4">
        <h1 class="display-4">Administrator Dashboard</h1>
    </div>

    <!-- Customer List Section -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5>Customer List</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-dark">
                    <tr>
                        <th>Customer ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Postal Code</th>
                        <th>Country</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        getConnection();
                        String customerSql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country FROM customer";
                        Statement customerStmt = con.createStatement();
                        ResultSet customerRst = customerStmt.executeQuery(customerSql);
                        while (customerRst.next()) {
                    %>
                    <tr>
                        <td><%= customerRst.getInt("customerId") %></td>
                        <td><%= customerRst.getString("firstName") %></td>
                        <td><%= customerRst.getString("lastName") %></td>
                        <td><%= customerRst.getString("email") %></td>
                        <td><%= customerRst.getString("phonenum") %></td>
                        <td><%= customerRst.getString("address") %></td>
                        <td><%= customerRst.getString("city") %></td>
                        <td><%= customerRst.getString("state") %></td>
                        <td><%= customerRst.getString("postalCode") %></td>
                        <td><%= customerRst.getString("country") %></td>
                    </tr>
                    <% } 
                        customerRst.close();
                        customerStmt.close();
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Sales Report Section -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-success text-white">
            <h5>Sales Report by Date</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-dark">
                    <tr>
                        <th>Date</th>
                        <th>Total Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                        String salesSql = "SELECT orderDate, SUM(totalAmount) AS total FROM ordersummary GROUP BY orderDate";
                        Statement salesStmt = con.createStatement();
                        ResultSet salesRst = salesStmt.executeQuery(salesSql);
                        while (salesRst.next()) {
                            Date date = salesRst.getDate("orderDate");
                            String totalAmount = currFormat.format(salesRst.getDouble("total"));
                    %>
                    <tr>
                        <td><%= date != null ? date.toString() : "N/A" %></td>
                        <td><%= totalAmount %></td>
                    </tr>
                    <% }
                        salesRst.close();
                        salesStmt.close();
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<!-- Product Management Section -->
<div class="card shadow-sm mb-4">
    <div class="card-header bg-warning text-white">
        <h5>Manage Products</h5>
    </div>
    <div class="card-body">
        <form method="post" enctype="multipart/form-data" class="form">
            <div class="form-group">
                <label for="productId">Product ID (For Update/Delete):</label>
                <input type="text" id="productId" name="productId" class="form-control" value="<%= request.getParameter("productId") != null ? request.getParameter("productId") : "" %>">
            </div>
            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" class="form-control" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
            </div>
            <div class="form-group">
                <label for="productPrice">Product Price:</label>
                <input type="text" id="productPrice" name="productPrice" class="form-control" value="<%= request.getParameter("productPrice") != null ? request.getParameter("productPrice") : "" %>">
            </div>
            <div class="form-group">
                <label for="productImage">Product Image:</label>
                <input type="file" id="productImage" name="productImage" class="form-control-file">
            </div>
            <div class="form-group">
                <label for="productDesc">Product Description:</label>
                <textarea id="productDesc" name="productDesc" class="form-control"><%= request.getParameter("productDesc") != null ? request.getParameter("productDesc") : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="categoryId">Category ID:</label>
                <input type="text" id="categoryId" name="categoryId" class="form-control" value="<%= request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "" %>">
            </div>
            <div class="text-center">
                <button type="submit" name="action" value="add" class="btn btn-success">Add Product</button>
                <button type="submit" name="action" value="update" class="btn btn-primary">Update Product</button>
                <button type="submit" name="action" value="delete" class="btn btn-danger">Delete Product</button>
            </div>
        </form>
    </div>
</div>

<%
// Database connection variables
String dbURL = "jdbc:sqlserver://localhost:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPassword = "304#sa#pw";
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

// Get action from the form submission
String action = request.getParameter("action");

if (action != null) {
    try {
        // Establish connection to the database
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Get form data
        int productId = request.getParameter("productId") != null ? Integer.parseInt(request.getParameter("productId")) : 0;
        String productName = request.getParameter("productName");
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));
        String productDesc = request.getParameter("productDesc");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        // Handle file upload (product image)
        Part productImagePart = request.getPart("productImage");
        byte[] productImage = null;
        if (productImagePart != null && productImagePart.getSize() > 0) {
            InputStream inputStream = productImagePart.getInputStream();
            productImage = new byte[inputStream.available()];
            inputStream.read(productImage);
            inputStream.close();
        }

        if ("add".equals(action)) {
            // Insert new product
            String insertSql = "INSERT INTO product (productName, productPrice, productImage, productDesc, categoryId) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertSql);
            stmt.setString(1, productName);
            stmt.setDouble(2, productPrice);
            stmt.setBytes(3, productImage);
            stmt.setString(4, productDesc);
            stmt.setInt(5, categoryId);
            stmt.executeUpdate();

        } else if ("update".equals(action)) {
            // Update product
            String updateSql = "UPDATE product SET productName = ?, productPrice = ?, productImage = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setString(1, productName);
            stmt.setDouble(2, productPrice);
            stmt.setBytes(3, productImage);
            stmt.setString(4, productDesc);
            stmt.setInt(5, categoryId);
            stmt.setInt(6, productId);
            stmt.executeUpdate();

        } else if ("delete".equals(action)) {
            // Delete product
            String deleteSql = "DELETE FROM product WHERE productId = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, productId);
            stmt.executeUpdate();
        }

        out.println("<div class='alert alert-success text-center'>Product " + action + " successfully!</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger text-center'>Error: " + e.getMessage() + "</div>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>

</div>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
