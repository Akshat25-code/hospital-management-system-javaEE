package servlet;

import dao.PatientDAO;
import model.Patient;
import util.LoggerUtil;
import exception.ValidationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddPatientServlet")
public class AddPatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errors = new ArrayList<>();
        
        try {
            // Get and validate parameters
            String name = validateName(request.getParameter("name"), errors);
            int age = validateAge(request.getParameter("age"), errors);
            String gender = validateGender(request.getParameter("gender"), errors);
            String address = validateAddress(request.getParameter("address"), errors);
            String phone = validatePhone(request.getParameter("phone"), errors);

            // If validation errors exist, redirect back with errors
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("name", request.getParameter("name"));
                request.setAttribute("age", request.getParameter("age"));
                request.setAttribute("gender", request.getParameter("gender"));
                request.setAttribute("address", request.getParameter("address"));
                request.setAttribute("phone", request.getParameter("phone"));
                
                LoggerUtil.logError("Patient validation failed: " + String.join(", ", errors), null);
                request.getRequestDispatcher("addPatient.jsp").forward(request, response);
                return;
            }

            // Create and save patient
            Patient patient = new Patient();
            patient.setName(name);
            patient.setAge(age);
            patient.setGender(gender);
            patient.setAddress(address);
            patient.setPhone(phone);

            PatientDAO dao = new PatientDAO();
            dao.addPatient(patient);
            
            LoggerUtil.logInfo("Patient added successfully: " + name);
            request.getSession().setAttribute("successMessage", "Patient added successfully!");
            response.sendRedirect("PatientListServlet");
            
        } catch (Exception e) {
            LoggerUtil.logError("Error adding patient", e);
            errors.add("An unexpected error occurred. Please try again.");
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("addPatient.jsp").forward(request, response);
        }
    }
    
    private String validateName(String name, List<String> errors) {
        if (name == null || name.trim().isEmpty()) {
            errors.add("Patient name is required");
            return "";
        }
        
        name = name.trim();
        
        if (name.length() < 2) {
            errors.add("Patient name must be at least 2 characters long");
        }
        
        if (name.length() > 100) {
            errors.add("Patient name must be less than 100 characters");
        }
        
        if (!name.matches("^[a-zA-Z\\s.'-]+$")) {
            errors.add("Patient name can only contain letters, spaces, periods, apostrophes, and hyphens");
        }
        
        return name;
    }
    
    private int validateAge(String ageStr, List<String> errors) {
        if (ageStr == null || ageStr.trim().isEmpty()) {
            errors.add("Age is required");
            return 0;
        }
        
        try {
            int age = Integer.parseInt(ageStr.trim());
            
            if (age < 0) {
                errors.add("Age cannot be negative");
            } else if (age > 150) {
                errors.add("Age cannot be greater than 150");
            }
            
            return age;
        } catch (NumberFormatException e) {
            errors.add("Age must be a valid number");
            return 0;
        }
    }
    
    private String validateGender(String gender, List<String> errors) {
        if (gender == null || gender.trim().isEmpty()) {
            errors.add("Gender is required");
            return "";
        }
        
        gender = gender.trim();
        
        if (!gender.equalsIgnoreCase("Male") && 
            !gender.equalsIgnoreCase("Female") && 
            !gender.equalsIgnoreCase("Other")) {
            errors.add("Gender must be Male, Female, or Other");
        }
        
        return gender;
    }
    
    private String validateAddress(String address, List<String> errors) {
        if (address != null) {
            address = address.trim();
            
            if (address.length() > 500) {
                errors.add("Address must be less than 500 characters");
            }
        }
        
        return address;
    }
    
    private String validatePhone(String phone, List<String> errors) {
        if (phone != null && !phone.trim().isEmpty()) {
            phone = phone.trim();
            
            // Remove common formatting characters
            String cleanPhone = phone.replaceAll("[\\s\\-\\(\\)\\+]", "");
            
            if (!cleanPhone.matches("^[0-9]{10,15}$")) {
                errors.add("Phone number must be 10-15 digits");
            }
        }
        
        return phone;
    }
}

