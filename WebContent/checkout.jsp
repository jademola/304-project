<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery - Checkout</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h1 class="text-center mb-4">Complete Your Transaction</h1>
    <div class="card p-4 shadow-sm">
        <form method="post" action="checkout.jsp">
            <div class="mb-3">
                <label for="customerId" class="form-label">Customer ID:</label>
                <input type="text" name="customerId" id="customerId" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" name="password" id="password" class="form-control" required>
            </div>
            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-primary">Submit</button>
                <button type="reset" class="btn btn-secondary">Reset</button>
            </div>
        </form>
    </div>

    <%-- Authentication Check --%>
    <%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String custId = request.getParameter("customerId");
        String password = request.getParameter("password");

        if (custId == null || password == null || custId.isEmpty() || password.isEmpty()) {
    %>
        <div class="alert alert-danger mt-3">Customer ID and Password cannot be empty.</div>
    <%
        } else {
            String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            Connection conn = null;

            try {
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM customer WHERE customerId = ? AND password = ?");
                stmt.setInt(1, Integer.parseInt(custId));
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                rs.next();
                if (rs.getInt(1) == 1) {
                    session.setAttribute("customerId", custId);
                    response.sendRedirect("order.jsp");
                    return;
                } else {
    %>
        <div class="alert alert-danger mt-3">Invalid Customer ID or Password. Please try again.</div>
    <%
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger mt-3'>Error closing connection: " + e.getMessage() + "</div>");
                    }
                }
            }
        }
    }
    %>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
