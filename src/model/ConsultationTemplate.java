package model;

import java.util.Date;

public class ConsultationTemplate {
    private int id;
    private int doctorId;
    private String templateName;
    private String templateContent;
    private Date createdDate;

    public ConsultationTemplate() {}

    public ConsultationTemplate(int id, int doctorId, String templateName, String templateContent, Date createdDate) {
        this.id = id;
        this.doctorId = doctorId;
        this.templateName = templateName;
        this.templateContent = templateContent;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public String getTemplateName() { return templateName; }
    public void setTemplateName(String templateName) { this.templateName = templateName; }
    public String getTemplateContent() { return templateContent; }
    public void setTemplateContent(String templateContent) { this.templateContent = templateContent; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}

