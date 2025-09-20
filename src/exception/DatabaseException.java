package exception;

/**
 * Custom exception for database-related errors
 */
public class DatabaseException extends Exception {
    
    private static final long serialVersionUID = 1L;
    
    public DatabaseException(String message) {
        super(message);
    }
    
    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }
}

