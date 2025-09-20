package servlet;

import dao.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/EditAppointmentServlet")
public class EditAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String dateStr = request.getParameter("date");
            String time = request.getParameter("time");
            String reason = request.getParameter("reason");
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);

            Appointment appointment = new Appointment();
            appointment.setId(id);
            appointment.setDoctorId(doctorId);
            appointment.setPatientId(patientId);
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setReason(reason);

            AppointmentDAO dao = new AppointmentDAO();
            dao.updateAppointment(appointment);
            
            // Success - redirect to appointment list servlet
            response.sendRedirect("AppointmentListServlet");
        } catch (Exception e) { 
            e.printStackTrace();
            request.setAttribute("error", "Failed to update appointment: " + e.getMessage());
            request.getRequestDispatcher("LoadEditAppointmentServlet?id=" + request.getParameter("id")).forward(request, response);
        }
    }
}

