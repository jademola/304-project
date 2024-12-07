<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%@ page import="java.time.Year" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>95AJ Industries: KeyGalaxy - Checkout</title>
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
<div class="container mx-auto px-4 py-8 max-w-2xl">
    <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">Complete Your Transaction</h1>
    
    <div class="bg-white shadow-md rounded-lg p-6">
        <form method="post" action="checkout.jsp" class="space-y-6">
            <div>
                <label for="customerId" class="block text-gray-700 font-bold mb-2">Customer ID:</label>
                <input type="text" name="customerId" id="customerId" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                       required>
            </div>
            
            <div>
                <label for="password" class="block text-gray-700 font-bold mb-2">Password:</label>
                <input type="password" name="password" id="password" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                       required>
            </div>

            <div class="border-t pt-4 mt-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4">Payment Information</h3>
                
                <div class="grid md:grid-cols-2 gap-4">
                    <div>
                        <label for="cardName" class="block text-gray-700 font-bold mb-2">Name on Card:</label>
                        <input type="text" name="cardName" id="cardName" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                    
                    <div>
                        <label for="cardType" class="block text-gray-700 font-bold mb-2">Card Type:</label>
                        <select name="cardType" id="cardType" 
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                                required>
                            <option value="">Select Card Type</option>
                            <option value="visa">Visa</option>
                            <option value="mastercard">Mastercard</option>
                            <option value="amex">American Express</option>
                            <option value="discover">Discover</option>
                        </select>
                    </div>
                </div>

                <div class="grid md:grid-cols-3 gap-4 mt-4">
                    <div class="md:col-span-2">
                        <label for="cardNumber" class="block text-gray-700 font-bold mb-2">Card Number:</label>
                        <input type="text" name="cardNumber" id="cardNumber" 
                               placeholder="XXXX-XXXX-XXXX-XXXX" 
                               pattern="[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                    
                    <div>
                        <label for="cardCVV" class="block text-gray-700 font-bold mb-2">CVV:</label>
                        <input type="text" name="cardCVV" id="cardCVV" 
                               pattern="[0-9]{3,4}" 
                               placeholder="CVV" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                </div>

                <div class="grid md:grid-cols-2 gap-4 mt-4">
                    <div>
                        <label for="expiryMonth" class="block text-gray-700 font-bold mb-2">Expiry Month:</label>
                        <select name="expiryMonth" id="expiryMonth" 
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                                required>
                            <option value="">Select Month</option>
                            <% for(int i=1; i<=12; i++) { %>
                                <option value="<%= String.format("%02d", i) %>"><%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div>
                        <label for="expiryYear" class="block text-gray-700 font-bold mb-2">Expiry Year:</label>
                        <select name="expiryYear" id="expiryYear" 
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                                required>
                            <option value="">Select Year</option>
                            <% 
                            Year currentYear = Year.now();
                            for(int i=0; i<10; i++) { 
                                int year = currentYear.getValue() + i;
                            %>
                                <option value="<%= year %>"><%= year %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>

            <div class="border-t pt-4 mt-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4">Shipping Information</h3>
                
                <div class="mb-4">
                    <label for="shippingName" class="block text-gray-700 font-bold mb-2">Full Name:</label>
                    <input type="text" name="shippingName" id="shippingName" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="shippingAddress" class="block text-gray-700 font-bold mb-2">Street Address:</label>
                    <input type="text" name="shippingAddress" id="shippingAddress" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                           required>
                </div>

                <div class="grid md:grid-cols-3 gap-4">
                    <div>
                        <label for="city" class="block text-gray-700 font-bold mb-2">City:</label>
                        <input type="text" name="city" id="city" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                    
                    <div>
                        <label for="state" class="block text-gray-700 font-bold mb-2">State/Province:</label>
                        <input type="text" name="state" id="state" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                    
                    <div>
                        <label for="zipCode" class="block text-gray-700 font-bold mb-2">Zip/Postal Code:</label>
                        <input type="text" name="zipCode" id="zipCode" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                               required>
                    </div>
                </div>

                <div class="mt-4">
                    <label for="country" class="block text-gray-700 font-bold mb-2">Country:</label>
                    <select name="country" id="country" 
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-primary" 
                            required>
                        <option value="">Select Country</option>
                        <option value="US">United States</option>
                        <option value="CA">Canada</option>
                        <!-- Add more countries as needed -->
                    </select>
                </div>
            </div>

            <div class="flex justify-between mt-6">
                <button type="submit" class="bg-brand-primary hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300">
                    Complete Order
                </button>
                <button type="reset" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded transition duration-300">
                    Reset Form
                </button>
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
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mt-4 text-center">
            Customer ID and Password cannot be empty.
        </div>
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
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mt-4 text-center">
            Invalid Customer ID or Password. Please try again.
        </div>
    <%
                }
            } catch (Exception e) {
                out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mt-4 text-center'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mt-4 text-center'>Error closing connection: " + e.getMessage() + "</div>");
                    }
                }
            }
        }
    }
    %>
</div>
</body>
</html>