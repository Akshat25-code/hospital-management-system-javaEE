package model;

import java.util.Date;

public class TaskAssignment {
    private int id;
    private int assignedTo;
    private int assignedBy;
    private String taskDescription;
    private String priority;
    private String status;
    private Date dueDate;
    private Date createdDate;

    public TaskAssignment() {}

    public TaskAssignment(int id, int assignedTo, int assignedBy, String taskDescription, String priority, String status, Date dueDate, Date createdDate) {
        this.id = id;
        this.assignedTo = assignedTo;
        this.assignedBy = assignedBy;
        this.taskDescription = taskDescription;
        this.priority = priority;
        this.status = status;
        this.dueDate = dueDate;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAssignedTo() { return assignedTo; }
    public void setAssignedTo(int assignedTo) { this.assignedTo = assignedTo; }
    public int getAssignedBy() { return assignedBy; }
    public void setAssignedBy(int assignedBy) { this.assignedBy = assignedBy; }
    public String getTaskDescription() { return taskDescription; }
    public void setTaskDescription(String taskDescription) { this.taskDescription = taskDescription; }
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}

