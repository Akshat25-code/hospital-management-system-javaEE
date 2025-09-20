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
import java.util.Map;
import java.util.HashMap;

@WebServlet("/AppointmentListServlet")
public class AppointmentListServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            DoctorDAO doctorDAO = new DoctorDAO();
            PatientDAO patientDAO = new PatientDAO();
            
            // Get all appointments
            List<Appointment> appointments = appointmentDAO.getAllAppointments();
            
            // Create maps for quick lookup of doctor and patient names
            Map<Integer, String> doctorNames = new HashMap<>();
            Map<Integer, String> patientNames = new HashMap<>();
            
            // Pre-load all doctor and patient names to avoid null pointer issues
            for (Appointment appointment : appointments) {
                // Get doctor name
                if (!doctorNames.containsKey(appointment.getDoctorId())) {
                    Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
                    String doctorName = (doctor != null) ? doctor.getName() : "Unknown Doctor";
                    doctorNames.put(appointment.getDoctorId(), doctorName);
                }
                
                // Get patient name
                if (!patientNames.containsKey(appointment.getPatientId())) {
                    Patient patient = patientDAO.getPatientById(appointment.getPatientId());
                    String patientName = (patient != null) ? patient.getName() : "Unknown Patient";
                    patientNames.put(appointment.getPatientId(), patientName);
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("doctorNames", doctorNames);
            request.setAttribute("patientNames", patientNames);
            
            // Forward to appointments.jsp
            request.getRequestDispatcher("appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load appointments: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
