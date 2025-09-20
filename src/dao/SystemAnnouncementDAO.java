package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.SystemAnnouncement;

public class SystemAnnouncementDAO {
    private Connection conn;
    public SystemAnnouncementDAO(Connection conn) {
        this.conn = conn;
    }

    public List<SystemAnnouncement> getAllAnnouncements() throws SQLException {
        List<SystemAnnouncement> announcements = new ArrayList<>();
        String sql = "SELECT * FROM system_announcements ORDER BY created_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SystemAnnouncement announcement = new SystemAnnouncement(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getInt("created_by"),
                    rs.getTimestamp("created_date"),
                    rs.getBoolean("active")
                );
                announcements.add(announcement);
            }
        }
        return announcements;
    }

    public void addAnnouncement(SystemAnnouncement announcement) throws SQLException {
        String sql = "INSERT INTO system_announcements (title, content, created_by, created_date, active) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, announcement.getTitle());
            ps.setString(2, announcement.getContent());
            ps.setInt(3, announcement.getCreatedBy());
            ps.setTimestamp(4, new Timestamp(announcement.getCreatedDate().getTime()));
            ps.setBoolean(5, announcement.isActive());
            ps.executeUpdate();
        }
    }

    public void updateAnnouncementStatus(int id, boolean active) throws SQLException {
        String sql = "UPDATE system_announcements SET active = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
}

