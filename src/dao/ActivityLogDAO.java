package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.ActivityLog;

public class ActivityLogDAO {
    private Connection conn;
    public ActivityLogDAO(Connection conn) {
        this.conn = conn;
    }

    public List<ActivityLog> getAllActivityLogs() throws SQLException {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM activity_logs ORDER BY timestamp DESC LIMIT 100";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("action"),
                    rs.getString("details"),
                    rs.getString("ip_address"),
                    rs.getTimestamp("timestamp")
                );
                logs.add(log);
            }
        }
        return logs;
    }

    public void addActivityLog(ActivityLog log) throws SQLException {
        String sql = "INSERT INTO activity_logs (user_id, action, details, ip_address, timestamp) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getAction());
            ps.setString(3, log.getDetails());
            ps.setString(4, log.getIpAddress());
            ps.setTimestamp(5, new Timestamp(log.getTimestamp().getTime()));
            ps.executeUpdate();
        }
    }
}

