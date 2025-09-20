package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.MedicalReport;

public class MedicalReportDAO {
    private Connection conn;
    public MedicalReportDAO(Connection conn) {
        this.conn = conn;
    }

    public List<MedicalReport> getReportsByPatientId(int patientId) throws SQLException {
        List<MedicalReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM medical_reports WHERE patient_id = ? ORDER BY upload_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MedicalReport report = new MedicalReport(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getString("report_type"),
                    rs.getString("file_name"),
                    rs.getString("file_path"),
                    rs.getTimestamp("upload_date")
                );
                reports.add(report);
            }
        }
        return reports;
    }

    // Add more methods as needed (add, delete, etc.)
}

