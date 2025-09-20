package servlet;

import dao.PrescriptionDAO;
import model.Prescription;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/PrescriptionListServlet")
public class PrescriptionListServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            List<Prescription> prescriptions = prescriptionDAO.getAllPrescriptions();
            
            // Set attributes for JSP
            request.setAttribute("prescriptions", prescriptions);
            
            // Forward to prescriptions.jsp
            request.getRequestDispatcher("prescriptions.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load prescriptions: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
