<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Doctor,dao.DoctorDAO,model.Patient,dao.PatientDAO,model.Medicine,dao.MedicineDAO" %>
<%
    DoctorDAO doctorDAO = new DoctorDAO();
    PatientDAO patientDAO = new PatientDAO();
    MedicineDAO medicineDAO = new MedicineDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Prescription - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-prescription-bottle-medical me-3"></i>Create New Prescription</h2>
            <p class="mb-0">Prescribe medication for patient treatment</p>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-plus-circle me-2"></i>Prescription Details</h5>
                    </div>
                    <div class="card-body">
                        <form action="AddPrescriptionServlet" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-bed-pulse me-2"></i>Select Patient</label>
                                    <select name="patientId" class="form-control" required>
                                        <option value="">Choose a patient...</option>
                                        <% for (Patient p : patientDAO.getAllPatients()) { %>
                                            <option value="<%= p.getId() %>">
                                                <%= p.getName() %> (Age: <%= p.getAge() %>, <%= p.getGender() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-user-doctor me-2"></i>Prescribing Doctor</label>
                                    <select name="doctorId" class="form-control" required>
                                        <option value="">Choose a doctor...</option>
                                        <% for (Doctor d : doctorDAO.getAllDoctors()) { %>
                                            <option value="<%= d.getId() %>">
                                                Dr. <%= d.getName() %> - <%= d.getSpecialization() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-pills me-2"></i>Select Medicine</label>
                                    <select name="medicineId" class="form-control" required>
                                        <option value="">Choose a medicine...</option>
                                        <% for (Medicine m : medicineDAO.getAllMedicines()) { %>
                                            <option value="<%= m.getId() %>">
                                                <%= m.getName() %> - <%= m.getManufacturer() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"><i class="fas fa-prescription me-2"></i>Dosage</label>
                                    <input type="text" name="dosage" class="form-control" placeholder="e.g., 2 tablets twice daily" required>
                                </div>
                                <div class="col-12 mb-3">
                                    <label class="form-label"><i class="fas fa-notes-medical me-2"></i>Instructions</label>
                                    <textarea name="instructions" class="form-control" rows="3" placeholder="Special instructions for taking the medication..." required></textarea>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="prescriptions.jsp" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Prescriptions
                                </a>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-save me-2"></i>Create Prescription
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
    <div class="spinner-border text-danger" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>





