<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,model.Patient,model.User" %>
<%
    // Get the current logged-in user
    User user = (User) session.getAttribute("user");
    
    // Check if data is loaded from servlet, if not redirect to servlet
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    if (patients == null) {
        response.sendRedirect("PatientListServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patients - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-bed-pulse me-3"></i>Patients Management</h2>
            <p class="mb-0">Manage patient records and information</p>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                    <a href="addPatient.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Patient
                    </a>
                <% } %>
            </div>
            <div>
                <button onclick="exportToCSV('patientsTable', 'patients')" class="btn btn-success me-2">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
                <button onclick="printTable('patientsTable')" class="btn btn-info">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body p-0">
                <table id="patientsTable" class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-2"></i>ID</th>
                            <th><i class="fas fa-user me-2"></i>Name</th>
                            <th><i class="fas fa-birthday-cake me-2"></i>Age</th>
                            <th><i class="fas fa-venus-mars me-2"></i>Gender</th>
                            <th><i class="fas fa-map-marker-alt me-2"></i>Address</th>
                            <th><i class="fas fa-phone me-2"></i>Phone</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Patient p : patients) { %>
                            <tr>
                                <td><span class="badge bg-success"><%= p.getId() %></span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-success text-white me-3">
                                            <%= p.getName().substring(0,1).toUpperCase() %>
                                        </div>
                                        <strong><%= p.getName() %></strong>
                                    </div>
                                </td>
                                <td><%= p.getAge() %> years</td>
                                <td>
                                    <span class="badge <%= p.getGender().equalsIgnoreCase("male") ? "bg-primary" : "bg-pink" %>">
                                        <i class="fas fa-<%= p.getGender().equalsIgnoreCase("male") ? "mars" : "venus" %> me-1"></i>
                                        <%= p.getGender() %>
                                    </span>
                                </td>
                                <td><i class="fas fa-map-marker-alt text-muted me-2"></i><%= p.getAddress() %></td>
                                <td><i class="fas fa-phone text-muted me-2"></i><%= p.getPhone() %></td>
                                <td>
                                    <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                                        <a href="editPatient.jsp?id=<%= p.getId() %>" class="btn btn-sm btn-warning me-1" title="Edit Patient">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="confirmDelete('patient', <%= p.getId() %>, 'DeletePatientServlet')" class="btn btn-sm btn-danger" title="Delete Patient">
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

<!-- Loading Spinner -->
<div id="loadingSpinner" class="loading-spinner">
    <div class="spinner-border text-success" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="script.js"></script>
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
.bg-pink {
    background-color: #e91e63 !important;
}
</style>
</body>
</html>





