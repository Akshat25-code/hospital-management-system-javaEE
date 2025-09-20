-- ===================================================================
-- Hospital Management System Database Schema
-- ===================================================================
-- MySQL 8.0+ Compatible
-- Execute this script to create the complete database structure

-- Create database
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- ===================================================================
-- CORE TABLES
-- ===================================================================

-- Users table with all roles including assistant
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL,
    role ENUM('admin','doctor','patient','assistant') NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Doctor table
CREATE TABLE IF NOT EXISTS doctor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Patient table
CREATE TABLE IF NOT EXISTS patient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender ENUM('Male','Female','Other'),
    address TEXT,
    phone VARCHAR(20),
    emergency_contact VARCHAR(20),
    blood_group VARCHAR(5),
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Assistant table
CREATE TABLE IF NOT EXISTS assistant (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- OPERATIONAL TABLES
-- ===================================================================

-- Appointment table
CREATE TABLE IF NOT EXISTS appointment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    date DATE NOT NULL,
    time VARCHAR(10) NOT NULL,
    reason TEXT,
    status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- Medicine table
CREATE TABLE IF NOT EXISTS medicine (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    quantity_available INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prescription table (traditional prescriptions)
CREATE TABLE IF NOT EXISTS prescription (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    instructions TEXT,
    prescribed_date DATE DEFAULT (CURDATE()),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointment(id) ON DELETE SET NULL,
    FOREIGN KEY (medicine_id) REFERENCES medicine(id) ON DELETE CASCADE
);

-- E-Prescriptions table (digital prescriptions)
CREATE TABLE IF NOT EXISTS e_prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medicine_details TEXT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE CASCADE
);

-- ===================================================================
-- MEDICAL RECORDS TABLES
-- ===================================================================

-- Lab Test table
CREATE TABLE IF NOT EXISTS lab_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    test_name VARCHAR(100) NOT NULL,
    test_date DATE,
    result TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- Medical Record table
CREATE TABLE IF NOT EXISTS medical_record (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    record_type VARCHAR(50),
    description TEXT,
    date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- ===================================================================
-- SAMPLE DATA FOR TESTING
-- ===================================================================

-- Sample Admin User
INSERT IGNORE INTO users (username, password, salt, role, first_name, last_name, email, phone) 
VALUES ('admin', 'admin123', 'demo_salt_value', 'admin', 'Admin', 'User', 'admin@hospital.com', '123-555-0000');

-- Sample Doctor Users
INSERT IGNORE INTO users (username, password, salt, role, first_name, last_name, email, phone) 
VALUES 
('doctor1', 'doctor123', 'demo_salt_value', 'doctor', 'Dr. John', 'Smith', 'john.smith@hospital.com', '123-555-0001'),
('doctor2', 'doctor123', 'demo_salt_value', 'doctor', 'Dr. Sarah', 'Johnson', 'sarah.johnson@hospital.com', '123-555-0002');

-- Sample Patient Users
INSERT IGNORE INTO users (username, password, salt, role, first_name, last_name, email, phone) 
VALUES 
('patient1', 'patient123', 'demo_salt_value', 'patient', 'John', 'Doe', 'john.doe@email.com', '123-555-0003'),
('patient2', 'patient123', 'demo_salt_value', 'patient', 'Jane', 'Smith', 'jane.smith@email.com', '123-555-0004');

-- Sample Assistant User
INSERT IGNORE INTO users (username, password, salt, role, first_name, last_name, email, phone) 
VALUES ('assistant1', 'assistant123', 'demo_salt_value', 'assistant', 'Medical', 'Assistant', 'assistant@hospital.com', '123-555-0005');

-- Sample Doctor Records
INSERT IGNORE INTO doctor (user_id, name, specialization, phone, email) 
VALUES 
((SELECT id FROM users WHERE username = 'doctor1'), 'Dr. John Smith', 'Cardiology', '123-555-0001', 'john.smith@hospital.com'),
((SELECT id FROM users WHERE username = 'doctor2'), 'Dr. Sarah Johnson', 'Neurology', '123-555-0002', 'sarah.johnson@hospital.com');

-- Sample Patient Records
INSERT IGNORE INTO patient (user_id, name, age, gender, address, phone, emergency_contact, blood_group) 
VALUES 
((SELECT id FROM users WHERE username = 'patient1'), 'John Doe', 30, 'Male', '123 Main St, City', '123-555-0003', '123-555-9003', 'O+'),
((SELECT id FROM users WHERE username = 'patient2'), 'Jane Smith', 28, 'Female', '456 Oak Ave, City', '123-555-0004', '123-555-9004', 'A+');

-- Sample Assistant Record
INSERT IGNORE INTO assistant (user_id, name, department, phone, email) 
VALUES ((SELECT id FROM users WHERE username = 'assistant1'), 'Medical Assistant', 'General', '123-555-0005', 'assistant@hospital.com');

-- Sample Medicines
INSERT IGNORE INTO medicine (name, category, price, quantity_available) 
VALUES 
('Paracetamol 500mg', 'Pain Relief', 5.50, 100),
('Amoxicillin 250mg', 'Antibiotic', 12.75, 50),
('Vitamin D3', 'Supplement', 8.25, 75),
('Ibuprofen 400mg', 'Pain Relief', 7.50, 80),
('Metformin 500mg', 'Diabetes', 15.00, 60);

-- Sample Appointments
INSERT IGNORE INTO appointment (doctor_id, patient_id, date, time, reason, status) 
VALUES 
(1, 1, '2025-09-15', '10:00', 'Regular checkup', 'scheduled'),
(2, 2, '2025-09-16', '14:30', 'Follow-up consultation', 'scheduled');

-- Commit all changes
COMMIT;

-- ===================================================================
-- SCHEMA CREATED SUCCESSFULLY
-- ===================================================================