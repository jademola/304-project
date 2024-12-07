<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>95AJ Industries: KeyGalaxy - Our Products</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

    <!-- Content -->
    <div class="container mx-auto mt-8 px-4">
        <!-- Heading -->
        <div class="text-center mb-6">
            <h1 class="text-4xl font-bold text-gray-800">Our Products</h1>
        </div>

        <!-- Return to Home Button -->
        <div class="text-center mb-6">
            <a href="index.jsp" class="bg-blue-500 text-white px-4 py-2 rounded shadow hover:bg-blue-600 transition">
                Return to Home
            </a>
        </div>

        <!-- Search Form -->
        <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-lg font-semibold text-gray-700 mb-4">Search for the products you want to buy:</h2>
            <form method="get" action="listprod.jsp" class="flex flex-wrap justify-center gap-4">
                <input type="text" name="productName" 
                       class="w-full md:w-1/2 px-4 py-2 border border-gray-300 rounded-md focus:ring focus:ring-blue-200" 
                       placeholder="Enter product name...">
                <div class="flex gap-2">
                    <button type="submit" 
                            class="bg-green-500 text-white px-6 py-2 rounded-md hover:bg-green-600 transition">
                        Search
                    </button>
                    <button type="reset" 
                            class="bg-gray-300 text-gray-800 px-6 py-2 rounded-md hover:bg-gray-400 transition">
                        Reset
                    </button>
                </div>
            </form>
            <p class="text-gray-500 text-center mt-4">Leave blank to view all products.</p>
        </div>

        <% 
        String name = request.getParameter("productName");
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("<div class='text-red-600 text-center mt-4'>ClassNotFoundException: " + e + "</div>");
        }

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
        <div class="mt-6">
            <p class="text-center italic text-gray-600">
                Showing results for: 
                <strong><%= name.isEmpty() ? "All Products" : name %></strong>
            </p>
        </div>

        <div class="mt-6 overflow-x-auto">
            <table class="min-w-full bg-white shadow rounded-lg border border-gray-200">
                <thead class="bg-gray-800 text-white">
                <tr>
                    <th class="py-2 px-4 text-left">Product ID</th>
                    <th class="py-2 px-4 text-left">Product Name</th>
                    <th class="py-2 px-4 text-left">Price</th>
                    <th class="py-2 px-4 text-left">Action</th>
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
                <tr class="border-t">
                    <td class="py-2 px-4"><%= id %></td>
                    <td class="py-2 px-4">
                        <a href="<%= productLink %>" class="text-blue-600 hover:underline"><%= name1 %></a>
                    </td>
                    <td class="py-2 px-4"><%= currFormat.format(price) %></td>
                    <td class="py-2 px-4">
                        <a href="<%= addToCartLink %>" 
                           class="text-white bg-blue-500 px-3 py-1 rounded-md shadow hover:bg-blue-600 transition">
                            Add to Cart
                        </a>
                    </td>
                </tr>
                <% } %>
                <% if (!hasResults) { %>
                <tr>
                    <td colspan="4" class="text-center py-4 text-gray-500">
                        No items match your search for "<%= name %>".
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% 
        } catch (Exception e) {
            out.println("<div class='text-red-600 text-center mt-4'>Error: " + e + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        } 
        %>
    </div>
</body>
</html>
