# 🏥 Hospital Management System

A comprehensive web-based Hospital Management System built with Java EE (Jakarta EE), MySQL, and modern web technologies.

## 📋 Project Overview

This Hospital Management System provides a complete digital solution for hospital operations including patient management, appointment scheduling, prescription handling, and administrative tasks with role-based access control.

## ✨ Features

### 👥 Multi-Role System
- **Admin**: Complete system management and user administration
- **Doctor**: Patient management, appointments, prescription creation
- **Patient**: Book appointments, view medical records, access e-prescriptions
- **Assistant**: Administrative support and patient queue management

### 🏥 Core Functionality
- **Patient Management**: Complete patient records with medical history
- **Appointment System**: Book, edit, cancel appointments with conflict detection
- **E-Prescription System**: Digital prescription creation and management
- **Medicine Inventory**: Track medicines and availability
- **Medical Records**: Comprehensive patient medical history
- **Dashboard**: Role-based dashboards for different user types

### 🔒 Security Features
- User authentication and authorization with BCrypt password hashing
- Role-based access control with session management
- CSRF protection and input validation
- Account lockout protection against brute force attacks

## 🛠️ Technology Stack

- **Backend**: Java EE (Jakarta EE) with Servlets and JSP
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 10.1+
- **Frontend**: Bootstrap 5, HTML5, CSS3, JavaScript
- **Libraries**: JSTL, MySQL Connector, Jakarta Servlet API
- **Build Tool**: IntelliJ IDEA with Maven/Gradle support

## 📁 Project Structure

```
hospital-management-jee/
├── src/
│   ├── dao/                    # Data Access Objects
│   │   ├── UserDAO.java        # User authentication & management
│   │   ├── DoctorDAO.java      # Doctor CRUD operations
│   │   ├── PatientDAO.java     # Patient management
│   │   └── [Other DAOs...]
│   ├── servlet/                # HTTP Controllers
│   │   ├── LoginServlet.java   # Authentication
│   │   ├── Add*Servlet.java    # Create operations
│   │   ├── Edit*Servlet.java   # Update operations
│   │   └── Delete*Servlet.java # Delete operations
│   ├── model/                  # Entity Classes
│   │   ├── User.java           # User entity
│   │   ├── Doctor.java         # Doctor entity
│   │   └── [Other Models...]
│   ├── util/                   # Utility Classes
│   │   ├── DBUtil.java         # Database connections
│   │   ├── SecurityUtil.java   # Security utilities
│   │   └── LoggerUtil.java     # Logging framework
│   ├── filter/                 # Security Filters
│   │   └── SecurityFilter.java # CSRF & Security Headers
│   ├── exception/              # Custom Exceptions
│   └── db.properties           # Database Configuration
├── WebContent/
│   ├── WEB-INF/               # Web Configuration
│   ├── admin/                 # Admin Interface Pages
│   ├── doctor/                # Doctor Interface Pages
│   ├── patient/               # Patient Interface Pages
│   ├── assistant/             # Assistant Interface Pages
│   ├── js/                    # JavaScript Files
│   └── *.jsp                  # Main JSP Pages
├── lib/                       # JAR Dependencies
└── database_schema.sql        # Database Schema
```

## 🚀 Setup Instructions for IntelliJ IDEA

### Prerequisites
- Java 11 or higher
- Apache Tomcat 10.1+
- MySQL 8.0+
- IntelliJ IDEA (Community or Ultimate)

### Installation Steps

1. **Database Setup**
   ```sql
   CREATE DATABASE hospital_db;
   USE hospital_db;
   -- Import database_schema.sql file
   ```

2. **Configure Database Connection**
   
   Edit `src/db.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/hospital_db
   db.username=root
   db.password=your_password
   ```

3. **IntelliJ IDEA Project Setup**
   - Open IntelliJ IDEA
   - File → Open → Select the `hospital-management-jee` folder
   - Configure Project Structure (File → Project Structure):
     - Set Project SDK to Java 11+
     - Add Module if not automatically detected
     - Set up Web Facet for the module
     - Configure Artifacts (Web Application: Exploded)
   - Add Tomcat Server Configuration:
     - Run → Edit Configurations → Add → Tomcat Server → Local
     - Configure Tomcat installation path
     - Set Deployment artifact
     - Configure Application Context: `/hospital-management-jee`

4. **Build and Run**
   - Build → Build Project
   - Run the Tomcat configuration
   - Access: `http://localhost:8080/hospital-management-jee/`

## 👤 Default Login Accounts

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |
| Doctor | doctor1 | doctor123 |
| Patient | patient1 | patient123 |
| Assistant | assistant1 | assistant123 |

## 🗄️ Database Schema

Core database tables:
- `users` - User authentication and roles
- `patients` - Patient information
- `doctors` - Doctor profiles  
- `appointments` - Appointment scheduling
- `prescriptions` - Medical prescriptions
- `e_prescriptions` - Digital prescriptions
- `medicines` - Medicine inventory
- `medical_records` - Patient medical history

## 🔧 Development Features

- ✅ Complete CRUD operations for all entities
- ✅ Appointment conflict detection and validation
- ✅ Role-based dashboard customization
- ✅ E-prescription system with patient access
- ✅ Session management and security
- ✅ Responsive design with Bootstrap 5
- ✅ Input validation and error handling
- ✅ Multi-role user management system

## 🚨 Troubleshooting

### Common Issues

**Database Connection Error**
- Verify MySQL server is running
- Check database credentials in `src/db.properties`
- Ensure `hospital_db` database exists

**IntelliJ Build Issues**
- Check Project Structure settings
- Verify Java SDK is properly configured  
- Ensure all JAR files are in the `lib/` directory
- Rebuild project (Build → Rebuild Project)

**Tomcat Deployment Issues**
- Verify Tomcat server configuration in IntelliJ
- Check Application Context path setting
- Ensure Web Facet is properly configured
- Check for port conflicts (default: 8080)

## 📄 License

This project is developed for educational and demonstration purposes as a comprehensive Java EE web application.

---

**🏥 Hospital Management System - Modern Healthcare Management Solution**