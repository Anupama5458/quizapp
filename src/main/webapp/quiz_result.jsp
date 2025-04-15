<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizQuestion" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- Added JSTL --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Result</title>
    <%-- Link to the new CSS file --%>
    <link rel="stylesheet" href="quiz_result.css">
    <%-- Link to Google Fonts (same as admin) --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- Removed outer admin-container div --%>

    <%-- Header - Structure matches admin header --%>
    <header class="admin-header">
        <div class="header-content">
            <%
                String username = (String) session.getAttribute("username");
                int score = 0; // Default
                int totalQuestions = 0; // Default

                // Safely get score and totalQuestions from request attributes
                Object scoreObj = request.getAttribute("score");
                Object totalQuestionsObj = request.getAttribute("totalQuestions");

                if (scoreObj instanceof Integer) {
                    score = (Integer) scoreObj;
                }
                if (totalQuestionsObj instanceof Integer) {
                    totalQuestions = (Integer) totalQuestionsObj;
                }

                // Calculate other metrics
                int correctAnswers = score;
                int incorrectAnswers = 0;
                int unattemptedQuestions = 0;

                // Default calculation
                incorrectAnswers = totalQuestions - score;

                // Attempt more precise calculation using session data if available
                try {
                    Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
                    if (userAnswers != null && totalQuestions > 0) { // Check totalQuestions > 0
                        int attempted = 0;
                        // Count non-empty/non-null answers as attempted
                        for (String answer : userAnswers.values()) {
                            if (answer != null && !answer.trim().isEmpty()) {
                                attempted++;
                            }
                        }
                        unattemptedQuestions = totalQuestions - attempted;
                        // Ensure incorrect is not negative if calculation is off
                        incorrectAnswers = Math.max(0, attempted - correctAnswers);
                    } else {
                        // If userAnswers is null, assume all non-correct are incorrect
                        unattemptedQuestions = 0; // Can't determine unattempted
                        incorrectAnswers = totalQuestions - score;
                    }
                } catch (Exception e) {
                     // Fallback to simple calculation in case of any error
                    incorrectAnswers = totalQuestions - score;
                    unattemptedQuestions = 0;
                    System.err.println("Error calculating detailed results: " + e.getMessage());
                }

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
                <input type="hidden" name="dashboardURL" value="homepage.jsp">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <%-- Wrapper for Sidebar and Main Content --%>
    <div class="dashboard-wrapper">

        <%-- Sidebar - User-specific links, styled like admin sidebar --%>
        <aside class="admin-sidebar">
            <%-- Added sidebar-nav class --%>
            <nav class="sidebar-nav">
                <a href="homepage.jsp" class="sidebar-link active"> <%-- Keep homepage active? --%>
                    <span class="link-icon">🏠</span>
                    Homepage
                </a>
                <a href="UserQuizHistoryServlet" class="sidebar-link">
                    <span class="link-icon">📊</span>
                    Quiz History
                </a>
                <a href="#" class="sidebar-link">
                    <span class="link-icon">⚙️</span>
                    Settings
                </a>
            </nav>
        </aside>

        <%-- Main Content - Contains the result information --%>
        <main class="admin-main-content">
            <div class="dashboard-cards">
                <div class="content-card quiz-result-page"> <%-- Use consistent card class --%>

                    <%-- Display Error Message (if any) --%>
                    <c:if test="${not empty errorMessage}">
                        <p class="error-message">${errorMessage}</p> <%-- Use a class for styling errors --%>
                    </c:if>

                    <h2>Quiz Completed!</h2>

                    <!-- Result Cards -->
                    <div class="result-cards">
                        <div class="result-card correct">
                            <h3>Correct Answers</h3>
                            <p><%= correctAnswers %></p>
                        </div>
                        <div class="result-card incorrect">
                            <h3>Incorrect Answers</h3>
                            <p><%= incorrectAnswers %></p>
                        </div>
                        <div class="result-card unattempted">
                            <h3>Unattempted</h3>
                            <p><%= unattemptedQuestions %></p>
                        </div>
                    </div>

                    <p class="final-score">Your Score: <strong><%= score %></strong> / <%= totalQuestions %></p>

                    <%-- Use action-footer for consistent centering/spacing --%>
                    <div class="action-footer">
                        <a href="homepage.jsp" class="action-button back-home-btn">Go Back to Homepage</a>
                    </div>
                </div>
                <%-- Add more content/cards here if needed to test scroll --%>
                <%-- <div style="height: 600px; background: lightpink; margin-top: 20px;">Extra space</div> --%>
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