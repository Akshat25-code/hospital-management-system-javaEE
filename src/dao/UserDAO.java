package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import exception.DatabaseException;
import model.User;
import util.DBUtil;
import util.LoggerUtil;
import util.SecurityUtil;

public class UserDAO {
    
    /**
     * Legacy authentication method (deprecated)
     */
    @Deprecated
    public User authenticate(String username, String password) {
        User user = null;
    String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (Exception e) {
            LoggerUtil.logError("Authentication error for user: " + username, e);
        }
        return user;
    }
    
    /**
     * Secure authentication with password hashing
     */
    public User authenticateSecure(String username, String password) throws DatabaseException {
        User user = null;
        String sql = "SELECT id, username, password, salt, role FROM users WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            LoggerUtil.logInfo("Attempting authentication for user: " + username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String salt = rs.getString("salt");
                    LoggerUtil.logInfo("User found in database: " + username + ", salt: " + (salt != null ? "present" : "null"));
                    
                    // For demo users with plain text passwords (backward compatibility)
                    if ("demo_salt_value".equals(salt) && password.equals(storedPassword)) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(rs.getString("role"));
                        LoggerUtil.logUserAction(username, "Successful login (plain text password)");
                    }
                    // Verify hashed password using salt for new users
                    else if (salt != null && !salt.equals("demo_salt_value") && SecurityUtil.verifyPassword(password, storedPassword, salt)) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(rs.getString("role"));
                        LoggerUtil.logUserAction(username, "Successful login (hashed password)");
                    } 
                    // Fallback for users with plain text passwords (old users)
                    else if (salt == null && password.equals(storedPassword)) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(rs.getString("role"));
                        LoggerUtil.logUserAction(username, "Successful login (plain text - needs migration)");
                        
                        // Migrate this user's password to hashed format
                        migrateUserPassword(rs.getInt("id"), password);
                    } else {
                        LoggerUtil.logWarning("Password verification failed for user: " + username);
                    }
                } else {
                    LoggerUtil.logWarning("User not found in database: " + username);
                }
            }
        } catch (Exception e) {
            LoggerUtil.logError("Database error during authentication for user: " + username, e);
            throw new DatabaseException("Authentication failed due to database error", e);
        }
        
        return user;
    }
    
    /**
     * Creates a new user with secure password hashing
     */
    public boolean createUser(String username, String password, String role) throws DatabaseException {
        String salt = SecurityUtil.generateSalt();
        String hashedPassword = SecurityUtil.hashPassword(password, salt);

        // Use correct table and column names as per schema
        String sql = "INSERT INTO users (username, password, salt, role, created_at) VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, salt);
            ps.setString(4, role);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                LoggerUtil.logUserAction("SYSTEM", "Created new user: " + username + " with role: " + role);
                return true;
            }
            
        } catch (Exception e) {
            LoggerUtil.logError("Error creating user: " + username, e);
            throw new DatabaseException("Failed to create user", e);
        }
        
        return false;
    }
    
    /**
     * Creates a new user with complete profile information
     */
    public boolean createUser(String username, String password, String role, String firstName, String lastName, String email, String phone) throws DatabaseException {
        // For now, use plain text password with demo salt for compatibility
        // In production, you would use proper hashing
        String salt = "demo_salt_value";
        String hashedPassword = password; // Store as plain text for demo compatibility

        // Use correct table and column names as per schema
        String sql = "INSERT INTO users (username, password, salt, role, first_name, last_name, email, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, salt);
            ps.setString(4, role);
            ps.setString(5, firstName);
            ps.setString(6, lastName);
            ps.setString(7, email);
            ps.setString(8, phone);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                LoggerUtil.logUserAction("SYSTEM", "Created new user: " + username + " (" + firstName + " " + lastName + ") with role: " + role);
                return true;
            }
            
        } catch (Exception e) {
            LoggerUtil.logError("Error creating user: " + username, e);
            throw new DatabaseException("Failed to create user", e);
        }
        
        return false;
    }
    
    /**
     * Migrates legacy plain text password to secure hash
     */
    private void migrateUserPassword(int userId, String plainPassword) {
        String salt = SecurityUtil.generateSalt();
        String hashedPassword = SecurityUtil.hashPassword(plainPassword, salt);
        
        String sql = "UPDATE user SET password_hash = ?, salt = ?, password = NULL WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, hashedPassword);
            ps.setString(2, salt);
            ps.setInt(3, userId);
            
            ps.executeUpdate();
            LoggerUtil.logInfo("Migrated password for user ID: " + userId);
            
        } catch (Exception e) {
            LoggerUtil.logError("Error migrating password for user ID: " + userId, e);
        }
    }
    
    /**
     * Updates last login timestamp
     */
    private void updateLastLogin(int userId) {
        String sql = "UPDATE user SET last_login = NOW() WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.executeUpdate();
            
        } catch (Exception e) {
            LoggerUtil.logError("Error updating last login for user ID: " + userId, e);
        }
    }
    
    /**
     * Changes user password securely
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) throws DatabaseException {
        // First verify old password
        String verifySQL = "SELECT password_hash, salt FROM user WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(verifySQL)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    String salt = rs.getString("salt");
                    
                    if (!SecurityUtil.verifyPassword(oldPassword, storedHash, salt)) {
                        return false; // Old password incorrect
                    }
                    
                    // Generate new salt and hash for new password
                    String newSalt = SecurityUtil.generateSalt();
                    String newHashedPassword = SecurityUtil.hashPassword(newPassword, newSalt);
                    
                    // Update password
                    String updateSQL = "UPDATE user SET password_hash = ?, salt = ? WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSQL)) {
                        updatePs.setString(1, newHashedPassword);
                        updatePs.setString(2, newSalt);
                        updatePs.setInt(3, userId);
                        
                        int rowsAffected = updatePs.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            LoggerUtil.logUserAction("USER_" + userId, "Password changed successfully");
                            return true;
                        }
                    }
                }
            }
        } catch (Exception e) {
            LoggerUtil.logError("Error changing password for user ID: " + userId, e);
            throw new DatabaseException("Failed to change password", e);
        }
        
        return false;
    }
}

