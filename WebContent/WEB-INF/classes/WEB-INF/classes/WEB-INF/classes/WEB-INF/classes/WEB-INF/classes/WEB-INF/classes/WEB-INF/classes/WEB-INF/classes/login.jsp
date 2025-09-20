<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Generate CSRF token
    String csrfToken = (String) session.getAttribute("csrfToken");
    if (csrfToken == null) {
        csrfToken = util.SecurityUtil.generateCSRFToken();
        session.setAttribute("csrfToken", csrfToken);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            backdrop-filter: blur(10px);
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h2 {
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .login-header p {
            color: #666;
            font-size: 14px;
        }
        .role-selector {
            margin-bottom: 20px;
        }
        .role-option {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .role-option:hover {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        .role-option.selected {
            border-color: #667eea;
            background-color: #667eea;
            color: white;
        }
        .role-icon {
            font-size: 20px;
            margin-right: 12px;
            width: 25px;
            text-align: center;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e0e0e0;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .alert {
            border-radius: 10px;
            border: none;
        }
        .input-group-text {
            background: transparent;
            border: 2px solid #e0e0e0;
            border-right: none;
            border-radius: 10px 0 0 10px;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
    </style>
</head>
<body>
<div class="login-container animate-in">
    <div class="login-header">
        <h2><i class="fas fa-hospital-medical me-2"></i>HMS Login</h2>
        <p class="text-muted">Hospital Management System</p>
    </div>
    
    <!-- Role Selection -->
    <div class="role-selector">
        <label class="form-label fw-semibold">Select Your Role:</label>
        <div class="role-option" data-role="admin">
            <i class="fas fa-user-shield role-icon"></i>
            <div>
                <strong>Administrator</strong>
                <div class="small text-muted">Full system access</div>
            </div>
        </div>
        <div class="role-option" data-role="doctor">
            <i class="fas fa-user-md role-icon"></i>
            <div>
                <strong>Doctor</strong>
                <div class="small text-muted">Manage patients & appointments</div>
            </div>
        </div>
        <div class="role-option" data-role="patient">
            <i class="fas fa-user role-icon"></i>
            <div>
                <strong>Patient</strong>
                <div class="small text-muted">Book appointments & view records</div>
            </div>
        </div>
        <div class="role-option" data-role="assistant">
            <i class="fas fa-user-nurse role-icon"></i>
            <div>
                <strong>Assistant</strong>
                <div class="small text-muted">Support medical staff</div>
            </div>
        </div>
    </div>
    
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle me-2"></i><%= error %>
        </div>
    <% } %>
    
    <% String registered = request.getParameter("registered"); %>
    <% if ("true".equals(registered)) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle me-2"></i>Registration successful! Please login with your credentials.
        </div>
    <% } %>
    
    <% String sessionExpired = request.getParameter("error"); %>
    <% if ("session_expired".equals(sessionExpired)) { %>
        <div class="alert alert-warning">
            <i class="fas fa-clock me-2"></i>Your session has expired. Please login again.
        </div>
    <% } %>
    
    <form action="LoginServlet" method="post" id="loginForm">
        <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
        <input type="hidden" name="role" id="selectedRole">
        
        <div class="mb-3">
            <label class="form-label">Username</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-user"></i>
                </span>
                <input type="text" name="username" class="form-control" required maxlength="50" 
                       placeholder="Enter your username">
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-lock"></i>
                </span>
                <input type="password" name="password" class="form-control" required maxlength="100" 
                       placeholder="Enter your password">
            </div>
        </div>
        
        <div class="d-grid">
            <button type="submit" class="btn btn-login">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>
        </div>
            <div class="text-center mt-3">
                <span class="text-muted">Don't have an account?</span>
                <a href="signup.jsp" class="ms-2" style="color:#667eea;font-weight:600;">Sign Up</a>
            </div>
    </form>
    
    <div class="text-center mt-3">
        <small class="text-muted">
            <i class="fas fa-shield-alt me-1"></i>Secure Login Protected
        </small>
    </div>
</div>

<div id="loadingSpinner" class="loading-spinner">
    <div class="spinner-border text-light" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
<script>
// Role selection functionality
document.querySelectorAll('.role-option').forEach(option => {
    option.addEventListener('click', function() {
        // Remove selected class from all options
        document.querySelectorAll('.role-option').forEach(opt => opt.classList.remove('selected'));
        // Add selected class to clicked option
        this.classList.add('selected');
        // Set hidden input value
        document.getElementById('selectedRole').value = this.dataset.role;
    });
});

// Form validation
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const selectedRole = document.getElementById('selectedRole').value;
    if (!selectedRole) {
        e.preventDefault();
        showAlert('Please select your role first', 'warning');
        return;
    }
    
    const username = this.username.value.trim();
    const password = this.password.value;
    
    if (!username || !password) {
        e.preventDefault();
        showAlert('Please fill in all fields', 'danger');
        return;
    }
    
    if (username.length > 50) {
        e.preventDefault();
        showAlert('Username too long', 'danger');
        return;
    }
    
    if (password.length > 100) {
        e.preventDefault();
        showAlert('Password too long', 'danger');
        return;
    }
    
    showLoadingSpinner();
});

// Show alert function
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const form = document.getElementById('loginForm');
    form.parentNode.insertBefore(alertDiv, form);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 5000);
}
</script>
</body>
</html>





