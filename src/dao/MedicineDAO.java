package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Medicine;
import util.DBUtil;

public class MedicineDAO {
    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM medicine")) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setManufacturer(rs.getString("manufacturer"));
                m.setQuantity(rs.getInt("quantity"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addMedicine(Medicine medicine) {
        String sql = "INSERT INTO medicine (name, manufacturer, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, medicine.getName());
            ps.setString(2, medicine.getManufacturer());
            ps.setInt(3, medicine.getQuantity());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Medicine getMedicineById(int id) {
        Medicine medicine = null;
        String sql = "SELECT * FROM medicine WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    medicine = new Medicine();
                    medicine.setId(rs.getInt("id"));
                    medicine.setName(rs.getString("name"));
                    medicine.setManufacturer(rs.getString("manufacturer"));
                    medicine.setQuantity(rs.getInt("quantity"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return medicine;
    }

    public void updateMedicine(Medicine medicine) {
        String sql = "UPDATE medicine SET name=?, manufacturer=?, quantity=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, medicine.getName());
            ps.setString(2, medicine.getManufacturer());
            ps.setInt(3, medicine.getQuantity());
            ps.setInt(4, medicine.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteMedicine(int id) {
        String sql = "DELETE FROM medicine WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

