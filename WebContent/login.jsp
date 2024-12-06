<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <!-- Add Bootstrap CSS for a modern look -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 40px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h3 {
            font-size: 1.75rem;
            margin-bottom: 20px;
            color: #4CAF50;
        }
        .form-group label {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
        }
        .form-control {
            font-size: 1.1rem;
            padding: 10px;
            border-radius: 4px;
        }
        .submit-btn {
            background-color: #007BFF;
            color: white;
            font-size: 1.2rem;
            border: none;
            padding: 10px 20px;
            width: 100%;
            border-radius: 4px;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: #dc3545;
            font-size: 1.1rem;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<!-- Login Form Wrapper -->
<div class="container">
    <h3 class="text-center">Please Log In to the System</h3>

    <!-- Display any prior error login message -->
    <% if (session.getAttribute("loginMessage") != null) { %>
        <div class="error-message text-center">
            <%= session.getAttribute("loginMessage") %>
        </div>
    <% } %>

    <!-- Login Form -->
    <form name="MyForm" method="post" action="validateLogin.jsp">
        <div class="form-group mb-3">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" class="form-control" maxlength="10" required>
        </div>
        <div class="form-group mb-3">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" class="form-control" maxlength="10" required>
        </div>
        <button type="submit" class="submit-btn">Log In</button>
    </form>
</div>

<!-- Bootstrap JS (Optional for interactivity) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
