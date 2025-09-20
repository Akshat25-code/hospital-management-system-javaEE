package servlet;

import dao.DoctorDAO;
import model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EditDoctorServlet")
public class EditDoctorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Doctor doctor = new Doctor();
        doctor.setId(id);
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setEmail(email);
        doctor.setPhone(phone);

        DoctorDAO dao = new DoctorDAO();
        dao.updateDoctor(doctor);

        response.sendRedirect("DoctorListServlet");
    }
}

