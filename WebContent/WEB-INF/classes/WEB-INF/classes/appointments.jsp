<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,model.Appointment,java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Check if data is loaded from servlet, if not redirect to servlet
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    Map<Integer, String> doctorNames = (Map<Integer, String>) request.getAttribute("doctorNames");
    Map<Integer, String> patientNames = (Map<Integer, String>) request.getAttribute("patientNames");
    
    if (appointments == null || doctorNames == null || patientNames == null) {
        response.sendRedirect("AppointmentListServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointments - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-calendar-check me-3"></i>Appointments Management</h2>
            <p class="mb-0">Schedule and manage patient appointments</p>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <% model.User user = (model.User) session.getAttribute("user"); %>
                <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                    <a href="LoadAddAppointmentServlet" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Appointment
                    </a>
                <% } %>
            </div>
            <div>
                <button onclick="exportToCSV('appointmentsTable', 'appointments')" class="btn btn-success me-2">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
                <button onclick="printTable('appointmentsTable')" class="btn btn-info">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body p-0">
                <table id="appointmentsTable" class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-2"></i>ID</th>
                            <th><i class="fas fa-user-doctor me-2"></i>Doctor</th>
                            <th><i class="fas fa-bed-pulse me-2"></i>Patient</th>
                            <th><i class="fas fa-calendar me-2"></i>Date</th>
                            <th><i class="fas fa-clock me-2"></i>Time</th>
                            <th><i class="fas fa-notes-medical me-2"></i>Reason</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Appointment a : appointments) { %>
                            <tr>
                                <td><span class="badge bg-secondary"><%= a.getId() %></span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-primary text-white me-3">
                                            <i class="fas fa-user-doctor"></i>
                                        </div>
                                        <strong><%= doctorNames.get(a.getDoctorId()) %></strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-success text-white me-3">
                                            <i class="fas fa-bed-pulse"></i>
                                        </div>
                                        <strong><%= patientNames.get(a.getPatientId()) %></strong>
                                    </div>
                                </td>
                                <td><i class="fas fa-calendar text-muted me-2"></i><%= a.getDate() %></td>
                                <td><span class="badge bg-info"><%= a.getTime() %></span></td>
                                <td><%= a.getReason() %></td>
                                <td>
                                    <% if (user != null && (user.getRole().equals("admin") || user.getRole().equals("doctor"))) { %>
                                        <a href="LoadEditAppointmentServlet?id=<%= a.getId() %>" class="btn btn-sm btn-warning me-1">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="confirmDelete('appointment', <%= a.getId() %>, 'DeleteAppointmentServlet')" class="btn btn-sm btn-danger">
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
    <div class="spinner-border text-secondary" role="status">
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





