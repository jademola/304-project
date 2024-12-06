<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group95 Grocery Order List</title>
    <!-- Bootstrap CSS for modern styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 800px;
            margin-top: 50px;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4CAF50;
            font-size: 2.5rem;
            margin-bottom: 30px;
        }
        h2 {
            font-size: 1.8rem;
            color: #007BFF;
            margin-top: 20px;
        }
        h3 {
            font-size: 1.5rem;
            margin-top: 20px;
            color: #333;
        }
        p {
            font-size: 1rem;
            margin: 5px 0;
        }
        .order-details {
            margin-bottom: 30px;
        }
        .order-details p {
            font-size: 1.1rem;
            color: #555;
        }
        ul {
            list-style-type: none;
            padding-left: 0;
        }
        li {
            background-color: #f1f1f1;
            padding: 8px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        li strong {
            color: #333;
        }
        .btn {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Order List</h1>

    <%! String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True"; %>
    <%! String uid = "sa"; %>
    <%! String pw = "304#sa#pw"; %>

    <%
        // Initialize the database connection
        Connection conn = null;
        PreparedStatement pstmtOrderProducts = null;
        ResultSet rsOrders = null;
        ResultSet rsOrderProducts = null;
        try {
            // Connect to the database
            conn = DriverManager.getConnection(url, uid, pw);

            // Query to get order summary information
            String sqlOrders = "SELECT o.orderId, o.orderDate, o.totalAmount, " +
                               "c.firstName, c.lastName, c.city, c.state, c.country " +
                               "FROM ordersummary o " +
                               "JOIN customer c ON o.customerId = c.customerId";
            Statement stmtOrders = conn.createStatement();
            rsOrders = stmtOrders.executeQuery(sqlOrders);

            // Format for currency
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            // Loop through each order
            while (rsOrders.next()) {
                int orderId = rsOrders.getInt("orderId");
                String customerName = rsOrders.getString("firstName") + " " + rsOrders.getString("lastName");
                String orderDate = rsOrders.getString("orderDate");
                String totalAmount = currFormat.format(rsOrders.getDouble("totalAmount"));
                String shipTo = rsOrders.getString("city") + ", " + rsOrders.getString("state") + ", " + rsOrders.getString("country");

                // Display order summary in a styled container
                out.println("<div class='order-details'>");
                out.println("<h2>Order ID: " + orderId + "</h2>");
                out.println("<p><strong>Customer:</strong> " + customerName + "</p>");
                out.println("<p><strong>Order Date:</strong> " + orderDate + "</p>");
                out.println("<p><strong>Total Amount:</strong> " + totalAmount + "</p>");
                out.println("<p><strong>Ship To:</strong> " + shipTo + "</p>");
                out.println("<h3>Products in Order:</h3>");
                out.println("<ul>");

                // Query to get products in the order
                String sqlOrderProducts = "SELECT p.productName, op.quantity, op.price " +
                                          "FROM orderproduct op " +
                                          "JOIN product p ON op.productId = p.productId " +
                                          "WHERE op.orderId = ?";
                pstmtOrderProducts = conn.prepareStatement(sqlOrderProducts);
                pstmtOrderProducts.setInt(1, orderId);
                rsOrderProducts = pstmtOrderProducts.executeQuery();

                // Loop through each product in the order and display product information
                while (rsOrderProducts.next()) {
                    String productName = rsOrderProducts.getString("productName");
                    int quantity = rsOrderProducts.getInt("quantity");
                    String price = currFormat.format(rsOrderProducts.getDouble("price"));

                    // Display product information in a styled list
                    out.println("<li><strong>Product:</strong> " + productName + 
                                ", <strong>Quantity:</strong> " + quantity + 
                                ", <strong>Price:</strong> " + price + "</li>");
                }
                out.println("</ul>");
                out.println("</div>");
                rsOrderProducts.close();
            }
            rsOrders.close();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            // Close resources
            if (rsOrderProducts != null) rsOrderProducts.close();
            if (pstmtOrderProducts != null) pstmtOrderProducts.close();
            if (rsOrders != null) rsOrders.close();
            if (conn != null) conn.close();
        }
    %>

</div>

<!-- Bootstrap JS (Optional for interactivity) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

