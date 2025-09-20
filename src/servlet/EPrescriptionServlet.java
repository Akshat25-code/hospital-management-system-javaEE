package servlet;

import dao.EPrescriptionDAO;
import dao.DoctorDAO;
import model.EPrescription;
import model.Doctor;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;

@WebServlet("/doctor/e-prescription")
public class EPrescriptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            // Get the doctor record for this user
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor currentDoctor = doctorDAO.getDoctorByUserId(user.getId());
            
            if (currentDoctor == null) {
                throw new ServletException("Doctor record not found for user: " + user.getUsername());
            }
            
            EPrescriptionDAO dao = new EPrescriptionDAO(conn);
            List<EPrescription> list = dao.getEPrescriptionsByDoctorId(currentDoctor.getId());
            request.setAttribute("ePrescriptions", list);
            request.getRequestDispatcher("/doctor/e-prescription.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String medicineDetails = request.getParameter("medicineDetails");
        
        // Validate patient ID exists
        if (patientId <= 0) {
            throw new ServletException("Invalid patient ID: " + patientId);
        }
        try (Connection conn = DBUtil.getConnection()) {
            // Get the doctor record for this user
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor currentDoctor = doctorDAO.getDoctorByUserId(user.getId());
            
            if (currentDoctor == null) {
                throw new ServletException("Doctor record not found for user: " + user.getUsername() + " (ID: " + user.getId() + ")");
            }
            
            System.out.println("DEBUG: User ID: " + user.getId() + ", Doctor ID: " + currentDoctor.getId() + ", Patient ID: " + patientId);
            
            EPrescription ep = new EPrescription(0, patientId, currentDoctor.getId(), medicineDetails, new Date());
            EPrescriptionDAO dao = new EPrescriptionDAO(conn);
            dao.addEPrescription(ep);
            response.sendRedirect("e-prescription");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

