<%@ page import="model.Assistant,dao.AssistantDAO" %>
<%
    String idStr = request.getParameter("id");
    int id = idStr != null ? Integer.parseInt(idStr) : 0;
    Assistant assistant = new AssistantDAO().getAssistantById(id);
%>
<html>
<head>
    <title>Edit Assistant</title>
</head>
<body>
    <h2>Edit Assistant</h2>
    <form action="EditAssistantServlet" method="post">
        <input type="hidden" name="id" value="<%= assistant.getId() %>" />
        Name: <input type="text" name="name" value="<%= assistant.getName() %>" required /><br/>
        Age: <input type="number" name="age" value="<%= assistant.getAge() %>" required /><br/>
        Gender: <input type="text" name="gender" value="<%= assistant.getGender() %>" required /><br/>
        Phone: <input type="text" name="phone" value="<%= assistant.getPhone() %>" required /><br/>
        <input type="submit" value="Update" />
    </form>
    <a href="assistants.jsp">Back to Assistants</a>
</body>
</html>





