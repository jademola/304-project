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
        
        // Handle quantity update or item deletion
        String updateProductId = request.getParameter("updateProductId");
        String deleteProductId = request.getParameter("deleteProductId");
        String newQuantity = request.getParameter("newQuantity");

        if (updateProductId != null && newQuantity != null && productList != null) {
            try {
                int qty = Integer.parseInt(newQuantity);
                if (qty > 0) {
                    ArrayList<Object> product = productList.get(updateProductId);
                    if (product != null) {
                        product.set(3, qty);
                    }
                } else {
                    productList.remove(updateProductId);
                }
                session.setAttribute("productList", productList);
            } catch (Exception e) {
                out.println("<div class='bg-red-100 text-red-800 p-4 rounded'>Error updating quantity: " + e.getMessage() + "</div>");
            }
        }

        if (deleteProductId != null && productList != null) {
            productList.remove(deleteProductId);
            session.setAttribute("productList", productList);
        }
        
        if (productList == null || productList.isEmpty()) { 
        %>
            <div class="text-center bg-white shadow-lg rounded-lg p-8 mt-10">
                <h1 class="text-2xl font-bold text-gray-800">Your shopping cart is empty!</h1>
                <a href="listprod.jsp" class="mt-4 inline-block text-blue-500 hover:underline">Continue Shopping</a>
            </div>
        <% 
            productList = new HashMap<String, ArrayList<Object>>();
        } else { 
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        %>
        <div class="bg-white shadow-lg rounded-lg p-6 mt-6">
            <h1 class="text-3xl font-bold text-gray-800 mb-4">Your Shopping Cart</h1>
            <form method="post" action="showcart.jsp" class="w-full">
                <table class="w-full table-auto border-collapse">
                    <thead>
                        <tr class="bg-gray-200 text-gray-700">
                            <th class="px-4 py-2 border">Product ID</th>
                            <th class="px-4 py-2 border">Product Name</th>
                            <th class="px-4 py-2 border text-center">Quantity</th>
                            <th class="px-4 py-2 border text-right">Price</th>
                            <th class="px-4 py-2 border text-right">Subtotal</th>
                            <th class="px-4 py-2 border text-center">Actions</th>
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
                            <td class="px-4 py-2 border text-center">
                                <input type="number" name="newQuantity" 
                                       value="<%= qty %>" 
                                       min="1" 
                                       class="w-16 text-center border rounded px-2 py-1"
                                       onchange="updateQuantity('<%= productId %>', this.value)">
                                <input type="hidden" name="updateProductId" id="updateProductId_<%= productId %>" value="">
                            </td>
                            <td class="px-4 py-2 border text-right"><%= currFormat.format(pr) %></td>
                            <td class="px-4 py-2 border text-right"><%= currFormat.format(subtotal) %></td>
                            <td class="px-4 py-2 border text-center">
                                <button type="button" 
                                        onclick="deleteItem('<%= productId %>')" 
                                        class="text-red-500 hover:text-red-700 font-bold">
                                    Delete
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="bg-gray-100">
                            <td colspan="4" class="px-4 py-2 border text-right font-bold">Order Total</td>
                            <td class="px-4 py-2 border text-right font-bold"><%= currFormat.format(total) %></td>
                            <td class="border"></td>
                        </tr>
                    </tfoot>
                </table>
            </form>
            <div class="flex justify-between items-center mt-6">
                <a href="listprod.jsp" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded transition duration-300">Continue Shopping</a>
                <a href="checkout.jsp" class="bg-blue-400 text-white px-4 py-2 rounded shadow hover:bg-blue-600">Check Out</a>
            </div>
        </div>
        <% } %>
    </div>

    <script>
        function updateQuantity(productId, newQuantity) {
            document.getElementById('updateProductId_' + productId).value = productId;
            document.forms[0].submit();
        }

        function deleteItem(productId) {
            // Create a hidden input for deletion
            const deleteInput = document.createElement('input');
            deleteInput.type = 'hidden';
            deleteInput.name = 'deleteProductId';
            deleteInput.value = productId;
            
            // Add to form and submit
            document.forms[0].appendChild(deleteInput);
            document.forms[0].submit();
        }
    </script>
</body>
</html>