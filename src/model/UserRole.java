package model;

public class UserRole {
    private int id;
    private String roleName;
    private String permissions;
    private java.util.Date createdDate;

    public UserRole() {}

    public UserRole(int id, String roleName, String permissions, java.util.Date createdDate) {
        this.id = id;
        this.roleName = roleName;
        this.permissions = permissions;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public String getPermissions() { return permissions; }
    public void setPermissions(String permissions) { this.permissions = permissions; }
    public java.util.Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(java.util.Date createdDate) { this.createdDate = createdDate; }
}

