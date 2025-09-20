package dao;

import model.PatientQueue;
import java.sql.*;
import java.util.*;

public class PatientQueueDAO {
    private Connection conn;
    public PatientQueueDAO(Connection conn) {
        this.conn = conn;
    }

    public List<PatientQueue> getCurrentQueue() throws SQLException {
        List<PatientQueue> queue = new ArrayList<>();
        String sql = "SELECT * FROM patient_queue WHERE status IN ('Waiting', 'Called') ORDER BY queue_number";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientQueue pq = new PatientQueue(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getInt("doctor_id"),
                    rs.getInt("queue_number"),
                    rs.getString("status"),
                    rs.getTimestamp("arrived_time"),
                    rs.getTimestamp("called_time")
                );
                queue.add(pq);
            }
        }
        return queue;
    }

    public void addToQueue(PatientQueue pq) throws SQLException {
        String sql = "INSERT INTO patient_queue (patient_id, doctor_id, queue_number, status, arrived_time) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pq.getPatientId());
            ps.setInt(2, pq.getDoctorId());
            ps.setInt(3, pq.getQueueNumber());
            ps.setString(4, pq.getStatus());
            ps.setTimestamp(5, new Timestamp(pq.getArrivedTime().getTime()));
            ps.executeUpdate();
        }
    }

    public void updateQueueStatus(int id, String status) throws SQLException {
        String sql = "UPDATE patient_queue SET status = ?, called_time = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, "Called".equals(status) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    public int getNextQueueNumber() throws SQLException {
        String sql = "SELECT COALESCE(MAX(queue_number), 0) + 1 FROM patient_queue WHERE DATE(arrived_time) = CURDATE()";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }
}

