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
    <title>Laboratory Tests - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
        .test-card {
            border-left: 4px solid;
            transition: all 0.3s ease;
        }
        .test-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.2);
        }
        .test-pending { border-left-color: #ffc107; }
        .test-in-progress { border-left-color: #17a2b8; }
        .test-completed { border-left-color: #28a745; }
        .test-cancelled { border-left-color: #dc3545; }
        
        .status-badge {
            border-radius: 20px;
            padding: 6px 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .btn-lab {
            background: linear-gradient(45deg, #4facfe, #00f2fe);
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-lab:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
            color: white;
        }
        .lab-stat-card {
            background: linear-gradient(45deg, rgba(79, 172, 254, 0.1), rgba(0, 242, 254, 0.1));
            border: 1px solid rgba(255, 255, 255, 0.3);
            text-align: center;
            padding: 25px 15px;
        }
        .test-result {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
        }
        .normal-range {
            color: #28a745;
            font-weight: 600;
        }
        .abnormal-range {
            color: #dc3545;
            font-weight: 600;
        }
        .result-chart {
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .test-timeline {
            position: relative;
            padding-left: 30px;
        }
        .test-timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(to bottom, #4facfe, #00f2fe);
        }
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -24px;
            top: 5px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #4facfe;
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
                    <i class="fas fa-flask me-3"></i>Laboratory Tests Management
                </h2>
                <p class="text-light opacity-75 mb-0">Comprehensive laboratory testing and results system</p>
            </div>
            <div>
                <a href="dashboard.jsp" class="btn btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#orderTestModal">
                    <i class="fas fa-plus me-2"></i>Order Test
                </button>
            </div>
        </div>

        <!-- Statistics Row -->
        <div class="row mb-4">
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-vial text-primary" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">156</h4>
                    <p class="text-light mb-0 small">Total Tests</p>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-clock text-warning" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">23</h4>
                    <p class="text-light mb-0 small">Pending</p>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-spinner text-info" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">12</h4>
                    <p class="text-light mb-0 small">In Progress</p>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-check-circle text-success" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">89</h4>
                    <p class="text-light mb-0 small">Completed</p>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-exclamation-triangle text-danger" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">7</h4>
                    <p class="text-light mb-0 small">Abnormal</p>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card lab-stat-card">
                    <i class="fas fa-calendar-day text-secondary" style="font-size: 2rem;"></i>
                    <h4 class="text-white mt-2 mb-1">18</h4>
                    <p class="text-light mb-0 small">Today</p>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Tests List -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
                        <h5 class="text-white mb-0">
                            <i class="fas fa-list me-2"></i>Recent Lab Tests
                        </h5>
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-outline-light active" data-filter="all">All</button>
                            <button class="btn btn-outline-light" data-filter="pending">Pending</button>
                            <button class="btn btn-outline-light" data-filter="completed">Completed</button>
                            <button class="btn btn-outline-light" data-filter="abnormal">Abnormal</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Test 1 -->
                        <div class="card test-card test-completed mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6 class="text-white mb-1">
                                            <i class="fas fa-microscope me-2"></i>Complete Blood Count (CBC)
                                        </h6>
                                        <small class="text-light opacity-75">
                                            Patient: John Smith (P001) | Ordered: Aug 20, 2025
                                        </small>
                                    </div>
                                    <div>
                                        <span class="status-badge bg-success">Completed</span>
                                    </div>
                                </div>
                                
                                <div class="test-result">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <h5 class="text-white normal-range">5.2</h5>
                                                <small class="text-light">RBC (4.5-5.5)</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <h5 class="text-white normal-range">7.8</h5>
                                                <small class="text-light">WBC (4.0-10.0)</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <h5 class="text-white normal-range">14.2</h5>
                                                <small class="text-light">Hemoglobin (12.0-16.0)</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <small class="text-light">
                                        <i class="fas fa-user-md me-1"></i>Dr. Johnson | 
                                        <i class="fas fa-calendar me-1"></i>Results: Aug 21, 2025
                                    </small>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-light" title="View Full Report">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-outline-info" title="Download PDF">
                                            <i class="fas fa-download"></i>
                                        </button>
                                        <button class="btn btn-outline-success" title="Share with Patient">
                                            <i class="fas fa-share"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Test 2 -->
                        <div class="card test-card test-in-progress mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6 class="text-white mb-1">
                                            <i class="fas fa-heartbeat me-2"></i>Lipid Panel
                                        </h6>
                                        <small class="text-light opacity-75">
                                            Patient: Sarah Davis (P002) | Ordered: Aug 21, 2025
                                        </small>
                                    </div>
                                    <div>
                                        <span class="status-badge bg-info">In Progress</span>
                                    </div>
                                </div>
                                
                                <div class="test-timeline">
                                    <div class="timeline-item">
                                        <small class="text-success"><i class="fas fa-check-circle me-2"></i>Sample collected</small>
                                    </div>
                                    <div class="timeline-item">
                                        <small class="text-info"><i class="fas fa-spinner fa-spin me-2"></i>Processing in lab</small>
                                    </div>
                                    <div class="timeline-item">
                                        <small class="text-muted"><i class="fas fa-clock me-2"></i>Results pending</small>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <small class="text-light">
                                        <i class="fas fa-user-md me-1"></i>Dr. Williams | 
                                        <i class="fas fa-clock me-1"></i>Expected: Aug 22, 2025
                                    </small>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-warning" title="Update Status">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-outline-info" title="Contact Lab">
                                            <i class="fas fa-phone"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Test 3 -->
                        <div class="card test-card test-pending mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6 class="text-white mb-1">
                                            <i class="fas fa-x-ray me-2"></i>Chest X-Ray
                                        </h6>
                                        <small class="text-light opacity-75">
                                            Patient: Michael Brown (P003) | Ordered: Aug 21, 2025
                                        </small>
                                    </div>
                                    <div>
                                        <span class="status-badge bg-warning text-dark">Pending</span>
                                    </div>
                                </div>
                                
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Patient needs to fast for 8 hours before the test
                                </div>
                                
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-light">
                                        <i class="fas fa-user-md me-1"></i>Dr. Brown | 
                                        <i class="fas fa-calendar me-1"></i>Scheduled: Aug 22, 2025 10:00 AM
                                    </small>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-success" title="Schedule Patient">
                                            <i class="fas fa-calendar-plus"></i>
                                        </button>
                                        <button class="btn btn-outline-info" title="Send Instructions">
                                            <i class="fas fa-envelope"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions & Stats -->
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
                            <button class="btn btn-lab" data-bs-toggle="modal" data-bs-target="#orderTestModal">
                                <i class="fas fa-plus me-2"></i>Order New Test
                            </button>
                            <button class="btn btn-outline-light">
                                <i class="fas fa-search me-2"></i>Search Results
                            </button>
                            <button class="btn btn-outline-light">
                                <i class="fas fa-chart-bar me-2"></i>View Analytics
                            </button>
                            <button class="btn btn-outline-light">
                                <i class="fas fa-download me-2"></i>Export Reports
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Today's Schedule -->
                <div class="card mb-4">
                    <div class="card-header bg-transparent">
                        <h6 class="text-white mb-0">
                            <i class="fas fa-calendar-day me-2"></i>Today's Lab Schedule
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="list-group list-group-flush">
                            <div class="list-group-item bg-transparent border-0 px-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-white mb-1">Blood Draw</h6>
                                        <small class="text-light">10:00 AM - Room 201</small>
                                    </div>
                                    <span class="badge bg-info">3 patients</span>
                                </div>
                            </div>
                            <div class="list-group-item bg-transparent border-0 px-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-white mb-1">X-Ray Session</h6>
                                        <small class="text-light">2:00 PM - Radiology</small>
                                    </div>
                                    <span class="badge bg-warning text-dark">5 patients</span>
                                </div>
                            </div>
                            <div class="list-group-item bg-transparent border-0 px-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-white mb-1">Lab Results</h6>
                                        <small class="text-light">4:00 PM - Review</small>
                                    </div>
                                    <span class="badge bg-success">12 reports</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Critical Results Alert -->
                <div class="card">
                    <div class="card-header bg-transparent">
                        <h6 class="text-white mb-0">
                            <i class="fas fa-exclamation-triangle me-2 text-danger"></i>Critical Results
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-danger">
                            <strong>Patient P005</strong><br>
                            <small>Glucose: 280 mg/dL (Critical High)</small>
                            <div class="mt-2">
                                <button class="btn btn-sm btn-outline-light">Notify Doctor</button>
                            </div>
                        </div>
                        <div class="alert alert-warning">
                            <strong>Patient P012</strong><br>
                            <small>WBC: 15.2 (Elevated)</small>
                            <div class="mt-2">
                                <button class="btn btn-sm btn-outline-light">Review</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Order Test Modal -->
<div class="modal fade" id="orderTestModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark">
            <div class="modal-header border-0">
                <h5 class="modal-title text-white">
                    <i class="fas fa-flask me-2"></i>Order Laboratory Test
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
                                <option>Michael Brown (P003)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-light">Test Type</label>
                            <select class="form-select">
                                <option>Select Test Type</option>
                                <option>Blood Test</option>
                                <option>Imaging</option>
                                <option>Urine Test</option>
                                <option>Culture</option>
                            </select>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label text-light">Specific Test</label>
                            <select class="form-select">
                                <option>Select Specific Test</option>
                                <option>Complete Blood Count (CBC)</option>
                                <option>Lipid Panel</option>
                                <option>Liver Function Test</option>
                                <option>Chest X-Ray</option>
                                <option>MRI Brain</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-light">Priority</label>
                            <select class="form-select">
                                <option>Routine</option>
                                <option>Urgent</option>
                                <option>STAT</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-light">Expected Date</label>
                            <input type="date" class="form-control" value="2025-08-22">
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label text-light">Clinical Notes</label>
                            <textarea class="form-control" rows="3" placeholder="Any specific instructions or clinical information..."></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Order Test</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Filter functionality
    document.querySelectorAll('[data-filter]').forEach(button => {
        button.addEventListener('click', function() {
            // Update active state
            document.querySelectorAll('[data-filter]').forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Filter tests (implement actual filtering logic here)
            const filter = this.dataset.filter;
            console.log('Filtering by:', filter);
        });
    });

    // Auto-refresh for real-time updates
    setInterval(function() {
        // Implement auto-refresh logic here
        console.log('Checking for updates...');
    }, 30000); // Every 30 seconds
</script>
</body>
</html>





