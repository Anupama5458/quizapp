<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Question Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/libraryDashboard.css">
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
                <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="logout-form">
                    <input type="hidden" name="logoutRequest" value="true">
                    <input type="hidden" name="dashboardURL" value="admin.jsp">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </header>

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
                    <a href="libraryDashboard.jsp" class="sidebar-link active">
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
                <div class="dashboard-cards">
                    <div class="welcome-card">
                        <h1>Question Library Management</h1>
                        <p>Here you can manage the topics and questions within the central library.</p>
                    </div>

                    <div class="quick-actions">
                        <h2>Library Options</h2>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin/topics" class="action-btn">
                                <span class="action-icon">🗂️</span>
                                Manage Topics
                                <p class="action-description">Add, edit, or delete topic categories (e.g., Arrays, OOP).</p>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/library/questions?action=list" class="action-btn">
                                <span class="action-icon">❓</span>
                                Manage Questions
                                <p class="action-description">Add, edit, or delete reusable questions and assign them to topics.</p>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin.jsp" class="action-btn">
                                <span class="action-icon">⬅️</span>
                                Back to Dashboard
                                <p class="action-description">Return to the main admin dashboard.</p>
                            </a>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="/includes/footer.jsp" />
    </div>
</body>
</html>