<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,model.Medicine" %>
<%
    // Check if data is loaded from servlet, if not redirect to servlet
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    if (medicines == null) {
        response.sendRedirect("MedicineListServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Medicines - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="main-container animate-in">
        <div class="page-header">
            <h2><i class="fas fa-pills me-3"></i>Medicines Inventory</h2>
            <p class="mb-0">Manage hospital medicine stock and information</p>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-2"></i>Dashboard
                </a>
                <% model.User user = (model.User) session.getAttribute("user"); %>
                <% if (user != null && user.getRole().equals("admin")) { %>
                    <a href="addMedicine.jsp" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add Medicine
                    </a>
                <% } %>
            </div>
            <div>
                <button onclick="exportToCSV('medicinesTable', 'medicines')" class="btn btn-success me-2">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
                <button onclick="printTable('medicinesTable')" class="btn btn-info">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body p-0">
                <table id="medicinesTable" class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-2"></i>ID</th>
                            <th><i class="fas fa-capsules me-2"></i>Name</th>
                            <th><i class="fas fa-industry me-2"></i>Manufacturer</th>
                            <th><i class="fas fa-dollar-sign me-2"></i>Price</th>
                            <th><i class="fas fa-boxes me-2"></i>Quantity</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Medicine m : medicines) { %>
                            <tr>
                                <td><span class="badge bg-info"><%= m.getId() %></span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="medicine-icon bg-info text-white me-3">
                                            <i class="fas fa-pills"></i>
                                        </div>
                                        <strong><%= m.getName() %></strong>
                                    </div>
                                </td>
                                <td><span class="badge bg-secondary"><%= m.getManufacturer() %></span></td>
                                <td><span class="text-success fw-bold">$<%= String.format("%.2f", m.getPrice()) %></span></td>
                                <td>
                                    <span class="badge <%= m.getQuantity() < 10 ? "bg-danger" : m.getQuantity() < 50 ? "bg-warning" : "bg-success" %>">
                                        <%= m.getQuantity() %> units
                                    </span>
                                </td>
                                <td>
                                    <% if (user != null && user.getRole().equals("admin")) { %>
                                        <a href="editMedicine.jsp?id=<%= m.getId() %>" class="btn btn-sm btn-warning me-1">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="confirmDelete('medicine', <%= m.getId() %>, 'DeleteMedicineServlet')" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    <% } else { %>
                                        <span class="text-muted">View Only</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="loadingSpinner" class="loading-spinner">
    <div class="spinner-border text-info" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="script.js"></script>
<style>
.medicine-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
</body>
</html>





