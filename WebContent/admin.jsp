<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file = "auth.jsp" %>
<%@ include file = "jdbc.jsp" %>
<h1>Daily Sales Report For Administrator</h1>
<%
// Format for currency
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT CAST(orderDate AS DATE) as OrderDate, SUM(totalAmount) AS total FROM ordersummary GROUP BY CAST(orderDate AS DATE) as OrderDate ORDER BY OrderDate";
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try(Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement();){
    PreparedStatement pstmt = con.prepareStatement("SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?;");
	ResultSet rst = stmt.executeQuery(sql); 
    out.println("<table class='table' border='1'><tr><th>Order Date</th><th>Total Order Amount</th>");
	while (rst.next()){
        out.println("<tr><td>" + rst.getString(1) + "</td><td>" + rst.getString(2) + "</td></tr>");
    }
    out.println("</table>");
	rst.close();
	stmt.close();
	con.close(); 
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
out.println("<h2><a href='index.jsp'>Back to Main Page</a></h2>");
%>

</body>
</html>

