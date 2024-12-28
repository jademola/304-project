<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, java.text.NumberFormat, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Page</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<div class="container mx-auto px-4 py-8">
    <!-- Page Heading -->
    <div class="text-center mb-8">
        <h1 class="text-4xl font-bold text-gray-800">Administrator Dashboard</h1>
    </div>

    <!-- Customer List Section -->
    <div class="bg-white shadow-md rounded-lg mb-6">
        <div class="bg-blue-600 text-white px-4 py-3 rounded-t-lg">
            <h5 class="text-xl font-semibold">Customer List</h5>
        </div>
        <div class="p-4 overflow-x-auto">
            <table class="w-full border-collapse">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="border p-2">Customer ID</th>
                        <th class="border p-2">First Name</th>
                        <th class="border p-2">Last Name</th>
                        <th class="border p-2">Email</th>
                        <th class="border p-2">Phone</th>
                        <th class="border p-2">Address</th>
                        <th class="border p-2">City</th>
                        <th class="border p-2">State</th>
                        <th class="border p-2">Postal Code</th>
                        <th class="border p-2">Country</th>
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
                    <tr class="hover:bg-gray-100">
                        <td class="border p-2"><%= customerRst.getInt("customerId") %></td>
                        <td class="border p-2"><%= customerRst.getString("firstName") %></td>
                        <td class="border p-2"><%= customerRst.getString("lastName") %></td>
                        <td class="border p-2"><%= customerRst.getString("email") %></td>
                        <td class="border p-2"><%= customerRst.getString("phonenum") %></td>
                        <td class="border p-2"><%= customerRst.getString("address") %></td>
                        <td class="border p-2"><%= customerRst.getString("city") %></td>
                        <td class="border p-2"><%= customerRst.getString("state") %></td>
                        <td class="border p-2"><%= customerRst.getString("postalCode") %></td>
                        <td class="border p-2"><%= customerRst.getString("country") %></td>
                    </tr>
                    <% } 
                        customerRst.close();
                        customerStmt.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Sales Report Section -->
    <div class="bg-white shadow-md rounded-lg mb-6">
        <div class="bg-green-600 text-white px-4 py-3 rounded-t-lg">
            <h5 class="text-xl font-semibold">Sales Report by Date</h5>
        </div>
        <div class="p-4 overflow-x-auto">
            <table class="w-full border-collapse">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="border p-2">Date</th>
                        <th class="border p-2">Total Amount</th>
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
                    <tr class="hover:bg-gray-100">
                        <td class="border p-2"><%= date != null ? date.toString() : "N/A" %></td>
                        <td class="border p-2"><%= totalAmount %></td>
                    </tr>
                    <% }
                        salesRst.close();
                        salesStmt.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Product Management Section -->
    <div class="bg-white shadow-md rounded-lg mb-6">
        <div class="bg-yellow-500 text-white px-4 py-3 rounded-t-lg">
            <h5 class="text-xl font-semibold">Manage Products</h5>
        </div>
        <div class="p-4">
            <form method="post" enctype="multipart/form-data" class="space-y-4">
                <div>
                    <label for="productId" class="block text-sm font-medium text-gray-700 mb-1">Product ID (For Update/Delete):</label>
                    <input type="text" id="productId" name="productId" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        value="<%= request.getParameter("productId") != null ? request.getParameter("productId") : "" %>">
                </div>
                <div>
                    <label for="productName" class="block text-sm font-medium text-gray-700 mb-1">Product Name:</label>
                    <input type="text" id="productName" name="productName" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
                </div>
                <div>
                    <label for="productPrice" class="block text-sm font-medium text-gray-700 mb-1">Product Price:</label>
                    <input type="text" id="productPrice" name="productPrice" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        value="<%= request.getParameter("productPrice") != null ? request.getParameter("productPrice") : "" %>">
                </div>
                <div>
                    <label for="productImage" class="block text-sm font-medium text-gray-700 mb-1">Product Image:</label>
                    <input type="file" id="productImage" name="productImage" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label for="productDesc" class="block text-sm font-medium text-gray-700 mb-1">Product Description:</label>
                    <textarea id="productDesc" name="productDesc" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"><%= request.getParameter("productDesc") != null ? request.getParameter("productDesc") : "" %></textarea>
                </div>
                <div>
                    <label for="categoryId" class="block text-sm font-medium text-gray-700 mb-1">Category ID:</label>
                    <input type="text" id="categoryId" name="categoryId" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        value="<%= request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "" %>">
                </div>
                <div class="flex justify-center space-x-4">
                    <button type="submit" name="action" value="add" 
                        class="px-4 py-2 bg-green-500 text-white rounded-md hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-500">
                        Add Product
                    </button>
                    <button type="submit" name="action" value="update" 
                        class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        Update Product
                    </button>
                    <button type="submit" name="action" value="delete" 
                        class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500">
                        Delete Product
                    </button>
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

            out.println("<div class='text-center p-4 bg-green-100 text-green-800 rounded-md'>Product " + action + " successfully!</div>");
        } catch (Exception e) {
            out.println("<div class='text-center p-4 bg-red-100 text-red-800 rounded-md'>Error: " + e.getMessage() + "</div>");
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

<!-- Tailwind CSS and Alpine.js for interactivity -->
<script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>

</body>
</html>