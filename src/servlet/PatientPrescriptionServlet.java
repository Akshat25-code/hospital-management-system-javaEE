package servlet;

import dao.EPrescriptionDAO;
import dao.PatientDAO;
import model.EPrescription;
import model.Patient;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/patient/my-prescriptions")
public class PatientPrescriptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Get the patient record for this user
            PatientDAO patientDAO = new PatientDAO();
            Patient currentPatient = patientDAO.getPatientByUserId(user.getId());
            
            if (currentPatient == null) {
                response.sendRedirect("../error.jsp");
                return;
            }

            // Get prescriptions for this patient
            EPrescriptionDAO dao = new EPrescriptionDAO(conn);
            List<EPrescription> prescriptions = dao.getEPrescriptionsByPatientId(currentPatient.getId());
            
            request.setAttribute("prescriptions", prescriptions);
            request.getRequestDispatcher("/patient/my-prescriptions.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
