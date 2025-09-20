<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="dao.DoctorDAO, dao.PatientDAO, model.Doctor, model.Patient, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("patient")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Doctor> doctors = null;
    Patient patient = null;
    String errorMessage = null;
    
    try {
        // Load doctors from DB
        DoctorDAO doctorDAO = new DoctorDAO();
        doctors = doctorDAO.getAllDoctors();
        
        // Get patient record for the logged-in user
        PatientDAO patientDAO = new PatientDAO();
        patient = patientDAO.getPatientByUserId(user.getId());
        
        if (patient == null) {
            errorMessage = "Patient record not found for user: " + user.getUsername() + " (ID: " + user.getId() + ")";
        }
        
    } catch (Exception e) {
        errorMessage = "Database connection error: " + e.getMessage();
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4><i class="fas fa-calendar-plus me-2"></i>Book New Appointment</h4>
                    <a href="../dashboard.jsp" class="btn btn-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                    </a>
                </div>
                <div class="card-body">
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger">
                            <h5>Error Loading Appointment Form</h5>
                            <p><%= errorMessage %></p>
                            <p>Please try again or contact the administrator.</p>
                        </div>
                    <% } else { %>
                    <form action="../AddAppointmentServlet" method="post">
                        <!-- Hidden field for patientId - use actual patient table ID -->
                        <input type="hidden" name="patientId" value="<%= patient.getId() %>" />
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="doctorId" class="form-label">Doctor</label>
                                <select class="form-select" id="doctorId" name="doctorId" required>
                                    <option value="">Select a Doctor</option>
                                    <% if (doctors != null) { %>
                                        <% for (Doctor d : doctors) { %>
                                            <option value="<%= d.getId() %>"><%= d.getName() %> - <%= d.getSpecialization() %></option>
                                        <% } %>
                                    <% } else { %>
                                        <option value="">No doctors available</option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="date" class="form-label">Appointment Date</label>
                                <input type="date" class="form-control" id="date" name="date" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="time" class="form-label">Appointment Time</label>
                                <select class="form-select" id="time" name="time" required>
                                    <option value="">Select Time</option>
                                    <option value="09:00">09:00 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="14:00">02:00 PM</option>
                                    <option value="15:00">03:00 PM</option>
                                    <option value="16:00">04:00 PM</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="priority" class="form-label">Priority</label>
                                <select class="form-select" id="priority" name="priority">
                                    <option value="Normal">Normal</option>
                                    <option value="Urgent">Urgent</option>
                                    <option value="Emergency">Emergency</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reason" class="form-label">Reason for Visit</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" 
                                    placeholder="Please describe your symptoms or reason for the appointment..." required></textarea>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-calendar-check me-2"></i>Book Appointment
                            </button>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set minimum date to today
    document.getElementById('date').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>





