<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.ConsultationTemplate" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("doctor")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Consultation Notes Templates</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-file-medical me-2"></i>Consultation Notes Templates</h2>
                    <p class="text-muted">Save and reuse common consultation note templates.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Create New Template -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Create New Template</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="notes-templates">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Template Name</label>
                                <input type="text" class="form-control" name="templateName" required 
                                       placeholder="e.g., General Checkup, Follow-up Visit">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Template Category</label>
                                <select class="form-select" name="category">
                                    <option value="general">General Consultation</option>
                                    <option value="followup">Follow-up Visit</option>
                                    <option value="emergency">Emergency Visit</option>
                                    <option value="specialty">Specialty Consultation</option>
                                    <option value="procedure">Procedure Notes</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Template Content</label>
                                <textarea class="form-control" name="templateContent" rows="8" required
                                          placeholder="Enter your template content here...

Example:
Chief Complaint: 
History of Present Illness:
Past Medical History:
Medications:
Allergies:
Physical Examination:
Assessment:
Plan:"></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Save Template
                                </button>
                                <button type="button" class="btn btn-outline-secondary ms-2" onclick="previewTemplate()">
                                    <i class="fas fa-eye me-2"></i>Preview
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Existing Templates -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>My Templates</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty templates}">
                            <div class="row">
                                <c:forEach var="template" items="${templates}">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card h-100">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">${template.templateName}</h6>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                            type="button" data-bs-toggle="dropdown">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="#" onclick="useTemplate(${template.id})">
                                                            <i class="fas fa-copy me-2"></i>Use Template</a></li>
                                                        <li><a class="dropdown-item" href="#" onclick="editTemplate(${template.id}, '${template.templateName}', '${template.templateContent}')">
                                                            <i class="fas fa-edit me-2"></i>Edit</a></li>
                                                        <li><hr class="dropdown-divider"></li>
                                                        <li>
                                                            <form method="post" style="display:inline;" 
                                                                  onsubmit="return confirm('Delete this template?')">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="${template.id}">
                                                                <button type="submit" class="dropdown-item text-danger">
                                                                    <i class="fas fa-trash me-2"></i>Delete
                                                                </button>
                                                            </form>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="template-preview" style="max-height: 150px; overflow-y: auto;">
                                                    <pre style="white-space: pre-wrap; font-size: 0.9rem; color: #666;">${template.templateContent}</pre>
                                                </div>
                                            </div>
                                            <div class="card-footer text-center">
                                                <small class="text-muted">
                                                    Created: <fmt:formatDate value="${template.createdDate}" pattern="MM/dd/yyyy"/>
                                                </small>
                                                <div class="btn-group mt-2 w-100" role="group">
                                                    <button type="button" class="btn btn-sm btn-primary" 
                                                            onclick="useTemplate(${template.id})">
                                                        <i class="fas fa-copy me-1"></i>Use
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="previewFullTemplate('${template.templateName}', '${template.templateContent}')">
                                                        <i class="fas fa-expand me-1"></i>View
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-file-medical fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Templates Created</h5>
                                <p class="text-muted">Create your first consultation notes template above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Template Modal -->
<div class="modal fade" id="editTemplateModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Template</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="notes-templates">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editTemplateId">
                    <div class="mb-3">
                        <label class="form-label">Template Name</label>
                        <input type="text" class="form-control" name="templateName" id="editTemplateName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Template Content</label>
                        <textarea class="form-control" name="templateContent" id="editTemplateContent" rows="10" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Template</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Preview Template Modal -->
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="previewModalTitle">Template Preview</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <pre id="previewContent" style="white-space: pre-wrap; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;"></pre>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="copyPreviewContent()">
                    <i class="fas fa-copy me-2"></i>Copy to Clipboard
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Use Template Modal -->
<div class="modal fade" id="useTemplateModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Use Template for Consultation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Patient ID</label>
                        <input type="number" class="form-control" id="useTemplatePatientId" placeholder="Enter Patient ID">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Consultation Date</label>
                        <input type="date" class="form-control" id="useTemplateDate" 
                               value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd'/>">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Consultation Notes</label>
                        <textarea class="form-control" id="useTemplateContent" rows="12"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveConsultationNotes()">
                    <i class="fas fa-save me-2"></i>Save Consultation Notes
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function editTemplate(id, name, content) {
    document.getElementById('editTemplateId').value = id;
    document.getElementById('editTemplateName').value = name;
    document.getElementById('editTemplateContent').value = content;
    new bootstrap.Modal(document.getElementById('editTemplateModal')).show();
}

function previewTemplate() {
    const content = document.querySelector('textarea[name="templateContent"]').value;
    const name = document.querySelector('input[name="templateName"]').value || 'Template Preview';
    previewFullTemplate(name, content);
}

function previewFullTemplate(name, content) {
    document.getElementById('previewModalTitle').textContent = name;
    document.getElementById('previewContent').textContent = content;
    new bootstrap.Modal(document.getElementById('previewModal')).show();
}

function useTemplate(templateId) {
    // In a real implementation, this would fetch the template content via AJAX
    // For now, we'll simulate it
    const templateContent = "Template content would be loaded here...";
    document.getElementById('useTemplateContent').value = templateContent;
    new bootstrap.Modal(document.getElementById('useTemplateModal')).show();
}

function copyPreviewContent() {
    const content = document.getElementById('previewContent').textContent;
    navigator.clipboard.writeText(content).then(function() {
        alert('Template content copied to clipboard!');
    });
}

function saveConsultationNotes() {
    const patientId = document.getElementById('useTemplatePatientId').value;
    const date = document.getElementById('useTemplateDate').value;
    const content = document.getElementById('useTemplateContent').value;
    
    if (!patientId || !content) {
        alert('Please fill in all required fields.');
        return;
    }
    
    // In a real implementation, this would save the consultation notes
    alert('Consultation notes saved successfully!');
    bootstrap.Modal.getInstance(document.getElementById('useTemplateModal')).hide();
}
</script>
</body>
</html>





