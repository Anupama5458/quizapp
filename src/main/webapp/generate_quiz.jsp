<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Your Quiz</title>
    <link rel="stylesheet" href="generate_quiz.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <%-- No extra top-level container needed unless specifically for other purposes --%>

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
                <a href="generate_quiz.jsp" class="sidebar-link active">
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
                <a href="AdminApprovalServlet" class="sidebar-link">
                    <span class="link-icon">👥</span>
                    Approve/Deny Registrations
                </a>
                 <%-- Add more links if needed to test sidebar scroll --%>
                 <%-- <a href="#" class="sidebar-link"><span class="link-icon">⚙️</span> Settings</a> --%>
                 <%-- <a href="#" class="sidebar-link"><span class="link-icon">❓</span> Help</a> --%>
                 <%-- <a href="#" class="sidebar-link"><span class="link-icon">ℹ️</span> About</a> --%>
                 <%-- <a href="#" class="sidebar-link"><span class="link-icon">📄</span> Reports</a> --%>
                 <%-- <a href="#" class="sidebar-link"><span class="link-icon">🔔</span> Notifications</a> --%>
            </nav>
        </aside>

        <main class="admin-main-content">
            <div class="page-header">
                <h1>Create Your Quiz</h1>
                <p>Fill out the form below to generate a new quiz for your students</p>
            </div>

            <div class="content-card quiz-form-card">
                <div class="card-header">
                    <span class="card-icon">🧩</span>
                    <h2>Quiz Details</h2>
                </div>

                <form action="GenerateQuizServlet" method="post" class="quiz-form">
                    <div class="form-group">
                        <label for="quizTitle">Quiz Title</label>
                        <input type="text" id="quizTitle" name="quizTitle" placeholder="Enter a descriptive title for your quiz" required>
                    </div>

                    <div class="form-group">
                        <label for="totalQuestions">Total Questions</label>
                        <input type="number" id="totalQuestions" name="totalQuestions" min="1" placeholder="Number of questions to include" required>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <select id="subject" name="subject">
                            <option value="Java">Java</option>
                            <option value="Python">Python</option>
                            <option value="HTML">HTML</option>
                            <option value="CSS">CSS</option>
                            <option value="SQL">SQL</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="submit-button">Create Quiz</button>
                        <a href="admin.jsp" class="cancel-button">Cancel</a>
                    </div>
                </form>
            </div>

            <%-- Add more content here to test main content scrolling --%>
            <%-- <div style="height: 800px; background: lightgoldenrodyellow; margin-top: 20px; padding: 10px; border: 1px solid #ccc;">
                <h2>Extra Content Area</h2>
                <p>This is extra content designed to make the main area taller than the viewport, forcing it to scroll. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                <div style="height: 400px; background: lightblue; margin-top: 10px;">Inner Tall Div</div>
            </div> --%>
        </main>
    </div>

    <%-- Ensure your included footer exists and generates appropriate HTML --%>
    <%-- If includes/footer.jsp outputs <div class="footer">...</div>, the CSS selector .admin-footer needs to match --%>
    <footer class="admin-footer">
        <jsp:include page="includes/footer.jsp" />
        <%-- Example basic footer content if include is empty/doesn't exist --%>
        <%-- <p>© 2023 Your Quiz Platform</p> --%>
    </footer>

</body>
</html>