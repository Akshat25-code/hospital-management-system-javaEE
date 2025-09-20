package dao;

import model.PatientVital;
import java.sql.*;
import java.util.*;

public class PatientVitalDAO {
    private Connection conn;
    public PatientVitalDAO(Connection conn) {
        this.conn = conn;
    }

    public List<PatientVital> getVitalsByPatientId(int patientId) throws SQLException {
        List<PatientVital> vitals = new ArrayList<>();
        String sql = "SELECT * FROM patient_vitals WHERE patient_id = ? ORDER BY recorded_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientVital vital = new PatientVital(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getInt("recorded_by"),
                    rs.getInt("blood_pressure_systolic"),
                    rs.getInt("blood_pressure_diastolic"),
                    rs.getInt("heart_rate"),
                    rs.getDouble("temperature"),
                    rs.getDouble("weight"),
                    rs.getDouble("height"),
                    rs.getInt("oxygen_saturation"),
                    rs.getTimestamp("recorded_date")
                );
                vitals.add(vital);
            }
        }
        return vitals;
    }

    public void addVital(PatientVital vital) throws SQLException {
        String sql = "INSERT INTO patient_vitals (patient_id, recorded_by, blood_pressure_systolic, blood_pressure_diastolic, heart_rate, temperature, weight, height, oxygen_saturation, recorded_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vital.getPatientId());
            ps.setInt(2, vital.getRecordedBy());
            ps.setInt(3, vital.getBloodPressureSystolic());
            ps.setInt(4, vital.getBloodPressureDiastolic());
            ps.setInt(5, vital.getHeartRate());
            ps.setDouble(6, vital.getTemperature());
            ps.setDouble(7, vital.getWeight());
            ps.setDouble(8, vital.getHeight());
            ps.setInt(9, vital.getOxygenSaturation());
            ps.setTimestamp(10, new Timestamp(vital.getRecordedDate().getTime()));
            ps.executeUpdate();
        }
    }
}

