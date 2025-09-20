<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .dashboard-card {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: white;
        }
        .welcome-header {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }
        .nav-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .nav-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .icon-large {
            font-size: 3rem;
            opacity: 0.8;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <!-- Welcome Header -->
    <div class="welcome-header text-center">
        <h1><i class="fa-solid fa-hospital"></i> Hospital Management System</h1>
        <h3>Welcome, <%= user.getUsername() %>!</h3>
        <span class="badge bg-primary fs-6">Role: <%= user.getRole().toUpperCase() %></span>
        <div class="mt-3">
            <a href="login.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <!-- Role-based Navigation -->
    <div class="row g-4">
        <% if ("admin".equals(user.getRole())) { %>
            <!-- Admin Dashboard -->
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-user-doctor icon-large text-primary"></i>
                        <h5 class="card-title mt-3">Manage Doctors</h5>
                        <p class="card-text">View, add, and manage doctor profiles</p>
                        <a href="doctors.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View Doctors
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-bed-pulse icon-large text-success"></i>
                        <h5 class="card-title mt-3">Manage Patients</h5>
                        <p class="card-text">View, add, and manage patient records</p>
                        <a href="patients.jsp" class="btn btn-success">
                            <i class="fa-solid fa-arrow-right"></i> View Patients
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-pills icon-large text-warning"></i>
                        <h5 class="card-title mt-3">Manage Medicines</h5>
                        <p class="card-text">Inventory and medicine management</p>
                        <a href="medicines.jsp" class="btn btn-warning">
                            <i class="fa-solid fa-arrow-right"></i> View Medicines
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-user-nurse icon-large text-info"></i>
                        <h5 class="card-title mt-3">Manage Assistants</h5>
                        <p class="card-text">View and manage nursing staff</p>
                        <a href="assistants.jsp" class="btn btn-info">
                            <i class="fa-solid fa-arrow-right"></i> View Assistants
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-calendar-check icon-large text-secondary"></i>
                        <h5 class="card-title mt-3">Appointments</h5>
                        <p class="card-text">View and manage all appointments</p>
                        <a href="appointments.jsp" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-right"></i> View Appointments
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-prescription-bottle-medical icon-large text-danger"></i>
                        <h5 class="card-title mt-3">Prescriptions</h5>
                        <p class="card-text">View and manage prescriptions</p>
                        <a href="prescriptions.jsp" class="btn btn-danger">
                            <i class="fa-solid fa-arrow-right"></i> View Prescriptions
                        </a>
                    </div>
                </div>
            </div>
        <% } else if ("doctor".equals(user.getRole())) { %>
            <!-- Doctor Dashboard -->
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-bed-pulse icon-large text-success"></i>
                        <h5 class="card-title mt-3">My Patients</h5>
                        <p class="card-text">View and manage your patients</p>
                        <a href="patients.jsp" class="btn btn-success">
                            <i class="fa-solid fa-arrow-right"></i> View Patients
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-calendar-check icon-large text-primary"></i>
                        <h5 class="card-title mt-3">My Appointments</h5>
                        <p class="card-text">View your scheduled appointments</p>
                        <a href="appointments.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View Appointments
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-prescription-bottle-medical icon-large text-warning"></i>
                        <h5 class="card-title mt-3">Prescriptions</h5>
                        <p class="card-text">Create and manage patient prescriptions</p>
                        <a href="prescriptions.jsp" class="btn btn-warning">
                            <i class="fa-solid fa-arrow-right"></i> Manage Prescriptions
                        </a>
                    </div>
                </div>
            </div>
        <% } else if ("patient".equals(user.getRole())) { %>
            <!-- Patient Dashboard -->
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-calendar-plus icon-large text-success"></i>
                        <h5 class="card-title mt-3">Book Appointment</h5>
                        <p class="card-text">Schedule a new appointment with a doctor</p>
                        <a href="patient/book-appointment.jsp" class="btn btn-success">
                            <i class="fa-solid fa-plus"></i> Book Now
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-history icon-large text-primary"></i>
                        <h5 class="card-title mt-3">My Appointments</h5>
                        <p class="card-text">View your appointment history</p>
                        <a href="patient/my-appointments.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View History
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-user-circle icon-large text-info"></i>
                        <h5 class="card-title mt-3">My Profile</h5>
                        <p class="card-text">Update your personal information and medical details</p>
                        <a href="patient/profile.jsp" class="btn btn-info">
                            <i class="fa-solid fa-edit"></i> Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        <% } else if ("assistant".equals(user.getRole())) { %>
            <!-- Assistant Dashboard -->
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-bed-pulse icon-large text-success"></i>
                        <h5 class="card-title mt-3">Patients</h5>
                        <p class="card-text">View and assist with patient records</p>
                        <a href="patients.jsp" class="btn btn-success">
                            <i class="fa-solid fa-arrow-right"></i> View Patients
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-calendar-check icon-large text-primary"></i>
                        <h5 class="card-title mt-3">Appointments</h5>
                        <p class="card-text">Help manage appointments</p>
                        <a href="appointments.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View Appointments
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Quick Stats for Admin -->
    <% if ("admin".equals(user.getRole())) { %>
    <div class="row mt-5">
        <div class="col-12">
            <div class="welcome-header">
                <h4><i class="fa-solid fa-chart-bar"></i> Quick Statistics</h4>
                <div class="row text-center mt-4">
                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fa-solid fa-user-doctor text-primary" style="font-size: 2rem;"></i>
                                <h3 class="mt-2">15</h3>
                                <p>Doctors</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fa-solid fa-bed-pulse text-success" style="font-size: 2rem;"></i>
                                <h3 class="mt-2">128</h3>
                                <p>Patients</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fa-solid fa-calendar-check text-warning" style="font-size: 2rem;"></i>
                                <h3 class="mt-2">23</h3>
                                <p>Appointments</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fa-solid fa-prescription-bottle-medical text-danger" style="font-size: 2rem;"></i>
                                <h3 class="mt-2">47</h3>
                                <p>Prescriptions</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>





