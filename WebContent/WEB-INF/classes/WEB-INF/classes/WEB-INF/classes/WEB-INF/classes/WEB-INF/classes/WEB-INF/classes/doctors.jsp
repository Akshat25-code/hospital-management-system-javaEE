<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,model.Doctor" %>
<%
    // Check if data is loaded from servlet, if not redirect to servlet
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    if (doctors == null) {
        response.sendRedirect("DoctorListServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Doctors - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-user-doctor me-3"></i>Doctors Management</h2>
            <p class="mb-0">Manage hospital doctors and their information</p>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <% model.User user = (model.User) session.getAttribute("user"); %>
                <% if (user != null && user.getRole().equals("admin")) { %>
                    <a href="addDoctor.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Doctor
                    </a>
                <% } %>
            </div>
            <div>
                <button onclick="exportToCSV('doctorsTable', 'doctors')" class="btn btn-success me-2">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
                <button onclick="printTable('doctorsTable')" class="btn btn-info">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body p-0">
                <table id="doctorsTable" class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-2"></i>ID</th>
                            <th><i class="fas fa-user me-2"></i>Name</th>
                            <th><i class="fas fa-stethoscope me-2"></i>Specialization</th>
                            <th><i class="fas fa-envelope me-2"></i>Email</th>
                            <th><i class="fas fa-phone me-2"></i>Phone</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Doctor d : doctors) { %>
                            <tr>
                                <td><span class="badge bg-primary"><%= d.getId() %></span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-primary text-white me-3">
                                            <%= d.getName().substring(0,1).toUpperCase() %>
                                        </div>
                                        <strong><%= d.getName() %></strong>
                                    </div>
                                </td>
                                <td><span class="badge bg-info"><%= d.getSpecialization() %></span></td>
                                <td><i class="fas fa-envelope text-muted me-2"></i><%= d.getEmail() %></td>
                                <td><i class="fas fa-phone text-muted me-2"></i><%= d.getPhone() %></td>
                                <td>
                                    <% if (user != null && user.getRole().equals("admin")) { %>
                                        <a href="editDoctor.jsp?id=<%= d.getId() %>" class="btn btn-sm btn-warning me-1">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="confirmDelete('doctor', <%= d.getId() %>, 'DeleteDoctorServlet')" class="btn btn-sm btn-danger">
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
    <div class="spinner-border text-primary" role="status">
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
</style>
</body>
</html>





