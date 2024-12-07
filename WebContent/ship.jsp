<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>95AJ Industries: KeyGalaxy Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>
<h1 style="text-align: center;">95AJ Industries: KeyGalaxy</h1>
<%
	String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True"; 
	String uid = "sa"; 
	String pw = "304#sa#pw";

	// TODO: Get order id
	String orderId = request.getParameter("orderId"); // Get the order ID from the URL
    if (orderId == null || orderId.trim().isEmpty()) {
        out.println("<p class='error'>Error: Order ID is required.</p>");
    } else {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        boolean success = true;
		
		
	// TODO: Check if valid order id in database
	try {
		connection = DriverManager.getConnection(url, uid, pw);
		connection.setAutoCommit(false); // Start transaction

		// Check if the order exists
		String checkOrderSql = "SELECT * FROM ordersummary WHERE orderId = ?";
		statement = connection.prepareStatement(checkOrderSql);
		statement.setInt(1, Integer.parseInt(orderId));
		resultSet = statement.executeQuery();

		if (!resultSet.next()) {
			out.println("<p class='error'>Error: Invalid order ID.</p>");
			connection.rollback(); // Rollback if invalid order
			success = false;
		} else {
			// Retrieve all items for the order
			String getOrderItemsSql = "SELECT productId, quantity FROM OrderProduct WHERE orderId = ?";
			statement = connection.prepareStatement(getOrderItemsSql);
			statement.setInt(1, Integer.parseInt(orderId));
			resultSet = statement.executeQuery();

			// Create shipment record
                String createShipmentSql = "INSERT INTO shipment (orderId, shipmentDate) VALUES (?, NOW())";
                PreparedStatement shipmentStmt = connection.prepareStatement(createShipmentSql, Statement.RETURN_GENERATED_KEYS);
                shipmentStmt.setInt(1, Integer.parseInt(orderId));
                shipmentStmt.executeUpdate();
                ResultSet shipmentKeys = shipmentStmt.getGeneratedKeys();
                shipmentKeys.next();
                int shipmentId = shipmentKeys.getInt(1);
			
				// Process each item
                while (resultSet.next()) {
                    int productId = resultSet.getInt("productId");
                    int quantityOrdered = resultSet.getInt("quantity");

                    // Check inventory
                    String checkInventorySql = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
                    PreparedStatement inventoryStmt = connection.prepareStatement(checkInventorySql);
                    inventoryStmt.setInt(1, productId);
                    ResultSet inventoryResult = inventoryStmt.executeQuery();

                    if (inventoryResult.next()) {
                        int currentInventory = inventoryResult.getInt("quantity");
                        if (currentInventory < quantityOrdered) {
                            out.println("<p class='error'>Shipment not done. Insufficient inventory for product id: " + productId + "</p>");
                            connection.rollback(); // Rollback if insufficient inventory
                            success = false;
                            break;
                        } else {
                            // Update inventory
                            String updateInventorySql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
                            PreparedStatement updateStmt = connection.prepareStatement(updateInventorySql);
                            updateStmt.setInt(1, quantityOrdered);
                            updateStmt.setInt(2, productId);
                            updateStmt.executeUpdate();

                            // Log shipment details
                            out.println("<p>Ordered product: " + productId + " Qty: " + quantityOrdered + 
                                        " Previous inventory: " + currentInventory + 
                                        " New inventory: " + (currentInventory - quantityOrdered) + "</p>");
                        }
                    } else {
                        out.println("<p class='error'>Error: Product ID " + productId + " not found in inventory.</p>");
                        connection.rollback();
                        success = false;
                        break;
                    }
                }
            }

            // Commit the transaction if successful
            if (success) {
                connection.commit();
                out.println("<p class='success'>Shipment successfully processed.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace(out);
            if (connection != null) connection.rollback(); // Rollback on any error
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (Exception e) {}
            if (statement != null) try { statement.close(); } catch (Exception e) {}
            if (connection != null) try { connection.setAutoCommit(true); } catch (Exception e) {}
        }
    }
%>
<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
