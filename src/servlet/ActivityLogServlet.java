package servlet;

import dao.ActivityLogDAO;
import model.ActivityLog;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/activity-logs")
public class ActivityLogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            ActivityLogDAO dao = new ActivityLogDAO(conn);
            List<ActivityLog> logs = dao.getAllActivityLogs();
            request.setAttribute("activityLogs", logs);
            request.getRequestDispatcher("/admin/activity-logs.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

