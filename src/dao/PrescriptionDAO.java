package dao;

import model.Prescription;
import util.DBUtil;
import java.sql.*;
import java.util.*;

public class PrescriptionDAO {
    public void addPrescription(Prescription p) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO prescription (patient_id, doctor_id, medicine_id, dosage, instructions) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, p.getPatientId());
            ps.setInt(2, p.getDoctorId());
            ps.setInt(3, p.getMedicineId());
            ps.setString(4, p.getDosage());
            ps.setString(5, p.getInstructions());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void updatePrescription(Prescription p) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE prescription SET patient_id=?, doctor_id=?, medicine_id=?, dosage=?, instructions=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, p.getPatientId());
            ps.setInt(2, p.getDoctorId());
            ps.setInt(3, p.getMedicineId());
            ps.setString(4, p.getDosage());
            ps.setString(5, p.getInstructions());
            ps.setInt(6, p.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void deletePrescription(int id) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "DELETE FROM prescription WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public Prescription getPrescriptionById(int id) {
        Prescription p = null;
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM prescription WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Prescription();
                p.setId(rs.getInt("id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setMedicineId(rs.getInt("medicine_id"));
                p.setDosage(rs.getString("dosage"));
                p.setInstructions(rs.getString("instructions"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return p;
    }
    public List<Prescription> getAllPrescriptions() {
        List<Prescription> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM prescription";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Prescription p = new Prescription();
                p.setId(rs.getInt("id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setMedicineId(rs.getInt("medicine_id"));
                p.setDosage(rs.getString("dosage"));
                p.setInstructions(rs.getString("instructions"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}

