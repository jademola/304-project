<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>95AJ Industries: KeyGalaxy</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <!-- Main Content Container -->
    <div class="container mx-auto my-10 px-4">

        <!-- Heading -->
        <h1 class="text-4xl font-bold text-center text-gray-800 mb-6">Our Products</h1>

        <!-- Category Selection Form -->
        <form method="get" action="listbycategory.jsp" class="mb-6">
            <div class="mb-4">
                <label for="categoryName" class="block text-sm font-medium text-gray-700">Select a category:</label>
                <select name="categoryName" id="categoryName" class="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
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
            <div class="flex justify-between">
                <button type="submit" class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400">Submit</button>
                <button type="reset" class="bg-gray-300 text-gray-800 px-6 py-2 rounded-lg hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-300">Reset</button>
            </div>
        </form>

        <% 
        // Database connection setup
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("<div class='text-red-600 text-center mb-4'>ClassNotFoundException: " + e + "</div>");
        }

        String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            String name = request.getParameter("categoryName");
            if (name == null || name.isEmpty()) name = "null";

            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String sql = "SELECT productId, productName, productPrice FROM product p "
                    + "WHERE (? = 'null' OR p.categoryId = (SELECT categoryId FROM category WHERE categoryName = ?))";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, name);
            rs = stmt.executeQuery();
        %>

        <!-- Table for Displaying Products -->
        <div class="overflow-x-auto mt-8">
            <table class="min-w-full bg-white shadow-md rounded-lg border border-gray-200">
                <thead class="bg-gray-800 text-white">
                    <tr>
                        <th class="px-4 py-2 text-left">Product ID</th>
                        <th class="px-4 py-2 text-left">Product Name</th>
                        <th class="px-4 py-2 text-left">Price</th>
                        <th class="px-4 py-2 text-left">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    while (rs.next()) {
                        int id = rs.getInt("productId");
                        String name1 = rs.getString("productName");
                        double price = rs.getDouble("productPrice");

                        String addToCartLink = "addcart.jsp?id=" + id + "&name=" + URLEncoder.encode(name1, "UTF-8") + "&price=" + price;
                        String productLink = "product.jsp?id=" + id;
                    %>
                    <tr class="border-t hover:bg-gray-50">
                        <td class="px-4 py-2"><%= id %></td>
                        <td class="px-4 py-2"><a href="<%= productLink %>" class="text-blue-500 hover:underline"><%= name1 %></a></td>
                        <td class="px-4 py-2"><%= currFormat.format(price) %></td>
                        <td class="px-4 py-2">
                            <a href="<%= addToCartLink %>" class="bg-green-500 text-white px-4 py-1 rounded-lg hover:bg-green-600">Add to Cart</a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
            </table>
        </div>

        <% 
        } catch (Exception e) {
            out.println("<div class='text-red-600 text-center mb-4'>Error: " + e + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
        %>

    </div>

</body>
</html>
