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
    <title>Download Medical Reports</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Download Medical Reports</h2>
    <p class="text-muted">Here you can download your lab results and prescriptions as PDF files.</p>
    <c:choose>
        <c:when test="${empty reports}">
            <div class="alert alert-info">No medical reports found.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover mt-4">
                <thead class="table-light">
                    <tr>
                        <th>Type</th>
                        <th>File Name</th>
                        <th>Uploaded</th>
                        <th>Download</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="report" items="${reports}">
                    <tr>
                        <td>${report.reportType}</td>
                        <td>${report.fileName}</td>
                        <td>${report.uploadDate}</td>
                        <td><a href="${pageContext.request.contextPath}/files/${report.filePath}" class="btn btn-sm btn-primary" download>Download</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>





