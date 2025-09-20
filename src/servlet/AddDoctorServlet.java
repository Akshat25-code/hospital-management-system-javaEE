package servlet;

import dao.DoctorDAO;
import model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddDoctorServlet")
public class AddDoctorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Doctor doctor = new Doctor();
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setEmail(email);
        doctor.setPhone(phone);

        DoctorDAO dao = new DoctorDAO();
        dao.addDoctor(doctor);

        response.sendRedirect("DoctorListServlet");
    }
}

