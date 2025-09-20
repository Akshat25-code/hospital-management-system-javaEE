package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/AddAppointmentServlet")
public class AddAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the logged-in user from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Safely parse parameters with null checks
            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");
            String time = request.getParameter("time");
            String reason = request.getParameter("reason");
            
            // Validate required parameters
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty() ||
                dateStr == null || dateStr.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled.");
                request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
                return;
            }
            
            int doctorId = Integer.parseInt(doctorIdStr.trim());
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr.trim());
            
            // Get patient ID from form parameter or user record
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = null;
            int patientId;
            
            String patientIdStr = request.getParameter("patientId");
            if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                // Patient ID provided in form (works for all user types)
                patientId = Integer.parseInt(patientIdStr.trim());
                patient = patientDAO.getPatientById(patientId);
                if (patient == null) {
                    request.setAttribute("error", "Selected patient not found.");
                    request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
                    return;
                }
            } else if ("patient".equals(user.getRole())) {
                // Fallback: For patient users without patientId parameter
                patient = patientDAO.getPatientByUserId(user.getId());
                if (patient == null) {
                    request.setAttribute("error", "Patient record not found for the logged-in user.");
                    request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
                    return;
                }
                patientId = patient.getId();
            } else {
                request.setAttribute("error", "Patient must be selected.");
                request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
                return;
            }

            AppointmentDAO dao = new AppointmentDAO();
            DoctorDAO doctorDAO = new DoctorDAO();
            
            // Check if doctor is already booked at this time
            if (dao.isDoctorBooked(doctorId, date, time)) {
                request.setAttribute("error", "Sorry, this time slot is already taken. Please select a different time.");
                request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
                return;
            }
            
            // Check if patient already has appointments on this date
            List<Appointment> existingAppointments = dao.getPatientAppointmentsByDate(patientId, date);
            if (!existingAppointments.isEmpty()) {
                String confirmParam = request.getParameter("confirmMultiple");
                if (confirmParam == null || !confirmParam.equals("yes")) {
                    // Show warning message with option to proceed
                    Doctor doctor = doctorDAO.getDoctorById(doctorId);
                    
                    request.setAttribute("warningMessage", 
                        "Patient already has " + existingAppointments.size() + " appointment(s) on this date. " +
                        "Are you sure you want to book another appointment?");
                    request.setAttribute("existingAppointments", existingAppointments);
                    request.setAttribute("doctorId", doctorId);
                    request.setAttribute("patientId", patientId);
                    request.setAttribute("date", dateStr);
                    request.setAttribute("time", time);
                    request.setAttribute("reason", reason);
                    request.setAttribute("doctor", doctor);
                    
                    request.getRequestDispatcher("confirm-appointment.jsp").forward(request, response);
                    return;
                }
            }

            Appointment appointment = new Appointment();
            appointment.setDoctorId(doctorId);
            appointment.setPatientId(patientId);
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setReason(reason);

            int appointmentId = dao.addAppointment(appointment);
            
            if (appointmentId > 0) {
                // Get doctor details for success page
                Doctor doctor = doctorDAO.getDoctorById(doctorId);
                
                // Set attributes for success page
                request.setAttribute("appointment", appointment);
                request.setAttribute("doctor", doctor);
                request.setAttribute("patientName", patient.getName());
                
                // Forward to success page
                request.getRequestDispatcher("appointment-success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to create appointment. Please try again.");
                request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
            }
        } catch (Exception e) { 
            e.printStackTrace();
            request.setAttribute("error", "Failed to add appointment: " + e.getMessage());
            request.getRequestDispatcher("addAppointment.jsp").forward(request, response);
        }
    }
}

