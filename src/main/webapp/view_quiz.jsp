<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizQuestion" %>
<%-- Assuming QuizMetadata might be useful or passed for context --%>
<%@ page import="com.yash.quizapplication.domain.QuizMetadata" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Quiz Questions</title>
    <%-- Link to the NEW final CSS file --%>
    <link rel="stylesheet" href="view_quiz.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <%-- Header structure identical to quiz_list.jsp --%>
        <header class="admin-header">
            <div class="header-content">
                <div class="admin-profile">
                    <div class="profile-icon">A</div>
                    <span class="admin-name">Admin</span>
                </div>
                <div class="header-actions">
                    <%-- Use "back-btn" class to match quiz_list.css styling --%>
                    <a href="quiz_list.jsp" class="back-btn">Back to Quiz List</a>
                    <form action="LogoutServlet" method="post" class="logout-form">
                        <input type="hidden" name="logoutRequest" value="true">
                        <input type="hidden" name="dashboardURL" value="admin.jsp">
                        <button type="submit" class="logout-btn">Logout</button>
                    </form>
                </div>
            </div>
        </header>

        <%-- Dashboard wrapper identical to quiz_list.jsp --%>
        <div class="dashboard-wrapper">
            <%-- Sidebar structure identical to quiz_list.jsp, adding "active" class --%>
            <aside class="admin-sidebar">
                <nav class="sidebar-nav">
                    <a href="generate_quiz.jsp" class="sidebar-link">
                        <span class="link-icon">🧩</span>
                        Generate New Quiz
                    </a>
                    <%-- Add 'active' class since viewing a quiz relates to editing/managing them --%>
                    <a href="quiz_list.jsp" class="sidebar-link active">
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
                    <a href="AdminApprovalServlet" class="sidebar-link">
                        <span class="link-icon">👥</span>
                        Approve/Deny Registrations
                    </a>
                </nav>
            </aside>

            <%-- Main content structure similar to quiz_list.jsp --%>
            <main class="admin-main-content">
                <%

                   QuizMetadata quizMetadata = (QuizMetadata) request.getAttribute("quizMetadata");
                   String quizTitle = (quizMetadata != null) ? quizMetadata.getQuizTitle() : (String) request.getAttribute("quizTitle");
                   if (quizTitle == null) quizTitle = "Selected Quiz";
                %>
                <%-- Page Header Section --%>
                <div class="page-header">
                    <h1>View Quiz Details</h1>
                     <p>Displaying questions for: <strong><%= quizTitle %></strong></p>
                </div>

                <%-- Content Card for the questions table --%>
                <div class="content-card">
                    <%-- Card Header --%>
                    <div class="card-header">
                        <span class="card-icon"></span> <%-- View icon --%>
                        <h2>Quiz Questions</h2>
                    </div>

                    <%-- Card Content holds the table --%>
                    <div class="card-content">
                        <%
                            // Retrieve the list of questions
                            List<QuizQuestion> questions = (List<QuizQuestion>) request.getAttribute("questions");
                        %>

                        <%-- Optional: Add messages if needed (e.g., if loading failed) --%>
                        <%-- <% String message = request.getParameter("msg"); %> --%>
                        <%-- <% if ("load_error".equals(message)) { %>
                            <div class="alert error-message"> ... Error loading questions ... </div>
                        <% } %> --%>

                        <%-- Table Wrapper identical to quiz_list.jsp --%>
                        <div class="table-wrapper">
                            <%-- Use "quiz-table" class to match quiz_list.css styling --%>
                            <table class="quiz-table">
                                <thead>
                                    <tr>
                                        <th>#</th> <%-- Use '#' instead of 'Quiz ID' --%>
                                        <th>Question</th>
                                        <th>Option A</th>
                                        <th>Option B</th>
                                        <th>Option C</th>
                                        <th>Option D</th>
                                        <th>Correct Answer</th> <%-- Keep specific header --%>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (questions != null && !questions.isEmpty()) {
                                        int count = 1;
                                        for(QuizQuestion q: questions){ %>
                                        <tr>
                                            <td><%= count++ %></td>
                                            <td><%= q.getQuestionText() %></td>
                                            <td><%= q.getOptionA() %></td>
                                            <td><%= q.getOptionB() %></td>
                                            <td><%= q.getOptionC() %></td>
                                            <td><%= q.getOptionD() %></td>
                                            <%-- Add a specific class for potentially different styling --%>
                                            <td class="correct-answer-cell"><%= q.getCorrectOption() %></td>
                                        </tr>
                                    <% }
                                    } else { %>
                                        <tr>
                                            <%-- Adjust colspan to match new number of columns --%>
                                            <td colspan="7" class="no-quizzes">No questions found for this quiz.</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <%-- Optional: Add card actions if needed --%>
                        <%-- <div class="card-actions"> ... </div> --%>
                    </div>
                </div>
            </main>
        </div>

        <%-- Use the same footer include as quiz_list.jsp for consistency --%>
        <%-- If you want the BLACK footer from previous request, use:
        <footer class="admin-footer">
            <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p>
        </footer>
        Make sure the CSS below includes .admin-footer styling if you use this. --%>
        <jsp:include page="includes/footer.jsp" />

    </div>
</body>
</html>