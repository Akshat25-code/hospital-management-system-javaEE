<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { background: #d4edda; padding: 10px; border: 1px solid #c3e6cb; border-radius: 5px; margin: 10px 0; }
        .error { background: #f8d7da; padding: 10px; border: 1px solid #f5c6cb; border-radius: 5px; margin: 10px 0; }
        table { border-collapse: collapse; width: 100%; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>🏥 Doctor Dashboard Test Page</h1>
    
    <%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user != null) {
        out.println("<div class='success'>");
        out.println("<h3>✅ Login Status: SUCCESS</h3>");
        out.println("<p><strong>Username:</strong> " + user.getUsername() + "</p>");
        out.println("<p><strong>Role:</strong> " + user.getRole() + "</p>");
        out.println("<p><strong>User ID:</strong> " + user.getId() + "</p>");
        out.println("</div>");
        
        try {
            Connection conn = DBUtil.getConnection();
            
            // Get doctor information
            String doctorSql = "SELECT * FROM doctors WHERE id = ? OR email LIKE ?";
            PreparedStatement doctorPs = conn.prepareStatement(doctorSql);
            doctorPs.setInt(1, user.getId());
            doctorPs.setString(2, "%" + user.getUsername() + "%");
            ResultSet doctorRs = doctorPs.executeQuery();
            
            int doctorId = 0;
            if (doctorRs.next()) {
                doctorId = doctorRs.getInt("id");
                out.println("<div class='success'>");
                out.println("<h3>👨‍⚕️ Doctor Information</h3>");
                out.println("<p><strong>Doctor ID:</strong> " + doctorId + "</p>");
                out.println("<p><strong>Name:</strong> " + doctorRs.getString("name") + "</p>");
                out.println("<p><strong>Specialization:</strong> " + doctorRs.getString("specialization") + "</p>");
                out.println("<p><strong>Email:</strong> " + doctorRs.getString("email") + "</p>");
                out.println("</div>");
            } else {
                // Use user ID as doctor ID for testing
                doctorId = user.getId();
                out.println("<div class='error'>");
                out.println("<h3>⚠️ Doctor not found in doctors table</h3>");
                out.println("<p>Using User ID (" + doctorId + ") for testing purposes</p>");
                out.println("</div>");
            }
            
            // Get appointments for this doctor
            String appointmentSql = "SELECT a.*, p.name as patient_name, d.name as doctor_name FROM appointments a " +
                                   "LEFT JOIN patients p ON a.patient_id = p.id " +
                                   "LEFT JOIN doctors d ON a.doctor_id = d.id " +
                                   "WHERE a.doctor_id = ? OR a.doctor_id = ? ORDER BY a.date, a.time";
            PreparedStatement appointmentPs = conn.prepareStatement(appointmentSql);
            appointmentPs.setInt(1, doctorId);
            appointmentPs.setInt(2, user.getId());
            ResultSet appointmentRs = appointmentPs.executeQuery();
            
            out.println("<h3>📅 Your Appointments</h3>");
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Patient</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th></tr>");
            
            boolean hasAppointments = false;
            while (appointmentRs.next()) {
                hasAppointments = true;
                out.println("<tr>");
                out.println("<td>" + appointmentRs.getInt("id") + "</td>");
                out.println("<td>" + appointmentRs.getString("patient_name") + "</td>");
                out.println("<td>" + appointmentRs.getDate("date") + "</td>");
                out.println("<td>" + appointmentRs.getTime("time") + "</td>");
                out.println("<td>" + appointmentRs.getString("reason") + "</td>");
                out.println("<td>" + appointmentRs.getString("status") + "</td>");
                out.println("</tr>");
            }
            
            if (!hasAppointments) {
                out.println("<tr><td colspan='6'>No appointments found for Doctor ID: " + doctorId + "</td></tr>");
            }
            out.println("</table>");
            
            // Get all appointments (for debugging)
            String allAppointmentsSql = "SELECT a.*, p.name as patient_name, d.name as doctor_name FROM appointments a " +
                                       "LEFT JOIN patients p ON a.patient_id = p.id " +
                                       "LEFT JOIN doctors d ON a.doctor_id = d.id " +
                                       "ORDER BY a.date, a.time";
            PreparedStatement allPs = conn.prepareStatement(allAppointmentsSql);
            ResultSet allRs = allPs.executeQuery();
            
            out.println("<h3>🔍 All Appointments (Debug)</h3>");
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Doctor ID</th><th>Patient ID</th><th>Doctor Name</th><th>Patient Name</th><th>Date</th><th>Time</th></tr>");
            
            while (allRs.next()) {
                out.println("<tr>");
                out.println("<td>" + allRs.getInt("id") + "</td>");
                out.println("<td>" + allRs.getInt("doctor_id") + "</td>");
                out.println("<td>" + allRs.getInt("patient_id") + "</td>");
                out.println("<td>" + allRs.getString("doctor_name") + "</td>");
                out.println("<td>" + allRs.getString("patient_name") + "</td>");
                out.println("<td>" + allRs.getDate("date") + "</td>");
                out.println("<td>" + allRs.getTime("time") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Get patient count
            String patientCountSql = "SELECT COUNT(*) as count FROM patients";
            PreparedStatement patientPs = conn.prepareStatement(patientCountSql);
            ResultSet patientRs = patientPs.executeQuery();
            if (patientRs.next()) {
                out.println("<div class='success'>");
                out.println("<h3>👥 Total Patients: " + patientRs.getInt("count") + "</h3>");
                out.println("</div>");
            }
            
            conn.close();
            
        } catch (Exception e) {
            out.println("<div class='error'>");
            out.println("<h3>❌ Database Error</h3>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("</div>");
            e.printStackTrace();
        }
        
    } else {
        out.println("<div class='error'>");
        out.println("<h3>❌ Not Logged In</h3>");
        out.println("<p>Please login first</p>");
        out.println("<a href='login.jsp'>Go to Login</a>");
        out.println("</div>");
    }
    %>
    
    <hr>
    <h3>🔗 Quick Links</h3>
    <ul>
        <li><a href="dashboard.jsp">🏠 Dashboard</a></li>
        <li><a href="patients.jsp">👥 View Patients</a></li>
        <li><a href="doctor/appointments.jsp">📅 My Appointments</a></li>
        <li><a href="logout">🔓 Logout</a></li>
    </ul>
    
</body>
</html>
