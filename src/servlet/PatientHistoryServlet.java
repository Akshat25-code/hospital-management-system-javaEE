package servlet;

import dao.PatientHistoryDAO;
import model.PatientHistory;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/doctor/patient-history")
public class PatientHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        try (Connection conn = DBUtil.getConnection()) {
            PatientHistoryDAO dao = new PatientHistoryDAO(conn);
            List<PatientHistory> history = dao.getHistoryByPatientId(patientId);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/doctor/patient-history.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

