<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizQuestion" %>
<%@ page import="com.yash.quizapplication.domain.QuizMetadata" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Quiz Questions</title>
    <link rel="stylesheet" href="view_quiz.css"> <%-- Link to the CSS file --%>
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
                    <%-- "Back to Quiz List" button REMOVED from here --%>
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
                        <span class="link-icon">🧩</span> Generate New Quiz
                    </a>
                    <a href="quiz_list.jsp" class="sidebar-link active"> <%-- Active link --%>
                        <span class="link-icon">✏️</span> Edit Existing Quiz
                    </a>
                    <a href="libraryDashboard.jsp" class="sidebar-link">
                        <span class="link-icon">📚</span> Manage Library
                    </a>
                    <a href="AdminActivityServlet" class="sidebar-link">
                        <span class="link-icon">📊</span> View Activity
                    </a>
                    <a href="AdminApprovalServlet" class="sidebar-link">
                        <span class="link-icon">👥</span> Approve/Deny Registrations
                    </a>
                </nav>
            </aside>

            <%-- Main content structure similar to quiz_list.jsp --%>
            <main class="admin-main-content">
                <%
                   QuizMetadata quizMetadata = (QuizMetadata) request.getAttribute("quizMetadata");
                   // Use metadata title preferably, fall back to request attribute if needed
                   String quizTitle = (quizMetadata != null) ? quizMetadata.getQuizTitle() : (String) request.getAttribute("quizTitle");
                   if (quizTitle == null || quizTitle.trim().isEmpty()) {
                       quizTitle = "Selected Quiz"; // Default if title is missing
                   }
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
                        <span class="card-icon">👁️</span> <%-- View icon --%>
                        <h2>Quiz Questions</h2>
                    </div>

                    <%-- Card Content holds the table --%>
                    <div class="card-content">
                        <%
                            List<QuizQuestion> questions = (List<QuizQuestion>) request.getAttribute("questions");
                        %>

                        <div class="table-wrapper">
                            <table class="quiz-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Question</th>
                                        <th>Option A</th>
                                        <th>Option B</th>
                                        <th>Option C</th>
                                        <th>Option D</th>
                                        <th>Correct Answer</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (questions != null && !questions.isEmpty()) {
                                        int count = 1;
                                        for(QuizQuestion q: questions){ %>
                                        <tr>
                                            <td><%= count++ %></td>
                                            <td><%= q.getQuestionText() != null ? q.getQuestionText() : "" %></td>
                                            <td><%= q.getOptionA() != null ? q.getOptionA() : "" %></td>
                                            <td><%= q.getOptionB() != null ? q.getOptionB() : "" %></td>
                                            <td><%= q.getOptionC() != null ? q.getOptionC() : "" %></td>
                                            <td><%= q.getOptionD() != null ? q.getOptionD() : "" %></td>
                                            <td class="correct-answer-cell"><%= q.getCorrectOption() != null ? q.getCorrectOption() : "" %></td>
                                        </tr>
                                    <% } // End for loop
                                    } else { %>
                                        <tr>
                                            <td colspan="7" class="no-quizzes">No questions found for this quiz.</td>
                                        </tr>
                                    <% } // End if-else %>
                                </tbody>
                            </table>
                        </div>
                    </div> <%-- End card-content --%>
                </div> <%-- End content-card --%>

                <%-- Page Actions Area (Button moved here) --%>
                <div class="page-actions">
                    <a href="quiz_list.jsp" class="back-btn">Back to Quiz List</a>
                </div>

            </main> <%-- End admin-main-content --%>
        </div> <%-- End dashboard-wrapper --%>

        <%-- Footer Include --%>
        <jsp:include page="includes/footer.jsp" />

    </div> <%-- End admin-container --%>
</body>
</html>