<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,model.Prescription,dao.PrescriptionDAO,model.Doctor,dao.DoctorDAO,model.Patient,dao.PatientDAO,model.Medicine,dao.MedicineDAO" %>
<%
    PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    List<Prescription> prescriptions = prescriptionDAO.getAllPrescriptions();
    DoctorDAO doctorDAO = new DoctorDAO();
    PatientDAO patientDAO = new PatientDAO();
    MedicineDAO medicineDAO = new MedicineDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Prescriptions - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-prescription-bottle-medical me-3"></i>Prescriptions Management</h2>
            <p class="mb-0">Manage patient prescriptions and medications</p>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <% model.User user = (model.User) session.getAttribute("user"); %>
                <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                    <a href="addPrescription.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Prescription
                    </a>
                <% } %>
            </div>
            <div>
                <button onclick="exportToCSV('prescriptionsTable', 'prescriptions')" class="btn btn-success me-2">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
                <button onclick="printTable('prescriptionsTable')" class="btn btn-info">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body p-0">
                <table id="prescriptionsTable" class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-2"></i>ID</th>
                            <th><i class="fas fa-bed-pulse me-2"></i>Patient</th>
                            <th><i class="fas fa-user-doctor me-2"></i>Doctor</th>
                            <th><i class="fas fa-pills me-2"></i>Medicine</th>
                            <th><i class="fas fa-prescription me-2"></i>Dosage</th>
                            <th><i class="fas fa-notes-medical me-2"></i>Instructions</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Prescription p : prescriptions) { %>
                            <tr>
                                <td><span class="badge bg-danger"><%= p.getId() %></span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-success text-white me-3">
                                            <i class="fas fa-bed-pulse"></i>
                                        </div>
                                        <strong><%= patientDAO.getPatientById(p.getPatientId()).getName() %></strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-primary text-white me-3">
                                            <i class="fas fa-user-doctor"></i>
                                        </div>
                                        <strong><%= doctorDAO.getDoctorById(p.getDoctorId()).getName() %></strong>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-info">
                                        <i class="fas fa-pills me-1"></i>
                                        <%= medicineDAO.getMedicineById(p.getMedicineId()).getName() %>
                                    </span>
                                </td>
                                <td><span class="fw-bold text-primary"><%= p.getDosage() %></span></td>
                                <td><%= p.getInstructions() %></td>
                                <td>
                                    <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                                        <a href="editPrescription.jsp?id=<%= p.getId() %>" class="btn btn-sm btn-warning me-1">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="confirmDelete('prescription', '<%= p.getId() %>', 'DeletePrescriptionServlet')" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    <% } else { %>
                                        <span class="text-muted">View Only</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="loadingSpinner" class="loading-spinner">
    <div class="spinner-border text-danger" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
<style>
.avatar-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}
</style>
</body>
</html>





