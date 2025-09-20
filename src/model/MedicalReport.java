package model;

import java.util.Date;

public class MedicalReport {
    private int id;
    private int patientId;
    private String reportType; // e.g., "Lab Result", "Prescription"
    private String fileName;
    private String filePath;
    private Date uploadDate;

    public MedicalReport() {}

    public MedicalReport(int id, int patientId, String reportType, String fileName, String filePath, Date uploadDate) {
        this.id = id;
        this.patientId = patientId;
        this.reportType = reportType;
        this.fileName = fileName;
        this.filePath = filePath;
        this.uploadDate = uploadDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public Date getUploadDate() { return uploadDate; }
    public void setUploadDate(Date uploadDate) { this.uploadDate = uploadDate; }
}

