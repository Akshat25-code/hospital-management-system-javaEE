<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Doctor,model.Patient,java.util.List" %>
<%
    // Check if data is loaded from servlet, if not redirect to servlet
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    
    if (doctors == null || patients == null) {
        response.sendRedirect("LoadAddAppointmentServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Appointment - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-calendar-check me-3"></i>Schedule New Appointment</h2>
            <p class="mb-0">Book an appointment between doctor and patient</p>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-plus-circle me-2"></i>Appointment Details</h5>
                    </div>
                    <div class="card-body">
                        <form action="AddAppointmentServlet" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-user-doctor me-2"></i>Select Doctor</label>
                                    <select name="doctorId" class="form-control" required>
                                        <option value="">Choose a doctor...</option>
                                        <% for (Doctor d : doctors) { %>
                                            <option value="<%= d.getId() %>">
                                                Dr. <%= d.getName() %> - <%= d.getSpecialization() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-bed-pulse me-2"></i>Select Patient</label>
                                    <select name="patientId" class="form-control" required>
                                        <option value="">Choose a patient...</option>
                                        <% for (Patient p : patients) { %>
                                            <option value="<%= p.getId() %>">
                                                <%= p.getName() %> (Age: <%= p.getAge() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-calendar me-2"></i>Appointment Date</label>
                                    <input type="date" name="date" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-clock me-2"></i>Appointment Time</label>
                                    <input type="time" name="time" class="form-control" required>
                                </div>
                                <div class="col-12 mb-3">
                                    <label class="form-label"><i class="fas fa-notes-medical me-2"></i>Reason for Visit</label>
                                    <textarea name="reason" class="form-control" rows="3" placeholder="Enter the reason for this appointment..." required></textarea>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="AppointmentListServlet" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Appointments
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-save me-2"></i>Schedule Appointment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="loadingSpinner" class="loading-spinner">
    <div class="spinner-border text-warning" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>





