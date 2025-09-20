package servlet;

import dao.HealthTimelineEventDAO;
import model.HealthTimelineEvent;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/patient/health-timeline")
public class HealthTimelineServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            HealthTimelineEventDAO dao = new HealthTimelineEventDAO(conn);
            List<HealthTimelineEvent> events = dao.getEventsByPatientId(user.getId());
            request.setAttribute("timelineEvents", events);
            request.getRequestDispatcher("/patient/health-timeline.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

