<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Appointment, model.Doctor, java.util.List, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String warningMessage = (String) request.getAttribute("warningMessage");
    List<Appointment> existingAppointments = (List<Appointment>) request.getAttribute("existingAppointments");
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    String doctorId = (String) request.getAttribute("doctorId");
    String date = (String) request.getAttribute("date");
    String time = (String) request.getAttribute("time");
    String reason = (String) request.getAttribute("reason");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Appointment - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .warning-card {
            border-left: 4px solid #ffc107;
            background-color: #fff3cd;
        }
        .existing-appointment {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 10px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card warning-card">
                <div class="card-header">
                    <h4><i class="fas fa-exclamation-triangle text-warning me-2"></i>Appointment Conflict Warning</h4>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning">
                        <strong><%= warningMessage %></strong>
                    </div>
                    
                    <h5>Your Existing Appointments on <%= date %>:</h5>
                    <% if (existingAppointments != null) {
                        for (Appointment apt : existingAppointments) { %>
                        <div class="existing-appointment">
                            <i class="fas fa-clock text-primary"></i>
                            <strong>Time:</strong> <%= apt.getTime() %> |
                            <i class="fas fa-user-md text-success"></i>
                            <strong>Reason:</strong> <%= apt.getReason() %>
                        </div>
                    <% }
                    } %>
                    
                    <hr>
                    
                    <h5>New Appointment Details:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <p><i class="fas fa-user-md text-primary"></i> <strong>Doctor:</strong> <%= doctor != null ? doctor.getName() : "Unknown" %></p>
                            <p><i class="fas fa-stethoscope text-info"></i> <strong>Specialization:</strong> <%= doctor != null ? doctor.getSpecialization() : "Unknown" %></p>
                        </div>
                        <div class="col-md-6">
                            <p><i class="fas fa-calendar text-success"></i> <strong>Date:</strong> <%= date %></p>
                            <p><i class="fas fa-clock text-warning"></i> <strong>Time:</strong> <%= time %></p>
                            <p><i class="fas fa-notes-medical text-secondary"></i> <strong>Reason:</strong> <%= reason %></p>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <form method="post" action="AddAppointmentServlet" class="d-inline">
                            <input type="hidden" name="doctorId" value="<%= doctorId %>">
                            <input type="hidden" name="date" value="<%= date %>">
                            <input type="hidden" name="time" value="<%= time %>">
                            <input type="hidden" name="reason" value="<%= reason %>">
                            <input type="hidden" name="confirmMultiple" value="yes">
                            <button type="submit" class="btn btn-warning btn-lg me-3">
                                <i class="fas fa-check me-2"></i>Yes, Book Anyway
                            </button>
                        </form>
                        
                        <a href="addAppointment.jsp" class="btn btn-secondary btn-lg">
                            <i class="fas fa-times me-2"></i>Cancel & Choose Different Time
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
