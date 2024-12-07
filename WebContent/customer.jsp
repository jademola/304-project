<%@ page import="java.sql.*,java.text.NumberFormat" %>
<%@ include file="header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Profile and Orders</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
tailwind.config = {
    theme: {
        extend: {
            colors: {
                'brand-primary': '#3498db',
                'brand-dark': '#2c3e50'
            }
        }
    }
}
</script>
</head>
<body class="bg-gray-50">
<div class="container mx-auto px-4 py-8 max-w-4xl">
<%
// Assume CustomerId is stored in session
String custId = (String) session.getAttribute("customerId");
if (custId == null || custId.isEmpty()) {
    out.println("<div class='bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative text-center' role='alert'>You must be logged in to view your profile and orders.</div>");
} else {
    int customerId = Integer.parseInt(custId);
    // Database variables
    String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    PreparedStatement userStmt = null;
    ResultSet userRs = null;
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        // Fetch user information
        String userSql = "SELECT firstName, lastName, email, phonenum, address, city, state, postalCode, country " +
                         "FROM customer WHERE customerId = ?";
        userStmt = conn.prepareStatement(userSql);
        userStmt.setInt(1, customerId);
        userRs = userStmt.executeQuery();
        
        // User Profile Section
        if (userRs.next()) {
            String fullName = userRs.getString("firstName") + " " + userRs.getString("lastName");
            String email = userRs.getString("email");
            String phone = userRs.getString("phonenum");
            String address = userRs.getString("address");
            String city = userRs.getString("city");
            String state = userRs.getString("state");
            String postalCode = userRs.getString("postalCode");
            String country = userRs.getString("country");
%>
    <!-- User Profile Section -->
    <div class="bg-white shadow-md rounded-lg p-6 mb-6">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-2xl font-bold text-gray-800">Your Profile</h2>
            <a href="editprofile.jsp" class="bg-brand-primary hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300">
                Edit Profile
            </a>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
            <div>
                <h3 class="font-semibold text-gray-700">Personal Information</h3>
                <p class="text-gray-600"><strong>Name:</strong> <%= fullName %></p>
                <p class="text-gray-600"><strong>Email:</strong> <%= email %></p>
                <p class="text-gray-600"><strong>Phone:</strong> <%= phone %></p>
            </div>
            
            <div>
                <h3 class="font-semibold text-gray-700">Address</h3>
                <p class="text-gray-600"><%= address %></p>
                <p class="text-gray-600">
                    <%= city %>, <%= state %> <%= postalCode %>
                </p>
                <p class="text-gray-600"><%= country %></p>
            </div>
        </div>
    </div>

    <!-- Orders Section -->
    <div class="text-center mb-6">
        <h1 class="text-4xl font-bold text-gray-800">Your Orders</h1>
    </div>

    <%
        // Fetch orders
        String sql = "SELECT orderId, orderDate, totalAmount FROM ordersummary WHERE customerId = ? ORDER BY orderDate DESC";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, customerId);
        rs = stmt.executeQuery();
    %>
    <div class="overflow-x-auto bg-white shadow-md rounded-lg">
        <table class="w-full text-sm text-left text-gray-600">
            <thead class="text-xs text-gray-700 uppercase bg-gray-100">
                <tr>
                    <th class="px-6 py-3">Order ID</th>
                    <th class="px-6 py-3">Order Date</th>
                    <th class="px-6 py-3">Total Amount</th>
                </tr>
            </thead>
            <tbody>
            <% 
            boolean hasOrders = false;
            while (rs.next()) {
                hasOrders = true;
                int orderId = rs.getInt("orderId");
                java.sql.Timestamp orderDate = rs.getTimestamp("orderDate");
                double totalAmount = rs.getDouble("totalAmount");
            %>
                <tr class="border-b hover:bg-gray-50 transition duration-200">
                    <td class="px-6 py-4"><%= orderId %></td>
                    <td class="px-6 py-4"><%= orderDate %></td>
                    <td class="px-6 py-4"><%= currFormat.format(totalAmount) %></td>
                </tr>
            <% } %>
            <% if (!hasOrders) { %>
                <tr>
                    <td colspan="3" class="text-center px-6 py-4 text-gray-500 italic">No orders found for your account.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <%
        } // end if userRs.next()
    } catch (Exception e) {
        out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Error: " + e + "</div>");
    } finally {
        // Close all database resources
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (userRs != null) try { userRs.close(); } catch (Exception ignored) {}
        if (userStmt != null) try { userStmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
    }
%>
</div>
</body>
</html>
