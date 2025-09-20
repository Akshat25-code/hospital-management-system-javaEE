<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("doctor")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>E-Prescription</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>E-Prescription</h2>
    <p class="text-muted">Generate and send digital prescriptions to patients.</p>
    <form method="post" class="mb-4">
        <div class="row g-2 align-items-end">
            <div class="col-auto">
                <label for="patientId" class="form-label">Patient ID</label>
                <input type="number" class="form-control" id="patientId" name="patientId" required>
            </div>
            <div class="col-auto">
                <label for="medicineDetails" class="form-label">Medicine Details</label>
                <textarea class="form-control" id="medicineDetails" name="medicineDetails" required></textarea>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Create Prescription</button>
            </div>
        </div>
    </form>
    <h4>Your E-Prescriptions</h4>
    <c:choose>
        <c:when test="${empty ePrescriptions}">
            <div class="alert alert-info">No e-prescriptions found.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover mt-3">
                <thead class="table-light">
                    <tr>
                        <th>Patient ID</th>
                        <th>Medicine Details</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="ep" items="${ePrescriptions}">
                    <tr>
                        <td>${ep.patientId}</td>
                        <td>${ep.medicineDetails}</td>
                        <td>${ep.date}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





