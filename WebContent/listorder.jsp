<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>95AJ Industries: KeyGalaxy Order List</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Include header for consistent styling and meta tags -->
    <%@ include file="header.jsp" %>
</head>
<body class="bg-gray-100 min-h-screen">

    <div class="container mx-auto px-4 py-8">
        <!-- Page Heading -->
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-800">Order List</h1>
        </div>

        <!-- Return to Home Button -->
        <div class="mb-6 text-center">
            <a href="index.jsp" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300 ease-in-out">
                Return to Home
            </a>
        </div>

        <%
        // Database connection details
        String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        Connection conn = null;
        PreparedStatement pstmtOrderProducts = null;
        ResultSet rsOrders = null;
        ResultSet rsOrderProducts = null;

        try {
            // Connect to the database
            conn = DriverManager.getConnection(url, uid, pw);

            // Query to get order summary
            String sqlOrders = "SELECT o.orderId, o.orderDate, o.totalAmount, " +
                               "c.firstName, c.lastName, c.city, c.state, c.country " +
                               "FROM ordersummary o " +
                               "JOIN customer c ON o.customerId = c.customerId";
            Statement stmtOrders = conn.createStatement();
            rsOrders = stmtOrders.executeQuery(sqlOrders);

            // Currency format
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            // Process each order
            while (rsOrders.next()) {
                int orderId = rsOrders.getInt("orderId");
                String customerName = rsOrders.getString("firstName") + " " + rsOrders.getString("lastName");
                String orderDate = rsOrders.getString("orderDate");
                String totalAmount = currFormat.format(rsOrders.getDouble("totalAmount"));
                String shipTo = rsOrders.getString("city") + ", " + rsOrders.getString("state") + ", " + rsOrders.getString("country");
        %>
            <div class="bg-white shadow-md rounded-lg overflow-hidden mb-6">
                <div class="p-6">
                    <h5 class="text-xl font-semibold text-gray-800 mb-2">Order ID: <%= orderId %></h5>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <p><span class="font-bold">Customer:</span> <%= customerName %></p>
                        <p><span class="font-bold">Order Date:</span> <%= orderDate %></p>
                        <p><span class="font-bold">Total Amount:</span> <%= totalAmount %></p>
                        <p><span class="font-bold">Ship To:</span> <%= shipTo %></p>
                    </div>

                    <h6 class="text-lg font-semibold text-gray-700 mt-4 mb-2">Products in Order:</h6>
                    <div class="space-y-2">
                        <%
                        // Query products in the order
                        String sqlOrderProducts = "SELECT p.productName, op.quantity, op.price " +
                                                  "FROM orderproduct op " +
                                                  "JOIN product p ON op.productId = p.productId " +
                                                  "WHERE op.orderId = ?";
                        pstmtOrderProducts = conn.prepareStatement(sqlOrderProducts);
                        pstmtOrderProducts.setInt(1, orderId);
                        rsOrderProducts = pstmtOrderProducts.executeQuery();

                        // List products
                        while (rsOrderProducts.next()) {
                            String productName = rsOrderProducts.getString("productName");
                            int quantity = rsOrderProducts.getInt("quantity");
                            String price = currFormat.format(rsOrderProducts.getDouble("price"));
                        %>
                            <div class="bg-gray-100 p-3 rounded-md">
                                <div class="flex justify-between">
                                    <span class="font-medium"><%= productName %></span>
                                    <div class="text-right">
                                        <span class="mr-4">Qty: <%= quantity %></span>
                                        <span class="font-semibold"><%= price %></span>
                                    </div>
                                </div>
                            </div>
                        <% 
                        }
                        rsOrderProducts.close();
                        %>
                    </div>
                </div>
            </div>
        <% 
        }
        rsOrders.close();
        } catch (SQLException e) {
        %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                <strong class="font-bold">Error: </strong>
                <span class="block sm:inline"><%= e.getMessage() %></span>
            </div>
        <% 
        } finally {
            if (rsOrderProducts != null) rsOrderProducts.close();
            if (pstmtOrderProducts != null) pstmtOrderProducts.close();
            if (rsOrders != null) rsOrders.close();
            if (conn != null) conn.close();
        }
        %>
    </div>

</body>
</html>