package model;

import java.util.Date;

public class PatientHistory {
    private int id;
    private int patientId;
    private String details;
    private Date date;

    public PatientHistory() {}

    public PatientHistory(int id, int patientId, String details, Date date) {
        this.id = id;
        this.patientId = patientId;
        this.details = details;
        this.date = date;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}

