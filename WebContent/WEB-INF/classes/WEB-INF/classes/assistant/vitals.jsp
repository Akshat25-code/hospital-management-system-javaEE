<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.PatientVital" %>
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
    <title>Vitals Entry</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .vital-card {
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        .vital-card.normal { border-left-color: #198754; }
        .vital-card.warning { border-left-color: #ffc107; }
        .vital-card.critical { border-left-color: #dc3545; }
        .vital-value {
            font-size: 1.25rem;
            font-weight: bold;
        }
        .vital-normal { color: #198754; }
        .vital-warning { color: #fd7e14; }
        .vital-critical { color: #dc3545; }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-heartbeat me-2"></i>Vitals Entry</h2>
                    <p class="text-muted">Enter and update patient vital signs in real time.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Patient Search and Vitals Entry -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Record New Vitals</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="vitals" id="vitalsForm">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Patient ID</label>
                                <input type="number" class="form-control" name="patientId" required 
                                       placeholder="Enter Patient ID" onchange="loadPatientInfo(this.value)">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Recorded By</label>
                                <input type="text" class="form-control" name="recordedBy" value="${user.username}" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Date & Time</label>
                                <input type="datetime-local" class="form-control" name="recordedDate" required
                                       value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd\'T\'HH:mm'/>">
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Blood Pressure (Systolic)</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="systolicBP" 
                                           placeholder="120" min="60" max="250">
                                    <span class="input-group-text">mmHg</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Blood Pressure (Diastolic)</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="diastolicBP" 
                                           placeholder="80" min="40" max="150">
                                    <span class="input-group-text">mmHg</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Heart Rate</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="heartRate" 
                                           placeholder="72" min="30" max="200">
                                    <span class="input-group-text">bpm</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Temperature</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="temperature" step="0.1"
                                           placeholder="98.6" min="90" max="110">
                                    <span class="input-group-text">°F</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Respiratory Rate</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="respiratoryRate" 
                                           placeholder="16" min="8" max="40">
                                    <span class="input-group-text">/min</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Oxygen Saturation</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="oxygenSaturation" 
                                           placeholder="98" min="70" max="100">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Weight</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="weight" step="0.1"
                                           placeholder="150" min="0" max="500">
                                    <span class="input-group-text">lbs</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Height</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="height" step="0.1"
                                           placeholder="68" min="20" max="96">
                                    <span class="input-group-text">inches</span>
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Notes</label>
                                <textarea class="form-control" name="notes" rows="3" 
                                          placeholder="Additional observations or notes..."></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Save Vitals
                                </button>
                                <button type="reset" class="btn btn-outline-secondary ms-2">
                                    <i class="fas fa-undo me-2"></i>Reset Form
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Filter Controls -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Patient ID</label>
                            <input type="number" class="form-control" name="patientId" value="${param.patientId}" 
                                   placeholder="Filter by Patient ID">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Date From</label>
                            <input type="date" class="form-control" name="dateFrom" value="${param.dateFrom}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Date To</label>
                            <input type="date" class="form-control" name="dateTo" value="${param.dateTo}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary d-block w-100">
                                <i class="fas fa-search me-2"></i>Filter Vitals
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Recent Vitals -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>Recent Vitals</h5>
                    <div>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="exportVitals()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success" onclick="refreshVitals()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty vitals}">
                            <div class="row">
                                <c:forEach var="vital" items="${vitals}">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card vital-card ${vital.alertLevel}">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">Patient ID: ${vital.patientId}</h6>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${vital.recordedDate}" pattern="MM/dd HH:mm"/>
                                                </small>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-2 text-center">
                                                    <c:if test="${not empty vital.systolicBP and not empty vital.diastolicBP}">
                                                        <div class="col-6">
                                                            <div class="vital-value vital-${vital.systolicBP > 140 or vital.diastolicBP > 90 ? 'critical' : vital.systolicBP > 130 or vital.diastolicBP > 80 ? 'warning' : 'normal'}">
                                                                ${vital.systolicBP}/${vital.diastolicBP}
                                                            </div>
                                                            <small class="text-muted">BP (mmHg)</small>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty vital.heartRate}">
                                                        <div class="col-6">
                                                            <div class="vital-value vital-${vital.heartRate > 100 or vital.heartRate < 60 ? 'warning' : 'normal'}">
                                                                ${vital.heartRate}
                                                            </div>
                                                            <small class="text-muted">HR (bpm)</small>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty vital.temperature}">
                                                        <div class="col-6">
                                                            <div class="vital-value vital-${vital.temperature > 100.4 or vital.temperature < 96 ? 'critical' : vital.temperature > 99 ? 'warning' : 'normal'}">
                                                                ${vital.temperature}°F
                                                            </div>
                                                            <small class="text-muted">Temp</small>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty vital.oxygenSaturation}">
                                                        <div class="col-6">
                                                            <div class="vital-value vital-${vital.oxygenSaturation < 95 ? 'critical' : vital.oxygenSaturation < 98 ? 'warning' : 'normal'}">
                                                                ${vital.oxygenSaturation}%
                                                            </div>
                                                            <small class="text-muted">O2 Sat</small>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <c:if test="${not empty vital.notes}">
                                                    <div class="alert alert-light mt-2 mb-0">
                                                        <small><strong>Notes:</strong> ${vital.notes}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="card-footer text-center">
                                                <small class="text-muted">
                                                    Recorded by: ${vital.recordedBy}
                                                </small>
                                                <div class="btn-group mt-1" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="viewDetails(${vital.id})">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-warning" 
                                                            onclick="editVitals(${vital.id})">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <form method="post" style="display:inline;" 
                                                          onsubmit="return confirm('Delete this vitals record?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${vital.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-heartbeat fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Vitals Recorded</h5>
                                <p class="text-muted">Start recording patient vitals using the form above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Vital Details Modal -->
<div class="modal fade" id="vitalsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Vital Signs Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="vitalsModalContent">
                <!-- Dynamic content will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function loadPatientInfo(patientId) {
    if (patientId) {
        // In a real implementation, this would fetch patient info via AJAX
        console.log('Loading patient info for ID:', patientId);
    }
}

function viewDetails(vitalId) {
    // In a real implementation, this would load vital details via AJAX
    document.getElementById('vitalsModalContent').innerHTML = 
        '<p>Loading vital signs details for ID: ' + vitalId + '</p>';
    new bootstrap.Modal(document.getElementById('vitalsModal')).show();
}

function editVitals(vitalId) {
    // In a real implementation, this would populate the form with existing data
    alert('Edit functionality for vital ID: ' + vitalId);
}

function exportVitals() {
    alert('Exporting vitals data...');
}

function refreshVitals() {
    window.location.reload();
}

// Auto-calculate BMI when weight and height are entered
document.addEventListener('DOMContentLoaded', function() {
    const weightInput = document.querySelector('input[name="weight"]');
    const heightInput = document.querySelector('input[name="height"]');
    
    function calculateBMI() {
        const weight = parseFloat(weightInput.value);
        const height = parseFloat(heightInput.value);
        
        if (weight && height) {
            const bmi = (weight / (height * height)) * 703;
            console.log('BMI calculated:', bmi.toFixed(1));
            // You could display this in the UI
        }
    }
    
    if (weightInput && heightInput) {
        weightInput.addEventListener('input', calculateBMI);
        heightInput.addEventListener('input', calculateBMI);
    }
});
</script>
</body>
</html>





