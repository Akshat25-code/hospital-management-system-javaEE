package model;

import java.util.Date;

public class InventoryAlert {
    private int id;
    private String itemName;
    private int currentStock;
    private int minimumStock;
    private String alertLevel;
    private Date createdDate;

    public InventoryAlert() {}

    public InventoryAlert(int id, String itemName, int currentStock, int minimumStock, String alertLevel, Date createdDate) {
        this.id = id;
        this.itemName = itemName;
        this.currentStock = currentStock;
        this.minimumStock = minimumStock;
        this.alertLevel = alertLevel;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }
    public int getMinimumStock() { return minimumStock; }
    public void setMinimumStock(int minimumStock) { this.minimumStock = minimumStock; }
    public String getAlertLevel() { return alertLevel; }
    public void setAlertLevel(String alertLevel) { this.alertLevel = alertLevel; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}

