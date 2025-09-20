package servlet;

import dao.DoctorDAO;
import model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DoctorListServlet")
public class DoctorListServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            
            // Set attributes for JSP
            request.setAttribute("doctors", doctors);
            
            // Forward to doctors.jsp
            request.getRequestDispatcher("doctors.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load doctors: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
