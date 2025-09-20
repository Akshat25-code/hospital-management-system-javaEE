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
    <title>Patient History Viewer</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Patient History Viewer</h2>
    <p class="text-muted">Quickly access a patient's full medical and appointment history.</p>
    <form method="get" class="mb-4">
        <div class="row g-2 align-items-end">
            <div class="col-auto">
                <label for="patientId" class="form-label">Patient ID</label>
                <input type="number" class="form-control" id="patientId" name="patientId" required>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">View History</button>
            </div>
        </div>
    </form>
    <c:choose>
        <c:when test="${empty history}">
            <div class="alert alert-info">No patient history found.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover mt-4">
                <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="h" items="${history}">
                    <tr>
                        <td>${h.date}</td>
                        <td>${h.details}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





