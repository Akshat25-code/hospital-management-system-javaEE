package servlet;

import dao.ConsultationTemplateDAO;
import model.ConsultationTemplate;
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

@WebServlet("/doctor/notes-templates")
public class ConsultationTemplateServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            ConsultationTemplateDAO dao = new ConsultationTemplateDAO(conn);
            List<ConsultationTemplate> templates = dao.getTemplatesByDoctorId(user.getId());
            request.setAttribute("templates", templates);
            request.getRequestDispatcher("/doctor/notes-templates.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            ConsultationTemplateDAO dao = new ConsultationTemplateDAO(conn);
            if ("add".equals(action)) {
                String templateName = request.getParameter("templateName");
                String templateContent = request.getParameter("templateContent");
                ConsultationTemplate template = new ConsultationTemplate(0, user.getId(), templateName, templateContent, new Date());
                dao.addTemplate(template);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteTemplate(id);
            }
            response.sendRedirect("notes-templates");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

