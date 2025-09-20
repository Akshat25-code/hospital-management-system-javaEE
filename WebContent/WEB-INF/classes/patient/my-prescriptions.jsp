<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.EPrescription, java.util.List, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("patient")) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    List<EPrescription> prescriptions = (List<EPrescription>) request.getAttribute("prescriptions");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My E-Prescriptions - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4><i class="fas fa-prescription me-2"></i>My E-Prescriptions</h4>
                    <a href="../dashboard.jsp" class="btn btn-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                    </a>
                </div>
                <div class="card-body">
                    <% if (prescriptions == null || prescriptions.isEmpty()) { %>
                        <div class="alert alert-info text-center">
                            <i class="fas fa-info-circle me-2"></i>
                            No e-prescriptions found. Your doctors will issue digital prescriptions that will appear here.
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Prescription ID</th>
                                        <th>Medicine Details</th>
                                        <th>Prescribed Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (EPrescription prescription : prescriptions) { %>
                                        <tr>
                                            <td>
                                                <span class="badge bg-primary">#<%= prescription.getId() %></span>
                                            </td>
                                            <td>
                                                <div class="prescription-details">
                                                    <%= prescription.getMedicineDetails().replace("\n", "<br>") %>
                                                </div>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <%= dateFormat.format(prescription.getDate()) %>
                                                </small>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-info" title="Print Prescription" onclick="printPrescription('<%= prescription.getId() %>')">
                                                    <i class="fas fa-print"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success" title="Download PDF" onclick="downloadPrescription('<%= prescription.getId() %>')">
                                                    <i class="fas fa-download"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function printPrescription(id) {
    alert('Print prescription #' + id + ' - Feature coming soon!');
}

function downloadPrescription(id) {
    alert('Download prescription #' + id + ' as PDF - Feature coming soon!');
}
</script>

<style>
.prescription-details {
    font-family: 'Courier New', monospace;
    background-color: #f8f9fa;
    padding: 10px;
    border-radius: 4px;
    border-left: 4px solid #007bff;
}
</style>
</body>
</html>
