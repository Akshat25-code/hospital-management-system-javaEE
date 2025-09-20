package model;

import java.util.Date;

public class EPrescription {
    private int id;
    private int patientId;
    private int doctorId;
    private String medicineDetails;
    private Date date;

    public EPrescription() {}

    public EPrescription(int id, int patientId, int doctorId, String medicineDetails, Date date) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.medicineDetails = medicineDetails;
        this.date = date;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public String getMedicineDetails() { return medicineDetails; }
    public void setMedicineDetails(String medicineDetails) { this.medicineDetails = medicineDetails; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}

