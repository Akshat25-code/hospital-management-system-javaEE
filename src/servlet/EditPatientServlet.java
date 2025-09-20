package servlet;

import dao.PatientDAO;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EditPatientServlet")
public class EditPatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age"));
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        Patient patient = new Patient();
        patient.setId(id);
        patient.setName(name);
        patient.setAge(age);
        patient.setGender(gender);
        patient.setAddress(address);
        patient.setPhone(phone);

        PatientDAO dao = new PatientDAO();
        dao.updatePatient(patient);

        response.sendRedirect("PatientListServlet");
    }
}

