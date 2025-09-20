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
                        <i class="fa-solid fa-clipboard-list icon-large text-info"></i>
                        <h5 class="card-title mt-3">User Activity Logs</h5>
                        <p class="card-text">Track all user actions for auditing and security</p>
                        <a href="admin/activity-logs.jsp" class="btn btn-info">
                            <i class="fa-solid fa-list"></i> View Logs
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-user-shield icon-large text-warning"></i>
                        <h5 class="card-title mt-3">Role Management</h5>
                        <p class="card-text">Assign and modify user roles and permissions</p>
                        <a href="admin/role-management.jsp" class="btn btn-warning">
                            <i class="fa-solid fa-user-cog"></i> Manage Roles
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-bullhorn icon-large text-success"></i>
                        <h5 class="card-title mt-3">System Announcements</h5>
                        <p class="card-text">Post announcements visible to all users on login</p>
                        <a href="admin/announcements.jsp" class="btn btn-success">
                            <i class="fa-solid fa-bullhorn"></i> Post Announcement
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-headset icon-large text-danger"></i>
                        <h5 class="card-title mt-3">User Feedback & Support</h5>
                        <p class="card-text">View user feedback and provide support</p>
                        <a href="admin/feedback.jsp" class="btn btn-danger">
                            <i class="fa-solid fa-comments"></i> View Feedback
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-file-medical icon-large text-success"></i>
                        <h5 class="card-title mt-3">Medical Records</h5>
                        <p class="card-text">Patient medical history and records</p>
                        <a href="medical-records.jsp" class="btn btn-success">
                            <i class="fa-solid fa-arrow-right"></i> View Records
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
        </div>
        
        <!-- Second Row of Admin Cards -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-flask icon-large text-primary"></i>
                        <h5 class="card-title mt-3">Lab Tests</h5>
                        <p class="card-text">Laboratory tests and results management</p>
                        <a href="lab-tests.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View Lab Tests
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-chart-line icon-large text-success"></i>
                        <h5 class="card-title mt-3">Analytics</h5>
                        <p class="card-text">Hospital performance and analytics</p>
                        <a href="analytics.jsp" class="btn btn-success">
                            <i class="fa-solid fa-arrow-right"></i> View Analytics
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-cog icon-large text-secondary"></i>
                        <h5 class="card-title mt-3">System Settings</h5>
                        <p class="card-text">Configure system preferences</p>
                        <a href="settings.jsp" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-right"></i> Settings
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
                        <button class="btn btn-secondary" onclick="window.location.href='patient/my-appointments.jsp'">
                            <i class="fa-solid fa-calendar-check"></i> View Appointments
                        </button>
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
            <!-- My Patients Section with all patient management tools -->
            <div class="col-md-12 mb-4">
                <div class="card dashboard-card">
                    <div class="card-header text-center bg-success text-white">
                        <h4><i class="fa-solid fa-bed-pulse me-2"></i>My Patients Management</h4>
                        <p class="mb-0">All tools to manage your patients</p>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="text-center p-3 border rounded h-100">
                                    <i class="fa-solid fa-users icon-large text-success mb-2"></i>
                                    <h6>View Patients</h6>
                                    <a href="PatientListServlet" class="btn btn-success btn-sm">
                                        <i class="fa-solid fa-arrow-right"></i> View All
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 border rounded h-100">
                                    <i class="fa-solid fa-file-prescription icon-large text-warning mb-2"></i>
                                    <h6>E-Prescription</h6>
                                    <a href="doctor/e-prescription" class="btn btn-warning btn-sm">
                                        <i class="fa-solid fa-prescription"></i> Create
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 border rounded h-100">
                                    <i class="fa-solid fa-video icon-large text-danger mb-2"></i>
                                    <h6>Video Call</h6>
                                    <a href="doctor/video-call.jsp" class="btn btn-danger btn-sm">
                                        <i class="fa-solid fa-video"></i> Start Call
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 border rounded h-100">
                                    <i class="fa-solid fa-clipboard-list icon-large text-info mb-2"></i>
                                    <h6>Notes Templates</h6>
                                    <a href="doctor/notes-templates.jsp" class="btn btn-info btn-sm">
                                        <i class="fa-solid fa-clipboard"></i> Manage
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-calendar-check icon-large text-primary"></i>
                        <h5 class="card-title mt-3">My Appointments</h5>
                        <p class="card-text">View your scheduled appointments</p>
                        <a href="doctor/my-appointments" class="btn btn-primary">
                            <i class="fa-solid fa-calendar-check"></i> View My Appointments
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-notes-medical icon-large text-info"></i>
                        <h5 class="card-title mt-3">Patient History Viewer</h5>
                        <p class="card-text">Quickly access a patient's full medical and appointment history</p>
                        <a href="doctor/patient-history.jsp" class="btn btn-info">
                            <i class="fa-solid fa-user-clock"></i> View History
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
                        <button class="btn btn-primary" onclick="window.location.href='patient/my-appointments.jsp'">
                            <i class="fa-solid fa-history"></i> View History
                        </button>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-file-medical icon-large text-warning"></i>
                        <h5 class="card-title mt-3">Download Medical Reports</h5>
                        <p class="card-text">Access and download your lab results and prescriptions</p>
                        <a href="patient/medical-reports.jsp" class="btn btn-warning">
                            <i class="fa-solid fa-download"></i> Download Reports
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-prescription icon-large text-info"></i>
                        <h5 class="card-title mt-3">My E-Prescriptions</h5>
                        <p class="card-text">View digital prescriptions from your doctors</p>
                        <a href="patient/my-prescriptions" class="btn btn-info">
                            <i class="fa-solid fa-file-prescription"></i> View Prescriptions
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-pills icon-large text-danger"></i>
                        <h5 class="card-title mt-3">Prescription Refill</h5>
                        <p class="card-text">Request a refill for your active prescriptions</p>
                        <a href="patient/prescription-refill.jsp" class="btn btn-danger">
                            <i class="fa-solid fa-capsules"></i> Request Refill
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-heartbeat icon-large text-pink"></i>
                        <h5 class="card-title mt-3">Health Timeline</h5>
                        <p class="card-text">Visualize your appointments, lab tests, and treatments</p>
                        <a href="patient/health-timeline.jsp" class="btn btn-pink" style="background:#e75480;color:white;">
                            <i class="fa-solid fa-chart-line"></i> View Timeline
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
                        <a href="AppointmentListServlet" class="btn btn-primary">
                            <i class="fa-solid fa-arrow-right"></i> View Appointments
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-tasks icon-large text-warning"></i>
                        <h5 class="card-title mt-3">Task Assignment</h5>
                        <p class="card-text">Assign and track daily tasks (e.g., check-ins, vitals)</p>
                        <a href="assistant/tasks.jsp" class="btn btn-warning">
                            <i class="fa-solid fa-tasks"></i> Manage Tasks
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-users icon-large text-info"></i>
                        <h5 class="card-title mt-3">Patient Queue</h5>
                        <p class="card-text">View and manage the waiting list for doctors</p>
                        <a href="assistant/queue.jsp" class="btn btn-info">
                            <i class="fa-solid fa-list-ol"></i> View Queue
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-boxes-stacked icon-large text-danger"></i>
                        <h5 class="card-title mt-3">Inventory Alerts</h5>
                        <p class="card-text">Get notified when medicine or supply stock is low</p>
                        <a href="assistant/inventory-alerts.jsp" class="btn btn-danger">
                            <i class="fa-solid fa-bell"></i> View Alerts
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card nav-card text-center h-100">
                    <div class="card-body">
                        <i class="fa-solid fa-heart-pulse icon-large text-pink"></i>
                        <h5 class="card-title mt-3">Vitals Entry</h5>
                        <p class="card-text">Enter and update patient vital signs in real time</p>
                        <a href="assistant/vitals.jsp" class="btn btn-pink" style="background:#e75480;color:white;">
                            <i class="fa-solid fa-heart-pulse"></i> Enter Vitals
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





