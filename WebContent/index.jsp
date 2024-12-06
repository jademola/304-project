<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ray's Grocery Main Page</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-primary': '#3498db',
                        'brand-green': '#2ecc71',
                        'brand-gray': '#95a5a6',
                        'brand-dark': '#34495e'
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- Navbar -->
    <nav class="bg-brand-primary text-white shadow-md">
        <div class="container mx-auto px-4 py-3 flex justify-between items-center">
            <a href="#" class="text-lg font-bold">Ray's Grocery</a>
            <ul class="flex space-x-6">
                <li><a href="login.jsp" class="hover:text-gray-200">Login</a></li>
                <li><a href="listprod.jsp" class="hover:text-gray-200">Begin Shopping</a></li>
                <li><a href="listbycategory.jsp" class="hover:text-gray-200">Shop by Category</a></li>
                <li><a href="listorder.jsp" class="hover:text-gray-200">List All Orders</a></li>
                <li><a href="customer.jsp" class="hover:text-gray-200">Customer Info</a></li>
                <li><a href="admin.jsp" class="hover:text-gray-200">Administrators</a></li>
                <li><a href="logout.jsp" class="hover:text-gray-200">Log out</a></li>
            </ul>
        </div>
    </nav>

    <!-- Welcome Section -->
    <div class="container mx-auto px-4 py-8">
        <div class="text-center">
            <h1 class="text-4xl font-extrabold text-gray-800">Welcome to Ray's Grocery</h1>
        </div>

        <!-- Top Products Section -->
        <div class="mt-10">
            <h2 class="text-2xl font-bold text-gray-800 text-center mb-6">Top 5 Products by Total Sales</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
                <% 
                    try {
                        getConnection();
                        String query = "SELECT TOP 5 p.productId, p.productName, p.productImageURL FROM product p JOIN orderproduct op ON p.productId = op.productId " +
                                       "GROUP BY p.productId, p.productName, p.productImageURL ORDER BY SUM(op.quantity) DESC";
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            String productId = rs.getString("productId");
                            String productName = rs.getString("productName");
                            String productImageURL = rs.getString("productImageURL");
                %>
                <a href="product.jsp?id=<%= productId %>" class="bg-white shadow-lg rounded-lg overflow-hidden block hover:shadow-xl transition-shadow">
                    <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                        <img src="<%= productImageURL %>" alt="<%= productName %>" class="h-40 w-full object-cover">
                    <% } else { %>
                        <div class="h-40 w-full bg-gray-200 flex items-center justify-center">
                            <span class="text-gray-500 text-sm font-semibold">No Image Available</span>
                        </div>
                    <% } %>
                    <div class="p-4 text-center">
                        <h5 class="text-lg font-medium text-gray-700"><%= productName %></h5>
                    </div>
                </a>
                <% 
                        }
                        rs.close();
                        stmt.close();
                        closeConnection();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-100 py-4 mt-10">
        <div class="container mx-auto px-4 text-center text-gray-600 text-sm">
            <% 
                String usersName = (String) session.getAttribute("authenticatedUser"); 
                if (usersName != null) { 
            %>
                <p>Signed in as: <span class="text-brand-primary font-semibold"><%= usersName %></span></p>
            <% } else { %>
                <p>Welcome, Guest!</p>
            <% } %>
        </div>
    </footer>
</body>
</html>
