package dao;

import model.HealthTimelineEvent;
import java.sql.*;
import java.util.*;

public class HealthTimelineEventDAO {
    private Connection conn;
    public HealthTimelineEventDAO(Connection conn) {
        this.conn = conn;
    }

    public List<HealthTimelineEvent> getEventsByPatientId(int patientId) throws SQLException {
        List<HealthTimelineEvent> events = new ArrayList<>();
        String sql = "SELECT * FROM health_timeline_events WHERE patient_id = ? ORDER BY event_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HealthTimelineEvent event = new HealthTimelineEvent(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getString("event_type"),
                    rs.getString("description"),
                    rs.getTimestamp("event_date")
                );
                events.add(event);
            }
        }
        return events;
    }
}

