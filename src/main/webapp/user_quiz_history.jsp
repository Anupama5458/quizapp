<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quizzy - Quiz History</title>
    <%-- Link to the new CSS file --%>
    <link rel="stylesheet" href="user_quiz_history.css">
    <%-- Link to Google Fonts (same as admin) --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- Removed outer admin-container div --%>

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
                 <%-- Removed onclick --%>
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

        <%-- Removed sidebar checkbox toggle and label --%>

        <%-- Sidebar - User-specific links, styled like admin sidebar --%>
        <aside class="admin-sidebar">
            <%-- Added sidebar-nav class --%>
            <nav class="sidebar-nav">
                <a href="homepage.jsp" class="sidebar-link">
                    <span class="link-icon">🏠</span> <%-- Changed icon --%>
                    Homepage
                </a>
                 <%-- Added "active" class to this link --%>
                <a href="UserQuizHistoryServlet" class="sidebar-link active">
                    <span class="link-icon">📊</span> <%-- Changed icon --%>
                    Quiz History
                </a>
                <a href="#" class="sidebar-link"> <%-- Link to user settings page if available --%>
                    <span class="link-icon">⚙️</span>
                    Settings
                </a>
            </nav>
        </aside>

        <%-- Main Content - Contains the unique history elements --%>
        <main class="admin-main-content">
             <%-- Use dashboard-cards structure similar to admin for grouping --%>
            <div class="dashboard-cards">
                 <%-- Renamed class to content-card for consistency --%>
                <div class="content-card quiz-history">
                    <h1>Your Quiz History</h1>
                    <div class="table-container">
                        <%-- Renamed table class for potential specific styling --%>
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>Subject</th>
                                    <th>Quiz Title</th>
                                    <th>Score</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty quizResults}">
                                        <c:forEach var="result" items="${quizResults}">
                                            <tr>
                                                <td>${result.subjectName}</td>
                                                <td>${result.quizTitle}</td>
                                                <td><span class="score">${result.score}</span></td>
                                                <td>${result.quizDate}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <%-- Added no-data class for consistency --%>
                                            <td colspan="4" class="no-data">No quiz history found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                     <%-- Optional: Add a back button if desired --%>
                     <%-- <div class="action-footer">
                         <a href="${pageContext.request.contextPath}/homepage.jsp" class="back-link">Back to Homepage</a>
                     </div> --%>
                </div>
                 <%-- Add more content/cards here if needed to test scroll --%>
                 <%-- <div style="height: 600px; background: lightblue; margin-top: 20px;">Extra space</div> --%>
            </div>
        </main>
    </div>

    <%-- Footer - Wrapped include in standard footer tag --%>
    <footer class="admin-footer">
        <jsp:include page="includes/footer.jsp" />
         <%-- Fallback content --%>
         <%-- <p>© 2023 Quizzy Platform</p> --%>
    </footer>
</body>
</html>