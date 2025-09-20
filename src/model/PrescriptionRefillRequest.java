package model;

import java.util.Date;

public class PrescriptionRefillRequest {
    private int id;
    private int patientId;
    private int prescriptionId;
    private Date requestDate;
    private String status; // Pending, Approved, Rejected

    public PrescriptionRefillRequest() {}

    public PrescriptionRefillRequest(int id, int patientId, int prescriptionId, Date requestDate, String status) {
        this.id = id;
        this.patientId = patientId;
        this.prescriptionId = prescriptionId;
        this.requestDate = requestDate;
        this.status = status;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

