<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.UserFeedback" %>
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
    <title>User Feedback & Support</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-comments me-2"></i>User Feedback & Support</h2>
                    <p class="text-muted">View user feedback and provide support.</p>
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
                            <label class="form-label">Category</label>
                            <select class="form-select" name="category">
                                <option value="">All Categories</option>
                                <option value="bug_report" ${param.category == 'bug_report' ? 'selected' : ''}>Bug Report</option>
                                <option value="feature_request" ${param.category == 'feature_request' ? 'selected' : ''}>Feature Request</option>
                                <option value="complaint" ${param.category == 'complaint' ? 'selected' : ''}>Complaint</option>
                                <option value="compliment" ${param.category == 'compliment' ? 'selected' : ''}>Compliment</option>
                                <option value="general" ${param.category == 'general' ? 'selected' : ''}>General</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="new" ${param.status == 'new' ? 'selected' : ''}>New</option>
                                <option value="in_progress" ${param.status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                <option value="resolved" ${param.status == 'resolved' ? 'selected' : ''}>Resolved</option>
                                <option value="closed" ${param.status == 'closed' ? 'selected' : ''}>Closed</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Priority</label>
                            <select class="form-select" name="priority">
                                <option value="">All Priorities</option>
                                <option value="low" ${param.priority == 'low' ? 'selected' : ''}>Low</option>
                                <option value="medium" ${param.priority == 'medium' ? 'selected' : ''}>Medium</option>
                                <option value="high" ${param.priority == 'high' ? 'selected' : ''}>High</option>
                                <option value="urgent" ${param.priority == 'urgent' ? 'selected' : ''}>Urgent</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary d-block w-100">
                                <i class="fas fa-search me-2"></i>Filter
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Feedback Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-primary">${totalFeedback}</h5>
                            <p class="card-text">Total Feedback</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-warning">${newFeedback}</h5>
                            <p class="card-text">New Items</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-info">${inProgressFeedback}</h5>
                            <p class="card-text">In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-success">${resolvedFeedback}</h5>
                            <p class="card-text">Resolved</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Feedback List -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>User Feedback</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty feedbacks}">
                            <c:forEach var="feedback" items="${feedbacks}">
                                <div class="card mb-3">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <h6 class="mb-0 me-3">User ID: ${feedback.userId}</h6>
                                            <c:choose>
                                                <c:when test="${feedback.category == 'bug_report'}">
                                                    <span class="badge bg-danger">Bug Report</span>
                                                </c:when>
                                                <c:when test="${feedback.category == 'feature_request'}">
                                                    <span class="badge bg-info">Feature Request</span>
                                                </c:when>
                                                <c:when test="${feedback.category == 'complaint'}">
                                                    <span class="badge bg-warning">Complaint</span>
                                                </c:when>
                                                <c:when test="${feedback.category == 'compliment'}">
                                                    <span class="badge bg-success">Compliment</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">General</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${feedback.priority == 'urgent'}">
                                                    <span class="badge bg-danger ms-2">Urgent</span>
                                                </c:when>
                                                <c:when test="${feedback.priority == 'high'}">
                                                    <span class="badge bg-warning ms-2">High</span>
                                                </c:when>
                                                <c:when test="${feedback.priority == 'medium'}">
                                                    <span class="badge bg-info ms-2">Medium</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary ms-2">Low</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <c:if test="${feedback.status != 'resolved' && feedback.status != 'closed'}">
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="id" value="${feedback.id}">
                                                    <input type="hidden" name="status" value="in_progress">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning">
                                                        <i class="fas fa-play me-1"></i>Start
                                                    </button>
                                                </form>
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="id" value="${feedback.id}">
                                                    <input type="hidden" name="status" value="resolved">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-check me-1"></i>Resolve
                                                    </button>
                                                </form>
                                            </c:if>
                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                    onclick="replyToFeedback(${feedback.id})">
                                                <i class="fas fa-reply me-1"></i>Reply
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <h6>${feedback.subject}</h6>
                                        <p class="card-text">${feedback.message}</p>
                                        <div class="row text-muted small">
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar me-1"></i>
                                                Submitted: <fmt:formatDate value="${feedback.submittedDate}" pattern="yyyy-MM-dd HH:mm"/>
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-flag me-1"></i>
                                                Status: <span class="badge bg-${feedback.status == 'resolved' ? 'success' : 'warning'}">${feedback.status}</span>
                                            </div>
                                        </div>
                                        <c:if test="${not empty feedback.adminResponse}">
                                            <div class="alert alert-light mt-3">
                                                <strong>Admin Response:</strong><br>
                                                ${feedback.adminResponse}
                                                <c:if test="${not empty feedback.responseDate}">
                                                    <br><small class="text-muted">
                                                        Responded on: <fmt:formatDate value="${feedback.responseDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                    </small>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Feedback Found</h5>
                                <p class="text-muted">No feedback matches your current filter criteria.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Reply Modal -->
<div class="modal fade" id="replyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Reply to Feedback</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="feedback">
                <div class="modal-body">
                    <input type="hidden" name="action" value="reply">
                    <input type="hidden" name="id" id="replyFeedbackId">
                    <div class="mb-3">
                        <label class="form-label">Response</label>
                        <textarea class="form-control" name="response" rows="5" required 
                                  placeholder="Type your response to the user..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Update Status</label>
                        <select class="form-select" name="newStatus">
                            <option value="in_progress">Keep In Progress</option>
                            <option value="resolved">Mark as Resolved</option>
                            <option value="closed">Close Ticket</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Send Response</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function replyToFeedback(feedbackId) {
    document.getElementById('replyFeedbackId').value = feedbackId;
    new bootstrap.Modal(document.getElementById('replyModal')).show();
}
</script>
</body>
</html>





