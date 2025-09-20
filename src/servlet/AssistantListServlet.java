package servlet;

import dao.AssistantDAO;
import model.Assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AssistantListServlet")
public class AssistantListServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AssistantDAO assistantDAO = new AssistantDAO();
            List<Assistant> assistants = assistantDAO.getAllAssistants();
            
            // Set attributes for JSP
            request.setAttribute("assistants", assistants);
            
            // Forward to assistants.jsp
            request.getRequestDispatcher("assistants.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load assistants: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
