<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">
    <div class="container mx-auto p-6">
        <% 
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        
        if (productList == null) { 
        %>
            <div class="text-center bg-white shadow-lg rounded-lg p-8 mt-10">
                <h1 class="text-2xl font-bold text-gray-800">Your shopping cart is empty!</h1>
                <a href="listprod.jsp" class="mt-4 inline-block text-brand-primary hover:underline">Continue Shopping</a>
            </div>
        <% 
            productList = new HashMap<String, ArrayList<Object>>();
        } else { 
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        %>
        <div class="bg-white shadow-lg rounded-lg p-6 mt-6">
            <h1 class="text-3xl font-bold text-gray-800 mb-4">Your Shopping Cart</h1>
            <table class="w-full table-auto border-collapse">
                <thead>
                    <tr class="bg-gray-200 text-gray-700">
                        <th class="px-4 py-2 border">Product ID</th>
                        <th class="px-4 py-2 border">Product Name</th>
                        <th class="px-4 py-2 border text-center">Quantity</th>
                        <th class="px-4 py-2 border text-right">Price</th>
                        <th class="px-4 py-2 border text-right">Subtotal</th>
                    </tr>
                </thead>
                <tbody class="bg-white">
                    <% 
                    double total = 0;
                    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                    while (iterator.hasNext()) { 
                        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                        if (product.size() < 4) { 
                            out.println("Expected product with four entries. Got: "+product);
                            continue;
                        }

                        String productId = product.get(0).toString();
                        String productName = product.get(1).toString();
                        Object price = product.get(2);
                        Object itemqty = product.get(3);

                        double pr = 0;
                        int qty = 0;

                        try { pr = Double.parseDouble(price.toString()); } 
                        catch (Exception e) { out.println("Invalid price for product: "+productId); }
                        
                        try { qty = Integer.parseInt(itemqty.toString()); } 
                        catch (Exception e) { out.println("Invalid quantity for product: "+productId); }

                        double subtotal = pr * qty;
                        total += subtotal;
                    %>
                    <tr class="border-b">
                        <td class="px-4 py-2 border"><%= productId %></td>
                        <td class="px-4 py-2 border"><%= productName %></td>
                        <td class="px-4 py-2 border text-center"><%= qty %></td>
                        <td class="px-4 py-2 border text-right"><%= currFormat.format(pr) %></td>
                        <td class="px-4 py-2 border text-right"><%= currFormat.format(subtotal) %></td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr class="bg-gray-100">
                        <td colspan="4" class="px-4 py-2 border text-right font-bold">Order Total</td>
                        <td class="px-4 py-2 border text-right font-bold"><%= currFormat.format(total) %></td>
                    </tr>
                </tfoot>
            </table>
            <div class="flex justify-between items-center mt-6">
                <a href="listprod.jsp" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded transition duration-300"">Continue Shopping</a>
                <a href="checkout.jsp" class="bg-blue-400 text-white px-4 py-2 rounded shadow hover:bg-blue-600">Check Out</a>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>
