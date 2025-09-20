package model;

import java.util.Date;

public class HealthTimelineEvent {
    private int id;
    private int patientId;
    private String eventType; // Appointment, Lab Test, Prescription, etc.
    private String description;
    private Date eventDate;

    public HealthTimelineEvent() {}

    public HealthTimelineEvent(int id, int patientId, String eventType, String description, Date eventDate) {
        this.id = id;
        this.patientId = patientId;
        this.eventType = eventType;
        this.description = description;
        this.eventDate = eventDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
}

