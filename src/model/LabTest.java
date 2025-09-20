package model;

import java.util.Date;

public class LabTest {
    private int id;
    private int patientId;
    private String testName;
    private String result;
    private Date testDate;
    private String reportFilePath;

    public LabTest() {}

    public LabTest(int id, int patientId, String testName, String result, Date testDate, String reportFilePath) {
        this.id = id;
        this.patientId = patientId;
        this.testName = testName;
        this.result = result;
        this.testDate = testDate;
        this.reportFilePath = reportFilePath;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getTestName() { return testName; }
    public void setTestName(String testName) { this.testName = testName; }
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    public Date getTestDate() { return testDate; }
    public void setTestDate(Date testDate) { this.testDate = testDate; }
    public String getReportFilePath() { return reportFilePath; }
    public void setReportFilePath(String reportFilePath) { this.reportFilePath = reportFilePath; }
}

