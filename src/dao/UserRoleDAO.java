package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.UserRole;

public class UserRoleDAO {
    private Connection conn;
    public UserRoleDAO(Connection conn) {
        this.conn = conn;
    }

    public List<UserRole> getAllRoles() throws SQLException {
        List<UserRole> roles = new ArrayList<>();
        String sql = "SELECT * FROM user_roles ORDER BY role_name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserRole role = new UserRole(
                    rs.getInt("id"),
                    rs.getString("role_name"),
                    rs.getString("permissions"),
                    rs.getTimestamp("created_date")
                );
                roles.add(role);
            }
        }
        return roles;
    }

    public void addRole(UserRole role) throws SQLException {
        String sql = "INSERT INTO user_roles (role_name, permissions) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.getRoleName());
            ps.setString(2, role.getPermissions());
            ps.executeUpdate();
        }
    }

    public void updateRole(UserRole role) throws SQLException {
        String sql = "UPDATE user_roles SET role_name = ?, permissions = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.getRoleName());
            ps.setString(2, role.getPermissions());
            ps.setInt(3, role.getId());
            ps.executeUpdate();
        }
    }
}

