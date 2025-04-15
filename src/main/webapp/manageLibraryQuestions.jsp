<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Library Questions</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            overflow: hidden; /* Prevent body scrolling */
            margin: 0;
            padding: 0;
        }

        .admin-container {
            height: 100vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .dashboard-wrapper {
            height: calc(100vh - 76px);
            display: flex;
            overflow-x: hidden; /* Allow vertical overflow only */
        }

        .admin-sidebar {
            height: 92%;
            overflow-y: auto;
            position: relative;
            min-width: 250px;
            flex-shrink: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 16px;
        }

        .admin-main-content {
            height: 100%;
            overflow-y: auto;
            padding: 20px;
            flex: 1;
        }

        .content-container {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 32px;
            margin-bottom: 24px;
        }

        .question-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed;
        }

        .question-table th, .question-table td {
            border: 1px solid #e2e8f0;
            padding: 12px;
            text-align: left;
            vertical-align: top;
            word-wrap: break-word;
        }

        .question-table th {
            background-color: rgba(241, 245, 249, 0.7);
            font-weight: bold;
            color: var(--secondary-color);
        }

        .question-table .col-id { width: 6%; }
        .question-table .col-text { width: 40%; }
        .question-table .col-options { width: 35%; }
        .question-table .col-correct { width: 10%; }
        .question-table .col-actions { width: 12%; text-align: center; }

        .action-links a, .action-links button {
            margin: 0 5px 5px 0;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.9em;
            cursor: pointer;
            display: inline-block;
            transition: var(--transition);
            font-weight: 500;
        }

        .action-links .edit-link {
            background-color: var(--primary-light);
            color: white;
            text-decoration: none;
            border: none;
        }

        .action-links .edit-link:hover {
            background-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .action-links .delete-button {
            background-color: var(--danger-color);
            color: white;
            border: none;
            text-decoration: none;
        }

        .action-links .delete-button:hover {
            background-color: var(--danger-hover);
            transform: translateY(-2px);
        }

        .filter-form, .add-button-container {
            margin-top: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .filter-form label {
            font-weight: bold;
            color: var(--text-color);
        }

        .filter-form select {
            padding: 10px 15px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            background-color: white;
            color: var(--text-color);
            transition: var(--transition);
        }

        .filter-form select:focus {
            border-color: var(--primary-light);
            outline: none;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .add-button-container .add-button {
            padding: 10px 20px;
            background-color: var(--success-color);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
        }

        .add-button-container .add-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .message {
            padding: 16px;
            margin-bottom: 24px;
            border-radius: 8px;
            border: 1px solid transparent;
            font-size: 0.95em;
        }

        .success-message {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border-color: var(--success-color);
        }

        .error-message {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border-color: var(--danger-color);
        }

        .info-message {
            background-color: rgba(14, 165, 233, 0.1);
            color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .navigation-links {
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #e2e8f0;
        }

        .back-link {
            display: inline-block;
            margin-right: 15px;
            color: var(--primary-light);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }

        h1, h2 {
            color: var(--primary-color);
            margin-bottom: 16px;
        }

        h1 {
            font-size: 2rem;
            font-weight: 700;
        }

        h2 {
            font-size: 1.5rem;
            color: var(--secondary-color);
            margin-top: 32px;
            position: relative;
            padding-bottom: 12px;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 3px;
            background-color: var(--accent-color);
            border-radius: 3px;
        }

        .admin-header {
                background-color: var(--primary-color);
                color: white;
                padding: 16px 24px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        .admin-profile {
            display: flex;
            align-items: center;

        }

        .profile-icon {
                width: 42px;
                height: 42px;
                background-color: var(--primary-light);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 12px;
                font-weight: bold;
                font-size: 18px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .admin-name {
              font-size: 1.2rem;
              font-weight: 500;
              letter-spacing: 0.5px;
        }

        .logout-btn {
            background-color: var(--danger-color);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: var(--transition);
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        /* Sidebar navigation styles */
        .sidebar-nav {
            padding: 10px 0px;
            display: flex;
            flex-direction: column;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: var(--text-color);
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
            border-radius: 8px;
        }

        .sidebar-link:hover {
            background-color: rgba(241, 245, 249, 0.8);
            color: var(--primary-color);
        }

        .link-icon {
             margin-right: 14px;
             font-size: 1.4rem;
             display: inline-flex;
             align-items: center;
             justify-content: center;
        }

        /* Footer styles */
        .admin-footer {
            background-color: var(--primary-color);
            color: white;
            padding: 16px 24px;
            text-align: center;
            font-size: 0.9rem;
            margin-top: auto; /* Push to bottom */
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Header Section - Fixed -->
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
            <!-- Sidebar Section with fixed links -->
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

            <!-- Main Content Section - Scrollable -->
            <main class="admin-main-content">
                <div class="content-container">
                    <h1>Manage Library Questions</h1>

                    <!-- Display Messages -->
                    <c:if test="${not empty sessionScope.questionSuccess}"><div class="message success-message"><c:out value="${sessionScope.questionSuccess}"/></div><c:remove var="questionSuccess" scope="session"/></c:if>
                    <c:if test="${not empty sessionScope.questionError}"><div class="message error-message"><c:out value="${sessionScope.questionError}"/></div><c:remove var="questionError" scope="session"/></c:if>
                    <c:if test="${param.addSuccess == 'true'}"><div class="message success-message">Question added successfully!</div></c:if>
                    <c:if test="${param.addSuccess == 'false'}"><div class="message error-message">Failed to add question.</div></c:if>
                    <c:if test="${param.updateSuccess == 'true'}"><div class="message success-message">Question updated successfully!</div></c:if>
                    <c:if test="${param.deleteSuccess == 'true'}"><div class="message success-message">Question deleted successfully!</div></c:if>

                    <!-- Filter and Add Button Area -->
                    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                        <form action="${pageContext.request.contextPath}/admin/library/questions" method="get" class="filter-form">
                            <input type="hidden" name="action" value="listByTopic">
                            <label for="topicFilter">Filter by Topic:</label>
                            <select id="topicFilter" name="topicId" onchange="this.form.submit()">
                                <option value="0" ${empty selectedTopicId or selectedTopicId == 0 ? 'selected' : ''}>-- All Topics --</option>
                                <c:forEach var="topic" items="${topics}">
                                    <option value="${topic.topicId}" ${selectedTopicId == topic.topicId ? 'selected' : ''}>
                                        <c:out value="${topic.topicName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </form>

                        <div class="add-button-container">
                            <a href="${pageContext.request.contextPath}/admin/library/questions?action=addForm" class="add-button">Add New Library Question</a>
                        </div>
                    </div>

                    <h2>Existing Library Questions</h2>
                    <c:choose>
                        <c:when test="${not empty questions}">
                            <table class="question-table">
                                <thead>
                                    <tr>
                                        <th class="col-id">ID</th>
                                        <th class="col-text">Question Text</th>
                                        <th class="col-options">Options (A, B, C, D)</th>
                                        <th class="col-correct">Correct</th>
                                        <th class="col-actions">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="q" items="${questions}">
                                        <tr>
                                            <td class="col-id">${q.libQuestionId}</td>
                                            <td class="col-text"><c:out value="${q.questionText}"/></td>
                                            <td class="col-options">
                                                A: <c:out value="${q.option1}"/><br>
                                                B: <c:out value="${q.option2}"/><br>
                                                C: <c:out value="${q.option3}"/><br>
                                                D: <c:out value="${q.option4}"/>
                                            </td>
                                            <td class="col-correct"><c:out value="${q.correctOption}"/></td>
                                            <td class="col-actions action-links">
                                                <a href="${pageContext.request.contextPath}/admin/library/questions?action=editForm&questionId=${q.libQuestionId}" class="edit-link">Edit</a>
                                                <form action="${pageContext.request.contextPath}/admin/library/questions" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="questionId" value="${q.libQuestionId}">
                                                    <button type="submit" class="delete-button"
                                                            onclick="return confirm('Are you sure you want to delete this library question?');">
                                                        Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="info-message">No questions found matching the criteria. Add one!</p>
                        </c:otherwise>
                    </c:choose>

                    <div class="navigation-links">
                        <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="back-link">← Back to Library Dashboard</a>
                        <a href="${pageContext.request.contextPath}/admin.jsp" class="back-link">← Back to Main Admin Dashboard</a>
                    </div>
                </div>
            </main>
        </div>

        <!-- Include footer - Fixed at bottom -->
        <jsp:include page="includes/footer.jsp" />
    </div>
</body>
</html>