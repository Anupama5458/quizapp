<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Set Title Dynamically based on Add or Edit mode --%>
    <title>${empty question ? 'Add New' : 'Edit'} Library Question</title>
    <%-- Link to external fonts if needed --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <%-- Start Inline CSS for Layout and Original Form/Sidebar Styles --%>
    <style>
        /* Basic Reset and Variables */
        :root {
            --primary-color: #1e3a8a;
            --primary-light: #2563eb;
            --secondary-color: #334155; /* For original form styles */
            --background-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-color: #1e293b;
            --text-light: #64748b; /* For original form styles */
            --accent-color: #0ea5e9;
            --danger-color: #ef4444;
            --danger-hover: #dc2626;
            --success-color: #10b981; /* For original form styles */
            --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s ease;

            /* Define heights for fixed elements */
            --header-height: 70px; /* ADJUST AS NEEDED */
            --footer-height: 50px; /* ADJUST AS NEEDED */
            --sidebar-width: 280px; /* Width from previous examples */
            --wrapper-padding: 24px; /* Padding from previous examples */
            --wrapper-gap: 24px; /* Gap from previous examples */
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html {
            scroll-behavior: smooth;
        }

        /* Body Styles - Setup for fixed header/footer */
        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            margin: 0;
            padding-top: var(--header-height); /* Space for fixed header */
            padding-bottom: var(--footer-height); /* Space for fixed footer */
        }

        /* Header Styles - Fixed */
        .admin-header {
            background-color: var(--primary-color);
            color: white;
            height: var(--header-height);
            padding: 0 var(--wrapper-padding);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px; /* Consistent max width */
            margin: 0 auto;
            width: 100%;
        }
        /* Styles for header elements (as seen in previous examples) */
        .admin-profile { display: flex; align-items: center; }
        .profile-icon { width: 42px; height: 42px; background-color: var(--primary-light); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px; font-weight: bold; font-size: 18px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .admin-name { font-size: 1.2rem; font-weight: 500; letter-spacing: 0.5px; }
        .logout-form { display: inline-block; }
        .logout-btn { background-color: var(--danger-color); color: white; border: none; padding: 10px 18px; border-radius: 6px; cursor: pointer; font-weight: 500; letter-spacing: 0.5px; transition: var(--transition); }
        .logout-btn:hover { background-color: var(--danger-hover); transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }


        /* Dashboard Wrapper - Flex container for Sidebar and Main */
        .dashboard-wrapper {
            display: flex;
            max-width: 1400px; /* Consistent max width */
            margin: 0 auto; /* Center the wrapper */
            width: 100%;
            padding: var(--wrapper-padding); /* Consistent padding */
            gap: var(--wrapper-gap); /* Gap between sidebar and main */
            align-items: flex-start; /* Align items to the top */
        }

        /* Sidebar Styles - Sticky LAYOUT ONLY */
        .admin-sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0; /* Prevent shrinking */
            background-color: var(--card-bg); /* Background from original */
            border-radius: 12px; /* Rounded corners from original */
            padding: 24px 16px; /* Padding from original */
            box-shadow: var(--card-shadow); /* Shadow from original */

            /* --- Sticky Positioning --- */
            position: sticky;
            top: calc(var(--header-height) + var(--wrapper-padding));
            max-height: calc(100vh - var(--header-height) - var(--footer-height) - (2 * var(--wrapper-padding)));
            overflow-y: auto; /* Allow internal scrolling */
            /* --- End Sticky --- */
        }
        /* Sidebar CONTENT Styles (from previous CSS examples) */
        .sidebar-nav { display: flex; flex-direction: column; gap: 8px; }
        .sidebar-link { display: flex; align-items: center; text-decoration: none; color: var(--text-color); padding: 14px 18px; border-radius: 8px; transition: var(--transition); font-weight: 500; }
        .sidebar-link:hover { background-color: var(--accent-color); color: white; transform: translateX(5px); }
        .sidebar-link.active { background-color: var(--primary-color); color: white; } /* Using primary color based on add_questions.css */
        .link-icon { margin-right: 14px; font-size: 1.4rem; display: inline-flex; align-items: center; justify-content: center; }


        /* Main Content Area - Takes remaining space and scrolls */
        .admin-main-content {
            flex-grow: 1;
            min-width: 0;
            /* Add display:flex if items inside need flex layout */
            /* display: flex; */
            /* flex-direction: column; */
            /* gap: 24px; */ /* Add gap if needed between direct children */
        }

        /* Footer Styles - Fixed & Black */
        .admin-footer {
            background-color: #000000; /* Black background */
            color: white;
            height: var(--footer-height);
            padding: 0 var(--wrapper-padding);
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 -4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .admin-footer p { margin: 0; font-size: 0.9rem; }


        /* --- Original Form Styles (from the <style> block in your JSP) --- */
        .content-container {
            padding: 20px;
            background-color: #fff; /* Uses --card-bg now */
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Uses --card-shadow now */
            width: 100%; /* Takes width from main content area */
            /* Removed margins */
        }
        .content-container h1 { margin-bottom: 20px; color: var(--primary-color); } /* Added color and spacing */
        .question-form label { display: block; margin-bottom: 5px; font-weight: bold; color: var(--secondary-color); } /* Use theme colors */
        .question-form input[type="text"],
        .question-form textarea,
        .question-form select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc; /* Keep original border or use #cbd5e1 */
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 1em;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .question-form input[type="text"]:focus,
        .question-form textarea:focus,
        .question-form select:focus {
             outline: none;
             border-color: var(--accent-color);
             box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15); /* Focus shadow */
         }

        .question-form textarea { min-height: 80px; resize: vertical; }
        .question-form .option-group { margin-bottom: 10px; }
        .question-form .option-group label { font-weight: normal; }

        .topic-selection { margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px;}
        .topic-selection h2 { margin-top: 0; margin-bottom: 10px; font-size: 1.2em; color: var(--secondary-color);}
        .topic-list { max-height: 150px; overflow-y: auto; border: 1px solid #eee; padding: 10px; background-color: #fdfdfd; border-radius: 4px; }
        .topic-list label { display: block; margin-bottom: 5px; font-weight: normal; cursor: pointer; }
        .topic-list input[type="checkbox"] { margin-right: 8px; vertical-align: middle;}

        .form-actions { margin-top: 25px; text-align: right; }
        .form-actions button, .form-actions a {
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            text-decoration: none;
            margin-left: 10px;
            display: inline-block;
            vertical-align: middle;
            transition: var(--transition);
        }
        .form-actions button[type="submit"] { background-color: var(--success-color); color: white; border: none; }
        .form-actions button[type="submit"]:hover { background-color: #059669; /* Darker success */ transform: translateY(-2px); }
        .form-actions .cancel-button { background-color: var(--text-light); color: white; border: none; }
        .form-actions .cancel-button:hover { background-color: var(--secondary-color); transform: translateY(-2px); }

        .back-link { display: inline-block; margin-top: 20px; color: var(--accent-color); text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }

        /* Basic Responsive Considerations (Inline) */
        @media screen and (max-width: 768px) {
            body { /* Padding remains */ }
            .dashboard-wrapper { flex-direction: column; padding: 16px; gap: 16px; }
            .admin-sidebar { width: 100%; position: static; max-height: none; overflow-y: visible; margin-bottom: 16px; }
            .form-actions { text-align: center; }
            .form-actions button, .form-actions a { margin: 5px; }
        }
         @media screen and (max-width: 480px) {
             .admin-header, .admin-footer { padding: 0 16px; }
             .profile-icon { width: 36px; height: 36px; }
             .admin-name { font-size: 1rem; }
             .logout-btn { padding: 8px 14px; }
             .content-container { padding: 15px; }
             .question-form input[type="text"],
             .question-form textarea,
             .question-form select { font-size: 0.95em; padding: 8px; }
             .form-actions button, .form-actions a { padding: 8px 15px; font-size: 0.95em; }
         }

    </style>
    <%-- End Inline CSS --%>

</head>
<body>
    <%-- Actual Header Structure (Example from previous files) --%>
    <header class="admin-header">
        <div class="header-content">
            <div class="admin-profile">
                 <div class="profile-icon">A</div>
                 <span class="admin-name">Admin</span>
            </div>
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="logout-form">
                <input type="hidden" name="logoutRequest" value="true">
                <input type="hidden" name="dashboardURL" value="admin.jsp"> <%-- Adjust if needed --%>
                <button type="submit" class="logout-btn">Logout</button>
           </form>
        </div>
    </header>

    <%-- Wrapper for Sidebar and Main Content --%>
    <div class="dashboard-wrapper">

        <%-- ACTUAL Sidebar Structure (Example from add_questions.jsp) --%>
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
                 <%-- Mark Library related link as active --%>
                <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="sidebar-link active">
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

        <%-- Main Content Area (Scrollable) --%>
        <main class="admin-main-content">
            <div class="content-container">

                <%-- Dynamically set heading --%>
                <h1>${empty question ? 'Add New Question to Library' : 'Edit Library Question'}</h1>

                <%-- Form posts to the LibraryQuestionServlet --%>
                <form action="${pageContext.request.contextPath}/admin/library/questions" method="post" class="question-form">

                    <%-- Hidden field for action (add or update) --%>
                    <input type="hidden" name="action" value="${empty question ? 'add' : 'update'}">

                    <%-- Hidden field for questionId ONLY when updating --%>
                    <c:if test="${not empty question}">
                        <input type="hidden" name="questionId" value="${question.libQuestionId}">
                    </c:if>

                    <%-- Question Text --%>
                    <div>
                        <label for="questionText">Question Text:</label>
                        <textarea id="questionText" name="questionText" rows="4" required>${question.questionText}</textarea>
                    </div>

                    <%-- Option A --%>
                    <div class="option-group">
                        <label for="option1">Option A:</label>
                        <input type="text" id="option1" name="option1" value="${question.option1}" required>
                    </div>

                    <%-- Option B --%>
                    <div class="option-group">
                        <label for="option2">Option B:</label>
                        <input type="text" id="option2" name="option2" value="${question.option2}" required>
                    </div>

                    <%-- Option C --%>
                    <div class="option-group">
                        <label for="option3">Option C:</label>
                        <input type="text" id="option3" name="option3" value="${question.option3}" required>
                    </div>

                    <%-- Option D --%>
                    <div class="option-group">
                        <label for="option4">Option D:</label>
                        <input type="text" id="option4" name="option4" value="${question.option4}" required>
                    </div>

                    <%-- Correct Option --%>
                    <div>
                        <label for="correctOption">Correct Option:</label>
                        <select id="correctOption" name="correctOption" required>
                            <option value="" ${empty question.correctOption ? 'selected' : ''}>-- Select Correct --</option>
                            <option value="A" ${question.correctOption == 'A' ? 'selected' : ''}>A</option>
                            <option value="B" ${question.correctOption == 'B' ? 'selected' : ''}>B</option>
                            <option value="C" ${question.correctOption == 'C' ? 'selected' : ''}>C</option>
                            <option value="D" ${question.correctOption == 'D' ? 'selected' : ''}>D</option>
                        </select>
                    </div>

                    <%-- Topic Selection Section --%>
                    <div class="topic-selection">
                        <h2>Assign to Topics:</h2>
                        <c:choose>
                            <c:when test="${not empty allTopics}">
                                <div class="topic-list">
                                    <c:forEach var="topic" items="${allTopics}">
                                        <label>
                                            <input type="checkbox" name="topicIds" value="${topic.topicId}"
                                                <%-- Check if this topicId is in the assigned list during EDIT mode --%>
                                                <c:if test="${not empty assignedTopicIds}">
                                                    <c:forEach var="assignedId" items="${assignedTopicIds}">
                                                        <c:if test="${topic.topicId == assignedId}">
                                                            checked
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                            >
                                            <c:out value="${topic.topicName}"/>
                                        </label>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>No topics available. Please <a href="${pageContext.request.contextPath}/admin/topics">add topics</a> first.</p> <%-- Make sure this link is correct --%>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Submit and Cancel Buttons --%>
                    <div class="form-actions">
                         <%-- Link back to library dashboard or question list --%>
                         <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="cancel-button">Cancel</a>
                         <button type="submit">${empty question ? 'Add Question' : 'Update Question'}</button>
                    </div>

                </form> <%-- End of form --%>

                 <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="back-link">← Back to Library Dashboard</a>

            </div> <%-- End content-container --%>

             <%-- Add extra content here to test scrolling if needed --%>
             <%-- <div style="height: 600px; background: lavender; margin-top: 20px;">Extra Tall Div</div> --%>

        </main> <%-- End admin-main-content --%>
    </div> <%-- End dashboard-wrapper --%>

    <%-- Actual Footer (Example) --%>
    <footer class="admin-footer">
        <%-- Use include or static text --%>
        <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p>
        <%-- <jsp:include page="includes/footer.jsp" /> --%>
    </footer>

</body>
</html>