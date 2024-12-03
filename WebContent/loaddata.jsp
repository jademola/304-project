<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Loading Data</title>
</head>
<body>

<%
out.print("<h1>Connecting to database.</h1><br><br>");

try
{	// Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
    throw new SQLException("ClassNotFoundException: " +e);
}

String fileName = "/usr/local/tomcat/webapps/shop/ddl/SQLServer_orderdb.ddl";

try ( Connection con = DriverManager.getConnection(urlForLoadData, uid, pw); )
{      
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals("") || command.trim().equals("go"))
            continue;
        
        if (command.trim().indexOf("go") == 0)
            command = command.substring(3, command.length());

        // Hack to make sure variable is declared
        if (command.contains("INSERT INTO ordersummary") && !command.contains("DECLARE @orderId"))
            command = "DECLARE @orderId int \n"+command;

        // out.print(command+"<br>");        // Uncomment if want to see commands executed
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            if (!e.toString().contains("Database 'orders' already exists"))    // Ignore error when database already exists
                out.println(e+"<br>");
        }
    }	 
    scanner.close();
    
    out.print("<br><br><h1>Database loaded.</h1>");
}
catch (Exception e)
{
    out.print(e);
}  
%>
</body>
</html> 
