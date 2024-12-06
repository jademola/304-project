<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group95's Grocery Main Page</title>
    <!-- Add Bootstrap CSS for a more professional look -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 960px;
            margin: 30px auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 3rem;
            color: #4CAF50;
        }
        h2, h3, h4 {
            color: #333;
        }
        .nav-link {
            font-size: 1.25rem;
            color: #007BFF;
            text-decoration: none;
            padding: 10px;
        }
        .nav-link:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        .test-links a {
            font-size: 1.1rem;
            color: #6c757d;
            text-decoration: none;
            padding: 8px;
        }
        .test-links a:hover {
            color: #343a40;
            text-decoration: underline;
        }
        .logout-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1.25rem;
            cursor: pointer;
            border-radius: 4px;
            width: 100%;
            margin-top: 20px;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<!-- Main Content Wrapper -->
<div class="container">
    <!-- Main Heading -->
    <h1 class="text-center mb-4">Welcome to Group95's Grocery</h1>

    <!-- Navigation Links -->
    <div class="text-center mb-4">
        <h2><a href="login.jsp" class="nav-link">Login</a></h2>
        <h2><a href="shop.html" class="nav-link">Begin Shopping</a></h2>
        <h2><a href="listorder.jsp" class="nav-link">List All Orders</a></h2>
        <h2><a href="customer.jsp" class="nav-link">Customer Info</a></h2>
        <h2><a href="admin.jsp" class="nav-link">Administrators</a></h2>
    </div>

    <!-- Display Signed in User (if any) -->
    <div class="text-center mb-4">
        <% String userName = (String) session.getAttribute("authenticatedUser"); 
           if (userName != null) { 
               out.println("<h3>Signed in as: " + userName + "</h3>");
           } 
        %>
    </div>

    <!-- Log Out Button -->
    <div class="text-center">
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-btn">Log Out</button>
        </form>
    </div>
</div>

<!-- Bootstrap JS (Optional for interactivity) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
