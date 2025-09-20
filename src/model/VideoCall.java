package model;

import java.util.Date;

public class VideoCall {
    private int id;
    private int appointmentId;
    private int doctorId;
    private int patientId;
    private String callLink;
    private String status; // scheduled, ongoing, completed, cancelled
    private Date startTime;
    private Date endTime;
    private int duration; // in minutes

    public VideoCall() {}

    public VideoCall(int id, int appointmentId, int doctorId, int patientId, String callLink, String status, Date startTime, Date endTime, int duration) {
        this.id = id;
        this.appointmentId = appointmentId;
        this.doctorId = doctorId;
        this.patientId = patientId;
        this.callLink = callLink;
        this.status = status;
        this.startTime = startTime;
        this.endTime = endTime;
        this.duration = duration;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getCallLink() { return callLink; }
    public void setCallLink(String callLink) { this.callLink = callLink; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
}

