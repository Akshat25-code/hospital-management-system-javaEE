<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.TaskAssignment" %>
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
    <title>Task Assignment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-tasks me-2"></i>Task Assignment</h2>
                    <p class="text-muted">Assign and track daily tasks (e.g., check-ins, vitals).</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Create New Task -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Create New Task</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="tasks">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Patient ID</label>
                                <input type="number" class="form-control" name="patientId" required placeholder="Enter Patient ID">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Assigned To (User ID)</label>
                                <input type="number" class="form-control" name="assignedTo" value="${user.id}" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Priority</label>
                                <select class="form-select" name="priority" required>
                                    <option value="low">Low</option>
                                    <option value="medium" selected>Medium</option>
                                    <option value="high">High</option>
                                    <option value="urgent">Urgent</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Task Title</label>
                                <input type="text" class="form-control" name="taskTitle" required placeholder="e.g., Take Patient Vitals">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Task Type</label>
                                <select class="form-select" name="taskType">
                                    <option value="vitals">Take Vitals</option>
                                    <option value="medication">Medication Administration</option>
                                    <option value="checkup">Patient Check-up</option>
                                    <option value="documentation">Documentation</option>
                                    <option value="preparation">Room Preparation</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Due Date</label>
                                <input type="datetime-local" class="form-control" name="dueDate" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="3" 
                                          placeholder="Detailed description of the task..."></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-plus me-2"></i>Create Task
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Task Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-primary">${totalTasks}</h5>
                            <p class="card-text">Total Tasks</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-warning">${pendingTasks}</h5>
                            <p class="card-text">Pending</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-info">${inProgressTasks}</h5>
                            <p class="card-text">In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-success">${completedTasks}</h5>
                            <p class="card-text">Completed</p>
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
                                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
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
                                <option value="medium" ${param.priority == 'medium' ? 'selected' : ''}>Medium</option>
                                <option value="low" ${param.priority == 'low' ? 'selected' : ''}>Low</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Task Type</label>
                            <select class="form-select" name="taskType">
                                <option value="">All Types</option>
                                <option value="vitals" ${param.taskType == 'vitals' ? 'selected' : ''}>Vitals</option>
                                <option value="medication" ${param.taskType == 'medication' ? 'selected' : ''}>Medication</option>
                                <option value="checkup" ${param.taskType == 'checkup' ? 'selected' : ''}>Check-up</option>
                                <option value="documentation" ${param.taskType == 'documentation' ? 'selected' : ''}>Documentation</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary d-block w-100">
                                <i class="fas fa-search me-2"></i>Filter Tasks
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tasks List -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Task List</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty tasks}">
                            <c:forEach var="task" items="${tasks}">
                                <div class="card mb-3">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <h6 class="mb-0 me-3">${task.taskTitle}</h6>
                                            <c:choose>
                                                <c:when test="${task.priority == 'urgent'}">
                                                    <span class="badge bg-danger">Urgent</span>
                                                </c:when>
                                                <c:when test="${task.priority == 'high'}">
                                                    <span class="badge bg-warning">High</span>
                                                </c:when>
                                                <c:when test="${task.priority == 'medium'}">
                                                    <span class="badge bg-info">Medium</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Low</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="badge bg-primary ms-2">${task.taskType}</span>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <c:if test="${task.status == 'pending'}">
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="start">
                                                    <input type="hidden" name="id" value="${task.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning">
                                                        <i class="fas fa-play me-1"></i>Start
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${task.status == 'in_progress'}">
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="complete">
                                                    <input type="hidden" name="id" value="${task.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-check me-1"></i>Complete
                                                    </button>
                                                </form>
                                            </c:if>
                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                    onclick="addNotes(${task.id})">
                                                <i class="fas fa-edit me-1"></i>Notes
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <p class="card-text">${task.description}</p>
                                                <c:if test="${not empty task.notes}">
                                                    <div class="alert alert-light">
                                                        <strong>Notes:</strong> ${task.notes}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="col-md-4">
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>Patient ID: ${task.patientId}<br>
                                                    <i class="fas fa-calendar me-1"></i>Due: <fmt:formatDate value="${task.dueDate}" pattern="yyyy-MM-dd HH:mm"/><br>
                                                    <i class="fas fa-flag me-1"></i>Status: 
                                                    <span class="badge bg-${task.status == 'completed' ? 'success' : task.status == 'in_progress' ? 'warning' : 'secondary'}">${task.status}</span>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-tasks fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Tasks Found</h5>
                                <p class="text-muted">Create your first task using the form above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Notes Modal -->
<div class="modal fade" id="notesModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Task Notes</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="tasks">
                <div class="modal-body">
                    <input type="hidden" name="action" value="addNotes">
                    <input type="hidden" name="id" id="notesTaskId">
                    <div class="mb-3">
                        <label class="form-label">Notes</label>
                        <textarea class="form-control" name="notes" rows="4" required 
                                  placeholder="Add notes about this task..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Notes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function addNotes(taskId) {
    document.getElementById('notesTaskId').value = taskId;
    new bootstrap.Modal(document.getElementById('notesModal')).show();
}
</script>
</body>
</html>





