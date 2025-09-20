package servlet;

import dao.VideoCallDAO;
import model.VideoCall;
import model.User;
import util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@WebServlet("/doctor/video-call")
public class VideoCallServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            VideoCallDAO dao = new VideoCallDAO(conn);
            List<VideoCall> calls = dao.getCallsByDoctorId(user.getId());
            request.setAttribute("calls", calls);
            request.getRequestDispatcher("/doctor/video-call.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            VideoCallDAO dao = new VideoCallDAO(conn);
            if ("start".equals(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                String callLink = "https://meet.hospital.com/room/" + UUID.randomUUID().toString();
                VideoCall call = new VideoCall(0, appointmentId, user.getId(), patientId, callLink, "ongoing", new Date(), null, 0);
                dao.addVideoCall(call);
            } else if ("end".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int duration = Integer.parseInt(request.getParameter("duration"));
                dao.updateCallStatus(id, "completed", new Date(), duration);
            }
            response.sendRedirect("video-call");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

