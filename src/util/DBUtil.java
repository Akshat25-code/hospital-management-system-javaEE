package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {
    private static String url;
    private static String username;
    private static String password;
    private static boolean initialized = false;
    private static String initError = null;

    static {
        try {
            Properties props = new Properties();
            InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            
            if (in == null) {
                throw new RuntimeException("db.properties file not found in classpath. Please ensure db.properties is in WEB-INF/classes/");
            }
            
            props.load(in);
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
            
            if (url == null || username == null || password == null) {
                throw new RuntimeException("Database configuration incomplete. Check db.properties file.");
            }
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            initialized = true;
            
            System.out.println("Database configuration loaded successfully:");
            System.out.println("URL: " + url);
            System.out.println("Username: " + username);
            
        } catch (Exception e) {
            initError = e.getMessage();
            e.printStackTrace();
            System.err.println("FATAL: Database initialization failed: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws Exception {
        if (!initialized) {
            throw new Exception("Database not initialized: " + initError);
        }
        
        if (url == null) {
            throw new Exception("Database URL is null. Check db.properties configuration.");
        }
        
        return DriverManager.getConnection(url, username, password);
    }
    
    public static boolean isInitialized() {
        return initialized;
    }
    
    public static String getInitError() {
        return initError;
    }
}

