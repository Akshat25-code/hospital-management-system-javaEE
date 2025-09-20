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
    <title>Lab Test Results</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Lab Test Results</h2>
    <p class="text-muted">View your lab test results and download reports.</p>
    <c:choose>
        <c:when test="${empty labTests}">
            <div class="alert alert-info">No lab tests found.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover mt-4">
                <thead class="table-light">
                    <tr>
                        <th>Test Name</th>
                        <th>Result</th>
                        <th>Date</th>
                        <th>Report</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="test" items="${labTests}">
                    <tr>
                        <td>${test.testName}</td>
                        <td>${test.result}</td>
                        <td>${test.testDate}</td>
                        <td>
                            <c:if test="${not empty test.reportFilePath}">
                                <a href="${pageContext.request.contextPath}/files/${test.reportFilePath}" class="btn btn-sm btn-primary" download>Download</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





