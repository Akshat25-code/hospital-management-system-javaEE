package model;

import java.util.Date;

public class SystemAnnouncement {
    private int id;
    private String title;
    private String content;
    private int createdBy;
    private Date createdDate;
    private boolean active;

    public SystemAnnouncement() {}

    public SystemAnnouncement(int id, String title, String content, int createdBy, Date createdDate, boolean active) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.active = active;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}

