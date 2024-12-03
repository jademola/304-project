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

<%

// Format for currency
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// TODO: Write SQL query that prints out total order amount by day
getConnection();

String sql = "SELECT orderDate, SUM(totalAmount) AS total FROM ordersummary GROUP BY orderDate";
Statement stmt = con.createStatement();
ResultSet rst = stmt.executeQuery(sql);


out.println("<h2>Sales Report by Date</h2>");
out.println("<table border='2'>");
out.println("<tr><th>Date</th><th>Total Amount</th></tr>");

while(rst.next()) {
    // set string values from ResultSet
    Date date = rst.getDate("orderDate");
    String dateString = date.toString();
    String totalAmount = currFormat.format(rst.getDouble("total"));



    out.println("<tr>");
        out.println("<td>" + dateString + "</td>");
        out.println("<td>" + totalAmount + "</td>");
    out.println("</tr>");
}

%>

</body>
</html>

