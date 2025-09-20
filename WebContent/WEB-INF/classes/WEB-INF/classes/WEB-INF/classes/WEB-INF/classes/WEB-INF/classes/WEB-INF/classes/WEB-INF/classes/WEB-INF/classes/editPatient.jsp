<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Patient,dao.PatientDAO" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    PatientDAO dao = new PatientDAO();
    Patient patient = dao.getPatientById(id);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Patient</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Edit Patient</h2>
    <form action="EditPatientServlet" method="post">
        <input type="hidden" name="id" value="<%= patient.getId() %>">
        <div class="mb-3">
            <label>Name:</label>
            <input type="text" name="name" class="form-control" value="<%= patient.getName() %>" required>
        </div>
        <div class="mb-3">
            <label>Age:</label>
            <input type="number" name="age" class="form-control" value="<%= patient.getAge() %>" required>
        </div>
        <div class="mb-3">
            <label>Gender:</label>
            <select name="gender" class="form-control" required>
                <option value="Male" <%= "Male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                <option value="Other" <%= "Other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Address:</label>
            <input type="text" name="address" class="form-control" value="<%= patient.getAddress() %>" required>
        </div>
        <div class="mb-3">
            <label>Phone:</label>
            <input type="text" name="phone" class="form-control" value="<%= patient.getPhone() %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Update Patient</button>
        <a href="patients.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>





