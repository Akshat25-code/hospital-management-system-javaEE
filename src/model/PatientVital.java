package model;

import java.util.Date;

public class PatientVital {
    private int id;
    private int patientId;
    private int recordedBy;
    private int bloodPressureSystolic;
    private int bloodPressureDiastolic;
    private int heartRate;
    private double temperature;
    private double weight;
    private double height;
    private int oxygenSaturation;
    private Date recordedDate;

    public PatientVital() {}

    public PatientVital(int id, int patientId, int recordedBy, int bloodPressureSystolic, int bloodPressureDiastolic, 
                       int heartRate, double temperature, double weight, double height, int oxygenSaturation, Date recordedDate) {
        this.id = id;
        this.patientId = patientId;
        this.recordedBy = recordedBy;
        this.bloodPressureSystolic = bloodPressureSystolic;
        this.bloodPressureDiastolic = bloodPressureDiastolic;
        this.heartRate = heartRate;
        this.temperature = temperature;
        this.weight = weight;
        this.height = height;
        this.oxygenSaturation = oxygenSaturation;
        this.recordedDate = recordedDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getRecordedBy() { return recordedBy; }
    public void setRecordedBy(int recordedBy) { this.recordedBy = recordedBy; }
    public int getBloodPressureSystolic() { return bloodPressureSystolic; }
    public void setBloodPressureSystolic(int bloodPressureSystolic) { this.bloodPressureSystolic = bloodPressureSystolic; }
    public int getBloodPressureDiastolic() { return bloodPressureDiastolic; }
    public void setBloodPressureDiastolic(int bloodPressureDiastolic) { this.bloodPressureDiastolic = bloodPressureDiastolic; }
    public int getHeartRate() { return heartRate; }
    public void setHeartRate(int heartRate) { this.heartRate = heartRate; }
    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    public double getHeight() { return height; }
    public void setHeight(double height) { this.height = height; }
    public int getOxygenSaturation() { return oxygenSaturation; }
    public void setOxygenSaturation(int oxygenSaturation) { this.oxygenSaturation = oxygenSaturation; }
    public Date getRecordedDate() { return recordedDate; }
    public void setRecordedDate(Date recordedDate) { this.recordedDate = recordedDate; }
}

