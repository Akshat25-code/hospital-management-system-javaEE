package servlet;

import dao.MedicalReportDAO;
import model.MedicalReport;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/patient/medical-reports")
public class MedicalReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            MedicalReportDAO reportDAO = new MedicalReportDAO(conn);
            List<MedicalReport> reports = reportDAO.getReportsByPatientId(user.getId());
            request.setAttribute("reports", reports);
            request.getRequestDispatcher("/patient/medical-reports.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

