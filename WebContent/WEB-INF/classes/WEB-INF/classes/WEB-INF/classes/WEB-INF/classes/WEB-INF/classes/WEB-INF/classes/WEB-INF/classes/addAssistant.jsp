<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
</html>
</head>
<body>
<div class="container mt-4">
    <h2>Add Assistant</h2>
    <form action="AddAssistantServlet" method="post">
        <div class="mb-3">
            <label>Name:</label>
            <input type="text" name="name" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Email:</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Phone:</label>
            <input type="text" name="phone" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Assistant</button>
        <a href="assistants.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>




