<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.List, com.yash.quizapplication.domain.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve/Deny Registrations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/approve_requests.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- The outer admin-container div is fine, but not strictly necessary for the layout --%>
    <%-- <div class="admin-container"> --%>

        <header class="admin-header">
            <div class="header-content">
                <div class="admin-profile">
                    <div class="profile-icon">A</div>
                    <span class="admin-name">Admin</span>
                </div>
                <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="logout-form">
                    <input type="hidden" name="logoutRequest" value="true">
                    <input type="hidden" name="dashboardURL" value="admin.jsp">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </header>

        <%
        // Check for request status message
        String requestStatus = (String) request.getAttribute("requestStatus");
        String requestMessage = (String) request.getAttribute("requestMessage");
        %>

        <% if(requestStatus != null && requestMessage != null) { %>
            <div class="popup <%= requestStatus %>">
                <div class="popup-content">
                    <p><%= requestMessage %></p>
                </div>
            </div>
        <% } %>

        <div class="dashboard-wrapper">
            <aside class="admin-sidebar">
                <nav class="sidebar-nav">
                    <a href="generate_quiz.jsp" class="sidebar-link">
                        <span class="link-icon">🧩</span>
                        Generate New Quiz
                    </a>
                    <a href="quiz_list.jsp" class="sidebar-link">
                        <span class="link-icon">✏️</span>
                        Edit Existing Quiz
                    </a>
                    <a href="libraryDashboard.jsp" class="sidebar-link">
                        <span class="link-icon">📚</span>
                        Manage Library
                    </a>
                    <a href="AdminActivityServlet" class="sidebar-link">
                        <span class="link-icon">📊</span>
                        View Activity
                    </a>
                    <a href="AdminApprovalServlet" class="sidebar-link active">
                        <span class="link-icon">👥</span>
                        Approve/Deny Registrations
                    </a>
                    <%-- Add more links if needed to test sidebar scroll --%>
                    <%-- <a href="#" class="sidebar-link"><span class="link-icon">⚙️</span> Settings</a> --%>
                </nav>
            </aside>

            <main class="admin-main-content">
                <div class="dashboard-cards"> <%-- This container seems specific to this page's content --%>
                    <div class="welcome-card">
                        <h1>Registration Management</h1>
                        <p>Review and process user registration requests</p>
                    </div>

                    <div class="data-table-card">
                        <h2>Pending Registration Requests</h2>
                        <div class="table-wrapper">
                            <%
                            List<Users> pendingUsers = (List<Users>) request.getAttribute("pendingUsers");
                            %>

                            <% if(pendingUsers == null || pendingUsers.isEmpty()) { %>
                                <p class="no-data">No pending registration requests</p>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Email</th>
                                            <th>Username</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Users user : pendingUsers){ %>
                                        <tr>
                                            <td><%= user.getEmail() %></td>
                                            <td><%= user.getUsername() %></td>
                                            <td class="action-buttons">
                                                <form action="AdminApprovalServlet" method="post">
                                                    <input type="hidden" name="email" value="<%= user.getEmail() %>">
                                                    <button type="submit" name="action" value="approve" class="approve-btn">Approve</button>
                                                    <button type="submit" name="action" value="rejected" class="deny-btn">Deny</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    </div>

                    <div class="action-footer">
                        <a href="${pageContext.request.contextPath}/admin.jsp" class="back-link">Back to Admin Dashboard</a>
                    </div>
                     <%-- Add extra content here if needed to test main scroll --%>
                     <%-- <div style="height: 500px; background: lightcoral; margin-top: 20px;">Extra space</div> --%>
                </div>
            </main>
        </div>

        <footer class="admin-footer">
            <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p>
        </footer>

    <%-- </div> --%> <%-- Optional closing tag for admin-container --%>
</body>
</html>