package servlet;

import dao.AssistantDAO;
import model.Assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddAssistantServlet")
public class AddAssistantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Assistant assistant = new Assistant();
        assistant.setName(name);
        assistant.setEmail(email);
        assistant.setPhone(phone);

        AssistantDAO dao = new AssistantDAO();
        dao.addAssistant(assistant);

        response.sendRedirect("AssistantListServlet");
    }
}

