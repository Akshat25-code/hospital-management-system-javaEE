package servlet;

import dao.InventoryAlertDAO;
import model.InventoryAlert;
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

@WebServlet("/assistant/inventory-alerts")
public class InventoryAlertServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"assistant".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            InventoryAlertDAO dao = new InventoryAlertDAO(conn);
            List<InventoryAlert> alerts = dao.getAllAlerts();
            request.setAttribute("inventoryAlerts", alerts);
            request.getRequestDispatcher("/assistant/inventory-alerts.jsp").forward(request, response);
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
            InventoryAlertDAO dao = new InventoryAlertDAO(conn);
            if ("add".equals(action)) {
                String itemName = request.getParameter("itemName");
                int currentStock = Integer.parseInt(request.getParameter("currentStock"));
                int minimumStock = Integer.parseInt(request.getParameter("minimumStock"));
                String alertLevel = currentStock == 0 ? "Out of Stock" : (currentStock <= minimumStock ? "Critical" : "Low");
                InventoryAlert alert = new InventoryAlert(0, itemName, currentStock, minimumStock, alertLevel, new Date());
                dao.addAlert(alert);
            } else if ("updateStock".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int newStock = Integer.parseInt(request.getParameter("newStock"));
                dao.updateStock(id, newStock);
            }
            response.sendRedirect("inventory-alerts");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

