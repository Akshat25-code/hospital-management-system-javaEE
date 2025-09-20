<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="dao.AppointmentDAO, model.Appointment, dao.DoctorDAO, model.Doctor, dao.PatientDAO, model.Patient, java.util.List, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("patient")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Get the patient record for this user
    PatientDAO patientDAO = new PatientDAO();
    Patient currentPatient = patientDAO.getPatientByUserId(user.getId());
    
    if (currentPatient == null) {
        response.sendRedirect("../error.jsp");
        return;
    }

    // Load appointments for this patient
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    DoctorDAO doctorDAO = new DoctorDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(currentPatient.getId());
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Appointments - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4><i class="fas fa-calendar-alt me-2"></i>My Appointments</h4>
                    <div>
                        <a href="book-appointment.jsp" class="btn btn-primary btn-sm me-2">
                            <i class="fas fa-calendar-plus me-1"></i>Book New
                        </a>
                        <a href="../dashboard.jsp" class="btn btn-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Doctor</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (appointments.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted">
                                        <em>No appointments found. Book a new appointment to see it here.</em>
                                    </td>
                                </tr>
                            <% } else {
                               for (Appointment a : appointments) {
                                   Doctor doc = doctorDAO.getDoctorById(a.getDoctorId());
                            %>
                                <tr>
                                    <td><%= dateFormat.format(a.getDate()) %></td>
                                    <td><%= a.getTime() %></td>
                                    <td><%= doc != null ? doc.getName() + " - " + doc.getSpecialization() : "Unknown" %></td>
                                    <td><%= a.getReason() %></td>
                                    <td><span class="badge bg-warning">Pending</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-info" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <a href="../DeleteAppointmentServlet?id=<%= a.getId() %>&from=patient" class="btn btn-sm btn-danger" title="Cancel" onclick="return confirm('Are you sure you want to cancel this appointment?');">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </td>
                                </tr>
                            <%   }
                               } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>





