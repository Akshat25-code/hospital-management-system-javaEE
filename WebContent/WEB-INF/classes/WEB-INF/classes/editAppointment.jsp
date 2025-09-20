<%@ page import="model.Appointment,model.Doctor,model.Patient,java.util.List" %>
<%
    // Check if data is loaded from servlet, if not redirect to servlet
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    
    if (appointment == null || doctors == null || patients == null) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            response.sendRedirect("LoadEditAppointmentServlet?id=" + idParam);
        } else {
            response.sendRedirect("AppointmentListServlet");
        }
        return;
    }
%>
<html>
<head>
    <title>Edit Appointment</title>
</head>
<body>
    <h2>Edit Appointment</h2>
    <form action="EditAppointmentServlet" method="post">
        <input type="hidden" name="id" value="<%= appointment.getId() %>" />
        Doctor:
        <select name="doctorId" required>
            <% for (Doctor d : doctors) { %>
                <option value="<%= d.getId() %>" <%= d.getId() == appointment.getDoctorId() ? "selected" : "" %>><%= d.getName() %></option>
            <% } %>
        </select><br/>
        Patient:
        <select name="patientId" required>
            <% for (Patient p : patients) { %>
                <option value="<%= p.getId() %>" <%= p.getId() == appointment.getPatientId() ? "selected" : "" %>><%= p.getName() %></option>
            <% } %>
        </select><br/>
        Date: <input type="date" name="date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(appointment.getDate()) %>" required /><br/>
        Time: <input type="time" name="time" value="<%= appointment.getTime() %>" required /><br/>
        Reason: <input type="text" name="reason" value="<%= appointment.getReason() %>" required /><br/>
        <input type="submit" value="Update Appointment" />
    </form>
    <a href="AppointmentListServlet">Back to Appointments</a>
</body>
</html>





