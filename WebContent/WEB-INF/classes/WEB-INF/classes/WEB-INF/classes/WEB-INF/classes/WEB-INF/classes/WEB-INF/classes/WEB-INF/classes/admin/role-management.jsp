<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.UserRole" %>
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
    <title>Role Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-users-cog me-2"></i>Role Management</h2>
                    <p class="text-muted">Assign and modify user roles and permissions.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Add New Role -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Create New Role</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="role-management">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Role Name</label>
                                <input type="text" class="form-control" name="roleName" required placeholder="e.g., Senior Doctor">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Description</label>
                                <input type="text" class="form-control" name="description" placeholder="Role description">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-success d-block w-100">
                                    <i class="fas fa-save me-2"></i>Create Role
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- User Role Assignment -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-user-tag me-2"></i>Assign User Roles</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="role-management">
                        <input type="hidden" name="action" value="assign">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">User ID</label>
                                <input type="number" class="form-control" name="userId" required placeholder="Enter User ID">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Primary Role</label>
                                <select class="form-select" name="primaryRole" required>
                                    <option value="">Select Role</option>
                                    <option value="patient">Patient</option>
                                    <option value="doctor">Doctor</option>
                                    <option value="assistant">Assistant/Nurse</option>
                                    <option value="admin">Administrator</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Additional Permissions</label>
                                <select class="form-select" name="permissions">
                                    <option value="">None</option>
                                    <option value="view_all_patients">View All Patients</option>
                                    <option value="manage_appointments">Manage Appointments</option>
                                    <option value="access_reports">Access Reports</option>
                                    <option value="system_config">System Configuration</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary d-block w-100">
                                    <i class="fas fa-user-check me-2"></i>Assign Role
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Current Roles Table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Existing Roles</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty roles}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Role Name</th>
                                            <th>Description</th>
                                            <th>Permissions</th>
                                            <th>Created Date</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="role" items="${roles}">
                                            <tr>
                                                <td>${role.id}</td>
                                                <td>
                                                    <span class="badge bg-primary">${role.roleName}</span>
                                                </td>
                                                <td>${role.description}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty role.permissions}">
                                                            <span class="badge bg-success">${role.permissions}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Standard</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${role.createdDate}" pattern="yyyy-MM-dd"/>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                onclick="editRole(${role.id}, '${role.roleName}', '${role.description}')">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <form method="post" style="display:inline;" 
                                                              onsubmit="return confirm('Are you sure you want to delete this role?')">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${role.id}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-users-cog fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Custom Roles Created</h5>
                                <p class="text-muted">Create your first custom role using the form above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Role Modal -->
<div class="modal fade" id="editRoleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="role-management">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editRoleId">
                    <div class="mb-3">
                        <label class="form-label">Role Name</label>
                        <input type="text" class="form-control" name="roleName" id="editRoleName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" id="editRoleDescription" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Role</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function editRole(id, roleName, description) {
    document.getElementById('editRoleId').value = id;
    document.getElementById('editRoleName').value = roleName;
    document.getElementById('editRoleDescription').value = description;
    new bootstrap.Modal(document.getElementById('editRoleModal')).show();
}
</script>
</body>
</html>





