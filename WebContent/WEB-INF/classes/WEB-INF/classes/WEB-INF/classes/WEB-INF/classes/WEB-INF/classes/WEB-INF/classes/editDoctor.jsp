<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Doctor,dao.DoctorDAO" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    DoctorDAO dao = new DoctorDAO();
    Doctor doctor = dao.getDoctorById(id);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Doctor</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Edit Doctor</h2>
    <form action="EditDoctorServlet" method="post">
        <input type="hidden" name="id" value="<%= doctor.getId() %>">
        <div class="mb-3">
            <label>Name:</label>
            <input type="text" name="name" class="form-control" value="<%= doctor.getName() %>" required>
        </div>
        <div class="mb-3">
            <label>Specialization:</label>
            <input type="text" name="specialization" class="form-control" value="<%= doctor.getSpecialization() %>" required>
        </div>
        <div class="mb-3">
            <label>Email:</label>
            <input type="email" name="email" class="form-control" value="<%= doctor.getEmail() %>" required>
        </div>
        <div class="mb-3">
            <label>Phone:</label>
            <input type="text" name="phone" class="form-control" value="<%= doctor.getPhone() %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Update Doctor</button>
        <a href="doctors.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>





