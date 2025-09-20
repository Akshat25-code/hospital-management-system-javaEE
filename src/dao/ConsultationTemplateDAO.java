package dao;

import model.ConsultationTemplate;
import java.sql.*;
import java.util.*;

public class ConsultationTemplateDAO {
    private Connection conn;
    public ConsultationTemplateDAO(Connection conn) {
        this.conn = conn;
    }

    public List<ConsultationTemplate> getTemplatesByDoctorId(int doctorId) throws SQLException {
        List<ConsultationTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM consultation_notes_templates WHERE doctor_id = ? ORDER BY created_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ConsultationTemplate template = new ConsultationTemplate(
                    rs.getInt("id"),
                    rs.getInt("doctor_id"),
                    rs.getString("template_name"),
                    rs.getString("template_content"),
                    rs.getTimestamp("created_date")
                );
                templates.add(template);
            }
        }
        return templates;
    }

    public void addTemplate(ConsultationTemplate template) throws SQLException {
        String sql = "INSERT INTO consultation_notes_templates (doctor_id, template_name, template_content, created_date) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, template.getDoctorId());
            ps.setString(2, template.getTemplateName());
            ps.setString(3, template.getTemplateContent());
            ps.setTimestamp(4, new Timestamp(template.getCreatedDate().getTime()));
            ps.executeUpdate();
        }
    }

    public void deleteTemplate(int id) throws SQLException {
        String sql = "DELETE FROM consultation_notes_templates WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}

