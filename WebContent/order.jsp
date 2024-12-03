<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Order Confirmation</title>
</head>
<body>
<%
String custId = request.getParameter("customerId");
@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPassword = "304#sa#pw";
Connection conn = null;

if (custId == null || custId.isEmpty() || !custId.matches("\\d+")) {
    out.println("<p>Error: Invalid customer ID.</p>");
    return;
}
if (productList == null || productList.isEmpty()) {
    out.println("<p>Error: Shopping cart is empty.</p>");
    return;
}


try {
    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

    PreparedStatement custStmt = conn.prepareStatement("SELECT COUNT(*) FROM customer WHERE customerId = ?");
    custStmt.setInt(1, Integer.parseInt(custId));
    ResultSet custRs = custStmt.executeQuery();
    custRs.next();
    if (custRs.getInt(1) == 0) {
        out.println("<p>Error: Customer ID not found in database.</p>");
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
        int qty = ((Integer)product.get(3)).intValue();
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
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();
        int productId = Integer.parseInt((String)product.get(0));
        int qty = ((Integer)product.get(3)).intValue();
        productStmt.setInt(1, orderId);
        productStmt.setInt(2, productId);
        productStmt.setInt(3, qty);
        productStmt.addBatch();	
    }
	productStmt.executeBatch();
    

    PreparedStatement updateStmt = conn.prepareStatement(
        "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?"
    );
    updateStmt.setDouble(1, totalAmount);
    updateStmt.setInt(2, orderId);
    updateStmt.executeUpdate();
    

    out.println("<p>Order ID: " + orderId + "</p>");
    out.println("<p>Customer ID: " + custId + "</p>");
    out.println("<p>Total Amount: $" + totalAmount + "</p>");
    out.println("<ul>");
    iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();
        String productName = (String)product.get(1);
        String rawPrice = (String)product.get(2);
        String cleanedPrice = rawPrice.replace("$", "").replace(",", "").trim();
        double price = Double.parseDouble(cleanedPrice);
        int qty = ((Integer)product.get(3)).intValue();

        out.println("<li>" + productName + " - Quantity: " + qty + " - Price: $" + (price * qty) + "</li>");
    }
    out.println("</ul>");

   session.removeAttribute("productList");
} catch (Exception e) {
    out.println("<p>Error processing order: " + e + "</p>");
} finally {
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            out.println("Error closing connection: " + e.getMessage());
        }
    }
}
%>
</body>
</html>


