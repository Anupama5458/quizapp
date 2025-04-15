<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Quiz Activity</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin_quiz_activity.css">
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
                    <a href="AdminActivityServlet" class="sidebar-link active">
                        <span class="link-icon">📊</span>
                        View Activity
                    </a>
                    <a href="AdminApprovalServlet" class="sidebar-link">
                        <span class="link-icon">👥</span>
                        Approve/Deny Registrations
                    </a>
                     <%-- Add more links if needed to test sidebar scroll --%>
                     <%-- <a href="#" class="sidebar-link"><span class="link-icon">⚙️</span> Settings</a> --%>
                </nav>
            </aside>

            <main class="admin-main-content">
                <div class="dashboard-cards"> <%-- Container specific to this page --%>
                    <div class="welcome-card">
                        <h1>Quiz Activity Dashboard</h1>
                        <p>Monitor user quiz attempts, scores, and performance data</p>
                    </div>

                    <div class="data-table-card">
                        <h2>Student Quiz Results</h2>
                        <div class="table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>User</th>
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
                                                    <td>${result.email}</td>
                                                    <td>${result.subjectName}</td>
                                                    <td>${result.quizTitle}</td>
                                                    <td><span class="score">${result.score}</span></td>
                                                    <td>${result.quizDate}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="no-data">No quiz activity found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="action-footer">
                        <a href="${pageContext.request.contextPath}/admin.jsp" class="back-link">Back to Admin Dashboard</a>
                    </div>
                    <%-- Add extra content here if needed to test main scroll --%>
                    <%-- <div style="height: 500px; background: lightseagreen; margin-top: 20px;">Extra space</div> --%>
                </div>
            </main>
        </div>

        <footer class="admin-footer">
            <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p>
        </footer>

    <%-- </div> --%> <%-- Optional closing tag for admin-container --%>
</body>
</html>