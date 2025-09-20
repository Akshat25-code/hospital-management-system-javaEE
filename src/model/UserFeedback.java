package model;

import java.util.Date;

public class UserFeedback {
    private int id;
    private int userId;
    private String feedbackType;
    private String subject;
    private String message;
    private String status;
    private Date createdDate;

    public UserFeedback() {}

    public UserFeedback(int id, int userId, String feedbackType, String subject, String message, String status, Date createdDate) {
        this.id = id;
        this.userId = userId;
        this.feedbackType = feedbackType;
        this.subject = subject;
        this.message = message;
        this.status = status;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFeedbackType() { return feedbackType; }
    public void setFeedbackType(String feedbackType) { this.feedbackType = feedbackType; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}

