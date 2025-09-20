<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.ActivityLog" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Activity Logs</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-history me-2"></i>User Activity Logs</h2>
                    <p class="text-muted">Track all user actions for auditing and security.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Filter Controls -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">User ID</label>
                            <input type="number" class="form-control" name="userId" value="${param.userId}" placeholder="Enter User ID">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Action Type</label>
                            <select class="form-select" name="actionType">
                                <option value="">All Actions</option>
                                <option value="login" ${param.actionType == 'login' ? 'selected' : ''}>Login</option>
                                <option value="logout" ${param.actionType == 'logout' ? 'selected' : ''}>Logout</option>
                                <option value="create" ${param.actionType == 'create' ? 'selected' : ''}>Create</option>
                                <option value="update" ${param.actionType == 'update' ? 'selected' : ''}>Update</option>
                                <option value="delete" ${param.actionType == 'delete' ? 'selected' : ''}>Delete</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Date From</label>
                            <input type="date" class="form-control" name="dateFrom" value="${param.dateFrom}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Date To</label>
                            <input type="date" class="form-control" name="dateTo" value="${param.dateTo}">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Filter Logs
                            </button>
                            <a href="activity-logs" class="btn btn-outline-secondary ms-2">
                                <i class="fas fa-refresh me-2"></i>Clear Filters
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Activity Logs Table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Activity History</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty logs}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>User ID</th>
                                            <th>Action</th>
                                            <th>Details</th>
                                            <th>IP Address</th>
                                            <th>Timestamp</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${logs}">
                                            <tr>
                                                <td>${log.id}</td>
                                                <td>
                                                    <span class="badge bg-primary">${log.userId}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${log.action == 'login'}">
                                                            <span class="badge bg-success"><i class="fas fa-sign-in-alt me-1"></i>Login</span>
                                                        </c:when>
                                                        <c:when test="${log.action == 'logout'}">
                                                            <span class="badge bg-warning"><i class="fas fa-sign-out-alt me-1"></i>Logout</span>
                                                        </c:when>
                                                        <c:when test="${log.action == 'create'}">
                                                            <span class="badge bg-info"><i class="fas fa-plus me-1"></i>Create</span>
                                                        </c:when>
                                                        <c:when test="${log.action == 'update'}">
                                                            <span class="badge bg-primary"><i class="fas fa-edit me-1"></i>Update</span>
                                                        </c:when>
                                                        <c:when test="${log.action == 'delete'}">
                                                            <span class="badge bg-danger"><i class="fas fa-trash me-1"></i>Delete</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${log.action}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${log.details}</td>
                                                <td><code>${log.ipAddress}</code></td>
                                                <td>
                                                    <fmt:formatDate value="${log.timestamp}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-history fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Activity Logs Found</h5>
                                <p class="text-muted">No logs match your current filter criteria.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>





