package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.EPrescription;

public class EPrescriptionDAO {
    private Connection conn;
    public EPrescriptionDAO(Connection conn) {
        this.conn = conn;
    }

    public List<EPrescription> getEPrescriptionsByDoctorId(int doctorId) throws SQLException {
        List<EPrescription> list = new ArrayList<>();
        String sql = "SELECT * FROM e_prescriptions WHERE doctor_id = ? ORDER BY date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EPrescription ep = new EPrescription(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getInt("doctor_id"),
                    rs.getString("medicine_details"),
                    rs.getTimestamp("date")
                );
                list.add(ep);
            }
        }
        return list;
    }

    public void addEPrescription(EPrescription ep) throws SQLException {
        String sql = "INSERT INTO e_prescriptions (patient_id, doctor_id, medicine_details, date) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ep.getPatientId());
            ps.setInt(2, ep.getDoctorId());
            ps.setString(3, ep.getMedicineDetails());
            ps.setTimestamp(4, new Timestamp(ep.getDate().getTime()));
            ps.executeUpdate();
        }
    }

    public List<EPrescription> getEPrescriptionsByPatientId(int patientId) throws SQLException {
        List<EPrescription> list = new ArrayList<>();
        String sql = "SELECT * FROM e_prescriptions WHERE patient_id = ? ORDER BY date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EPrescription ep = new EPrescription(
                    rs.getInt("id"),
                    rs.getInt("patient_id"),
                    rs.getInt("doctor_id"),
                    rs.getString("medicine_details"),
                    rs.getTimestamp("date")
                );
                list.add(ep);
            }
        }
        return list;
    }
}

