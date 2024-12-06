<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group95's Grocery CheckOut Line</title>
    <!-- Bootstrap CSS for layout and components -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container {
            max-width: 600px;
            margin-top: 50px;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #007BFF;
            font-size: 2.5rem;
            font-family: 'Verdana', sans-serif;
            margin-bottom: 30px;
        }
        h2 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
        }
        .form-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .form-container p {
            font-size: 1.1rem;
            color: #555;
            margin: 10px 0;
        }
        .form-container input[type="text"],
        .form-container input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            margin: 5px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-container input[type="submit"],
        .form-container input[type="reset"] {
            font-size: 1.1rem;
            padding: 10px 20px;
            margin-top: 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 48%;
        }
        .form-container input[type="submit"] {
            background-color: #4CAF50;
            color: white;
        }
        .form-container input[type="submit"]:hover {
            background-color: #357a38;
        }
        .form-container input[type="reset"] {
            background-color: #f44336;
            color: white;
        }
        .form-container input[type="reset"]:hover {
            background-color: #d2190b;
        }
    </style>
</head>
<body>

<div class="container">
    <header class="text-center">
        <h1><i>Group95 Keyboard Store</i></h1>
    </header>

    <h2 class="text-center">Enter your CustomerID and Password to complete the transaction:</h2>

    <form method="get" action="order.jsp" class="form-container">
        <p>Customer ID: <input type="text" name="customerId" size="40"></p>
        <p>Password: <input type="password" name="customerPassword" size="40"></p>
        <div class="d-flex justify-content-between">
            <input type="submit" name="submit" value="Submit">
            <input type="reset" value="Reset">
        </div>
    </form>
</div>

<!-- Bootstrap JS (optional, for added features if needed) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
