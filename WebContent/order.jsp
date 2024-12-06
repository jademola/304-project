<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h1 class="text-center mb-4">Order Confirmation</h1>
    <div class="card p-4 shadow-sm">
        <%
        String custId = (String) session.getAttribute("customerId");
        @SuppressWarnings("unchecked")
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        Connection conn = null;

        if (custId == null || custId.isEmpty() || !custId.matches("\\d+")) {
        %>
        <div class="alert alert-danger">Error: Invalid customer ID.</div>
        <%
            return;
        }

        if (productList == null || productList.isEmpty()) {
        %>
        <div class="alert alert-danger">Error: Shopping cart is empty.</div>
        <%
            return;
        }

        try {
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            PreparedStatement custStmt = conn.prepareStatement("SELECT COUNT(*) FROM customer WHERE customerId = ?");
            custStmt.setInt(1, Integer.parseInt(custId));
            ResultSet custRs = custStmt.executeQuery();
            custRs.next();
            if (custRs.getInt(1) == 0) {
        %>
        <div class="alert alert-danger">Error: Customer ID not found in database.</div>
        <%
                return;
            }

            PreparedStatement orderStmt = conn.prepareStatement(
                "INSERT INTO ordersummary (customerId, totalAmount) OUTPUT INSERTED.orderId VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            double totalAmount = 0.0;

            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                ArrayList<Object> product = entry.getValue();
                String rawPrice = (String) product.get(2);
                String cleanedPrice = rawPrice.replace("$", "").replace(",", "").trim();
                double price = Double.parseDouble(cleanedPrice);
                int qty = ((Integer) product.get(3)).intValue();
                totalAmount += price * qty;
            }
            orderStmt.setInt(1, Integer.parseInt(custId));
            orderStmt.setDouble(2, totalAmount);
            orderStmt.execute();

            ResultSet keys = orderStmt.getGeneratedKeys();
            keys.next();
            int orderId = keys.getInt(1);

            PreparedStatement productStmt = conn.prepareStatement(
                "INSERT INTO orderproduct (orderId, productId, quantity) VALUES (?, ?, ?)"
            );
            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                ArrayList<Object> product = entry.getValue();
                int productId = Integer.parseInt((String) product.get(0));
                int qty = ((Integer) product.get(3)).intValue();
                productStmt.setInt(1, orderId);
                productStmt.setInt(2, productId);
                productStmt.setInt(3, qty);
                productStmt.addBatch();
            }
            productStmt.executeBatch();

            out.println("<div class='alert alert-success'>Order placed successfully!</div>");
            out.println("<p>Order ID: <strong>" + orderId + "</strong></p>");
            out.println("<p>Customer ID: <strong>" + custId + "</strong></p>");
            out.println("<p>Total Amount: <strong>$" + totalAmount + "</strong></p>");
            out.println("<ul>");
            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                ArrayList<Object> product = entry.getValue();
                String productName = (String) product.get(1);
                String rawPrice = (String) product.get(2);
                String cleanedPrice = rawPrice.replace("$", "").replace(",", "").trim();
                double price = Double.parseDouble(cleanedPrice);
                int qty = ((Integer) product.get(3)).intValue();
                out.println("<li>" + productName + " - Quantity: " + qty + " - Price: $" + (price * qty) + "</li>");
            }
            out.println("</ul>");

            session.removeAttribute("productList");
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error processing order: " + e + "</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("<div class='alert alert-danger'>Error closing connection: " + e.getMessage() + "</div>");
                }
            }
        }
        %>
    </div>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
