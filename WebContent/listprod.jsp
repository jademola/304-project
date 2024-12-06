<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Group95's Grocery</title>
    <!-- Link to Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container {
            margin-top: 30px;
        }
        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 20px;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        form p {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        form select, form input[type="text"] {
            margin-right: 10px;
            width: 100%;
        }
        form input[type="submit"], form input[type="reset"] {
            margin-left: 10px;
        }
        .product-table {
            margin-top: 20px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-table th {
            background-color: #007bff;
            color: white;
        }
        .add-to-cart a {
            color: #007bff;
            text-decoration: none;
        }
        .add-to-cart a:hover {
            text-decoration: underline;
        }
        .category-color {
            font-weight: bold;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Browse Products By Category and Search by Product Name</h2>

    <form method="get" action="listprod.jsp">
        <p>
            <select size="1" name="categoryName" class="form-select">
                <option>All</option>
                <%-- Dynamic category loading (commented-out for simplicity) --%>
                <!--
                try {
                    getConnection();
                    ResultSet rst = executeQuery("SELECT DISTINCT categoryName FROM Product");
                    while (rst.next()) {
                        out.println("<option>" + rst.getString(1) + "</option>");
                    }
                } catch (SQLException ex) {
                    out.println(ex);
                }
                -->
                <option>Beverages</option>
                <option>Condiments</option>
                <option>Confections</option>
                <option>Dairy Products</option>
                <option>Grains/Cereals</option>
                <option>Meat/Poultry</option>
                <option>Produce</option>
                <option>Seafood</option>
            </select>
            <input type="text" name="productName" size="50" class="form-control" placeholder="Enter product name">
            <input type="submit" value="Submit" class="btn btn-primary">
            <input type="reset" value="Reset" class="btn btn-secondary">
        </p>
    </form>

    <%-- Define colors for categories --%>
    <% 
    HashMap<String, String> colors = new HashMap<>();
    colors.put("Beverages", "#0000FF");
    colors.put("Condiments", "#FF0000");
    colors.put("Confections", "#000000");
    colors.put("Dairy Products", "#6600CC");
    colors.put("Grains/Cereals", "#55A5B3");
    colors.put("Meat/Poultry", "#FF9900");
    colors.put("Produce", "#00CC00");
    colors.put("Seafood", "#FF66CC");
    %>

    <%-- Display products based on filters --%>
    <%
    String name = request.getParameter("productName");
    String category = request.getParameter("categoryName");

    boolean hasNameParam = name != null && !name.equals("");
    boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
    String filter = "", sql = "";

    if (hasNameParam && hasCategoryParam) {
        filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
        name = '%' + name + '%';
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ? AND categoryName = ?";
    } else if (hasNameParam) {
        filter = "<h3>Products containing '" + name + "'</h3>";
        name = '%' + name + '%';
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ?";
    } else if (hasCategoryParam) {
        filter = "<h3>Products in category: '" + category + "'</h3>";
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE categoryName = ?";
    } else {
        filter = "<h3>All Products</h3>";
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId";
    }

    out.println(filter);

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        getConnection();
        PreparedStatement pstmt = con.prepareStatement(sql);
        if (hasNameParam) {
            pstmt.setString(1, name);
            if (hasCategoryParam) {
                pstmt.setString(2, category);
            }
        } else if (hasCategoryParam) {
            pstmt.setString(1, category);
        }

        ResultSet rst = pstmt.executeQuery();

        out.print("<div class='product-table'><table class='table table-striped'><thead><tr><th></th><th>Product Name</th><th>Category</th><th>Price</th></tr></thead><tbody>");
        while (rst.next()) {
            int id = rst.getInt(1);
            String productName = rst.getString(2);
            String itemCategory = rst.getString(4);
            String color = colors.getOrDefault(itemCategory, "#000000");

            out.print("<tr>");
            out.print("<td class='add-to-cart'><a href='addcart.jsp?id=" + id + "&name=" + productName + "&price=" + rst.getDouble(3) + "'>Add to Cart</a></td>");
            out.print("<td><a href='product.jsp?id=" + id + "' class='category-color' style='color:" + color + "'>" + productName + "</a></td>");
            out.print("<td style='color:" + color + "'>" + itemCategory + "</td>");
            out.print("<td style='color:" + color + "'>" + currFormat.format(rst.getDouble(3)) + "</td>");
            out.print("</tr>");
        }
        out.print("</tbody></table></div>");
        closeConnection();
    } catch (SQLException ex) {
        out.println(ex);
    }
    %>
</div>

<!-- Include Bootstrap JS (optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
