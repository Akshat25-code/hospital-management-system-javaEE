package dao;

import model.PrescriptionRefillRequest;
import java.sql.*;
import java.util.*;

public class PrescriptionRefillRequestDAO {
    private Connection conn;
    public PrescriptionRefillRequestDAO(Connection conn) {
        this.conn = conn;
    }

    public List<PrescriptionRefillRequest> getRequestsByPatientId(int patientId) throws SQLException {
        List<PrescriptionRefillRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM prescription_refill_requests WHERE patient_id = ? ORDER BY request_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PrescriptionRefillRequest req = new PrescriptionRefillRequest(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getInt("prescription_id"),
                    rs.getTimestamp("request_date"),
                    rs.getString("status")
                );
                requests.add(req);
            }
        }
        return requests;
    }

    public void addRequest(PrescriptionRefillRequest req) throws SQLException {
        String sql = "INSERT INTO prescription_refill_requests (patient_id, prescription_id, request_date, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, req.getPatientId());
            ps.setInt(2, req.getPrescriptionId());
            ps.setTimestamp(3, new Timestamp(req.getRequestDate().getTime()));
            ps.setString(4, req.getStatus());
            ps.executeUpdate();
        }
    }
}

