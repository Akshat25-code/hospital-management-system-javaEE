package model;

import java.util.Date;

public class PatientQueue {
    private int id;
    private int patientId;
    private int doctorId;
    private int queueNumber;
    private String status;
    private Date arrivedTime;
    private Date calledTime;

    public PatientQueue() {}

    public PatientQueue(int id, int patientId, int doctorId, int queueNumber, String status, Date arrivedTime, Date calledTime) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.queueNumber = queueNumber;
        this.status = status;
        this.arrivedTime = arrivedTime;
        this.calledTime = calledTime;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public int getQueueNumber() { return queueNumber; }
    public void setQueueNumber(int queueNumber) { this.queueNumber = queueNumber; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getArrivedTime() { return arrivedTime; }
    public void setArrivedTime(Date arrivedTime) { this.arrivedTime = arrivedTime; }
    public Date getCalledTime() { return calledTime; }
    public void setCalledTime(Date calledTime) { this.calledTime = calledTime; }
}

