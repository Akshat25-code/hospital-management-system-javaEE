package servlet;

import dao.PrescriptionRefillRequestDAO;
import model.PrescriptionRefillRequest;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;

@WebServlet("/patient/prescription-refill")
public class PrescriptionRefillServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            PrescriptionRefillRequestDAO dao = new PrescriptionRefillRequestDAO(conn);
            List<PrescriptionRefillRequest> requests = dao.getRequestsByPatientId(user.getId());
            request.setAttribute("refillRequests", requests);
            request.getRequestDispatcher("/patient/prescription-refill.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        int prescriptionId = Integer.parseInt(request.getParameter("prescriptionId"));
        try (Connection conn = DBUtil.getConnection()) {
            PrescriptionRefillRequest req = new PrescriptionRefillRequest(0, user.getId(), prescriptionId, new Date(), "Pending");
            PrescriptionRefillRequestDAO dao = new PrescriptionRefillRequestDAO(conn);
            dao.addRequest(req);
            response.sendRedirect("prescription-refill");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

