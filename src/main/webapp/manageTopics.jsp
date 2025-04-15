<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Library Topics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }

        .admin-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        .admin-header {
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .dashboard-wrapper {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        .admin-sidebar {
            position: sticky;
            top: 0;
            height: 96%;
            overflow-y: auto;
        }

        .admin-main-content {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }

        .admin-footer {
            background-color: #000000;
            color: white;
            text-align: center;
            padding: 11px 0;
            width: 100%;
            z-index: 100;
        }

        .admin-footer p {
            margin: 0;
            font-size: 0.9rem;
        }

        .content-card {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            padding: 32px;
            margin-bottom: 24px;
            transition: all 0.3s ease;
            width: 100%;
        }

        .content-card h1 {
            color: #1e3a8a;
            margin-bottom: 24px;
            font-size: 1.8rem;
            font-weight: 700;
            position: relative;
            padding-bottom: 12px;
        }

        .content-card h1::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 3px;
            background-color: #0ea5e9;
            border-radius: 3px;
        }

        .topic-section {
            margin-bottom: 32px;
        }

        .topic-section h2 {
            color: #334155;
            font-size: 1.4rem;
            margin-bottom: 16px;
            font-weight: 600;
        }

        .table-container {
            overflow-x: auto;
            margin-bottom: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .topic-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
        }

        .topic-table th, .topic-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .topic-table th {
            background-color: #1e3a8a;
            color: white;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .topic-table tr:nth-child(even) {
            background-color: #f8fafc;
        }

        .topic-table tr:hover {
            background-color: #eef2ff;
        }

        .topic-table td:first-child {
            font-weight: 500;
        }

        .action-links {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .edit-link {
            background-color: #0ea5e9;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .edit-link:hover {
            background-color: #0284c7;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .delete-button {
            background-color: #ef4444;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .delete-button:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .add-topic-form {
            background-color: #f8fafc;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 32px;
            border: 1px solid #e2e8f0;
        }

        .add-topic-form h2 {
            color: #334155;
            font-size: 1.4rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input[type="text"] {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input[type="text"]:focus {
            border-color: #0ea5e9;
            outline: none;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.3);
        }

        .submit-btn {
            background-color: #10b981;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .message {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-weight: 500;
        }

        .success-message {
            background-color: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        .error-message {
            background-color: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        .info-message {
            background-color: #dbeafe;
            color: #1e40af;
            border-left: 4px solid #3b82f6;
        }

        .navigation-links {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
        }

        .back-link {
            display: flex;
            align-items: center;
            color: #1e3a8a;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
            background-color: #f1f5f9;
        }

        .back-link:hover {
            background-color: #e2e8f0;
            transform: translateX(-5px);
        }

        .back-link .link-icon {
            margin-right: 8px;
            font-size: 1.2rem;
        }


        @media screen and (max-width: 768px) {
            .content-card {
                padding: 24px 16px;
            }

            .action-links {
                flex-direction: column;
                align-items: flex-start;
            }

            .edit-link, .delete-button {
                width: 100%;
                text-align: center;
            }

            .navigation-links {
                flex-direction: column;
            }

            .back-link {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <header class="admin-header">
            <div class="header-content">
                <div class="admin-profile">
                    <div class="profile-icon">A</div>
                    <span class="admin-name">Admin</span>
                </div>
                <form action="LogoutServlet" method="post" class="logout-form">
                    <input type="hidden" name="logoutRequest" value="true">
                    <input type="hidden" name="dashboardURL" value="admin.jsp">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </header>

        <div class="dashboard-wrapper">
            <aside class="admin-sidebar">
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/generate_quiz.jsp" class="sidebar-link">
                        <span class="link-icon">🧩</span>
                        Generate New Quiz
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz_list.jsp" class="sidebar-link">
                        <span class="link-icon">✏️</span>
                        Edit Existing Quiz
                    </a>
                    <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="sidebar-link">
                        <span class="link-icon">📚</span>
                        Manage Library
                    </a>
                    <a href="${pageContext.request.contextPath}/AdminActivityServlet" class="sidebar-link">
                        <span class="link-icon">📊</span>
                        View Activity
                    </a>
                    <a href="${pageContext.request.contextPath}/AdminApprovalServlet" class="sidebar-link">
                        <span class="link-icon">👥</span>
                        Approve/Deny Registrations
                    </a>
                </nav>
            </aside>

            <main class="admin-main-content">
                <div class="content-card">
                    <h1>Manage Library Topics</h1>

                    <%-- Display Success/Error messages passed via Session attributes --%>
                    <c:if test="${not empty sessionScope.topicSuccess}">
                        <div class="message success-message"><c:out value="${sessionScope.topicSuccess}"/></div>
                        <c:remove var="topicSuccess" scope="session"/> <%-- Remove after displaying --%>
                    </c:if>
                    <c:if test="${not empty sessionScope.topicError}">
                        <div class="message error-message"><c:out value="${sessionScope.topicError}"/></div>
                        <c:remove var="topicError" scope="session"/> <%-- Remove after displaying --%>
                    </c:if>
                    <c:if test="${param.addSuccess == 'true'}">
                        <div class="message success-message">Topic added successfully!</div>
                    </c:if>
                    <c:if test="${param.addSuccess == 'false'}">
                        <div class="message error-message">Failed to add topic. Maybe it already exists?</div>
                    </c:if>
                    <c:if test="${param.updateSuccess == 'true'}">
                        <div class="message success-message">Topic updated successfully!</div>
                    </c:if>
                    <c:if test="${param.updateSuccess == 'false'}">
                        <div class="message error-message">Failed to update topic.</div>
                    </c:if>
                    <c:if test="${param.deleteSuccess == 'true'}">
                        <div class="message success-message">Topic deleted successfully!</div>
                    </c:if>
                    <c:if test="${param.deleteSuccess == 'false'}">
                        <div class="message error-message">Failed to delete topic.</div>
                    </c:if>
                    <c:if test="${param.error == 'notFound'}">
                        <div class="message error-message">Topic not found.</div>
                    </c:if>
                    <c:if test="${param.error == 'invalidId'}">
                        <div class="message error-message">Invalid Topic ID provided.</div>
                    </c:if>

                    <div class="topic-section">
                        <h2>Existing Topics</h2>
                        <c:choose>
                            <c:when test="${not empty topics}">
                                <div class="table-container">
                                    <table class="topic-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Topic Name</th>
                                                <th>Created At</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%-- Loop through the topics passed from the servlet --%>
                                            <c:forEach var="topic" items="${topics}">
                                                <tr>
                                                    <td>${topic.topicId}</td>
                                                    <td><c:out value="${topic.topicName}"/></td>
                                                    <td>
                                                        <%-- Format the timestamp nicely --%>
                                                        <fmt:formatDate value="${topic.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                    </td>
                                                    <td class="action-links">
                                                        <a href="${pageContext.request.contextPath}/admin/topics?action=editForm&topicId=${topic.topicId}" class="edit-link">Edit</a>
                                                        <form action="${pageContext.request.contextPath}/admin/topics" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="topicId" value="${topic.topicId}">
                                                            <button type="submit" class="delete-button"
                                                                    onclick="return confirm('Are you sure you want to delete the topic \\'${topic.topicName}\\'? This might remove questions linked ONLY to this topic.');">
                                                                Delete
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="info-message">No topics found in the library yet. Add one below!</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Form to Add New Topic --%>
                    <div class="add-topic-form">
                        <h2>Add New Topic</h2>
                        <%-- Form POSTs to TopicServlet --%>
                        <form action="${pageContext.request.contextPath}/admin/topics" method="post">
                            <%-- Hidden field specifies the action for the servlet's doPost --%>
                            <input type="hidden" name="action" value="add">

                            <div class="form-group">
                                <label for="topicName">Topic Name:</label>
                                <input type="text" id="topicName" name="topicName" required placeholder="e.g., Java Basics" maxlength="250">
                            </div>
                            <button type="submit" class="submit-btn">Add Topic</button>
                        </form>
                    </div>

                    <div class="navigation-links">
                        <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="back-link">
                            <span class="link-icon">📚</span>
                            Back to Library Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/admin.jsp" class="back-link">
                            <span class="link-icon">🏠</span>
                            Back to Main Admin Dashboard
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <footer class="admin-footer">
            <p>&copy; 2025 Quiz Administration System. All rights reserved.</p>
        </footer>
    </div>
</body>
</html>