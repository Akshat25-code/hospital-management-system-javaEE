<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("patient")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Prescription Refill Request</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Prescription Refill Request</h2>
    <p class="text-muted">Request a refill for your active prescriptions.</p>
    <form method="post" class="mb-4">
        <div class="row g-2 align-items-end">
            <div class="col-auto">
                <label for="prescriptionId" class="form-label">Prescription ID</label>
                <input type="number" class="form-control" id="prescriptionId" name="prescriptionId" required>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Request Refill</button>
            </div>
        </div>
    </form>
    <h4>Your Refill Requests</h4>
    <c:choose>
        <c:when test="${empty refillRequests}">
            <div class="alert alert-info">No refill requests found.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover mt-3">
                <thead class="table-light">
                    <tr>
                        <th>Prescription ID</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="req" items="${refillRequests}">
                    <tr>
                        <td>${req.prescriptionId}</td>
                        <td>${req.requestDate}</td>
                        <td>${req.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





