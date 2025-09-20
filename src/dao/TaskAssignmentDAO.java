package dao;

import model.TaskAssignment;
import java.sql.*;
import java.util.*;

public class TaskAssignmentDAO {
    private Connection conn;
    public TaskAssignmentDAO(Connection conn) {
        this.conn = conn;
    }

    public List<TaskAssignment> getTasksByAssignedTo(int userId) throws SQLException {
        List<TaskAssignment> tasks = new ArrayList<>();
        String sql = "SELECT * FROM task_assignments WHERE assigned_to = ? ORDER BY created_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TaskAssignment task = new TaskAssignment(
                    rs.getInt("id"),
                    rs.getInt("assigned_to"),
                    rs.getInt("assigned_by"),
                    rs.getString("task_description"),
                    rs.getString("priority"),
                    rs.getString("status"),
                    rs.getDate("due_date"),
                    rs.getTimestamp("created_date")
                );
                tasks.add(task);
            }
        }
        return tasks;
    }

    public void addTask(TaskAssignment task) throws SQLException {
        String sql = "INSERT INTO task_assignments (assigned_to, assigned_by, task_description, priority, status, due_date, created_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, task.getAssignedTo());
            ps.setInt(2, task.getAssignedBy());
            ps.setString(3, task.getTaskDescription());
            ps.setString(4, task.getPriority());
            ps.setString(5, task.getStatus());
            ps.setDate(6, task.getDueDate() != null ? new java.sql.Date(task.getDueDate().getTime()) : null);
            ps.setTimestamp(7, new Timestamp(task.getCreatedDate().getTime()));
            ps.executeUpdate();
        }
    }

    public void updateTaskStatus(int id, String status) throws SQLException {
        String sql = "UPDATE task_assignments SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
}

