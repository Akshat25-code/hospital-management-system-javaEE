package dao;

import model.UserFeedback;
import java.sql.*;
import java.util.*;

public class UserFeedbackDAO {
    private Connection conn;
    public UserFeedbackDAO(Connection conn) {
        this.conn = conn;
    }

    public List<UserFeedback> getAllFeedback() throws SQLException {
        List<UserFeedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM user_feedback ORDER BY created_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserFeedback feedback = new UserFeedback(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("feedback_type"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getString("status"),
                    rs.getTimestamp("created_date")
                );
                feedbackList.add(feedback);
            }
        }
        return feedbackList;
    }

    public void addFeedback(UserFeedback feedback) throws SQLException {
        String sql = "INSERT INTO user_feedback (user_id, feedback_type, subject, message, status, created_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getUserId());
            ps.setString(2, feedback.getFeedbackType());
            ps.setString(3, feedback.getSubject());
            ps.setString(4, feedback.getMessage());
            ps.setString(5, feedback.getStatus());
            ps.setTimestamp(6, new Timestamp(feedback.getCreatedDate().getTime()));
            ps.executeUpdate();
        }
    }

    public void updateFeedbackStatus(int id, String status) throws SQLException {
        String sql = "UPDATE user_feedback SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
}

