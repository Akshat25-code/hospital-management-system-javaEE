<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="util.DBUtil" %>
<%
    String username = request.getParameter("username");
    boolean available = true;
    
    if (username != null && !username.trim().isEmpty()) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        available = false;
                    }
                }
            }
        } catch (Exception e) {
            available = false; // If error, assume not available for safety
        }
    }
    
    response.setContentType("application/json");
%>
{
    "available": <%= available %>,
    "username": "<%= username != null ? username : "" %>"
}





