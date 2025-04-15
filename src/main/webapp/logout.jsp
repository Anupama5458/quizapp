<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Logout</title>
    <link rel="stylesheet" type="text/css" href="logout.css">
</head>
<body>
    <div class="confirmation-container">
        <div class="logout-icon">
            <svg viewBox="0 0 24 24" width="48" height="48">
                <path fill="currentColor" d="M16,17V14H9V10H16V7L21,12L16,17M14,2A2,2 0 0,1 16,4V6H14V4H5V20H14V18H16V20A2,2 0 0,1 14,22H5A2,2 0 0,1 3,20V4A2,2 0 0,1 5,2H14Z" />
            </svg>
        </div>
        <h2>Are you sure you want to logout?</h2>
        <p class="subtitle">Your session will end and you'll need to sign in again.</p>
        <div class="confirm-buttons">
            <form action="<%= request.getParameter("dashboardURL") %>" method="post">
                <button type="submit" class="no">Stay Signed In</button>
            </form>
            <form action="LogoutServlet" method="post">
                <input type="hidden" name="confirm" value="yes">
                <button type="submit" class="yes">Logout</button>
            </form>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2025 Your Company Name</p>
    </div>
</body>
</html>