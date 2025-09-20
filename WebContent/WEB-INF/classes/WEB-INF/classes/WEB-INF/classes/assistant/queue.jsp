<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.PatientQueue" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("assistant")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Queue</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .queue-card { 
            border-left: 4px solid #007bff; 
            transition: all 0.3s ease;
        }
        .queue-card.urgent { border-left-color: #dc3545; }
        .queue-card.waiting { border-left-color: #ffc107; }
        .queue-card.in-progress { border-left-color: #fd7e14; }
        .queue-card.completed { border-left-color: #198754; }
        .queue-number { 
            font-size: 2rem; 
            font-weight: bold; 
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-users me-2"></i>Patient Queue</h2>
                    <p class="text-muted">View and manage the waiting list for doctors.</p>
                </div>
                <div>
                    <button type="button" class="btn btn-success me-2" onclick="addToQueue()">
                        <i class="fas fa-plus me-2"></i>Add to Queue
                    </button>
                    <a href="../dashboard.jsp" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Queue Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-primary">${totalInQueue}</h5>
                            <p class="card-text">Total in Queue</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-warning">${waitingCount}</h5>
                            <p class="card-text">Waiting</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-info">${inProgressCount}</h5>
                            <p class="card-text">In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-success">${completedToday}</h5>
                            <p class="card-text">Completed Today</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Controls -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="waiting" ${param.status == 'waiting' ? 'selected' : ''}>Waiting</option>
                                <option value="in_progress" ${param.status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Priority</label>
                            <select class="form-select" name="priority">
                                <option value="">All Priorities</option>
                                <option value="urgent" ${param.priority == 'urgent' ? 'selected' : ''}>Urgent</option>
                                <option value="high" ${param.priority == 'high' ? 'selected' : ''}>High</option>
                                <option value="normal" ${param.priority == 'normal' ? 'selected' : ''}>Normal</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Doctor ID</label>
                            <input type="number" class="form-control" name="doctorId" value="${param.doctorId}" placeholder="Filter by Doctor">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary d-block w-100">
                                <i class="fas fa-search me-2"></i>Filter Queue
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Patient Queue List -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Current Queue</h5>
                    <div>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshQueue()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                        <span class="badge bg-secondary ms-2">
                            <i class="fas fa-clock me-1"></i>
                            <span id="currentTime"></span>
                        </span>
                    </div>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty queueItems}">
                            <div class="row">
                                <c:forEach var="item" items="${queueItems}" varStatus="status">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card queue-card ${item.status} h-100">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <div class="queue-number">#${item.queuePosition}</div>
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${item.priority == 'urgent'}">
                                                            <span class="badge bg-danger">Urgent</span>
                                                        </c:when>
                                                        <c:when test="${item.priority == 'high'}">
                                                            <span class="badge bg-warning">High</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Normal</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <h6 class="card-title">Patient ID: ${item.patientId}</h6>
                                                <p class="card-text text-muted">
                                                    <i class="fas fa-user-md me-1"></i>Doctor ID: ${item.doctorId}<br>
                                                    <i class="fas fa-calendar me-1"></i>Joined: <fmt:formatDate value="${item.joinTime}" pattern="HH:mm"/><br>
                                                    <c:if test="${not empty item.estimatedWaitTime}">
                                                        <i class="fas fa-hourglass-half me-1"></i>Est. Wait: ${item.estimatedWaitTime} min<br>
                                                    </c:if>
                                                    <i class="fas fa-clipboard me-1"></i>Reason: ${item.reason}
                                                </p>
                                                <c:if test="${not empty item.notes}">
                                                    <div class="alert alert-light p-2">
                                                        <small><strong>Notes:</strong> ${item.notes}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="card-footer">
                                                <div class="btn-group w-100" role="group">
                                                    <c:choose>
                                                        <c:when test="${item.status == 'waiting'}">
                                                            <form method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="startConsultation">
                                                                <input type="hidden" name="id" value="${item.id}">
                                                                <button type="submit" class="btn btn-sm btn-warning">
                                                                    <i class="fas fa-play me-1"></i>Start
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${item.status == 'in_progress'}">
                                                            <form method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="completeConsultation">
                                                                <input type="hidden" name="id" value="${item.id}">
                                                                <button type="submit" class="btn btn-sm btn-success">
                                                                    <i class="fas fa-check me-1"></i>Complete
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success w-100">Completed</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="updateNotes(${item.id}, '${item.notes != null ? item.notes : ''}')">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <c:if test="${item.status != 'completed'}">
                                                        <form method="post" style="display:inline;" 
                                                              onsubmit="return confirm('Remove from queue?')">
                                                            <input type="hidden" name="action" value="removeFromQueue">
                                                            <input type="hidden" name="id" value="${item.id}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Patients in Queue</h5>
                                <p class="text-muted">The queue is currently empty.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add to Queue Modal -->
<div class="modal fade" id="addQueueModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Patient to Queue</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="queue">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Patient ID</label>
                            <input type="number" class="form-control" name="patientId" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Doctor ID</label>
                            <input type="number" class="form-control" name="doctorId" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Priority</label>
                            <select class="form-select" name="priority" required>
                                <option value="normal">Normal</option>
                                <option value="high">High</option>
                                <option value="urgent">Urgent</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Est. Wait Time (min)</label>
                            <input type="number" class="form-control" name="estimatedWaitTime" value="15" min="5" max="120">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Reason for Visit</label>
                            <input type="text" class="form-control" name="reason" required placeholder="e.g., Regular checkup">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Notes</label>
                            <textarea class="form-control" name="notes" rows="3" placeholder="Additional notes..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add to Queue</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Update Notes Modal -->
<div class="modal fade" id="notesModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Notes</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="queue">
                <div class="modal-body">
                    <input type="hidden" name="action" value="updateNotes">
                    <input type="hidden" name="id" id="notesQueueId">
                    <div class="mb-3">
                        <label class="form-label">Notes</label>
                        <textarea class="form-control" name="notes" id="notesContent" rows="4"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Notes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function addToQueue() {
    new bootstrap.Modal(document.getElementById('addQueueModal')).show();
}

function updateNotes(queueId, currentNotes) {
    document.getElementById('notesQueueId').value = queueId;
    document.getElementById('notesContent').value = currentNotes || '';
    new bootstrap.Modal(document.getElementById('notesModal')).show();
}

function refreshQueue() {
    window.location.reload();
}

function updateTime() {
    const now = new Date();
    document.getElementById('currentTime').textContent = now.toLocaleTimeString();
}

// Update time every second
setInterval(updateTime, 1000);
updateTime(); // Initial call
</script>
</body>
</html>





