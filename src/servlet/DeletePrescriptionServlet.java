package servlet;

import dao.PrescriptionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeletePrescriptionServlet")
public class DeletePrescriptionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PrescriptionDAO dao = new PrescriptionDAO();
        dao.deletePrescription(id);
        response.sendRedirect("PrescriptionListServlet");
    }
}

