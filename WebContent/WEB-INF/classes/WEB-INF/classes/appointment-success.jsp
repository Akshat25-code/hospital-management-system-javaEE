<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Appointment, model.Doctor, dao.DoctorDAO, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get appointment details from request attributes (set by AddAppointmentServlet)
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    String patientName = (String) request.getAttribute("patientName");
    
    if (appointment == null) {
        response.sendRedirect("patient/book-appointment.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM dd, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Confirmed - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Arial', sans-serif;
        }
        .success-container {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            margin-top: 50px;
            text-align: center;
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 20px;
            animation: bounce 1s ease-in-out;
        }
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        .appointment-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin: 30px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            opacity: 0.9;
        }
        .detail-value {
            font-weight: 500;
        }
        .reminder-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            margin: 10px;
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="success-container">
                <!-- Success Icon and Title -->
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 class="text-success mb-3">🎉 Appointment Successfully Booked!</h2>
                <p class="lead text-muted">
                    Great news, <strong><%= patientName %></strong>! Your appointment has been confirmed and saved to our system.
                </p>
                
                <!-- Appointment Details Card -->
                <div class="appointment-card">
                    <h4 class="mb-4"><i class="fas fa-calendar-check me-2"></i>Your Appointment Details</h4>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-user-md me-2"></i>Doctor:</span>
                        <span class="detail-value"><%= doctor != null ? doctor.getName() : "Unknown Doctor" %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-stethoscope me-2"></i>Specialization:</span>
                        <span class="detail-value"><%= doctor != null ? doctor.getSpecialization() : "N/A" %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-calendar me-2"></i>Date:</span>
                        <span class="detail-value"><%= dateFormat.format(appointment.getDate()) %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-clock me-2"></i>Time:</span>
                        <span class="detail-value"><%= appointment.getTime() %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-notes-medical me-2"></i>Reason:</span>
                        <span class="detail-value"><%= appointment.getReason() %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-hashtag me-2"></i>Appointment ID:</span>
                        <span class="detail-value">#<%= appointment.getId() %></span>
                    </div>
                </div>
                
                <!-- Important Reminder -->
                <div class="reminder-box">
                    <h5 class="text-warning mb-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>Important Reminder
                    </h5>
                    <p class="mb-2">
                        <strong>⏰ Please don't be late!</strong> Arrive 15 minutes before your scheduled time.
                    </p>
                    <p class="mb-2">
                        📱 Bring a valid ID and your insurance card (if applicable).
                    </p>
                    <p class="mb-0">
                        📞 If you need to reschedule or cancel, please contact us at least 24 hours in advance.
                    </p>
                </div>
                
                <!-- Action Buttons -->
                <div class="mt-4">
                    <a href="patient/my-appointments.jsp" class="btn btn-primary btn-custom">
                        <i class="fas fa-list me-2"></i>View My Appointments
                    </a>
                    <a href="patient/book-appointment.jsp" class="btn btn-success btn-custom">
                        <i class="fas fa-plus me-2"></i>Book Another Appointment
                    </a>
                    <a href="dashboard.jsp" class="btn btn-secondary btn-custom">
                        <i class="fas fa-home me-2"></i>Go to Dashboard
                    </a>
                </div>
                
                <!-- Additional Info -->
                <div class="mt-4 text-muted">
                    <small>
                        <i class="fas fa-info-circle me-1"></i>
                        Your appointment has been saved to the database. You will receive a confirmation email shortly.
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-scroll to top
    window.scrollTo(0, 0);
    
    // Optional: Auto-redirect after 30 seconds
    setTimeout(function() {
        if (confirm("Would you like to go back to your appointments list?")) {
            window.location.href = "patient/my-appointments.jsp";
        }
    }, 30000);
</script>
</body>
</html>
