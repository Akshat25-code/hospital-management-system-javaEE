package servlet;

import dao.UserDAO;
import model.User;
import util.SecurityUtil;
import util.LoggerUtil;
import exception.ValidationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    private static final int MAX_LOGIN_ATTEMPTS = 3;
    private static final long LOCKOUT_DURATION = 15 * 60 * 1000; // 15 minutes
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        long startTime = System.currentTimeMillis();
        String clientIP = getClientIP(request);
        
        try {
            // Input validation and sanitization
            String username = SecurityUtil.sanitizeInput(request.getParameter("username"));
            String password = request.getParameter("password");
            String csrfToken = request.getParameter("csrfToken");
            
            // Validate inputs
            validateLoginInputs(username, password);
            
            // CSRF protection
            validateCSRFToken(request, csrfToken);
            
            // Check for account lockout
            if (isAccountLocked(request, username)) {
                LoggerUtil.logSecurityEvent("Account locked due to multiple failed attempts: " + username + " from IP: " + clientIP);
                request.setAttribute("error", "Account temporarily locked due to multiple failed login attempts. Please try again later.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Authenticate user
            UserDAO userDAO = new UserDAO();
            User user = userDAO.authenticateSecure(username, password);
            
            if (user != null) {
                // Reset failed attempts on successful login
                resetFailedAttempts(request, username);
                
                // Create secure session
                createSecureSession(request, response, user);
                
                LoggerUtil.logUserAction(username, "Successful login from IP: " + clientIP);
                response.sendRedirect("dashboard.jsp");
                
            } else {
                // Handle failed login
                handleFailedLogin(request, response, username, clientIP);
            }
            
        } catch (ValidationException e) {
            LoggerUtil.logWarning("Login validation failed: " + e.getMessage() + " from IP: " + clientIP);
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            LoggerUtil.logError("Login error", e);
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            long executionTime = System.currentTimeMillis() - startTime;
            LoggerUtil.logPerformance("LoginServlet.doPost", executionTime);
        }
    }
    
    private void validateLoginInputs(String username, String password) throws ValidationException {
        if (username == null || username.trim().isEmpty()) {
            throw new ValidationException("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new ValidationException("Password is required");
        }
        if (username.length() > 50) {
            throw new ValidationException("Username too long");
        }
        if (password.length() > 100) {
            throw new ValidationException("Password too long");
        }
    }
    
    private void validateCSRFToken(HttpServletRequest request, String csrfToken) throws ValidationException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String sessionToken = (String) session.getAttribute("csrfToken");
            if (sessionToken == null || !sessionToken.equals(csrfToken)) {
                throw new ValidationException("Invalid security token");
            }
        }
    }
    
    private boolean isAccountLocked(HttpServletRequest request, String username) {
        HttpSession session = request.getSession();
        String lockKey = "lockout_" + username;
        Long lockoutTime = (Long) session.getAttribute(lockKey);
        
        if (lockoutTime != null) {
            long currentTime = System.currentTimeMillis();
            if (currentTime - lockoutTime < LOCKOUT_DURATION) {
                return true;
            } else {
                // Lockout period expired, remove it
                session.removeAttribute(lockKey);
                session.removeAttribute("attempts_" + username);
            }
        }
        return false;
    }
    
    private void handleFailedLogin(HttpServletRequest request, HttpServletResponse response, 
                                 String username, String clientIP) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String attemptsKey = "attempts_" + username;
        Integer attempts = (Integer) session.getAttribute(attemptsKey);
        attempts = (attempts == null) ? 1 : attempts + 1;
        
        session.setAttribute(attemptsKey, attempts);
        
        LoggerUtil.logSecurityEvent("Failed login attempt " + attempts + " for user: " + username + " from IP: " + clientIP);
        
        if (attempts >= MAX_LOGIN_ATTEMPTS) {
            // Lock account
            session.setAttribute("lockout_" + username, System.currentTimeMillis());
            LoggerUtil.logSecurityEvent("Account locked for user: " + username + " after " + attempts + " failed attempts");
            request.setAttribute("error", "Account locked due to multiple failed attempts. Please try again after 15 minutes.");
        } else {
            int remainingAttempts = MAX_LOGIN_ATTEMPTS - attempts;
            request.setAttribute("error", "Invalid username or password. " + remainingAttempts + " attempts remaining.");
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    private void resetFailedAttempts(HttpServletRequest request, String username) {
        HttpSession session = request.getSession();
        session.removeAttribute("attempts_" + username);
        session.removeAttribute("lockout_" + username);
    }
    
    private void createSecureSession(HttpServletRequest request, HttpServletResponse response, User user) {
        HttpSession session = request.getSession(true);
        
        // Regenerate session ID to prevent session fixation
        session.invalidate();
        session = request.getSession(true);
        
        session.setAttribute("user", user);
        session.setAttribute("lastAccessTime", System.currentTimeMillis());
        session.setAttribute("creationTime", System.currentTimeMillis());
        
        // Set secure session cookie attributes
        Cookie sessionCookie = new Cookie("JSESSIONID", session.getId());
        sessionCookie.setHttpOnly(true);
        sessionCookie.setSecure(false); // Set to true in production with HTTPS
        sessionCookie.setMaxAge(-1); // Session cookie
        response.addCookie(sessionCookie);
    }
    
    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Generate CSRF token for login form
        HttpSession session = request.getSession(true);
        String csrfToken = SecurityUtil.generateCSRFToken();
        session.setAttribute("csrfToken", csrfToken);
        
        response.sendRedirect("login.jsp");
    }
}

