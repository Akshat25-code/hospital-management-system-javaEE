<%@ page import="model.Medicine,dao.MedicineDAO" %>
<%
    String idStr = request.getParameter("id");
    int id = idStr != null ? Integer.parseInt(idStr) : 0;
    Medicine medicine = new MedicineDAO().getMedicineById(id);
%>
<html>
<head>
    <title>Edit Medicine</title>
</head>
<body>
    <h2>Edit Medicine</h2>
    <form action="EditMedicineServlet" method="post">
        <input type="hidden" name="id" value="<%= medicine.getId() %>" />
        Name: <input type="text" name="name" value="<%= medicine.getName() %>" required /><br/>
        Manufacturer: <input type="text" name="manufacturer" value="<%= medicine.getManufacturer() %>" required /><br/>
        Price: <input type="number" step="0.01" name="price" value="<%= medicine.getPrice() %>" required /><br/>
        Quantity: <input type="number" name="quantity" value="<%= medicine.getQuantity() %>" required /><br/>
        <input type="submit" value="Update" />
    </form>
    <a href="medicines.jsp">Back to Medicines</a>
</body>
</html>





