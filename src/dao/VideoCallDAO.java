package dao;

import model.VideoCall;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class VideoCallDAO {
    private Connection conn;
    public VideoCallDAO(Connection conn) {
        this.conn = conn;
    }

    public List<VideoCall> getCallsByDoctorId(int doctorId) throws SQLException {
        List<VideoCall> calls = new ArrayList<>();
        String sql = "SELECT * FROM video_calls WHERE doctor_id = ? ORDER BY start_time DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                VideoCall call = new VideoCall(
                    rs.getInt("id"),
                    rs.getInt("appointment_id"),
                    rs.getInt("doctor_id"),
                    rs.getInt("patient_id"),
                    rs.getString("call_link"),
                    rs.getString("status"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getInt("duration")
                );
                calls.add(call);
            }
        }
        return calls;
    }

    public void addVideoCall(VideoCall call) throws SQLException {
        String sql = "INSERT INTO video_calls (appointment_id, doctor_id, patient_id, call_link, status, start_time) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, call.getAppointmentId());
            ps.setInt(2, call.getDoctorId());
            ps.setInt(3, call.getPatientId());
            ps.setString(4, call.getCallLink());
            ps.setString(5, call.getStatus());
            ps.setTimestamp(6, new Timestamp(call.getStartTime().getTime()));
            ps.executeUpdate();
        }
    }

    public void updateCallStatus(int id, String status, Date endTime, int duration) throws SQLException {
        String sql = "UPDATE video_calls SET status = ?, end_time = ?, duration = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, endTime != null ? new Timestamp(endTime.getTime()) : null);
            ps.setInt(3, duration);
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }
}

