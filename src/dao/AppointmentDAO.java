package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Appointment;
import util.DBUtil;

public class AppointmentDAO {
    public int addAppointment(Appointment a) {
        int appointmentId = -1;
        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO appointment (doctor_id, patient_id, date, time, reason) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, a.getDoctorId());
            ps.setInt(2, a.getPatientId());
            ps.setDate(3, new java.sql.Date(a.getDate().getTime()));
            ps.setString(4, a.getTime());
            ps.setString(5, a.getReason());
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                appointmentId = rs.getInt(1);
                a.setId(appointmentId);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return appointmentId;
    }
    public void updateAppointment(Appointment a) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE appointment SET doctor_id=?, patient_id=?, date=?, time=?, reason=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, a.getDoctorId());
            ps.setInt(2, a.getPatientId());
            ps.setDate(3, new java.sql.Date(a.getDate().getTime()));
            ps.setString(4, a.getTime());
            ps.setString(5, a.getReason());
            ps.setInt(6, a.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void deleteAppointment(int id) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "DELETE FROM appointment WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public Appointment getAppointmentById(int id) {
        Appointment a = null;
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM appointment WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDate(rs.getDate("date"));
                a.setTime(rs.getString("time"));
                a.setReason(rs.getString("reason"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return a;
    }
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM appointment";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDate(rs.getDate("date"));
                a.setTime(rs.getString("time"));
                a.setReason(rs.getString("reason"));
                list.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    // Check if a doctor is already booked at a specific date and time
    public boolean isDoctorBooked(int doctorId, java.util.Date date, String time) {
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT COUNT(*) FROM appointment WHERE doctor_id = ? AND date = ? AND time = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            ps.setString(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
    // Check if a patient already has an appointment on a specific date
    public List<Appointment> getPatientAppointmentsByDate(int patientId, java.util.Date date) {
        List<Appointment> appointments = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM appointment WHERE patient_id = ? AND date = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDate(rs.getDate("date"));
                a.setTime(rs.getString("time"));
                a.setReason(rs.getString("reason"));
                appointments.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return appointments;
    }
    
    // Get all appointments for a specific patient
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM appointment WHERE patient_id = ? ORDER BY date DESC, time DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDate(rs.getDate("date"));
                a.setTime(rs.getString("time"));
                a.setReason(rs.getString("reason"));
                appointments.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return appointments;
    }
    
    // Get all appointments for a specific doctor
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT * FROM appointment WHERE doctor_id = ? ORDER BY date DESC, time DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDate(rs.getDate("date"));
                a.setTime(rs.getString("time"));
                a.setReason(rs.getString("reason"));
                appointments.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return appointments;
    }
}

