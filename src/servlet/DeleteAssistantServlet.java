package servlet;

import dao.AssistantDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteAssistantServlet")
public class DeleteAssistantServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AssistantDAO dao = new AssistantDAO();
        dao.deleteAssistant(id);
        response.sendRedirect("AssistantListServlet");
    }
}

