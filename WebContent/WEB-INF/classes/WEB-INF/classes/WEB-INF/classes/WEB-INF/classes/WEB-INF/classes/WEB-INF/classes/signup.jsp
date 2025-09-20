<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Sign Up - Hospital Management System</title>
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
        .signup-container {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            backdrop-filter: blur(10px);
        }
        .signup-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .signup-header h2 {
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .signup-header p {
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
            font-size: 18px;
            margin-right: 12px;
            width: 22px;
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
        .btn-signup {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .login-link {
            text-align: center;
            margin-top: 18px;
        }
        .alert {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
<div class="signup-container animate-in">
    <div class="signup-header">
        <h2><i class="fas fa-user-plus me-2"></i>Sign Up</h2>
        <p class="text-muted">Create your Hospital Management account</p>
    </div>
    
    <!-- Role Selection -->
    <div class="role-selector">
        <label class="form-label fw-semibold">Select Your Role:</label>
        <div class="role-option" data-role="patient">
            <i class="fas fa-user role-icon"></i>
            <div>
                <strong>Patient</strong>
                <div class="small text-muted">Book appointments & view records</div>
            </div>
        </div>
        <div class="role-option" data-role="doctor">
            <i class="fas fa-user-md role-icon"></i>
            <div>
                <strong>Doctor</strong>
                <div class="small text-muted">Manage patients & appointments</div>
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
    <form action="RegisterServlet" method="post" id="signupForm">
        <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
        <input type="hidden" name="role" id="selectedRole">
        
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">First Name</label>
                <input type="text" name="firstName" class="form-control" required maxlength="50" placeholder="First name">
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Last Name</label>
                <input type="text" name="lastName" class="form-control" required maxlength="50" placeholder="Last name">
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Username</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" name="username" id="username" class="form-control" required maxlength="50" 
                       placeholder="Choose a username" onkeyup="checkUsernameAvailability()">
            </div>
            <div id="usernameStatus" class="mt-2"></div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Email</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                <input type="email" name="email" class="form-control" required maxlength="100" placeholder="your.email@example.com">
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Phone Number</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                <input type="tel" name="phone" class="form-control" required maxlength="20" placeholder="Your phone number">
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" name="password" class="form-control" required maxlength="100" 
                       placeholder="Create a password" id="password" onkeyup="checkPasswordStrength()">
            </div>
            <div id="passwordStrength" class="mt-2"></div>
            <div class="password-requirements mt-2" style="font-size: 0.875rem;">
                <div class="text-muted mb-1">Password must contain:</div>
                <div id="req-length" class="requirement"><i class="fas fa-times text-danger me-1"></i>At least 8 characters</div>
                <div id="req-upper" class="requirement"><i class="fas fa-times text-danger me-1"></i>One uppercase letter</div>
                <div id="req-lower" class="requirement"><i class="fas fa-times text-danger me-1"></i>One lowercase letter</div>
                <div id="req-number" class="requirement"><i class="fas fa-times text-danger me-1"></i>One number</div>
                <div id="req-special" class="requirement"><i class="fas fa-times text-danger me-1"></i>One special character</div>
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Confirm Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" name="confirmPassword" class="form-control" required maxlength="100" placeholder="Confirm your password">
            </div>
        </div>
        
        <div class="d-grid">
            <button type="submit" class="btn btn-signup">
                <i class="fas fa-user-plus me-2"></i>Register
            </button>
        </div>
    </form>
    <div class="login-link">
        Already have an account? <a href="login.jsp" style="color:#667eea;font-weight:600;">Login</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

// Form validation with enhanced security
document.getElementById('signupForm').addEventListener('submit', function(e) {
    const selectedRole = document.getElementById('selectedRole').value;
    if (!selectedRole) {
        e.preventDefault();
        showAlert('Please select your role first', 'warning');
        return;
    }
    
    const username = this.username.value.trim();
    const password = this.password.value;
    const confirmPassword = this.confirmPassword.value;
    const email = this.email.value;
    const firstName = this.firstName.value;
    const lastName = this.lastName.value;
    
    // Username validation
    if (username.length < 3) {
        e.preventDefault();
        showAlert('Username must be at least 3 characters long', 'danger');
        return;
    }
    
    // Check if username is available (from last check)
    const usernameStatus = document.getElementById('usernameStatus').innerHTML;
    if (usernameStatus.includes('already taken')) {
        e.preventDefault();
        showAlert('Please choose a different username', 'danger');
        return;
    }
    
    // Password validation
    if (password !== confirmPassword) {
        e.preventDefault();
        showAlert('Passwords do not match', 'danger');
        return;
    }
    
    // Enhanced password strength validation
    if (!isPasswordStrong(password)) {
        e.preventDefault();
        alert('Password must contain at least 8 characters, including uppercase, lowercase, number, and special character');
        return;
    }
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        e.preventDefault();
        alert('Please enter a valid email address');
        return;
    }
    
    // Name validation
    const nameRegex = /^[a-zA-Z\s'-]+$/;
    if (!nameRegex.test(firstName) || !nameRegex.test(lastName)) {
        e.preventDefault();
        alert('Names can only contain letters, spaces, hyphens, and apostrophes');
        return;
    }
    
    // Security: Check for common injection patterns
    const inputs = [firstName, lastName, email, this.username.value];
    const dangerousPatterns = /<script|javascript:|data:|vbscript:|onload=|onclick=/i;
    
    for (let input of inputs) {
        if (dangerousPatterns.test(input)) {
            e.preventDefault();
            alert('Invalid characters detected in form fields');
            return;
        }
    }
});

// Password strength checker
function isPasswordStrong(password) {
    return password.length >= 8 &&
           /[a-z]/.test(password) &&
           /[A-Z]/.test(password) &&
           /\d/.test(password) &&
           /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
}

// Real-time username availability checking
let usernameCheckTimeout;
function checkUsernameAvailability() {
    const username = document.getElementById('username').value.trim();
    const statusDiv = document.getElementById('usernameStatus');
    
    // Clear previous timeout
    clearTimeout(usernameCheckTimeout);
    
    if (username.length < 3) {
        statusDiv.innerHTML = '<small class="text-muted"><i class="fas fa-info-circle me-1"></i>Username must be at least 3 characters</small>';
        return;
    }
    
    // Debounce the API call
    usernameCheckTimeout = setTimeout(() => {
        // Show checking status
        statusDiv.innerHTML = '<small class="text-info"><i class="fas fa-spinner fa-spin me-1"></i>Checking availability...</small>';
        
        // Use fetch to check username availability
        fetch('check-username.jsp?username=' + encodeURIComponent(username))
            .then(response => response.json())
            .then(data => {
                if (data.available) {
                    statusDiv.innerHTML = '<small class="text-success"><i class="fas fa-check-circle me-1"></i>Username available</small>';
                } else {
                    statusDiv.innerHTML = '<small class="text-danger"><i class="fas fa-times-circle me-1"></i>Username already taken</small>';
                }
            })
            .catch(error => {
                statusDiv.innerHTML = '<small class="text-warning"><i class="fas fa-exclamation-triangle me-1"></i>Could not check availability</small>';
            });
    }, 500); // 500ms delay
}

// Show alert function
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const form = document.getElementById('signupForm');
    form.parentNode.insertBefore(alertDiv, form);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 5000);
}

// Password strength checking
function checkPasswordStrength() {
    const password = document.getElementById('password').value;
    const strengthDiv = document.getElementById('passwordStrength');
    
    // Check individual requirements
    const hasLength = password.length >= 8;
    const hasUpper = /[A-Z]/.test(password);
    const hasLower = /[a-z]/.test(password);
    const hasNumber = /\d/.test(password);
    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
    
    // Update requirement indicators
    updateRequirement('req-length', hasLength);
    updateRequirement('req-upper', hasUpper);
    updateRequirement('req-lower', hasLower);
    updateRequirement('req-number', hasNumber);
    updateRequirement('req-special', hasSpecial);
    
    // Calculate strength
    let strength = 0;
    if (hasLength) strength++;
    if (hasUpper) strength++;
    if (hasLower) strength++;
    if (hasNumber) strength++;
    if (hasSpecial) strength++;
    
    // Update strength indicator
    if (password.length === 0) {
        strengthDiv.innerHTML = '';
    } else if (strength < 3) {
        strengthDiv.innerHTML = '<div class="progress mt-2"><div class="progress-bar bg-danger" style="width: 33%"></div></div><small class="text-danger mt-1 d-block"><i class="fas fa-exclamation-triangle me-1"></i>Weak password</small>';
    } else if (strength < 5) {
        strengthDiv.innerHTML = '<div class="progress mt-2"><div class="progress-bar bg-warning" style="width: 66%"></div></div><small class="text-warning mt-1 d-block"><i class="fas fa-shield-alt me-1"></i>Medium password</small>';
    } else {
        strengthDiv.innerHTML = '<div class="progress mt-2"><div class="progress-bar bg-success" style="width: 100%"></div></div><small class="text-success mt-1 d-block"><i class="fas fa-check-circle me-1"></i>Strong password</small>';
    }
}

function updateRequirement(elementId, isMet) {
    const element = document.getElementById(elementId);
    if (isMet) {
        element.innerHTML = element.innerHTML.replace('fas fa-times text-danger', 'fas fa-check text-success');
        element.classList.add('text-success');
        element.classList.remove('text-muted');
    } else {
        element.innerHTML = element.innerHTML.replace('fas fa-check text-success', 'fas fa-times text-danger');
        element.classList.remove('text-success');
        element.classList.add('text-muted');
    }
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>





