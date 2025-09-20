package servlet;

import dao.UserRoleDAO;
import model.UserRole;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/role-management")
public class RoleManagementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            UserRoleDAO dao = new UserRoleDAO(conn);
            List<UserRole> roles = dao.getAllRoles();
            request.setAttribute("userRoles", roles);
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            UserRoleDAO dao = new UserRoleDAO(conn);
            if ("add".equals(action)) {
                String roleName = request.getParameter("roleName");
                String permissions = request.getParameter("permissions");
                UserRole role = new UserRole(0, roleName, permissions, new java.util.Date());
                dao.addRole(role);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String roleName = request.getParameter("roleName");
                String permissions = request.getParameter("permissions");
                UserRole role = new UserRole(id, roleName, permissions, null);
                dao.updateRole(role);
            }
            response.sendRedirect("role-management");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

