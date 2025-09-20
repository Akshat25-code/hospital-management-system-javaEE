<%@ page import="model.Prescription,dao.PrescriptionDAO,model.Doctor,dao.DoctorDAO,model.Patient,dao.PatientDAO,model.Medicine,dao.MedicineDAO" %>
<%
    String idStr = request.getParameter("id");
    int id = idStr != null ? Integer.parseInt(idStr) : 0;
    Prescription prescription = new PrescriptionDAO().getPrescriptionById(id);
    DoctorDAO doctorDAO = new DoctorDAO();
    PatientDAO patientDAO = new PatientDAO();
    MedicineDAO medicineDAO = new MedicineDAO();
%>
<html>
<head>
    <title>Edit Prescription</title>
</head>
<body>
    <h2>Edit Prescription</h2>
    <form action="EditPrescriptionServlet" method="post">
        <input type="hidden" name="id" value="<%= prescription.getId() %>" />
        Patient:
        <select name="patientId" required>
            <% for (Patient p : patientDAO.getAllPatients()) { %>
                <option value="<%= p.getId() %>" <%= p.getId() == prescription.getPatientId() ? "selected" : "" %>><%= p.getName() %></option>
            <% } %>
        </select><br/>
        Doctor:
        <select name="doctorId" required>
            <% for (Doctor d : doctorDAO.getAllDoctors()) { %>
                <option value="<%= d.getId() %>" <%= d.getId() == prescription.getDoctorId() ? "selected" : "" %>><%= d.getName() %></option>
            <% } %>
        </select><br/>
        Medicine:
        <select name="medicineId" required>
            <% for (Medicine m : medicineDAO.getAllMedicines()) { %>
                <option value="<%= m.getId() %>" <%= m.getId() == prescription.getMedicineId() ? "selected" : "" %>><%= m.getName() %></option>
            <% } %>
        </select><br/>
        Dosage: <input type="text" name="dosage" value="<%= prescription.getDosage() %>" required /><br/>
        Instructions: <input type="text" name="instructions" value="<%= prescription.getInstructions() %>" required /><br/>
        <input type="submit" value="Update Prescription" />
    </form>
    <a href="prescriptions.jsp">Back to Prescriptions</a>
</body>
</html>





