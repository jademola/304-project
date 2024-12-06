<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group95 Grocery Order List</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <!-- Page Heading -->
    <div class="text-center mb-4">
        <h1 class="display-4">Order List</h1>
    </div>

    <!-- Return to Home Button -->
    <div class="mb-4 text-center">
        <a href="index.jsp" class="btn btn-primary">Return to Home</a>
    </div>

    <%
        // Initialize database connection
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
                <div class="card mb-4 shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">Order ID: <%= orderId %></h5>
                        <p class="card-text"><strong>Customer:</strong> <%= customerName %></p>
                        <p class="card-text"><strong>Order Date:</strong> <%= orderDate %></p>
                        <p class="card-text"><strong>Total Amount:</strong> <%= totalAmount %></p>
                        <p class="card-text"><strong>Ship To:</strong> <%= shipTo %></p>
                        <h6 class="mt-3">Products in Order:</h6>
                        <ul class="list-group">
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
                                    <li class="list-group-item">
                                        <strong>Product:</strong> <%= productName %>, 
                                        <strong>Quantity:</strong> <%= quantity %>, 
                                        <strong>Price:</strong> <%= price %>
                                    </li>
                                    <%
                                }
                                rsOrderProducts.close();
                            %>
                        </ul>
                    </div>
                </div>
                <%
            }
            rsOrders.close();
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger text-center'>Error: " + e.getMessage() + "</div>");
        } finally {
            if (rsOrderProducts != null) rsOrderProducts.close();
            if (pstmtOrderProducts != null) pstmtOrderProducts.close();
            if (rsOrders != null) rsOrders.close();
            if (conn != null) conn.close();
        }
    %>

</div>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
