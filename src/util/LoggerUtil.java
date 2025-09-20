package util;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

/**
 * Centralized logging utility for the Hospital Management System
 */
public class LoggerUtil {
    
    private static final String LOG_FILE = "hospital_management.log";
    private static Logger logger;
    
    static {
        try {
            logger = Logger.getLogger("HospitalManagement");
            FileHandler fileHandler = new FileHandler(LOG_FILE, true);
            fileHandler.setFormatter(new SimpleFormatter());
            logger.addHandler(fileHandler);
            logger.setLevel(Level.ALL);
        } catch (IOException e) {
            System.err.println("Failed to initialize logger: " + e.getMessage());
            logger = Logger.getLogger("HospitalManagement");
        }
    }
    
    public static void logInfo(String message) {
        logger.info(message);
    }
    
    public static void logWarning(String message) {
        logger.warning(message);
    }
    
    public static void logError(String message, Throwable throwable) {
        logger.log(Level.SEVERE, message, throwable);
    }
    
    public static void logDebug(String message) {
        logger.fine(message);
    }
    
    public static void logUserAction(String username, String action) {
        logInfo("USER_ACTION: " + username + " performed: " + action);
    }
    
    public static void logSecurityEvent(String event) {
        logWarning("SECURITY_EVENT: " + event);
    }
    
    public static void logPerformance(String operation, long executionTime) {
        logInfo("PERFORMANCE: " + operation + " executed in " + executionTime + "ms");
    }
}

