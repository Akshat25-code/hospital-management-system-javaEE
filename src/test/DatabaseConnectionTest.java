package test;

import util.DBUtil;
import java.sql.Connection;

/**
 * Simple test class to verify database connectivity
 */
public class DatabaseConnectionTest {
    
    public static void main(String[] args) {
        System.out.println("=== DATABASE CONNECTION TEST ===");
        
        try {
            // Check if DBUtil is initialized
            if (!DBUtil.isInitialized()) {
                System.err.println("❌ DBUtil initialization failed: " + DBUtil.getInitError());
                return;
            }
            
            System.out.println("✅ DBUtil initialized successfully");
            
            // Test connection
            Connection conn = DBUtil.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connection successful!");
                System.out.println("📊 Database URL: " + conn.getMetaData().getURL());
                System.out.println("🔧 Database Product: " + conn.getMetaData().getDatabaseProductName());
                conn.close();
                System.out.println("✅ Connection closed successfully");
            } else {
                System.err.println("❌ Database connection failed - connection is null or closed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Database connection test failed:");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            
            System.out.println("\n📋 TROUBLESHOOTING CHECKLIST:");
            System.out.println("1. ✅ MySQL server is running on localhost:3306");
            System.out.println("2. ✅ Database 'hospital_db' exists");
            System.out.println("3. ✅ User 'Hospital' exists with password 'Hospital'");
            System.out.println("4. ✅ User has proper permissions on hospital_db");
            System.out.println("5. ✅ db.properties file is in WEB-INF/classes/");
            System.out.println("6. ✅ MySQL Connector JAR is in WEB-INF/lib/");
        }
    }
}
