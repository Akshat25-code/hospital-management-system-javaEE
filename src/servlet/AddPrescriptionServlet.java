package servlet;

import dao.PrescriptionDAO;
import model.Prescription;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddPrescriptionServlet")
public class AddPrescriptionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int medicineId = Integer.parseInt(request.getParameter("medicineId"));
        String dosage = request.getParameter("dosage");
        String instructions = request.getParameter("instructions");

        Prescription prescription = new Prescription();
        prescription.setPatientId(patientId);
        prescription.setDoctorId(doctorId);
        prescription.setMedicineId(medicineId);
        prescription.setDosage(dosage);
        prescription.setInstructions(instructions);

        PrescriptionDAO dao = new PrescriptionDAO();
        dao.addPrescription(prescription);
        response.sendRedirect("PrescriptionListServlet");
    }
}

