<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>🧪 CRUD Testing Center - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
        }
        .test-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
            max-width: 1200px;
        }
        .feature-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin: 15px 0;
            transition: transform 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .btn-test {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 10px;
            padding: 10px 20px;
            margin: 5px;
            transition: all 0.3s ease;
        }
        .btn-test:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            color: white;
        }
        .test-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="text-center mb-4">
            <h1 class="display-4">🧪 CRUD Testing Center</h1>
            <p class="lead">Test all Create, Read, Update, Delete operations through the web interface</p>
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                <strong>Login Status:</strong> 
                <% 
                model.User user = (model.User) session.getAttribute("user");
                if (user != null) {
                    out.println("✅ Logged in as <strong>" + user.getUsername() + "</strong> (" + user.getRole() + ")");
                } else {
                    out.println("❌ Not logged in - <a href='login.jsp'>Please login first</a>");
                }
                %>
            </div>
        </div>

        <!-- PATIENT CRUD TESTING -->
        <div class="feature-card">
            <h3><i class="fas fa-user-injured me-3"></i>Patient Management CRUD</h3>
            <p>Test complete patient lifecycle: Create, View, Update, Delete</p>
            
            <div class="row">
                <div class="col-md-3">
                    <h5>📝 CREATE</h5>
                    <a href="addPatient.jsp" class="btn btn-test w-100">
                        <i class="fas fa-plus me-2"></i>Add New Patient
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>👁️ READ</h5>
                    <a href="PatientListServlet" class="btn btn-test w-100">
                        <i class="fas fa-list me-2"></i>View All Patients
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>✏️ UPDATE</h5>
                    <a href="PatientListServlet" class="btn btn-test w-100">
                        <i class="fas fa-edit me-2"></i>Edit Patients
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>🗑️ DELETE</h5>
                    <a href="PatientListServlet" class="btn btn-test w-100">
                        <i class="fas fa-trash me-2"></i>Delete Patients
                    </a>
                </div>
            </div>
        </div>

        <!-- DOCTOR CRUD TESTING -->
        <div class="feature-card">
            <h3><i class="fas fa-user-md me-3"></i>Doctor Management CRUD</h3>
            <p>Test complete doctor lifecycle: Create, View, Update, Delete</p>
            
            <div class="row">
                <div class="col-md-3">
                    <h5>📝 CREATE</h5>
                    <a href="addDoctor.jsp" class="btn btn-test w-100">
                        <i class="fas fa-plus me-2"></i>Add New Doctor
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>👁️ READ</h5>
                    <a href="DoctorListServlet" class="btn btn-test w-100">
                        <i class="fas fa-list me-2"></i>View All Doctors
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>✏️ UPDATE</h5>
                    <a href="DoctorListServlet" class="btn btn-test w-100">
                        <i class="fas fa-edit me-2"></i>Edit Doctors
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>🗑️ DELETE</h5>
                    <a href="DoctorListServlet" class="btn btn-test w-100">
                        <i class="fas fa-trash me-2"></i>Delete Doctors
                    </a>
                </div>
            </div>
        </div>

        <!-- APPOINTMENT CRUD TESTING -->
        <div class="feature-card">
            <h3><i class="fas fa-calendar-check me-3"></i>Appointment Management CRUD</h3>
            <p>Test appointment booking, viewing, updating, and cancellation</p>
            
            <div class="row">
                <div class="col-md-3">
                    <h5>📝 CREATE</h5>
                    <a href="addAppointment.jsp" class="btn btn-test w-100">
                        <i class="fas fa-plus me-2"></i>Book Appointment
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>👁️ READ</h5>
                    <a href="AppointmentListServlet" class="btn btn-test w-100">
                        <i class="fas fa-list me-2"></i>View Appointments
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>✏️ UPDATE</h5>
                    <a href="AppointmentListServlet" class="btn btn-test w-100">
                        <i class="fas fa-edit me-2"></i>Modify Appointments
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>🗑️ DELETE</h5>
                    <a href="AppointmentListServlet" class="btn btn-test w-100">
                        <i class="fas fa-trash me-2"></i>Cancel Appointments
                    </a>
                </div>
            </div>
        </div>

        <!-- MEDICINE CRUD TESTING -->
        <div class="feature-card">
            <h3><i class="fas fa-pills me-3"></i>Medicine Management CRUD</h3>
            <p>Test medicine inventory: Add, View, Update, Remove medicines</p>
            
            <div class="row">
                <div class="col-md-3">
                    <h5>📝 CREATE</h5>
                    <a href="addMedicine.jsp" class="btn btn-test w-100">
                        <i class="fas fa-plus me-2"></i>Add Medicine
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>👁️ READ</h5>
                    <a href="MedicineListServlet" class="btn btn-test w-100">
                        <i class="fas fa-list me-2"></i>View Medicines
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>✏️ UPDATE</h5>
                    <a href="MedicineListServlet" class="btn btn-test w-100">
                        <i class="fas fa-edit me-2"></i>Update Inventory
                    </a>
                </div>
                <div class="col-md-3">
                    <h5>🗑️ DELETE</h5>
                    <a href="MedicineListServlet" class="btn btn-test w-100">
                        <i class="fas fa-trash me-2"></i>Remove Medicine
                    </a>
                </div>
            </div>
        </div>

        <!-- TESTING INSTRUCTIONS -->
        <div class="test-section">
            <h4><i class="fas fa-clipboard-check me-3"></i>Testing Instructions</h4>
            
            <div class="row">
                <div class="col-md-6">
                    <h5>🎯 Test Scenarios:</h5>
                    <ol>
                        <li><strong>Create Patient:</strong> Add a new patient with all required fields</li>
                        <li><strong>View Patients:</strong> Verify the new patient appears in the list</li>
                        <li><strong>Edit Patient:</strong> Update patient information</li>
                        <li><strong>Delete Patient:</strong> Remove a patient record</li>
                        <li><strong>Repeat for Doctors:</strong> Same CRUD operations for doctors</li>
                        <li><strong>Test Appointments:</strong> Book appointments between patients and doctors</li>
                        <li><strong>Test Medicines:</strong> Manage medicine inventory</li>
                    </ol>
                </div>
                
                <div class="col-md-6">
                    <h5>✅ Verification Points:</h5>
                    <ul>
                        <li>Forms should validate input properly</li>
                        <li>Success messages should appear after operations</li>
                        <li>Data should persist in the database</li>
                        <li>Lists should update immediately</li>
                        <li>Delete confirmations should work</li>
                        <li>Navigation should be smooth</li>
                        <li>Role permissions should be respected</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- SAMPLE DATA FOR TESTING -->
        <div class="test-section">
            <h4><i class="fas fa-database me-3"></i>Sample Data for Testing</h4>
            
            <div class="row">
                <div class="col-md-6">
                    <h5>👥 Sample Patient Data:</h5>
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <tr><th>Name</th><td>John Smith</td></tr>
                            <tr><th>Age</th><td>35</td></tr>
                            <tr><th>Gender</th><td>Male</td></tr>
                            <tr><th>Address</th><td>123 Main St, City</td></tr>
                            <tr><th>Phone</th><td>555-0123</td></tr>
                        </table>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <h5>👨‍⚕️ Sample Doctor Data:</h5>
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <tr><th>Name</th><td>Dr. Sarah Johnson</td></tr>
                            <tr><th>Specialization</th><td>Internal Medicine</td></tr>
                            <tr><th>Email</th><td>sarah.johnson@hospital.com</td></tr>
                            <tr><th>Phone</th><td>555-0456</td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- QUICK LINKS -->
        <div class="text-center">
            <h4>🔗 Quick Navigation</h4>
            <a href="dashboard.jsp" class="btn btn-primary me-2">
                <i class="fas fa-home me-2"></i>Dashboard
            </a>
            <a href="doctor-test.jsp" class="btn btn-info me-2">
                <i class="fas fa-stethoscope me-2"></i>Doctor Test Page
            </a>
            <a href="test-db-connection.jsp" class="btn btn-success me-2">
                <i class="fas fa-database me-2"></i>DB Connection Test
            </a>
            <a href="logout" class="btn btn-outline-secondary">
                <i class="fas fa-sign-out-alt me-2"></i>Logout
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
