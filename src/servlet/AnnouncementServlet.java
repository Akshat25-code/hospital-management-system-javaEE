package servlet;

import dao.SystemAnnouncementDAO;
import model.SystemAnnouncement;
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

@WebServlet("/admin/announcements")
public class AnnouncementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            SystemAnnouncementDAO dao = new SystemAnnouncementDAO(conn);
            List<SystemAnnouncement> announcements = dao.getAllAnnouncements();
            request.setAttribute("announcements", announcements);
            request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            SystemAnnouncementDAO dao = new SystemAnnouncementDAO(conn);
            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                SystemAnnouncement announcement = new SystemAnnouncement(0, title, content, user.getId(), new Date(), true);
                dao.addAnnouncement(announcement);
            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                dao.updateAnnouncementStatus(id, !active);
            }
            response.sendRedirect("announcements");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

