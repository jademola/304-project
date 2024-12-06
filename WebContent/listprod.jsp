<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Group95 Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Initialize database variables
    String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Make the connection
try {
	// Get search parameter
	if (name == null) name = "";

	// Connect to database
	conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

	// Prepare SQL query
	String sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ? OR ";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%" + name + "%");
	rs = stmt.executeQuery();

	// Print out the ResultSet
	out.println("<table border='10'>");
	out.println("<tr><th>Product ID</th><th>Product Name</th><th>Price</th><th>Action</th></tr>");
	while (rs.next()) {
		int id = rs.getInt("productId");
		String name1 = rs.getString("productName");
		double price = rs.getDouble("productPrice");

		// For each product create a link of the form
		// Create link to add to cart
		String addToCartLink = "addcart.jsp?id=" + id + "&name=" + name1 + "&price=" + price;
		String productLink = "product.jsp?id=" + id;
		out.println("<tr>");
		out.println("<td>" + id + "</td>");
		out.println("<td><a href = '"+ productLink + "'>"+ name1 +"</a></td>");
		out.println("<td>" + currFormat.format(price) + "</td>");
		out.println("<td><a href='" + addToCartLink + "'>Add to Cart</a></td>");
		out.println("</tr>");
	}
	out.println("</table>");
} catch (Exception e) {
	out.println("Error: "+ e);
} finally {
	// Close connection
	// Close resources
	if (rs != null) rs.close();
	if (stmt != null) stmt.close();
	if (conn != null) conn.close();


}
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>