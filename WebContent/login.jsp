<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<%	
boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
if(authenticated) response.sendRedirect("customer.jsp");
%>

<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white shadow-md rounded-lg p-8 w-full max-w-sm">
        <h3 class="text-2xl font-bold text-gray-800 text-center mb-6">Please Login to System</h3>

        <!-- Display login error message if present -->
        <%
        if (session.getAttribute("loginMessage") != null) {
        %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4 text-center" role="alert">
                <%= session.getAttribute("loginMessage").toString() %>
            </div>
        <%
        }
        %>

        <!-- Login Form -->
        <form name="MyForm" method="post" action="validateLogin.jsp" class="space-y-4">
            <div>
                <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                <input type="text" id="username" name="username" maxlength="10" required 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand-primary focus:border-brand-primary">
            </div>
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                <input type="password" id="password" name="password" maxlength="10" required 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand-primary focus:border-brand-primary">
            </div>
            <div class="flex justify-center">
                <button type="submit" name="Submit2" 
                        class="bg-blue-400 text-white font-bold py-2 px-6 rounded-lg shadow-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-primary">
                    Log In
                </button>
            </div>
        </form>
    </div>
</body>
</html>
