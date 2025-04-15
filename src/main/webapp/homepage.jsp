<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quizzy - Home</title>
    <%-- Link to the new CSS file --%>
    <link rel="stylesheet" href="homepage.css">
    <%-- Link to Google Fonts (same as admin) --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- Removed outer .admin-container, body handles layout base --%>

    <%-- Header - Structure matches admin header --%>
    <header class="admin-header">
        <div class="header-content">
            <%@ page session="true" %>
            <%
                String username = (String) session.getAttribute("username");
                String userInitial = (username != null && !username.isEmpty()) ? String.valueOf(username.charAt(0)).toUpperCase() : "U";
                String displayName = (username != null && !username.isEmpty()) ? username : "User";
            %>
            <div class="admin-profile">
                <%-- No JS toggle needed --%>
                <div class="profile-icon">
                    <%= userInitial %>
                </div>
                <span class="admin-name"><%= displayName %></span>
            </div>

            <form action="LogoutServlet" method="post" class="logout-form">
                <input type="hidden" name="logoutRequest" value="true">
                <%-- Redirect back to homepage on logout --%>
                <input type="hidden" name="dashboardURL" value="homepage.jsp">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <%-- Wrapper for Sidebar and Main Content --%>
    <div class="dashboard-wrapper">

        <%-- Sidebar - User-specific links, styled like admin sidebar --%>
        <aside class="admin-sidebar">
             <%-- Added sidebar-nav class for consistency --%>
            <nav class="sidebar-nav">
                <%-- Added "active" class to Homepage link --%>
                <a href="homepage.jsp" class="sidebar-link active">
                    <span class="link-icon">🏠</span> <%-- Changed icon --%>
                    Homepage
                </a>
                <a href="UserQuizHistoryServlet" class="sidebar-link">
                    <span class="link-icon">📊</span>
                    Quiz History
                </a>
                <a href="#" class="sidebar-link"> <%-- Link to user settings page if available --%>
                    <span class="link-icon">⚙️</span>
                    Settings
                </a>
            </nav>
        </aside>

        <%-- Main Content - Contains the unique homepage elements --%>
        <main class="admin-main-content">
            <%-- Use dashboard-cards structure similar to admin for grouping --%>
            <div class="dashboard-cards">
                <%-- Renamed class to match admin structure, kept content --%>
                <div class="content-card subject-selection">
                    <h1>Quiz Time! Choose your subject</h1>
                    <div class="subject-grid">
                        <% String[] subjects = {"Java", "Python", "HTML", "CSS", "OOPS", "SQL"}; %>
                        <%-- Use consistent button styling if possible, but keep card structure --%>
                        <% for (String subject : subjects) { %>
                            <form action="QuizServlet" method="get" class="subject-card-form">
                                <input type="hidden" name="subjectName" value="<%= subject %>">
                                <button type="submit" class="subject-card-button">
                                     <%-- Make sure image paths are correct relative to webapp root --%>
                                    <img src="images/<%= subject.toLowerCase() %>-logo.png" alt="<%= subject %> Logo">
                                    <h3><%= subject %></h3>
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
                 <%-- Add more content/cards here if needed to test scroll --%>
                 <%-- <div style="height: 600px; background: lightsalmon; margin-top: 20px;">Extra space</div> --%>
            </div>
        </main>
    </div>

    <%-- Footer - Wrapped include in standard footer tag --%>
    <footer class="admin-footer">
        <jsp:include page="includes/footer.jsp" />
         <%-- Fallback content --%>
         <%-- <p>© 2023 Quizzy Platform</p> --%>
    </footer>

    <%-- Removed JavaScript block --%>
</body>
</html>