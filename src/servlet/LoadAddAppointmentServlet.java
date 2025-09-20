package servlet;

import dao.DoctorDAO;
import dao.PatientDAO;
import model.Doctor;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoadAddAppointmentServlet")
public class LoadAddAppointmentServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            PatientDAO patientDAO = new PatientDAO();
            
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            List<Patient> patients = patientDAO.getAllPatients();
            
            // Set attributes for JSP
            request.setAttribute("doctors", doctors);
            request.setAttribute("patients", patients);
            
            // Forward to addAppointment.jsp
            request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load appointment form: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
