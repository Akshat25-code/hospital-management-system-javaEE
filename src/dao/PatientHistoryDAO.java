package dao;

import model.PatientHistory;
import java.sql.*;
import java.util.*;

public class PatientHistoryDAO {
    private Connection conn;
    public PatientHistoryDAO(Connection conn) {
        this.conn = conn;
    }

    public List<PatientHistory> getHistoryByPatientId(int patientId) throws SQLException {
        List<PatientHistory> history = new ArrayList<>();
        String sql = "SELECT * FROM patient_history WHERE patient_id = ? ORDER BY date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientHistory h = new PatientHistory(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getString("details"),
                    rs.getTimestamp("date")
                );
                history.add(h);
            }
        }
        return history;
    }
}

