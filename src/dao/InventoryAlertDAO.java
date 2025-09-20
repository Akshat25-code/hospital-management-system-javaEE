package dao;

import model.InventoryAlert;
import java.sql.*;
import java.util.*;

public class InventoryAlertDAO {
    private Connection conn;
    public InventoryAlertDAO(Connection conn) {
        this.conn = conn;
    }

    public List<InventoryAlert> getAllAlerts() throws SQLException {
        List<InventoryAlert> alerts = new ArrayList<>();
        String sql = "SELECT * FROM inventory_alerts ORDER BY alert_level DESC, created_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryAlert alert = new InventoryAlert(
                    rs.getInt("id"),
                    rs.getString("item_name"),
                    rs.getInt("current_stock"),
                    rs.getInt("minimum_stock"),
                    rs.getString("alert_level"),
                    rs.getTimestamp("created_date")
                );
                alerts.add(alert);
            }
        }
        return alerts;
    }

    public void addAlert(InventoryAlert alert) throws SQLException {
        String sql = "INSERT INTO inventory_alerts (item_name, current_stock, minimum_stock, alert_level, created_date) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, alert.getItemName());
            ps.setInt(2, alert.getCurrentStock());
            ps.setInt(3, alert.getMinimumStock());
            ps.setString(4, alert.getAlertLevel());
            ps.setTimestamp(5, new Timestamp(alert.getCreatedDate().getTime()));
            ps.executeUpdate();
        }
    }

    public void updateStock(int id, int newStock) throws SQLException {
        String sql = "UPDATE inventory_alerts SET current_stock = ?, alert_level = ? WHERE id = ?";
        String alertLevel = newStock == 0 ? "Out of Stock" : (newStock <= 5 ? "Critical" : "Low");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setString(2, alertLevel);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }
}

