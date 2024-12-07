<%@ include file="header.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
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
    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Database connection details
            String dbURL = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Collect form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phonenum = request.getParameter("phonenum");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String country = request.getParameter("country");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validation flags
            boolean isValid = true;
            String errorMessage = "";

            // Email validation
            Pattern emailPattern = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
            if (!emailPattern.matcher(email).matches()) {
                isValid = false;
                errorMessage += "Invalid email format. ";
            }

            // Check if email already exists
            String checkEmailSql = "SELECT COUNT(*) FROM customer WHERE email = ?";
            stmt = conn.prepareStatement(checkEmailSql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                isValid = false;
                errorMessage += "Email already exists. ";
            }

            // Password validation
            if (!password.matches("^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
                isValid = false;
                errorMessage += "Password must contain: 8 characters, 1 number, 1 uppercase letter, 1 special character. ";
            }

            // Confirm password match
            if (!password.equals(confirmPassword)) {
                isValid = false;
                errorMessage += "Passwords do not match. ";
            }

            // Proceed with registration if validation passes
            if (isValid) {
                // Prepare insert statement
                String insertSql = "INSERT INTO customer " +
                    "(firstName, lastName, email, phonenum, address, city, state, postalCode, country, password) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, phonenum);
                stmt.setString(5, address);
                stmt.setString(6, city);
                stmt.setString(7, state);
                stmt.setString(8, postalCode);
                stmt.setString(9, country);
                stmt.setString(10, password);

                // Execute insert
                int rowsUpdated = stmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Retrieve the auto-generated customer ID
                    rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        int newCustomerId = rs.getInt(1);
                        // Set session attribute and redirect
                        session.setAttribute("customerId", String.valueOf(newCustomerId));
                        response.sendRedirect("login.jsp");
                        return;
                    }
                } else {
                    errorMessage += "Error creating account. ";
                }
            }

            // If we reach here, there was an error
            if (!errorMessage.isEmpty()) {
                out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>" + 
                            errorMessage + "</div>");
            }

        } catch (Exception e) {
            out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative text-center' role='alert'>Error: " + 
                        e.getMessage() + "</div>");
        } finally {
            // Close database resources
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
%>
    <div class="bg-white shadow-md rounded-lg p-6">
        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">Create Your Account</h2>
        
        <form method="post" action="createaccount.jsp" class="space-y-4">
            <div class="grid md:grid-cols-2 gap-4">
                <div>
                    <label for="firstName" class="block text-gray-700 font-bold mb-2">First Name *</label>
                    <input type="text" id="firstName" name="firstName" required
                           value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="lastName" class="block text-gray-700 font-bold mb-2">Last Name *</label>
                    <input type="text" id="lastName" name="lastName" required
                           value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
            </div>

            <div>
                <label for="email" class="block text-gray-700 font-bold mb-2">Email *</label>
                <input type="email" id="email" name="email" required
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div>
                <label for="phonenum" class="block text-gray-700 font-bold mb-2">Phone Number</label>
                <input type="tel" id="phonenum" name="phonenum" 
                       value="<%= request.getParameter("phonenum") != null ? request.getParameter("phonenum") : "" %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div>
                <label for="address" class="block text-gray-700 font-bold mb-2">Address</label>
                <input type="text" id="address" name="address" 
                       value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div class="grid md:grid-cols-3 gap-4">
                <div>
                    <label for="city" class="block text-gray-700 font-bold mb-2">City</label>
                    <input type="text" id="city" name="city" 
                           value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="state" class="block text-gray-700 font-bold mb-2">State</label>
                    <input type="text" id="state" name="state" 
                           value="<%= request.getParameter("state") != null ? request.getParameter("state") : "" %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
                
                <div>
                    <label for="postalCode" class="block text-gray-700 font-bold mb-2">Postal Code</label>
                    <input type="text" id="postalCode" name="postalCode" 
                           value="<%= request.getParameter("postalCode") != null ? request.getParameter("postalCode") : "" %>" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                </div>
            </div>

            <div>
                <label for="country" class="block text-gray-700 font-bold mb-2">Country</label>
                <input type="text" id="country" name="country" 
                       value="<%= request.getParameter("country") != null ? request.getParameter("country") : "" %>" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
            </div>

            <div class="border-t pt-4 mt-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4">Set Password</h3>
                <div class="space-y-4">
                    <div>
                        <label for="password" class="block text-gray-700 font-bold mb-2">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                        <p class="text-xs text-gray-600 mt-1">
                            Password must contain: 8 characters, 1 number, 1 uppercase letter, 1 special character
                        </p>
                    </div>
                    <div>
                        <label for="confirmPassword" class="block text-gray-700 font-bold mb-2">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary">
                    </div>
                </div>
            </div>

            <div class="flex justify-between items-center mt-6">
                <a href="index.jsp" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded transition duration-300">
                    Back
                </a>
                <button type="submit" class="bg-brand-primary hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300">
                    Create Account
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>