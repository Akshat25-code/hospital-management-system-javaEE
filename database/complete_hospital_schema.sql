-- Complete Hospital Management System Database Schema
-- Enhanced with all new features for Patient, Doctor, Admin, and Assistant roles

-- Create database
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- CORE TABLES (Existing)
-- ==========================================

-- Users table (enhanced with more fields)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(20),
    address TEXT,
    role ENUM('patient', 'doctor', 'assistant', 'admin') NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    profile_picture VARCHAR(255),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20)
);

-- Patients table (enhanced)
CREATE TABLE IF NOT EXISTS patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender ENUM('male', 'female', 'other'),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    medical_history TEXT,
    blood_group VARCHAR(5),
    allergies TEXT,
    insurance_info TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Doctors table (enhanced)
CREATE TABLE IF NOT EXISTS doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    experience_years INT,
    qualification TEXT,
    license_number VARCHAR(50),
    consultation_fee DECIMAL(10,2),
    available_days VARCHAR(50),
    available_hours VARCHAR(50),
    department VARCHAR(100),
    room_number VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Assistants table (enhanced)
CREATE TABLE IF NOT EXISTS assistants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    department VARCHAR(100),
    shift_timing VARCHAR(50),
    supervisor_id INT,
    specialization VARCHAR(100),
    certification TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (supervisor_id) REFERENCES doctors(id) ON DELETE SET NULL
);

-- Appointments table (enhanced)
CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason TEXT,
    status ENUM('scheduled', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    notes TEXT,
    consultation_type ENUM('in_person', 'video_call', 'phone_call') DEFAULT 'in_person',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Medicines table (enhanced)
CREATE TABLE IF NOT EXISTS medicines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manufacturer VARCHAR(100),
    category VARCHAR(50),
    dosage_form VARCHAR(50),
    strength VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    min_stock_level INT DEFAULT 10,
    expiry_date DATE,
    batch_number VARCHAR(50),
    storage_conditions TEXT,
    prescription_required BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Prescriptions table (enhanced)
CREATE TABLE IF NOT EXISTS prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    instructions TEXT,
    quantity INT,
    refills_allowed INT DEFAULT 0,
    refills_used INT DEFAULT 0,
    status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
    prescribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
);

-- ==========================================
-- NEW FEATURE TABLES
-- ==========================================

-- 1. Medical Reports
CREATE TABLE medical_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    report_type VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    test_results TEXT,
    diagnosis TEXT,
    recommendations TEXT,
    report_date DATE NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_path VARCHAR(255),
    status ENUM('draft', 'finalized', 'sent') DEFAULT 'draft',
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- 2. Lab Tests
CREATE TABLE lab_tests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    test_name VARCHAR(150) NOT NULL,
    test_category VARCHAR(100),
    test_description TEXT,
    sample_type VARCHAR(50),
    test_date DATE NOT NULL,
    result_date DATE,
    results TEXT,
    normal_range VARCHAR(100),
    status ENUM('ordered', 'sample_collected', 'in_progress', 'completed', 'cancelled') DEFAULT 'ordered',
    lab_technician VARCHAR(100),
    cost DECIMAL(10,2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- 3. Prescription Refill Requests
CREATE TABLE prescription_refill_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    prescription_id INT NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approved_by INT,
    approved_date TIMESTAMP NULL,
    rejection_reason TEXT,
    pharmacy_notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 4. Health Timeline Events
CREATE TABLE health_timeline_events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    related_appointment_id INT,
    related_prescription_id INT,
    related_test_id INT,
    severity ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (related_appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (related_prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL,
    FOREIGN KEY (related_test_id) REFERENCES lab_tests(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 5. Patient History (detailed medical records)
CREATE TABLE patient_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    record_type VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    symptoms TEXT,
    diagnosis TEXT,
    treatment TEXT,
    outcome TEXT,
    record_date DATE NOT NULL,
    doctor_id INT,
    hospital_name VARCHAR(150),
    attachments TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE SET NULL
);

-- 6. E-Prescriptions (digital prescriptions)
CREATE TABLE e_prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    prescription_number VARCHAR(50) UNIQUE NOT NULL,
    medications TEXT NOT NULL,
    diagnosis TEXT,
    instructions TEXT,
    status ENUM('active', 'dispensed', 'cancelled', 'expired') DEFAULT 'active',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until DATE,
    digital_signature TEXT,
    pharmacy_id INT,
    dispensed_date TIMESTAMP NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- 7. Consultation Notes Templates
CREATE TABLE consultation_notes_templates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    template_name VARCHAR(150) NOT NULL,
    template_content TEXT NOT NULL,
    category VARCHAR(100),
    usage_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- 8. Video Calls
CREATE TABLE video_calls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    call_link VARCHAR(255) NOT NULL,
    status ENUM('scheduled', 'ongoing', 'completed', 'cancelled') DEFAULT 'scheduled',
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    duration INT DEFAULT 0,
    call_notes TEXT,
    recording_url VARCHAR(255),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- 9. Activity Logs (for admin monitoring)
CREATE TABLE activity_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    affected_table VARCHAR(100),
    affected_record_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 10. User Roles (advanced role management)
CREATE TABLE user_roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    permissions TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 11. System Announcements
CREATE TABLE system_announcements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    priority ENUM('info', 'warning', 'critical') DEFAULT 'info',
    target_role ENUM('all', 'patient', 'doctor', 'assistant', 'admin') DEFAULT 'all',
    active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    valid_until TIMESTAMP NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 12. User Feedback
CREATE TABLE user_feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    category ENUM('bug_report', 'feature_request', 'complaint', 'compliment', 'general') NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('new', 'in_progress', 'resolved', 'closed') DEFAULT 'new',
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    admin_response TEXT,
    response_date TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 13. Task Assignments (for assistants/nurses)
CREATE TABLE task_assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    assigned_to INT NOT NULL,
    assigned_by INT,
    task_title VARCHAR(200) NOT NULL,
    description TEXT,
    task_type VARCHAR(100),
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('pending', 'in_progress', 'completed', 'cancelled') DEFAULT 'pending',
    due_date TIMESTAMP NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 14. Patient Queue
CREATE TABLE patient_queue (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    queue_position INT,
    priority ENUM('normal', 'high', 'urgent') DEFAULT 'normal',
    reason VARCHAR(200),
    status ENUM('waiting', 'in_progress', 'completed', 'cancelled') DEFAULT 'waiting',
    join_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_time TIMESTAMP NULL,
    end_time TIMESTAMP NULL,
    estimated_wait_time INT,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- 15. Inventory Alerts
CREATE TABLE inventory_alerts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    item_type ENUM('medicine', 'supplies', 'equipment') NOT NULL,
    current_stock INT NOT NULL,
    threshold_level INT NOT NULL,
    alert_level ENUM('info', 'warning', 'critical') NOT NULL,
    message TEXT,
    status ENUM('active', 'acknowledged', 'resolved') DEFAULT 'active',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledged_date TIMESTAMP NULL,
    resolved_date TIMESTAMP NULL,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 16. Patient Vitals
CREATE TABLE patient_vitals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    systolic_bp INT,
    diastolic_bp INT,
    heart_rate INT,
    temperature DECIMAL(5,2),
    respiratory_rate INT,
    oxygen_saturation INT,
    weight DECIMAL(6,2),
    height DECIMAL(5,2),
    bmi DECIMAL(5,2),
    notes TEXT,
    recorded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recorded_by VARCHAR(100),
    device_info VARCHAR(100),
    alert_level ENUM('normal', 'warning', 'critical') DEFAULT 'normal',
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- ==========================================
-- INDEXES FOR PERFORMANCE
-- ==========================================

-- User-related indexes
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_email ON users(email);

-- Appointment indexes
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_status ON appointments(status);

-- Medical record indexes
CREATE INDEX idx_medical_reports_patient ON medical_reports(patient_id);
CREATE INDEX idx_medical_reports_doctor ON medical_reports(doctor_id);
CREATE INDEX idx_medical_reports_date ON medical_reports(report_date);

-- Lab test indexes
CREATE INDEX idx_lab_tests_patient ON lab_tests(patient_id);
CREATE INDEX idx_lab_tests_status ON lab_tests(status);
CREATE INDEX idx_lab_tests_date ON lab_tests(test_date);

-- Timeline indexes
CREATE INDEX idx_timeline_patient ON health_timeline_events(patient_id);
CREATE INDEX idx_timeline_date ON health_timeline_events(event_date);

-- Activity log indexes
CREATE INDEX idx_activity_logs_user ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_timestamp ON activity_logs(timestamp);

-- Task indexes
CREATE INDEX idx_tasks_assigned_to ON task_assignments(assigned_to);
CREATE INDEX idx_tasks_status ON task_assignments(status);
CREATE INDEX idx_tasks_due_date ON task_assignments(due_date);

-- Queue indexes
CREATE INDEX idx_queue_doctor ON patient_queue(doctor_id);
CREATE INDEX idx_queue_status ON patient_queue(status);
CREATE INDEX idx_queue_priority ON patient_queue(priority);

-- Vitals indexes
CREATE INDEX idx_vitals_patient ON patient_vitals(patient_id);
CREATE INDEX idx_vitals_date ON patient_vitals(recorded_date);

-- ==========================================
-- SAMPLE DATA INSERT
-- ==========================================

-- Insert default admin user (password: admin123)
INSERT IGNORE INTO users (username, password, full_name, email, role, status) VALUES 
('admin', '$2b$10$rODjCOtKZy6ooN.x5kLZtOIjkjZPZLJf8kVsjCVLLgJqZy.wYWLta', 'System Administrator', 'admin@hospital.com', 'admin', 'active');

-- Insert default role permissions
INSERT IGNORE INTO user_roles (role_name, description, permissions) VALUES 
('Super Admin', 'Full system access', 'all'),
('Doctor', 'Medical staff permissions', 'patients,appointments,prescriptions,reports'),
('Nurse', 'Assistant staff permissions', 'patients,vitals,tasks,queue'),
('Receptionist', 'Front desk permissions', 'appointments,patients,queue');

-- ==========================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ==========================================

-- Update user last_login on successful login
DELIMITER $$
CREATE TRIGGER update_last_login 
AFTER UPDATE ON users 
FOR EACH ROW 
BEGIN 
    IF NEW.status = 'active' AND OLD.status != 'active' THEN
        UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END IF;
END$$
DELIMITER ;

-- Auto-generate queue positions
DELIMITER $$
CREATE TRIGGER auto_queue_position 
BEFORE INSERT ON patient_queue 
FOR EACH ROW 
BEGIN 
    DECLARE next_position INT DEFAULT 1;
    SELECT COALESCE(MAX(queue_position), 0) + 1 INTO next_position 
    FROM patient_queue 
    WHERE doctor_id = NEW.doctor_id AND status = 'waiting';
    SET NEW.queue_position = next_position;
END$$
DELIMITER ;

-- Auto-calculate BMI in vitals
DELIMITER $$
CREATE TRIGGER calculate_bmi 
BEFORE INSERT ON patient_vitals 
FOR EACH ROW 
BEGIN 
    IF NEW.weight IS NOT NULL AND NEW.height IS NOT NULL AND NEW.height > 0 THEN
        SET NEW.bmi = (NEW.weight / (NEW.height * NEW.height)) * 703;
    END IF;
END$$
DELIMITER ;

-- Log user activities
DELIMITER $$
CREATE TRIGGER log_user_activity 
AFTER INSERT ON appointments 
FOR EACH ROW 
BEGIN 
    INSERT INTO activity_logs (user_id, action, details, affected_table, affected_record_id) 
    VALUES (NEW.created_by, 'CREATE_APPOINTMENT', CONCAT('Created appointment for patient ', NEW.patient_id), 'appointments', NEW.id);
END$$
DELIMITER ;

-- ==========================================
-- VIEWS FOR COMMON QUERIES
-- ==========================================

-- Comprehensive patient view
CREATE OR REPLACE VIEW patient_overview AS
SELECT 
    p.id,
    p.name,
    p.age,
    p.gender,
    p.phone,
    p.email,
    p.blood_group,
    COUNT(DISTINCT a.id) as total_appointments,
    COUNT(DISTINCT pr.id) as active_prescriptions,
    COUNT(DISTINCT lt.id) as pending_tests,
    MAX(a.appointment_date) as last_visit,
    p.created_date
FROM patients p
LEFT JOIN appointments a ON p.id = a.patient_id
LEFT JOIN prescriptions pr ON p.id = pr.patient_id AND pr.status = 'active'
LEFT JOIN lab_tests lt ON p.id = lt.patient_id AND lt.status IN ('ordered', 'in_progress')
GROUP BY p.id;

-- Doctor workload view
CREATE OR REPLACE VIEW doctor_workload AS
SELECT 
    d.id,
    d.name,
    d.specialization,
    COUNT(DISTINCT a.id) as appointments_today,
    COUNT(DISTINCT q.id) as patients_in_queue,
    COUNT(DISTINCT vc.id) as active_video_calls,
    d.consultation_fee
FROM doctors d
LEFT JOIN appointments a ON d.id = a.doctor_id AND a.appointment_date = CURDATE()
LEFT JOIN patient_queue q ON d.id = q.doctor_id AND q.status = 'waiting'
LEFT JOIN video_calls vc ON d.id = vc.doctor_id AND vc.status = 'ongoing'
GROUP BY d.id;

-- ==========================================
-- COMPLETION MESSAGE
-- ==========================================

SELECT 'Hospital Management System Database Schema Created Successfully!' as Status,
       'All 16 feature tables created with indexes, triggers, and sample data' as Details,
       NOW() as Created_At;
