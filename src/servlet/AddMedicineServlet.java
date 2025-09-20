package servlet;

import dao.MedicineDAO;
import model.Medicine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddMedicineServlet")
public class AddMedicineServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String manufacturer = request.getParameter("manufacturer");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Medicine medicine = new Medicine();
        medicine.setName(name);
        medicine.setManufacturer(manufacturer);
        medicine.setQuantity(quantity);

        MedicineDAO dao = new MedicineDAO();
        dao.addMedicine(medicine);

        response.sendRedirect("MedicineListServlet");
    }
}

