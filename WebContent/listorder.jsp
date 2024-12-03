<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Group95 Grocery Order List</title>
</head>
<body>

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

            // Display order summary
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

            // Loop through each product in the order
            while (rsOrderProducts.next()) {
                String productName = rsOrderProducts.getString("productName");
                int quantity = rsOrderProducts.getInt("quantity");
                String price = currFormat.format(rsOrderProducts.getDouble("price"));

                // Display product information
                out.println("<li><strong>Product:</strong> " + productName + 
                            ", <strong>Quantity:</strong> " + quantity + 
                            ", <strong>Price:</strong> " + price + "</li>");
            }
            out.println("</ul>");
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

</body>
</html>
