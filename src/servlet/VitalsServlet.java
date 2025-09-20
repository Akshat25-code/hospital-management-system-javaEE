package servlet;

import dao.PatientVitalDAO;
import model.PatientVital;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;

@WebServlet("/assistant/vitals")
public class VitalsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam != null) {
            try (Connection conn = DBUtil.getConnection()) {
                int patientId = Integer.parseInt(patientIdParam);
                PatientVitalDAO dao = new PatientVitalDAO(conn);
                List<PatientVital> vitals = dao.getVitalsByPatientId(patientId);
                request.setAttribute("patientVitals", vitals);
                request.setAttribute("patientId", patientId);
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }
        request.getRequestDispatcher("/assistant/vitals.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int systolic = Integer.parseInt(request.getParameter("systolic"));
            int diastolic = Integer.parseInt(request.getParameter("diastolic"));
            int heartRate = Integer.parseInt(request.getParameter("heartRate"));
            double temperature = Double.parseDouble(request.getParameter("temperature"));
            double weight = Double.parseDouble(request.getParameter("weight"));
            double height = Double.parseDouble(request.getParameter("height"));
            int oxygenSaturation = Integer.parseInt(request.getParameter("oxygenSaturation"));
            
            PatientVital vital = new PatientVital(0, patientId, user.getId(), systolic, diastolic, heartRate, temperature, weight, height, oxygenSaturation, new Date());
            PatientVitalDAO dao = new PatientVitalDAO(conn);
            dao.addVital(vital);
            response.sendRedirect("vitals?patientId=" + patientId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

