package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Assistant;
import util.DBUtil;

public class AssistantDAO {
    public List<Assistant> getAllAssistants() {
        List<Assistant> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM assistant")) {
            while (rs.next()) {
                Assistant a = new Assistant();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPhone(rs.getString("phone"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addAssistant(Assistant assistant) {
        String sql = "INSERT INTO assistant (name, email, phone) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, assistant.getName());
            ps.setString(2, assistant.getEmail());
            ps.setString(3, assistant.getPhone());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Assistant getAssistantById(int id) {
        Assistant assistant = null;
        String sql = "SELECT * FROM assistant WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    assistant = new Assistant();
                    assistant.setId(rs.getInt("id"));
                    assistant.setName(rs.getString("name"));
                    assistant.setEmail(rs.getString("email"));
                    assistant.setPhone(rs.getString("phone"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assistant;
    }

    public void updateAssistant(Assistant assistant) {
        String sql = "UPDATE assistant SET name=?, email=?, phone=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, assistant.getName());
            ps.setString(2, assistant.getEmail());
            ps.setString(3, assistant.getPhone());
            ps.setInt(4, assistant.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteAssistant(int id) {
        String sql = "DELETE FROM assistant WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

