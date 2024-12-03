<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
 
<%
	String userName = (String) session.getAttribute("authenticatedUser");
	String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True"; 
    String uid = "sa"; 
    String pw = "304#sa#pw";
%>
if (userName == null) {
	out.println("<p style='color:red;'>Error: You must be logged in to access this page.</p>");
} else {
	// Retrieve customer information by ID
	String customerId = request.getParameter("customerId"); // Assuming customer ID is passed as a parameter
	if (customerId != null) {
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
<%

// TODO: Print Customer information
String sql = "SELECT * FROM customer WHERE customerId = ?";
// Make sure to close connection
try {
	connection = DriverManager.getConnection(url, uid, pw);
	statement = connection.prepareStatement(sql);
	statement.setInt(1, Integer.parseInt(customerId)); // Safely parse and use the customer ID
	resultSet = statement.executeQuery();

	if (resultSet.next()) {
		out.println("<h2 style='text-align: center;'>Customer Profile</h2>");
		out.println("<table>");
		out.println("<tr><th>Id</th><td>" + resultSet.getInt("customerId") + "</td></tr>");
		out.println("<tr><th>First Name</th><td>" + resultSet.getString("firstName") + "</td></tr>");
		out.println("<tr><th>Last Name</th><td>" + resultSet.getString("lastName") + "</td></tr>");
		out.println("<tr><th>Email</th><td>" + resultSet.getString("email") + "</td></tr>");
		out.println("<tr><th>Phone</th><td>" + resultSet.getString("phonenum") + "</td></tr>");
		out.println("<tr><th>Address</th><td>" + resultSet.getString("address") + "</td></tr>");
		out.println("<tr><th>City</th><td>" + resultSet.getString("city") + "</td></tr>");
		out.println("<tr><th>State</th><td>" + resultSet.getString("state") + "</td></tr>");
		out.println("<tr><th>Postal Code</th><td>" + resultSet.getString("postalCode") + "</td></tr>");
		out.println("<tr><th>Country</th><td>" + resultSet.getString("country") + "</td></tr>");
		out.println("<tr><th>User Id</th><td>" + resultSet.getString("userid") + "</td></tr>");
		out.println("</table>");
	} else {
		out.println("<p>No customer found with ID " + customerId + ".</p>");
	}
} catch (Exception e) {
	e.printStackTrace(out);
} finally {
	// Clean up resources
	if (resultSet != null) try { resultSet.close(); } catch (Exception e) {}
	if (statement != null) try { statement.close(); } catch (Exception e) {}
}
} else {
out.println("<p>Error: Customer ID not provided.</p>");
}
}
%>

</body>
</html>

