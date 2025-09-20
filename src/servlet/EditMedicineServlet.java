package servlet;

import dao.MedicineDAO;
import model.Medicine;
import util.LoggerUtil;
import exception.ValidationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditMedicineServlet")
public class EditMedicineServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errors = new ArrayList<>();
        
        try {
            // Get and validate parameters
            int id = validateId(request.getParameter("id"), errors);
            String name = validateName(request.getParameter("name"), errors);
            String manufacturer = validateManufacturer(request.getParameter("manufacturer"), errors);
            double price = validatePrice(request.getParameter("price"), errors);
            int quantity = validateQuantity(request.getParameter("quantity"), errors);

            // If validation errors exist, redirect back with errors
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("id", request.getParameter("id"));
                request.setAttribute("name", request.getParameter("name"));
                request.setAttribute("manufacturer", request.getParameter("manufacturer"));
                request.setAttribute("price", request.getParameter("price"));
                request.setAttribute("quantity", request.getParameter("quantity"));
                
                LoggerUtil.logError("Medicine validation failed: " + String.join(", ", errors), null);
                request.getRequestDispatcher("editMedicine.jsp").forward(request, response);
                return;
            }

            // Create and update medicine
            Medicine medicine = new Medicine();
            medicine.setId(id);
            medicine.setName(name);
            medicine.setManufacturer(manufacturer);
            medicine.setPrice(price);
            medicine.setQuantity(quantity);

            MedicineDAO dao = new MedicineDAO();
            dao.updateMedicine(medicine);
            
            LoggerUtil.logInfo("Medicine updated successfully: " + name + " (ID: " + id + ")");
            request.getSession().setAttribute("successMessage", "Medicine updated successfully!");
            response.sendRedirect("MedicineListServlet");
            
        } catch (Exception e) {
            LoggerUtil.logError("Error updating medicine", e);
            errors.add("An unexpected error occurred. Please try again.");
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("editMedicine.jsp").forward(request, response);
        }
    }
    
    private int validateId(String idStr, List<String> errors) {
        if (idStr == null || idStr.trim().isEmpty()) {
            errors.add("Medicine ID is required");
            return 0;
        }
        
        try {
            int id = Integer.parseInt(idStr.trim());
            
            if (id <= 0) {
                errors.add("Medicine ID must be a positive number");
            }
            
            return id;
        } catch (NumberFormatException e) {
            errors.add("Medicine ID must be a valid number");
            return 0;
        }
    }
    
    private String validateName(String name, List<String> errors) {
        if (name == null || name.trim().isEmpty()) {
            errors.add("Medicine name is required");
            return "";
        }
        
        name = name.trim();
        
        if (name.length() < 2) {
            errors.add("Medicine name must be at least 2 characters long");
        }
        
        if (name.length() > 100) {
            errors.add("Medicine name must be less than 100 characters");
        }
        
        if (!name.matches("^[a-zA-Z0-9\\s.\\-\\(\\)]+$")) {
            errors.add("Medicine name can only contain letters, numbers, spaces, periods, hyphens, and parentheses");
        }
        
        return name;
    }
    
    private String validateManufacturer(String manufacturer, List<String> errors) {
        if (manufacturer == null || manufacturer.trim().isEmpty()) {
            errors.add("Manufacturer is required");
            return "";
        }
        
        manufacturer = manufacturer.trim();
        
        if (manufacturer.length() < 2) {
            errors.add("Manufacturer name must be at least 2 characters long");
        }
        
        if (manufacturer.length() > 100) {
            errors.add("Manufacturer name must be less than 100 characters");
        }
        
        if (!manufacturer.matches("^[a-zA-Z0-9\\s.\\-&,]+$")) {
            errors.add("Manufacturer name can only contain letters, numbers, spaces, periods, hyphens, ampersands, and commas");
        }
        
        return manufacturer;
    }
    
    private double validatePrice(String priceStr, List<String> errors) {
        if (priceStr == null || priceStr.trim().isEmpty()) {
            errors.add("Price is required");
            return 0.0;
        }
        
        try {
            double price = Double.parseDouble(priceStr.trim());
            
            if (price < 0) {
                errors.add("Price cannot be negative");
            } else if (price > 999999.99) {
                errors.add("Price cannot exceed $999,999.99");
            }
            
            // Check for reasonable decimal places (max 2)
            String[] parts = priceStr.trim().split("\\.");
            if (parts.length > 1 && parts[1].length() > 2) {
                errors.add("Price can have at most 2 decimal places");
            }
            
            return price;
        } catch (NumberFormatException e) {
            errors.add("Price must be a valid number");
            return 0.0;
        }
    }
    
    private int validateQuantity(String quantityStr, List<String> errors) {
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            errors.add("Quantity is required");
            return 0;
        }
        
        try {
            int quantity = Integer.parseInt(quantityStr.trim());
            
            if (quantity < 0) {
                errors.add("Quantity cannot be negative");
            } else if (quantity > 999999) {
                errors.add("Quantity cannot exceed 999,999");
            }
            
            return quantity;
        } catch (NumberFormatException e) {
            errors.add("Quantity must be a valid number");
            return 0;
        }
    }
}

