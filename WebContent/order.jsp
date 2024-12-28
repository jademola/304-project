<%@ include file="header.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto mt-10">
    <h1 class="text-3xl font-bold text-center mb-8">Order Confirmation</h1>
    <div class="bg-white shadow-md rounded-lg p-6">
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
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            Error: Invalid customer ID.
        </div>
        <%
            return;
        }

        if (productList == null || productList.isEmpty()) {
        %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            Error: Shopping cart is empty.
        </div>
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
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            Error: Customer ID not found in database.
        </div>
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

            out.println("<div class='bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative'>Order placed successfully!</div>");
            out.println("<p>Order ID: <strong>" + orderId + "</strong></p>");
            out.println("<p>Customer ID: <strong>" + custId + "</strong></p>");
            out.println("<p>Total Amount: <strong>$" + totalAmount + "</strong></p>");
            out.println("<ul class='list-disc list-inside'>");
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
            out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative'>Error processing order: " + e + "</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative'>Error closing connection: " + e.getMessage() + "</div>");
                }
            }
        }
        %>
    </div>
</div>
</body>
</html>
