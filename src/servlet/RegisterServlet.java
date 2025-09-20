package servlet;

import dao.UserDAO;
import exception.DatabaseException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Basic validation
        if (username == null || password == null || role == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "All required fields must be filled.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password confirmation validation
        if (confirmPassword != null && !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Username length validation
        if (username.length() < 3) {
            request.setAttribute("error", "Username must be at least 3 characters long.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password strength validation
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        boolean success = false;
        try {
            UserDAO userDAO = new UserDAO();
            success = userDAO.createUser(username, password, role, firstName, lastName, email, phone);
        } catch (DatabaseException e) {
            String errorMessage = e.getMessage();
            if (errorMessage.contains("Duplicate entry") || errorMessage.contains("already exists")) {
                request.setAttribute("error", "Username '" + username + "' is already taken. Please choose a different username.");
            } else {
                request.setAttribute("error", "Registration failed: " + errorMessage);
            }
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            if (e.getMessage().contains("Duplicate entry") || e.getCause() != null && e.getCause().getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Username '" + username + "' is already taken. Please choose a different username.");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
            }
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (success) {
            response.sendRedirect("login.jsp?registered=true");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}

