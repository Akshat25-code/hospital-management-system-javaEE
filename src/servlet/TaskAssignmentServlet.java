package servlet;

import dao.TaskAssignmentDAO;
import model.TaskAssignment;
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

@WebServlet("/assistant/tasks")
public class TaskAssignmentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            TaskAssignmentDAO dao = new TaskAssignmentDAO(conn);
            List<TaskAssignment> tasks = dao.getTasksByAssignedTo(user.getId());
            request.setAttribute("tasks", tasks);
            request.getRequestDispatcher("/assistant/tasks.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            TaskAssignmentDAO dao = new TaskAssignmentDAO(conn);
            if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                dao.updateTaskStatus(id, status);
            }
            response.sendRedirect("tasks");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

