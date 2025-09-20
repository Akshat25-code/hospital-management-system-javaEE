<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.SystemAnnouncement" %>
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
    <title>System Announcements</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-bullhorn me-2"></i>System Announcements</h2>
                    <p class="text-muted">Post announcements visible to all users on login.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Create New Announcement -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Create New Announcement</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="announcements">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Title</label>
                                <input type="text" class="form-control" name="title" required placeholder="Announcement title">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Priority</label>
                                <select class="form-select" name="priority" required>
                                    <option value="info">Info</option>
                                    <option value="warning">Warning</option>
                                    <option value="critical">Critical</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Target Role</label>
                                <select class="form-select" name="targetRole">
                                    <option value="all">All Users</option>
                                    <option value="patient">Patients Only</option>
                                    <option value="doctor">Doctors Only</option>
                                    <option value="assistant">Assistants Only</option>
                                    <option value="admin">Admins Only</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Message</label>
                                <textarea class="form-control" name="message" rows="4" required 
                                          placeholder="Enter your announcement message here..."></textarea>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Valid Until</label>
                                <input type="datetime-local" class="form-control" name="validUntil">
                            </div>
                            <div class="col-md-8">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-success d-block">
                                    <i class="fas fa-bullhorn me-2"></i>Post Announcement
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Current Announcements -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Current Announcements</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty announcements}">
                            <c:forEach var="announcement" items="${announcements}">
                                <div class="card mb-3">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <h6 class="mb-0 me-3">${announcement.title}</h6>
                                            <c:choose>
                                                <c:when test="${announcement.priority == 'critical'}">
                                                    <span class="badge bg-danger">Critical</span>
                                                </c:when>
                                                <c:when test="${announcement.priority == 'warning'}">
                                                    <span class="badge bg-warning">Warning</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info">Info</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="badge bg-secondary ms-2">${announcement.targetRole}</span>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <c:choose>
                                                <c:when test="${announcement.active}">
                                                    <form method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="id" value="${announcement.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning">
                                                            <i class="fas fa-pause me-1"></i>Deactivate
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="activate">
                                                        <input type="hidden" name="id" value="${announcement.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-play me-1"></i>Activate
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                            <form method="post" style="display:inline;" 
                                                  onsubmit="return confirm('Are you sure you want to delete this announcement?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${announcement.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">${announcement.message}</p>
                                        <div class="row text-muted small">
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar me-1"></i>
                                                Created: <fmt:formatDate value="${announcement.createdDate}" pattern="yyyy-MM-dd HH:mm"/>
                                            </div>
                                            <div class="col-md-6">
                                                <c:if test="${not empty announcement.validUntil}">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Valid until: <fmt:formatDate value="${announcement.validUntil}" pattern="yyyy-MM-dd HH:mm"/>
                                                </c:if>
                                            </div>
                                        </div>
                                        <c:if test="${not announcement.active}">
                                            <div class="alert alert-warning mt-2 mb-0">
                                                <i class="fas fa-pause-circle me-2"></i>This announcement is currently inactive.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-bullhorn fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Announcements Posted</h5>
                                <p class="text-muted">Create your first announcement using the form above.</p>
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





