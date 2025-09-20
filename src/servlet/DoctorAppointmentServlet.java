package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
import model.Patient;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/doctor/my-appointments")
public class DoctorAppointmentServlet extends HttpServlet {
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
                response.sendRedirect("../error.jsp");
                return;
            }

            // Get appointments for this doctor
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            PatientDAO patientDAO = new PatientDAO();
            
            List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctorId(currentDoctor.getId());
            
            request.setAttribute("appointments", appointments);
            request.setAttribute("currentDoctor", currentDoctor);
            request.setAttribute("patientDAO", patientDAO);
            request.getRequestDispatcher("/doctor/my-appointments.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
