<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
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
    // Check if user is logged in
    String custId = (String) session.getAttribute("customerId");
    if (custId == null || custId.isEmpty()) {
        out.println("<div class='bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative text-center' role='alert'>You must be logged in to edit your profile.</div>");
        return;
    }

    int customerId = Integer.parseInt(custId);
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Database connection details
            String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Check if it's a password change request
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (oldPassword != null && !oldPassword.isEmpty()) {
                // Verify old password first
                String verifyPasswordSql = "SELECT * FROM customer WHERE customerId = ? AND password = ?";
                stmt = conn.prepareStatement(verifyPasswordSql);
                stmt.setInt(1, customerId);
                stmt.setString(2, oldPassword);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    // Old password is correct
                    if(!newPassword.matches("^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$") || newPassword != null)
                        out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Password must contain 8 characters, including 1 number,  1 upper-case letter and 1 special character.</div>");
                    else if (newPassword.equals(confirmPassword)) {
                        // Update password
                        String updatePasswordSql = "UPDATE customer SET password = ? WHERE customerId = ?";
                        stmt = conn.prepareStatement(updatePasswordSql);
                        stmt.setString(1, newPassword);
                        stmt.setInt(2, customerId);
                        int passwordUpdated = stmt.executeUpdate();
                        
                        if (passwordUpdated > 0) {
                            out.println("<div class='bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative text-center' role='alert'>Password updated successfully!</div>");
                        }
                    } else {
                        out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>New passwords do not match.</div>");
                    }
                } else {
                    out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Current password is incorrect.</div>");
                }
            }

            // Profile information update
            String updateSql = "UPDATE customer SET " +
                "firstName = ?, lastName = ?, email = ?, phonenum = ?, " +
                "address = ?, city = ?, state = ?, postalCode = ?, country = ? " +
                "WHERE customerId = ?";
            stmt = conn.prepareStatement(updateSql);

            // Set parameters from form
            stmt.setString(1, request.getParameter("firstName"));
            stmt.setString(2, request.getParameter("lastName"));
            stmt.setString(3, request.getParameter("email"));
            stmt.setString(4, request.getParameter("phonenum"));
            stmt.setString(5, request.getParameter("address"));
            stmt.setString(6, request.getParameter("city"));
            stmt.setString(7, request.getParameter("state"));
            stmt.setString(8, request.getParameter("postalCode"));
            stmt.setString(9, request.getParameter("country"));
            stmt.setInt(10, customerId);

            // Execute update
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<div class='bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative text-center' role='alert'>Profile updated successfully!</div>");
            } else {
                out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Error updating profile.</div>");
            }
        } catch (Exception e) {
            out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Close database resources
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }

    // Fetch current user information
    try {
        // Database connection details
        String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Prepare select statement
        String selectSql = "SELECT * FROM customer WHERE customerId = ?";
        stmt = conn.prepareStatement(selectSql);
        stmt.setInt(1, customerId);
        rs = stmt.executeQuery();

        if (rs.next()) {
%>
    <div class="bg-white shadow-md rounded-lg p-6">
        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">Edit Your Profile</h2>
        
        <form method="post" action="editprofile.jsp" class="space-y-4">
            <div class="grid md:grid-cols-2 gap-4">
                <div>
                    <label for="firstName" class="block text-gray-700 font-bold mb-2">First Name</label>
                    <input type="text" id="firstName" name="firstName" 
                           value="<%= rs.getString("firstName") %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="lastName" class="block text-gray-700 font-bold mb-2">Last Name</label>
                    <input type="text" id="lastName" name="lastName" 
                           value="<%= rs.getString("lastName") %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
            </div>

            <div>
                <label for="email" class="block text-gray-700 font-bold mb-2">Email</label>
                <input type="email" id="email" name="email" 
                       value="<%= rs.getString("email") %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div>
                <label for="phonenum" class="block text-gray-700 font-bold mb-2">Phone Number</label>
                <input type="tel" id="phonenum" name="phonenum" 
                       value="<%= rs.getString("phonenum") %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div>
                <label for="address" class="block text-gray-700 font-bold mb-2">Address</label>
                <input type="text" id="address" name="address" 
                       value="<%= rs.getString("address") %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div class="grid md:grid-cols-3 gap-4">
                <div>
                    <label for="city" class="block text-gray-700 font-bold mb-2">City</label>
                    <input type="text" id="city" name="city" 
                           value="<%= rs.getString("city") %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="state" class="block text-gray-700 font-bold mb-2">State</label>
                    <input type="text" id="state" name="state" 
                           value="<%= rs.getString("state") %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="postalCode" class="block text-gray-700 font-bold mb-2">Postal Code</label>
                    <input type="text" id="postalCode" name="postalCode" 
                           value="<%= rs.getString("postalCode") %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
            </div>

            <div>
                <label for="country" class="block text-gray-700 font-bold mb-2">Country</label>
                <input type="text" id="country" name="country" 
                       value="<%= rs.getString("country") %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div class="border-t pt-4 mt-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4">Change Password</h3>
                <div class="space-y-4">
                    <div>
                        <label for="oldPassword" class="block text-gray-700 font-bold mb-2">Current Password</label>
                        <input type="password" id="oldPassword" name="oldPassword" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                    </div>
                    <div>
                        <label for="newPassword" class="block text-gray-700 font-bold mb-2">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                    </div>
                    <div>
                        <label for="confirmPassword" class="block text-gray-700 font-bold mb-2">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                    </div>
                </div>
            </div>

            <div class="flex justify-between items-center mt-6">
                <a href="index.jsp" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded transition duration-300">
                    Back
                </a>
                <button type="submit" class="bg-brand-primary hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300">
                    Save Changes
                </button>
            </div>
        </form>
    </div>

    
<%
        }
    } catch (Exception e) {
        out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Error: " + e.getMessage() + "</div>");
    } finally {
        // Close database resources
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
</div>
</body>
</html>