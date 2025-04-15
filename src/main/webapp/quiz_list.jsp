<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizMetadata" %>
<%@ page import="com.yash.quizapplication.service.QuizService" %>
<%@ page import="com.yash.quizapplication.serviceimpl.QuizServiceImpl" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Existing Quiz</title>
    <link rel="stylesheet" href="quiz_list.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="admin-header">
            <div class="header-content">
                <div class="admin-profile">
                    <div class="profile-icon">A</div>
                    <span class="admin-name">Admin</span>
                </div>
                <div class="header-actions">
                    <form action="LogoutServlet" method="post" class="logout-form">
                        <input type="hidden" name="logoutRequest" value="true">
                        <input type="hidden" name="dashboardURL" value="admin.jsp">
                        <button type="submit" class="logout-btn">Logout</button>
                    </form>
                </div>
            </div>
        </header>

        <div class="dashboard-wrapper">
            <aside class="admin-sidebar">
                <nav class="sidebar-nav">
                    <a href="generate_quiz.jsp" class="sidebar-link">
                        <span class="link-icon">🧩</span>
                        Generate New Quiz
                    </a>
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

            <main class="admin-main-content">
                <div class="page-header">
                    <h1>Quiz Management</h1>
                    <p>View, edit, or delete existing quizzes from the system</p>
                </div>

                <div class="content-card">
                    <div class="card-header">
                        <span class="card-icon">✏️</span>
                        <h2>Available Quizzes</h2>
                    </div>

                    <div class="card-content">
                        <%
                            QuizService quizService = new QuizServiceImpl();
                            List<QuizMetadata> quizList = quizService.getAllQuizzes();
                        %>

                        <%
                            String message = request.getParameter("msg");
                            if("deleted".equals(message)) {
                        %>
                            <div class="alert success-message">
                                <span class="alert-icon">✅</span>
                                Quiz deleted successfully!
                            </div>
                        <% } else if ("error".equals(message)) { %>
                            <div class="alert error-message">
                                <span class="alert-icon">❌</span>
                                Failed to delete quiz!
                            </div>
                        <% } %>

                        <div class="table-wrapper">
                            <table class="quiz-table">
                                <thead>
                                    <tr>
                                        <th>Quiz ID</th>
                                        <th>Quiz Title</th>
                                        <th>Subject</th>
                                        <th>Questions</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (quizList != null && !quizList.isEmpty()) {
                                        for(QuizMetadata quiz: quizList){ %>
                                        <tr>
                                            <td><%= quiz.getQuizId() %></td>
                                            <td><%= quiz.getQuizTitle() %></td>
                                            <td><%= quiz.getSubjectName() %></td>
                                            <td><%= quiz.getTotalQuestions() %></td>
                                            <td class="action-buttons">
                                                <a href="ViewQuizServlet?quizId=<%= quiz.getQuizId() %>" class="btn view-btn">
                                                    <span class="btn-icon">👁️</span> View
                                                </a>
                                                <a href="DeleteQuizServlet?quizId=<%= quiz.getQuizId() %>" class="btn delete-btn" onclick="return confirm('Are you sure you want to delete this quiz?');">
                                                    <span class="btn-icon">🗑️</span> Delete
                                                </a>
                                            </td>
                                        </tr>
                                    <% }
                                    } else { %>
                                        <tr>
                                            <td colspan="5" class="no-quizzes">No quizzes found</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-actions">
                            <a href="generate_quiz.jsp" class="action-link">
                                <span class="action-icon">➕</span>
                                Create New Quiz
                            </a>
                            <a href="add_questions.jsp" class="action-link add-questions-link">
                                <span class="action-icon">❓</span>
                                Add Questions to Existing Quiz
                            </a>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </div>
</body>
</html>