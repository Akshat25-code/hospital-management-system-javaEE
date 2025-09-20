package servlet;

import dao.AssistantDAO;
import model.Assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EditAssistantServlet")
public class EditAssistantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age"));
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");

        Assistant assistant = new Assistant();
        assistant.setId(id);
        assistant.setName(name);
        assistant.setAge(age);
        assistant.setGender(gender);
        assistant.setPhone(phone);

        AssistantDAO dao = new AssistantDAO();
        dao.updateAssistant(assistant);

        response.sendRedirect("AssistantListServlet");
    }
}

