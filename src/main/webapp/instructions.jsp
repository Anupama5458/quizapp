<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.yash.quizapplication.domain.QuizMetadata" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String subjectName = request.getParameter("subjectName");
    List<QuizMetadata> quizzes = (List<QuizMetadata>) request.getAttribute("quizzes");

    // --- Define timer rules (MUST MATCH ViewQuizServlet) ---
    final double MINUTES_PER_QUESTION_JSP = 0.5;
    final int MINIMUM_TIME_LIMIT_MINUTES_JSP = 1;
    // No fallback needed here, just display minimum if count is 0

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quizzy - Instructions: <%= subjectName != null ? subjectName : "Select Subject" %></title> <%-- Dynamic Title --%>
    <link rel="stylesheet" href="instructions.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- Header (No Changes Needed) --%>
     <header class="admin-header">
        <div class="header-content">
            <%
                String username = (String) session.getAttribute("username");
                String userInitial = (username != null && !username.isEmpty()) ? String.valueOf(username.charAt(0)).toUpperCase() : "U";
                String displayName = (username != null && !username.isEmpty()) ? username : "User";
            %>
            <div class="admin-profile">
                <div class="profile-icon"><%= userInitial %></div>
                <span class="admin-name"><%= displayName %></span>
            </div>
            <form action="LogoutServlet" method="post" class="logout-form">
                <input type="hidden" name="logoutRequest" value="true">
                <input type="hidden" name="dashboardURL" value="homepage.jsp">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <%-- Wrapper for Sidebar and Main Content (No Changes Needed) --%>
    <div class="dashboard-wrapper">

        <%-- Sidebar (No Changes Needed) --%>
        <aside class="admin-sidebar">
            <nav class="sidebar-nav">
                <a href="homepage.jsp" class="sidebar-link active"> <span class="link-icon">🏠</span> Homepage </a>
                <a href="UserQuizHistoryServlet" class="sidebar-link"> <span class="link-icon">📊</span> Quiz History </a>
                <a href="#" class="sidebar-link"> <span class="link-icon">⚙️</span> Settings </a>
            </nav>
        </aside>

        <%-- Main Content --%>
        <main class="admin-main-content">
            <div class="dashboard-cards">
                <div class="content-card instructions-page">
                    <h1 class="page-title">Quiz Instructions: <span class="highlight"><%= subjectName != null ? subjectName : "Selected Subject" %></span></h1>

                     <%-- Display Error Message if present in request --%>
                     <% String errorMsg = request.getParameter("error");
                        if (errorMsg != null && !errorMsg.trim().isEmpty()) {
                     %>
                         <p style="color: red; background-color: #ffebee; border: 1px solid red; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                             Error: <%= errorMsg %>
                         </p>
                     <%
                        }
                     %>

                    <div class="instructions-section">
                        <h2>Before You Begin</h2>
                        <ul class="instruction-list">
                            <li>The quiz consists of questions designed to help you self-assess your comprehension of the topic.</li>
                            <li>Each question in the quiz is multiple-choice format.</li>
                            <li>Each question carries 1 mark, no negative marking.</li>
                            <%-- Changed the static time limit text to be more general --%>
                            <li>The quiz has a time limit based on the number of questions (typically 30 seconds per question).</li>
                            <li>Once time expires, the quiz will automatically submit.</li>
                            <li>Your score will be displayed immediately after completion.</li>
                        </ul>
                    </div>

                    <h2 class="section-title">Available Quizzes</h2>

                    <div class="quiz-container">
                        <% if (quizzes != null && !quizzes.isEmpty()) { %>
                            <div class="quiz-grid">
                                <% for (QuizMetadata quiz: quizzes) { %>
                                    <%
                                        // --- Apply the calculation rule for display ---
                                        int totalQuestions = quiz.getTotalQuestions();
                                        int displayTimeLimit = 0; // Default to 0 before calc
                                        String timeText = "N/A"; // Default text

                                        if (totalQuestions > 0) {
                                            displayTimeLimit = (int) Math.ceil(totalQuestions * MINUTES_PER_QUESTION_JSP);
                                            if (displayTimeLimit < MINIMUM_TIME_LIMIT_MINUTES_JSP) {
                                                displayTimeLimit = MINIMUM_TIME_LIMIT_MINUTES_JSP;
                                            }
                                            timeText = displayTimeLimit + (displayTimeLimit == 1 ? " minute" : " minutes");
                                        } else {
                                            // Handle case where metadata reports 0 questions
                                            // You might still allow starting it if ViewQuizServlet finds questions later,
                                            // but display minimal time or "N/A" here.
                                             timeText = "(" + MINIMUM_TIME_LIMIT_MINUTES_JSP + " min minimum)"; // Indicate minimum applies
                                        }
                                    %>
                                    <div class="quiz-card">
                                        <h3><%= quiz.getQuizTitle() %></h3>
                                        <div class="quiz-info">
                                            <p><span class="info-label">Questions:</span> <%= totalQuestions > 0 ? totalQuestions : "N/A" %></p>
                                            <%-- *** FIX: Use calculated time text *** --%>
                                            <p><span class="info-label">Time Limit:</span> <%= timeText %></p>
                                        </div>
                                        <form action="ViewQuizServlet" method="get">
                                            <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>">
                                            <input type="hidden" name="subjectName" value="<%= subjectName %>">
                                            <button type="submit" class="action-button start-btn">Start Quiz</button>
                                        </form>
                                    </div>
                                <% } // End for loop %>
                            </div>
                        <% } else { %>
                            <div class="no-quiz-message">
                                <p>No quizzes available for this subject yet.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="navigation action-footer">
                        <a href="homepage.jsp" class="action-button cancel-button">Back to Home</a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%-- Footer (No Changes Needed) --%>
    <footer class="admin-footer">
        <jsp:include page="includes/footer.jsp" />
    </footer>

</body>
</html>