package servlet;

import dao.LabTestDAO;
import model.LabTest;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/patient/lab-tests")
public class LabTestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            LabTestDAO testDAO = new LabTestDAO(conn);
            List<LabTest> tests = testDAO.getLabTestsByPatientId(user.getId());
            request.setAttribute("labTests", tests);
            request.getRequestDispatcher("/patient/lab-tests.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

