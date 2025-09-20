package server;

import java.io.*;
import java.net.*;
import java.nio.file.*;
import java.util.concurrent.*;
import com.sun.net.httpserver.*;
import java.util.Date;

/**
 * Simple HTTP Server for Hospital Management System
 * Serves static files and forwards servlet requests
 */
public class SimpleHospitalServer {
    
    private static final int PORT = 8080;
    private static final String WEB_ROOT = "WebContent";
    private static HttpServer server;
    
    public static void main(String[] args) {
        try {
            startServer();
        } catch (Exception e) {
            System.err.println("Failed to start server: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void startServer() throws IOException {
        server = HttpServer.create(new InetSocketAddress(PORT), 0);
        
        // Static file handler
        server.createContext("/", new StaticFileHandler());
        server.createContext("/hospital/", new StaticFileHandler());
        
        // Set executor
        server.setExecutor(Executors.newFixedThreadPool(10));
        
        // Start server
        server.start();
        
        System.out.println("🚀 Hospital Management System Server Started!");
        System.out.println("📍 URL: http://localhost:" + PORT + "/");
        System.out.println("📍 Direct: http://localhost:" + PORT + "/index.jsp");
        System.out.println("🔧 Web Root: " + new File(WEB_ROOT).getAbsolutePath());
        System.out.println("⚠️  Note: This is a development server. For production, use Tomcat.");
        System.out.println("🛑 Press Ctrl+C to stop the server");
        
        // Keep server running
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("\n🛑 Shutting down server...");
            server.stop(0);
            System.out.println("✅ Server stopped.");
        }));
        
        // Keep main thread alive
        try {
            Thread.currentThread().join();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
    
    static class StaticFileHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String path = exchange.getRequestURI().getPath();
            
            // Default to index.jsp
            if (path.equals("/") || path.equals("/hospital/")) {
                path = "/index.jsp";
            }
            
            // Remove /hospital prefix if present
            if (path.startsWith("/hospital/")) {
                path = path.substring(9);
            }
            
            File file = new File(WEB_ROOT, path);
            
            if (file.exists() && file.isFile()) {
                serveFile(exchange, file);
            } else {
                // Try with .jsp extension if not found
                if (!path.endsWith(".jsp") && !path.contains(".")) {
                    File jspFile = new File(WEB_ROOT, path + ".jsp");
                    if (jspFile.exists()) {
                        serveFile(exchange, jspFile);
                        return;
                    }
                }
                
                // File not found
                String response = "<!DOCTYPE html><html><head><title>Hospital Management System</title></head><body>" +
                    "<h1>🏥 Hospital Management System</h1>" +
                    "<h2>File not found: " + path + "</h2>" +
                    "<p><a href='/index.jsp'>🏠 Go to Home Page</a></p>" +
                    "<hr><p>Available pages:</p><ul>" +
                    "<li><a href='/index.jsp'>Home</a></li>" +
                    "<li><a href='/login.jsp'>Login</a></li>" +
                    "<li><a href='/dashboard.jsp'>Dashboard</a></li>" +
                    "</ul></body></html>";
                
                exchange.sendResponseHeaders(404, response.getBytes().length);
                try (OutputStream os = exchange.getResponseBody()) {
                    os.write(response.getBytes());
                }
            }
        }
        
        private void serveFile(HttpExchange exchange, File file) throws IOException {
            String contentType = getContentType(file.getName());
            exchange.getResponseHeaders().set("Content-Type", contentType);
            
            try {
                byte[] fileBytes = Files.readAllBytes(file.toPath());
                exchange.sendResponseHeaders(200, fileBytes.length);
                
                try (OutputStream os = exchange.getResponseBody()) {
                    os.write(fileBytes);
                }
                
                System.out.println("📄 Served: " + file.getName() + " (" + fileBytes.length + " bytes)");
                
            } catch (IOException e) {
                String errorResponse = "Error reading file: " + e.getMessage();
                exchange.sendResponseHeaders(500, errorResponse.getBytes().length);
                try (OutputStream os = exchange.getResponseBody()) {
                    os.write(errorResponse.getBytes());
                }
            }
        }
        
        private String getContentType(String fileName) {
            if (fileName.endsWith(".html") || fileName.endsWith(".htm")) {
                return "text/html; charset=utf-8";
            } else if (fileName.endsWith(".jsp")) {
                return "text/html; charset=utf-8";
            } else if (fileName.endsWith(".css")) {
                return "text/css";
            } else if (fileName.endsWith(".js")) {
                return "application/javascript";
            } else if (fileName.endsWith(".json")) {
                return "application/json";
            } else if (fileName.endsWith(".png")) {
                return "image/png";
            } else if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
                return "image/jpeg";
            } else if (fileName.endsWith(".gif")) {
                return "image/gif";
            } else {
                return "text/plain";
            }
        }
    }
}

