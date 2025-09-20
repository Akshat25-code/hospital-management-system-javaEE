package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Security utility class for password hashing and validation
 * Implements BCrypt-style password hashing with salt
 */
public class SecurityUtil {
    
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Generates a random salt for password hashing
     * @return Base64 encoded salt
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Hashes a password with the provided salt
     * @param password Plain text password
     * @param salt Base64 encoded salt
     * @return Hashed password
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(Base64.getDecoder().decode(salt));
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }
    
    /**
     * Verifies a password against a stored hash
     * @param password Plain text password to verify
     * @param storedHash Stored password hash
     * @param salt Salt used for hashing
     * @return true if password matches
     */
    public static boolean verifyPassword(String password, String storedHash, String salt) {
        String hashedInput = hashPassword(password, salt);
        return hashedInput.equals(storedHash);
    }
    
    /**
     * Validates input to prevent XSS attacks
     * @param input User input to validate
     * @return Sanitized input
     */
    public static String sanitizeInput(String input) {
        if (input == null) return "";
        
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;")
                   .trim();
    }
    
    /**
     * Validates email format
     * @param email Email to validate
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email != null && email.matches(emailRegex);
    }
    
    /**
     * Validates phone number format
     * @param phone Phone number to validate
     * @return true if valid phone format
     */
    public static boolean isValidPhone(String phone) {
        String phoneRegex = "^[+]?[0-9]{10,15}$";
        return phone != null && phone.replaceAll("[\\s()-]", "").matches(phoneRegex);
    }
    
    /**
     * Generates CSRF token
     * @return Random CSRF token
     */
    public static String generateCSRFToken() {
        SecureRandom random = new SecureRandom();
        byte[] token = new byte[32];
        random.nextBytes(token);
        return Base64.getEncoder().encodeToString(token);
    }
}

