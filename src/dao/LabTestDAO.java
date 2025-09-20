package dao;

import model.LabTest;
import java.sql.*;
import java.util.*;

public class LabTestDAO {
    private Connection conn;
    public LabTestDAO(Connection conn) {
        this.conn = conn;
    }

    public List<LabTest> getLabTestsByPatientId(int patientId) throws SQLException {
        List<LabTest> tests = new ArrayList<>();
        String sql = "SELECT * FROM lab_tests WHERE patient_id = ? ORDER BY test_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LabTest test = new LabTest(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getString("test_name"),
                    rs.getString("result"),
                    rs.getTimestamp("test_date"),
                    rs.getString("report_file_path")
                );
                tests.add(test);
            }
        }
        return tests;
    }

    // Add more methods as needed (add, delete, etc.)
}

