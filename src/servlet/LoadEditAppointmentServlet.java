package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoadEditAppointmentServlet")
public class LoadEditAppointmentServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("AppointmentListServlet");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            DoctorDAO doctorDAO = new DoctorDAO();
            PatientDAO patientDAO = new PatientDAO();
            
            Appointment appointment = appointmentDAO.getAppointmentById(id);
            if (appointment == null) {
                request.setAttribute("error", "Appointment not found.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            List<Patient> patients = patientDAO.getAllPatients();
            
            // Set attributes for JSP
            request.setAttribute("appointment", appointment);
            request.setAttribute("doctors", doctors);
            request.setAttribute("patients", patients);
            
            // Forward to editAppointment.jsp
            request.getRequestDispatcher("editAppointment.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load appointment for editing: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
