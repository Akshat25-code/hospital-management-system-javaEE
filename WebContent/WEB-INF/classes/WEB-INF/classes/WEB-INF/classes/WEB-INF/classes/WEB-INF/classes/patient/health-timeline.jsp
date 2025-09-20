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
    <title>Health Timeline</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Health Timeline</h2>
    <p class="text-muted">Visualize your appointments, lab tests, and treatments over time.</p>
    <c:choose>
        <c:when test="${empty timelineEvents}">
            <div class="alert alert-info">No health events found.</div>
        </c:when>
        <c:otherwise>
            <ul class="list-group mt-4">
                <c:forEach var="event" items="${timelineEvents}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span>
                            <strong>${event.eventType}:</strong> ${event.description}
                        </span>
                        <span class="badge bg-primary rounded-pill">${event.eventDate}</span>
                    </li>
                </c:forEach>
            </ul>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





