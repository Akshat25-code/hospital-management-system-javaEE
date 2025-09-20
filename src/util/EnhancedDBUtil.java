package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Enhanced Database Utility with Connection Pooling and H2 Fallback
 * Optimized for high-performance testing and production environments
 */
public class EnhancedDBUtil {
    
    // Connection pool configuration
    private static final int MAX_POOL_SIZE = 20;
    private static final int MIN_POOL_SIZE = 5;
    private static final long CONNECTION_TIMEOUT = 30000; // 30 seconds
    
    // Connection pools
    private static final BlockingQueue<Connection> connectionPool = new LinkedBlockingQueue<>();
    private static final ConcurrentHashMap<Connection, Long> connectionTimestamps = new ConcurrentHashMap<>();
    private static final AtomicInteger activeConnections = new AtomicInteger(0);
    
    // Database configuration
    private static String primaryDbUrl = "jdbc:mysql://localhost:3306/hospital_db";
    private static String primaryDbUser = "root";
    private static String primaryDbPassword = "root";
    
    // H2 fallback configuration
    private static final String fallbackDbUrl = "jdbc:h2:mem:hospital_test;DB_CLOSE_DELAY=-1;MODE=MySQL";
    private static final String fallbackDbUser = "sa";
    private static final String fallbackDbPassword = "";
    
    private static boolean useFallbackMode = false;
    private static boolean poolInitialized = false;
    
    static {
        try {
            // Load database drivers
            Class.forName("com.mysql.cj.jdbc.Driver");
            Class.forName("org.h2.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Database drivers not found: " + e.getMessage());
        }
    }
    
    /**
     * Get a database connection with automatic fallback to H2
     */
    public static Connection getConnection() throws SQLException {
        if (!poolInitialized) {
            initializeConnectionPool();
        }
        
        try {
            Connection conn = connectionPool.poll();
            if (conn != null && !conn.isClosed()) {
                connectionTimestamps.put(conn, System.currentTimeMillis());
                return conn;
            }
        } catch (SQLException e) {
            // Connection might be stale, create a new one
        }
        
        return createNewConnection();
    }
    
    /**
     * Return a connection to the pool
     */
    public static void returnConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed() && !conn.getAutoCommit()) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
                
                if (connectionPool.size() < MAX_POOL_SIZE) {
                    connectionPool.offer(conn);
                } else {
                    conn.close();
                    activeConnections.decrementAndGet();
                }
                
                connectionTimestamps.remove(conn);
            } catch (SQLException e) {
                System.err.println("Error returning connection to pool: " + e.getMessage());
            }
        }
    }
    
    /**
     * Initialize the connection pool
     */
    private static synchronized void initializeConnectionPool() {
        if (poolInitialized) return;
        
        // Test primary database connection
        try (Connection testConn = DriverManager.getConnection(primaryDbUrl, primaryDbUser, primaryDbPassword)) {
            System.out.println("✅ Primary database connection successful");
            
            // Initialize pool with primary database
            for (int i = 0; i < MIN_POOL_SIZE; i++) {
                Connection conn = DriverManager.getConnection(primaryDbUrl, primaryDbUser, primaryDbPassword);
                connectionPool.offer(conn);
                activeConnections.incrementAndGet();
            }
            
        } catch (SQLException e) {
            System.err.println("⚠️ Primary database unavailable, switching to H2 fallback mode");
            useFallbackMode = true;
            initializeH2Fallback();
        }
        
        poolInitialized = true;
    }
    
    /**
     * Initialize H2 fallback database with test data
     */
    private static void initializeH2Fallback() {
        try (Connection conn = DriverManager.getConnection(fallbackDbUrl, fallbackDbUser, fallbackDbPassword)) {
            
            // Create tables
            String createUsersTable = "CREATE TABLE IF NOT EXISTS users (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "username VARCHAR(50) UNIQUE NOT NULL," +
                "password VARCHAR(255) NOT NULL," +
                "salt VARCHAR(255) NOT NULL," +
                "role VARCHAR(20) NOT NULL," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";
            
            String createPatientsTable = "CREATE TABLE IF NOT EXISTS patients (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(100) NOT NULL," +
                "age INT NOT NULL," +
                "gender VARCHAR(10) NOT NULL," +
                "phone VARCHAR(15)," +
                "address TEXT," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";
            
            String createMedicinesTable = "CREATE TABLE IF NOT EXISTS medicines (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(100) NOT NULL," +
                "manufacturer VARCHAR(100)," +
                "price DECIMAL(10,2) NOT NULL," +
                "quantity INT NOT NULL," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";
            
            var stmt = conn.createStatement();
            stmt.execute(createUsersTable);
            stmt.execute(createPatientsTable);
            stmt.execute(createMedicinesTable);
            
            // Insert test data
            String insertTestUser = "INSERT INTO users (username, password, salt, role) VALUES " +
                "('testadmin', 'hashedpassword123', 'testsalt123', 'admin')," +
                "('testdoctor', 'hashedpassword456', 'testsalt456', 'doctor')";
            
            String insertTestPatients = "INSERT INTO patients (name, age, gender, phone, address) VALUES " +
                "('Test Patient 1', 30, 'Male', '1234567890', '123 Test Street')," +
                "('Test Patient 2', 25, 'Female', '0987654321', '456 Demo Avenue')";
            
            String insertTestMedicines = "INSERT INTO medicines (name, manufacturer, price, quantity) VALUES " +
                "('Test Medicine A', 'Test Pharma', 19.99, 100)," +
                "('Test Medicine B', 'Demo Labs', 45.50, 75)";
            
            stmt.execute(insertTestUser);
            stmt.execute(insertTestPatients);
            stmt.execute(insertTestMedicines);
            
            // Initialize connection pool with H2
            for (int i = 0; i < MIN_POOL_SIZE; i++) {
                Connection poolConn = DriverManager.getConnection(fallbackDbUrl, fallbackDbUser, fallbackDbPassword);
                connectionPool.offer(poolConn);
                activeConnections.incrementAndGet();
            }
            
            System.out.println("✅ H2 fallback database initialized with test data");
            
        } catch (SQLException e) {
            System.err.println("❌ Failed to initialize H2 fallback: " + e.getMessage());
        }
    }
    
    /**
     * Create a new database connection
     */
    private static Connection createNewConnection() throws SQLException {
        if (activeConnections.get() >= MAX_POOL_SIZE) {
            throw new SQLException("Connection pool exhausted");
        }
        
        Connection conn;
        if (useFallbackMode) {
            conn = DriverManager.getConnection(fallbackDbUrl, fallbackDbUser, fallbackDbPassword);
        } else {
            try {
                conn = DriverManager.getConnection(primaryDbUrl, primaryDbUser, primaryDbPassword);
            } catch (SQLException e) {
                // Fallback to H2 if primary fails
                System.err.println("Primary database failed, using H2 fallback");
                useFallbackMode = true;
                initializeH2Fallback();
                conn = DriverManager.getConnection(fallbackDbUrl, fallbackDbUser, fallbackDbPassword);
            }
        }
        
        activeConnections.incrementAndGet();
        connectionTimestamps.put(conn, System.currentTimeMillis());
        return conn;
    }
    
    /**
     * Check if currently using fallback mode
     */
    public static boolean isUsingFallbackMode() {
        return useFallbackMode;
    }
    
    /**
     * Get connection pool statistics
     */
    public static String getPoolStatistics() {
        return String.format(
            "Pool Stats - Active: %d, Available: %d, Mode: %s",
            activeConnections.get(),
            connectionPool.size(),
            useFallbackMode ? "H2 Fallback" : "MySQL Primary"
        );
    }
    
    /**
     * Clean up stale connections
     */
    public static void cleanupStaleConnections() {
        long currentTime = System.currentTimeMillis();
        connectionTimestamps.entrySet().removeIf(entry -> {
            long age = currentTime - entry.getValue();
            if (age > CONNECTION_TIMEOUT) {
                try {
                    entry.getKey().close();
                    activeConnections.decrementAndGet();
                    return true;
                } catch (SQLException e) {
                    // Connection was already closed
                    return true;
                }
            }
            return false;
        });
    }
    
    /**
     * Close all connections and cleanup
     */
    public static void shutdown() {
        System.out.println("🔄 Shutting down Enhanced Database Utility...");
        
        // Close all pooled connections
        Connection conn;
        while ((conn = connectionPool.poll()) != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // Ignore close errors during shutdown
            }
        }
        
        // Clear tracking
        connectionTimestamps.clear();
        activeConnections.set(0);
        poolInitialized = false;
        
        System.out.println("✅ Enhanced Database Utility shutdown complete");
    }
}

