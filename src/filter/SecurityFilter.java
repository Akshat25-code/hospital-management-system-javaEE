package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Security filter for session management and security headers
 */
@WebFilter("/*")
public class SecurityFilter implements Filter {
    
    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Add security headers
        addSecurityHeaders(httpResponse);
        
        // Check session timeout
        checkSessionTimeout(httpRequest, httpResponse);
        
        chain.doFilter(request, response);
    }
    
    private void addSecurityHeaders(HttpServletResponse response) {
        // Prevent XSS attacks
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        
        // HTTPS enforcement (in production)
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        // Content Security Policy
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
            "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; " +
            "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; " +
            "img-src 'self' data:;");
    }
    
    private void checkSessionTimeout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String uri = request.getRequestURI();
        
        // Skip timeout check for login page and static resources
        if (uri.contains("login.jsp") || uri.contains("LoginServlet") || 
            uri.contains(".css") || uri.contains(".js") || uri.contains(".png") || 
            uri.contains(".jpg") || uri.contains(".ico")) {
            return;
        }
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Set session timeout
            session.setMaxInactiveInterval(SESSION_TIMEOUT);
            
            // Check if session has expired
            long currentTime = System.currentTimeMillis();
            Long lastAccessTime = (Long) session.getAttribute("lastAccessTime");
            
            if (lastAccessTime != null && 
                (currentTime - lastAccessTime) > (SESSION_TIMEOUT * 1000)) {
                session.invalidate();
                response.sendRedirect("login.jsp?error=session_expired");
                return;
            }
            
            // Update last access time
            session.setAttribute("lastAccessTime", currentTime);
        }
    }
    
    @Override
    public void destroy() {
        // Filter cleanup
    }
}

