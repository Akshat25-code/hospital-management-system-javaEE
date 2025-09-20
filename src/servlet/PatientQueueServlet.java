package servlet;

import dao.PatientQueueDAO;
import model.PatientQueue;
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

@WebServlet("/assistant/queue")
public class PatientQueueServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            PatientQueueDAO dao = new PatientQueueDAO(conn);
            List<PatientQueue> queue = dao.getCurrentQueue();
            request.setAttribute("patientQueue", queue);
            request.getRequestDispatcher("/assistant/queue.jsp").forward(request, response);
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
            PatientQueueDAO dao = new PatientQueueDAO(conn);
            if ("add".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                int queueNumber = dao.getNextQueueNumber();
                PatientQueue pq = new PatientQueue(0, patientId, doctorId, queueNumber, "Waiting", new Date(), null);
                dao.addToQueue(pq);
            } else if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                dao.updateQueueStatus(id, status);
            }
            response.sendRedirect("queue");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

