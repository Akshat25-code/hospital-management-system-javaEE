<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.InventoryAlert" %>
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
    <title>Inventory Alerts</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .alert-card.critical { border-left: 4px solid #dc3545; }
        .alert-card.warning { border-left: 4px solid #ffc107; }
        .alert-card.info { border-left: 4px solid #0dcaf0; }
        .stock-level {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .stock-critical { color: #dc3545; }
        .stock-warning { color: #fd7e14; }
        .stock-ok { color: #198754; }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-exclamation-triangle me-2"></i>Inventory Alerts</h2>
                    <p class="text-muted">Get notified when medicine or supply stock is low.</p>
                </div>
                <div>
                    <button type="button" class="btn btn-success me-2" onclick="addAlert()">
                        <i class="fas fa-plus me-2"></i>Add Alert
                    </button>
                    <a href="../dashboard.jsp" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Alert Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-danger">${criticalAlerts}</h5>
                            <p class="card-text">Critical Alerts</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-warning">${warningAlerts}</h5>
                            <p class="card-text">Warning Alerts</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-info">${infoAlerts}</h5>
                            <p class="card-text">Info Alerts</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title text-success">${resolvedAlerts}</h5>
                            <p class="card-text">Resolved Today</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Controls -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Alert Level</label>
                            <select class="form-select" name="alertLevel">
                                <option value="">All Levels</option>
                                <option value="critical" ${param.alertLevel == 'critical' ? 'selected' : ''}>Critical</option>
                                <option value="warning" ${param.alertLevel == 'warning' ? 'selected' : ''}>Warning</option>
                                <option value="info" ${param.alertLevel == 'info' ? 'selected' : ''}>Info</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Item Type</label>
                            <select class="form-select" name="itemType">
                                <option value="">All Types</option>
                                <option value="medicine" ${param.itemType == 'medicine' ? 'selected' : ''}>Medicine</option>
                                <option value="supplies" ${param.itemType == 'supplies' ? 'selected' : ''}>Medical Supplies</option>
                                <option value="equipment" ${param.itemType == 'equipment' ? 'selected' : ''}>Equipment</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="acknowledged" ${param.status == 'acknowledged' ? 'selected' : ''}>Acknowledged</option>
                                <option value="resolved" ${param.status == 'resolved' ? 'selected' : ''}>Resolved</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary d-block w-100">
                                <i class="fas fa-search me-2"></i>Filter Alerts
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <form method="post" action="inventory-alerts">
                                <input type="hidden" name="action" value="acknowledgeAll">
                                <button type="submit" class="btn btn-outline-warning w-100">
                                    <i class="fas fa-check-circle me-2"></i>Acknowledge All Critical
                                </button>
                            </form>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-outline-info w-100" onclick="generateReport()">
                                <i class="fas fa-file-alt me-2"></i>Generate Report
                            </button>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-outline-success w-100" onclick="checkStock()">
                                <i class="fas fa-sync-alt me-2"></i>Check Stock Levels
                            </button>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-outline-primary w-100" onclick="setThresholds()">
                                <i class="fas fa-cog me-2"></i>Set Thresholds
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inventory Alerts List -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Current Alerts</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty alerts}">
                            <c:forEach var="alert" items="${alerts}">
                                <div class="card alert-card ${alert.alertLevel} mb-3">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <h6 class="mb-0 me-3">${alert.itemName}</h6>
                                            <c:choose>
                                                <c:when test="${alert.alertLevel == 'critical'}">
                                                    <span class="badge bg-danger">Critical</span>
                                                </c:when>
                                                <c:when test="${alert.alertLevel == 'warning'}">
                                                    <span class="badge bg-warning">Warning</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info">Info</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="badge bg-secondary ms-2">${alert.itemType}</span>
                                        </div>
                                        <div class="btn-group" role="group">
                                            <c:if test="${alert.status == 'active'}">
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="acknowledge">
                                                    <input type="hidden" name="id" value="${alert.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning">
                                                        <i class="fas fa-check me-1"></i>Acknowledge
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${alert.status != 'resolved'}">
                                                <form method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="resolve">
                                                    <input type="hidden" name="id" value="${alert.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-check-circle me-1"></i>Resolve
                                                    </button>
                                                </form>
                                            </c:if>
                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                    onclick="editAlert(${alert.id}, '${alert.itemName}', ${alert.currentStock}, ${alert.thresholdLevel})">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p class="card-text">${alert.message}</p>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    Created: <fmt:formatDate value="${alert.createdDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                </small>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="text-center">
                                                    <div class="stock-level stock-${alert.alertLevel == 'critical' ? 'critical' : alert.alertLevel == 'warning' ? 'warning' : 'ok'}">
                                                        ${alert.currentStock}
                                                    </div>
                                                    <small class="text-muted">Current Stock</small>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="text-center">
                                                    <div class="stock-level text-secondary">
                                                        ${alert.thresholdLevel}
                                                    </div>
                                                    <small class="text-muted">Threshold Level</small>
                                                </div>
                                            </div>
                                        </div>
                                        <c:if test="${alert.status == 'acknowledged'}">
                                            <div class="alert alert-warning mt-2 mb-0">
                                                <i class="fas fa-info-circle me-2"></i>This alert has been acknowledged and is being addressed.
                                            </div>
                                        </c:if>
                                        <c:if test="${alert.status == 'resolved'}">
                                            <div class="alert alert-success mt-2 mb-0">
                                                <i class="fas fa-check-circle me-2"></i>This alert has been resolved.
                                                <c:if test="${not empty alert.resolvedDate}">
                                                    <br><small>Resolved on: <fmt:formatDate value="${alert.resolvedDate}" pattern="yyyy-MM-dd HH:mm"/></small>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                                <h5 class="text-muted">No Active Alerts</h5>
                                <p class="text-muted">All inventory levels are within acceptable thresholds.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Alert Modal -->
<div class="modal fade" id="addAlertModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Inventory Alert</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="inventory-alerts">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Item Name</label>
                            <input type="text" class="form-control" name="itemName" required placeholder="e.g., Paracetamol">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Item Type</label>
                            <select class="form-select" name="itemType" required>
                                <option value="medicine">Medicine</option>
                                <option value="supplies">Medical Supplies</option>
                                <option value="equipment">Equipment</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Current Stock</label>
                            <input type="number" class="form-control" name="currentStock" required min="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Threshold Level</label>
                            <input type="number" class="form-control" name="thresholdLevel" required min="1">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Alert Level</label>
                            <select class="form-select" name="alertLevel" required>
                                <option value="info">Info</option>
                                <option value="warning">Warning</option>
                                <option value="critical">Critical</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Message</label>
                            <textarea class="form-control" name="message" rows="3" required
                                      placeholder="Describe the alert condition..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Alert</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Alert Modal -->
<div class="modal fade" id="editAlertModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Alert Thresholds</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="inventory-alerts">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editAlertId">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Item Name</label>
                            <input type="text" class="form-control" id="editItemName" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Current Stock</label>
                            <input type="number" class="form-control" name="currentStock" id="editCurrentStock" required min="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Threshold Level</label>
                            <input type="number" class="form-control" name="thresholdLevel" id="editThresholdLevel" required min="1">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Alert</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function addAlert() {
    new bootstrap.Modal(document.getElementById('addAlertModal')).show();
}

function editAlert(id, itemName, currentStock, thresholdLevel) {
    document.getElementById('editAlertId').value = id;
    document.getElementById('editItemName').value = itemName;
    document.getElementById('editCurrentStock').value = currentStock;
    document.getElementById('editThresholdLevel').value = thresholdLevel;
    new bootstrap.Modal(document.getElementById('editAlertModal')).show();
}

function generateReport() {
    // Implementation for generating inventory report
    alert('Generating inventory report...');
}

function checkStock() {
    // Implementation for checking stock levels
    alert('Checking current stock levels...');
}

function setThresholds() {
    // Implementation for setting global thresholds
    alert('Opening threshold configuration...');
}
</script>
</body>
</html>





