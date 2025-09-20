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
    <title>Medical Records - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
        }
        .main-container {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            padding: 30px;
            margin-top: 20px;
        }
        .card {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .feature-card {
            text-align: center;
            padding: 30px 20px;
            height: 100%;
        }
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .btn-feature {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-feature:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .stats-card {
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .nav-pills .nav-link {
            border-radius: 25px;
            margin: 0 5px;
            transition: all 0.3s ease;
        }
        .nav-pills .nav-link.active {
            background: linear-gradient(45deg, #667eea, #764ba2);
        }
        .search-box {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            color: white;
            padding: 12px 20px;
        }
        .search-box::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }
        .search-box:focus {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.4);
            color: white;
            box-shadow: none;
        }
        .table-dark {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            overflow: hidden;
        }
        .record-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }
        .record-item:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        .vital-signs {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }
        .vital-sign {
            background: rgba(255, 255, 255, 0.1);
            padding: 10px;
            border-radius: 8px;
            text-align: center;
        }
        .medication-item {
            background: linear-gradient(45deg, rgba(40, 167, 69, 0.1), rgba(23, 162, 184, 0.1));
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="main-container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="text-white mb-1">
                    <i class="fas fa-file-medical me-3"></i>Medical Records Management
                </h2>
                <p class="text-light opacity-75 mb-0">Comprehensive patient medical information system</p>
            </div>
            <div>
                <a href="dashboard.jsp" class="btn btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addRecordModal">
                    <i class="fas fa-plus me-2"></i>New Record
                </button>
            </div>
        </div>

        <!-- Statistics Row -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-file-medical text-primary" style="font-size: 2.5rem;"></i>
                        <h3 class="text-white mt-2 mb-1">1,247</h3>
                        <p class="text-light mb-0">Total Records</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-calendar-day text-success" style="font-size: 2.5rem;"></i>
                        <h3 class="text-white mt-2 mb-1">23</h3>
                        <p class="text-light mb-0">Today's Records</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-prescription-bottle text-warning" style="font-size: 2.5rem;"></i>
                        <h3 class="text-white mt-2 mb-1">89</h3>
                        <p class="text-light mb-0">Active Prescriptions</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-flask text-info" style="font-size: 2.5rem;"></i>
                        <h3 class="text-white mt-2 mb-1">45</h3>
                        <p class="text-light mb-0">Pending Lab Tests</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <div class="input-group">
                            <input type="text" class="form-control search-box" placeholder="Search records..." id="searchInput">
                            <button class="btn btn-outline-light" type="button">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <ul class="nav nav-pills justify-content-end">
                            <li class="nav-item">
                                <a class="nav-link active" href="#" data-filter="all">All Records</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-filter="recent">Recent</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-filter="prescriptions">Prescriptions</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-filter="lab-tests">Lab Tests</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-filter="follow-up">Follow-up</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Medical Records Content -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-transparent">
                        <h5 class="text-white mb-0">
                            <i class="fas fa-history me-2"></i>Recent Medical Records
                        </h5>
                    </div>
                    <div class="card-body">
                        <!-- Sample Medical Record 1 -->
                        <div class="record-item">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h6 class="text-white mb-1">
                                        <i class="fas fa-user-injured me-2"></i>John Smith - ID: P001
                                    </h6>
                                    <small class="text-light opacity-75">
                                        <i class="fas fa-calendar me-1"></i>August 20, 2025 | 
                                        <i class="fas fa-user-md me-1"></i>Dr. Johnson (Cardiology)
                                    </small>
                                </div>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-light" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-info" title="Print">
                                        <i class="fas fa-print"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="text-light mb-2">
                                        <strong>Diagnosis:</strong> Hypertension, Stage 1
                                    </p>
                                    <p class="text-light mb-2">
                                        <strong>Symptoms:</strong> Elevated blood pressure, mild headaches
                                    </p>
                                    <p class="text-light mb-0">
                                        <strong>Treatment:</strong> Lifestyle modifications, ACE inhibitor therapy
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <div class="vital-signs">
                                        <div class="vital-sign">
                                            <div class="text-danger"><i class="fas fa-heartbeat"></i></div>
                                            <small class="text-light">BP: 145/92</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-success"><i class="fas fa-heart"></i></div>
                                            <small class="text-light">HR: 78</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-info"><i class="fas fa-thermometer-half"></i></div>
                                            <small class="text-light">98.6°F</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-warning"><i class="fas fa-weight"></i></div>
                                            <small class="text-light">185 lbs</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <span class="badge bg-danger me-2">Follow-up: Sept 20</span>
                                <span class="badge bg-success me-2">Prescription Active</span>
                                <span class="badge bg-warning">Lab Test Pending</span>
                            </div>
                        </div>

                        <!-- Sample Medical Record 2 -->
                        <div class="record-item">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h6 class="text-white mb-1">
                                        <i class="fas fa-user-injured me-2"></i>Sarah Davis - ID: P002
                                    </h6>
                                    <small class="text-light opacity-75">
                                        <i class="fas fa-calendar me-1"></i>August 19, 2025 | 
                                        <i class="fas fa-user-md me-1"></i>Dr. Williams (Neurology)
                                    </small>
                                </div>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-light" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-info" title="Print">
                                        <i class="fas fa-print"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="text-light mb-2">
                                        <strong>Diagnosis:</strong> Migraine without aura
                                    </p>
                                    <p class="text-light mb-2">
                                        <strong>Symptoms:</strong> Severe headache, photophobia, nausea
                                    </p>
                                    <p class="text-light mb-0">
                                        <strong>Treatment:</strong> Sumatriptan, lifestyle counseling
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <div class="vital-signs">
                                        <div class="vital-sign">
                                            <div class="text-success"><i class="fas fa-heartbeat"></i></div>
                                            <small class="text-light">BP: 118/75</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-success"><i class="fas fa-heart"></i></div>
                                            <small class="text-light">HR: 72</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-success"><i class="fas fa-thermometer-half"></i></div>
                                            <small class="text-light">98.4°F</small>
                                        </div>
                                        <div class="vital-sign">
                                            <div class="text-success"><i class="fas fa-weight"></i></div>
                                            <small class="text-light">142 lbs</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <span class="badge bg-info me-2">Follow-up: Sept 2</span>
                                <span class="badge bg-success">Treatment Complete</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <!-- Quick Actions -->
                <div class="card mb-4">
                    <div class="card-header bg-transparent">
                        <h6 class="text-white mb-0">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <button class="btn btn-feature" data-bs-toggle="modal" data-bs-target="#addRecordModal">
                                <i class="fas fa-plus me-2"></i>New Medical Record
                            </button>
                            <button class="btn btn-feature" data-bs-toggle="modal" data-bs-target="#prescriptionModal">
                                <i class="fas fa-prescription me-2"></i>New Prescription
                            </button>
                            <button class="btn btn-feature" data-bs-toggle="modal" data-bs-target="#labTestModal">
                                <i class="fas fa-flask me-2"></i>Order Lab Test
                            </button>
                            <button class="btn btn-outline-light">
                                <i class="fas fa-download me-2"></i>Export Reports
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Recent Prescriptions -->
                <div class="card">
                    <div class="card-header bg-transparent">
                        <h6 class="text-white mb-0">
                            <i class="fas fa-prescription-bottle me-2"></i>Active Prescriptions
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="medication-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-white mb-1">Lisinopril 10mg</h6>
                                    <small class="text-light">John Smith - Daily</small>
                                </div>
                                <span class="badge bg-success">Active</span>
                            </div>
                        </div>
                        
                        <div class="medication-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-white mb-1">Sumatriptan 50mg</h6>
                                    <small class="text-light">Sarah Davis - As needed</small>
                                </div>
                                <span class="badge bg-warning">Expiring</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Medical Record Modal -->
<div class="modal fade" id="addRecordModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark">
            <div class="modal-header border-0">
                <h5 class="modal-title text-white">
                    <i class="fas fa-file-medical me-2"></i>New Medical Record
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-light">Patient</label>
                            <select class="form-select">
                                <option>Select Patient</option>
                                <option>John Smith (P001)</option>
                                <option>Sarah Davis (P002)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-light">Visit Date</label>
                            <input type="date" class="form-control" value="2025-08-21">
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label text-light">Diagnosis</label>
                            <input type="text" class="form-control" placeholder="Primary diagnosis">
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label text-light">Symptoms</label>
                            <textarea class="form-control" rows="3" placeholder="Patient reported symptoms"></textarea>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label text-light">Treatment Plan</label>
                            <textarea class="form-control" rows="3" placeholder="Recommended treatment"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Save Record</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Filter functionality
    document.querySelectorAll('[data-filter]').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Update active state
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            // Filter records (implement actual filtering logic here)
            console.log('Filtering by:', this.dataset.filter);
        });
    });

    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        // Implement search logic here
        console.log('Searching for:', searchTerm);
    });
</script>
</body>
</html>





