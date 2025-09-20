<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Hospital Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            text-align: center;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        .error-message {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .error-actions {
            margin-top: 30px;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">
            We're sorry, but we encountered an unexpected error while processing your request.
            <br>
            <strong>Error Code:</strong> 
            <%
                if (request.getAttribute("javax.servlet.error.status_code") != null) {
                    out.print(request.getAttribute("javax.servlet.error.status_code"));
                } else {
                    out.print("Unknown");
                }
            %>
        </p>
        
        <div class="error-actions">
            <a href="index.jsp" class="btn btn-primary">🏠 Go to Home</a>
            <a href="javascript:history.back()" class="btn btn-secondary">⬅️ Go Back</a>
        </div>
        
        <div style="margin-top: 30px; font-size: 14px; color: #bdc3c7;">
            <p>If this problem persists, please contact the system administrator.</p>
            <p><strong>Hospital Management System</strong> | Version 1.0</p>
        </div>
    </div>
</body>
</html>





