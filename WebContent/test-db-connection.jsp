<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .success { color: green; background: #f0fff0; padding: 15px; border: 1px solid green; border-radius: 5px; }
        .error { color: red; background: #fff0f0; padding: 15px; border: 1px solid red; border-radius: 5px; }
        .info { color: blue; background: #f0f0ff; padding: 15px; border: 1px solid blue; border-radius: 5px; }
        .code { background: #f5f5f5; padding: 10px; font-family: monospace; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>🏥 Hospital Management System - Database Connection Test</h1>
    
    <%
    try {
        // Test DBUtil initialization
        if (!DBUtil.isInitialized()) {
            out.println("<div class='error'>");
            out.println("<h3>❌ Database Initialization Failed</h3>");
            out.println("<p><strong>Error:</strong> " + DBUtil.getInitError() + "</p>");
            out.println("</div>");
        } else {
            out.println("<div class='success'>");
            out.println("<h3>✅ Database Utility Initialized Successfully</h3>");
            out.println("</div>");
            
            // Test actual connection
            Connection conn = DBUtil.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<div class='success'>");
                out.println("<h3>✅ Database Connection Successful!</h3>");
                out.println("<p><strong>Database URL:</strong> " + conn.getMetaData().getURL() + "</p>");
                out.println("<p><strong>Database Product:</strong> " + conn.getMetaData().getDatabaseProductName() + "</p>");
                out.println("<p><strong>Database Version:</strong> " + conn.getMetaData().getDatabaseProductVersion() + "</p>");
                out.println("<p><strong>Driver Name:</strong> " + conn.getMetaData().getDriverName() + "</p>");
                out.println("</div>");
                conn.close();
            } else {
                out.println("<div class='error'>");
                out.println("<h3>❌ Database Connection Failed</h3>");
                out.println("<p>Connection is null or closed</p>");
                out.println("</div>");
            }
        }
    } catch (Exception e) {
        out.println("<div class='error'>");
        out.println("<h3>❌ Database Connection Error</h3>");
        out.println("<p><strong>Error Message:</strong> " + e.getMessage() + "</p>");
        out.println("<p><strong>Error Type:</strong> " + e.getClass().getSimpleName() + "</p>");
        out.println("</div>");
        
        out.println("<div class='info'>");
        out.println("<h3>📋 Troubleshooting Checklist</h3>");
        out.println("<ol>");
        out.println("<li>✅ MySQL server is running on <code>localhost:3306</code></li>");
        out.println("<li>✅ Database '<code>hospital_db</code>' exists</li>");
        out.println("<li>✅ User '<code>Hospital</code>' exists with password '<code>Hospital</code>'</li>");
        out.println("<li>✅ User has proper permissions on hospital_db</li>");
        out.println("<li>✅ <code>db.properties</code> file is in <code>WEB-INF/classes/</code></li>");
        out.println("<li>✅ MySQL Connector JAR is in <code>WEB-INF/lib/</code></li>");
        out.println("</ol>");
        out.println("</div>");
        
        out.println("<div class='code'>");
        out.println("<h4>Database Setup Commands:</h4>");
        out.println("<pre>");
        out.println("mysql -u root -p");
        out.println("CREATE DATABASE hospital_db;");
        out.println("CREATE USER 'Hospital'@'localhost' IDENTIFIED BY 'Hospital';");
        out.println("GRANT ALL PRIVILEGES ON hospital_db.* TO 'Hospital'@'localhost';");
        out.println("FLUSH PRIVILEGES;");
        out.println("</pre>");
        out.println("</div>");
    }
    %>
    
    <div class="info">
        <h3>🔗 Quick Links</h3>
        <ul>
            <li><a href="index.jsp">🏠 Home Page</a></li>
            <li><a href="login.jsp">🔐 Login Page</a></li>
            <li><a href="signup.jsp">📝 Signup Page</a></li>
        </ul>
    </div>
    
    <div class="info">
        <h3>📊 Test Credentials</h3>
        <ul>
            <li><strong>Admin:</strong> admin / admin123</li>
            <li><strong>Doctor:</strong> ak12 / password123</li>
            <li><strong>Patient:</strong> patient1 / patient123</li>
            <li><strong>Assistant:</strong> assistant1 / assistant123</li>
        </ul>
    </div>
    
    <hr>
    <p><em>Generated at: <%= new java.util.Date() %></em></p>
    
</body>
</html>
