<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Topic</title>
    <%-- Link to Google Fonts (same as admin) --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <%-- Start Inline CSS --%>
    <style>
        /* --- Base Styles and Variables (from Admin Theme) --- */
        :root {
            --primary-color: #1e3a8a;
            --primary-light: #2563eb;
            --secondary-color: #334155;
            --background-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-color: #1e293b;
            --text-light: #64748b;
            --accent-color: #0ea5e9;
            --danger-color: #ef4444;
            --danger-hover: #dc2626;
            --success-color: #10b981;
            --success-hover: #059669;
            --grey-color: #6c757d; /* Original cancel button color */
            --grey-hover: #5a6268; /* Original cancel hover */
            --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s ease;

            /* Layout Dimensions */
            --header-height: 70px;
            --footer-height: 50px;
            --sidebar-width: 280px;
            --wrapper-padding: 24px;
            --wrapper-gap: 24px;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html {
            scroll-behavior: smooth;
        }
        body {
            font-family: 'Roboto', sans-serif; /* Use Roboto */
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            padding-top: var(--header-height); /* Space for fixed header */
            padding-bottom: var(--footer-height); /* Space for fixed footer */
        }

        /* --- Fixed/Sticky Layout Styles --- */

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
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }
        /* Header Content Styles */
        .admin-profile { display: flex; align-items: center; }
        .profile-icon { width: 42px; height: 42px; background-color: var(--primary-light); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px; font-weight: bold; font-size: 18px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .admin-name { font-size: 1.2rem; font-weight: 500; letter-spacing: 0.5px; }
        .header-actions { display: flex; align-items: center; gap: 16px; }

        .logout-form { display: inline-block; }
        .logout-btn { background-color: var(--danger-color); color: white; border: none; padding: 10px 18px; border-radius: 6px; cursor: pointer; font-weight: 500; letter-spacing: 0.5px; transition: var(--transition); }
        .logout-btn:hover { background-color: var(--danger-hover); transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

        .dashboard-wrapper {
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
            padding: var(--wrapper-padding);
            gap: var(--wrapper-gap);
            align-items: flex-start;
        }

        .admin-sidebar {
            width: var(--sidebar-width);
            flex-shrink: 0;
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 24px 16px;
            box-shadow: var(--card-shadow);
            position: sticky;
            top: calc(var(--header-height) + var(--wrapper-padding));
            max-height: calc(100vh - var(--header-height) - var(--footer-height) - (2 * var(--wrapper-padding)));
            overflow-y: auto;
        }
        .sidebar-nav { display: flex; flex-direction: column; gap: 8px; }
        .sidebar-link { display: flex; align-items: center; text-decoration: none; color: var(--text-color); padding: 14px 18px; border-radius: 8px; transition: var(--transition); font-weight: 500; }
        .sidebar-link:hover { background-color: var(--accent-color); color: white; transform: translateX(5px); }
        .sidebar-link.active { background-color: var(--primary-color); color: white; } /* Default active style */
        .link-icon { margin-right: 14px; font-size: 1.4rem; display: inline-flex; align-items: center; justify-content: center; }

        .admin-main-content {
            flex-grow: 1;
            min-width: 0;
        }

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

        .content-container {
            padding: 32px; /* Use more padding like admin cards */
            background-color: var(--card-bg); /* Use theme variable */
            border-radius: 12px; /* Match admin radius */
            box-shadow: var(--card-shadow); /* Use theme shadow */
            width: 100%; /* Fill main content area */
            border-top: 5px solid var(--primary-color); /* Add admin card border */
        }
        .edit-topic-form h1 {
            margin-bottom: 25px;
            font-size: 1.8em; /* Match other H1 */
            color: var(--primary-color);
            text-align: center; /* Center title */
            padding-bottom: 12px; /* Space for underline */
            border-bottom: 1px solid #e2e8f0; /* Add divider */
             position: relative;
        }
         .edit-topic-form h1::after {
            content: '';
            position: absolute;
            bottom: -1px; /* Sit on top of border */
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background-color: var(--accent-color);
            border-radius: 3px;
        }

        .form-group { margin-bottom: 20px; } /* Added form-group class */

        .edit-topic-form label {
            display: block;
            margin-bottom: 8px; /* Consistent spacing */
            font-weight: 500; /* Match admin labels */
            color: var(--secondary-color);
        }
        .edit-topic-form input[type="text"] {
            width: 100%; /* Full width */
            padding: 12px 16px; /* Match admin inputs */
            margin-bottom: 15px;
            border: 1px solid #cbd5e1; /* Match admin border */
            border-radius: 8px; /* Match admin radius */
            font-size: 1rem; /* Match admin font size */
            box-sizing: border-box;
            transition: var(--transition);
        }
         .edit-topic-form input[type="text"]:focus {
             outline: none;
             border-color: var(--accent-color);
             box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15);
         }

        .form-actions {
            margin-top: 32px; /* More space */
            text-align: right;
            display: flex; /* Use flex for better spacing */
            justify-content: flex-end; /* Align buttons right */
            gap: 16px; /* Gap between buttons */
        }
        .form-actions button, .form-actions a {
            padding: 10px 20px;
            border-radius: 6px; /* Match admin button radius */
            cursor: pointer;
            font-size: 1rem; /* Match admin button font size */
            font-weight: 500;
            text-decoration: none;
            border: none;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
         .form-actions button:hover, .form-actions a:hover {
             transform: translateY(-2px);
             box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
         }

        .form-actions button[type="submit"] {
            background-color: var(--success-color);
            color: white;
        }
        .form-actions button[type="submit"]:hover { background-color: var(--success-hover); }

        .form-actions .cancel-link {
            background-color: var(--grey-color);
            color: white;
            line-height: normal; /* Reset line-height */
        }
        .form-actions .cancel-link:hover { background-color: var(--grey-hover); text-decoration: none; }


        .back-link { /* Style for the back link below form */
            display: inline-block;
            margin-top: 25px;
            color: var(--accent-color); /* Use accent color */
            text-decoration: none;
            font-weight: 500;
        }
        .back-link:hover { text-decoration: underline; }

        .error-message { /* Add a class for potential errors */
            color: var(--danger-color);
            background-color: #fee2e2;
            border: 1px solid #fecaca;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        @media screen and (max-width: 768px) {
            .dashboard-wrapper { flex-direction: column; padding: 16px; gap: 16px; }
            .admin-sidebar { width: 100%; position: static; max-height: none; overflow-y: visible; margin-bottom: 16px; }
            .content-container { padding: 24px; }
            .form-actions { justify-content: center; flex-direction: column-reverse; gap: 10px; align-items: stretch; } /* Stack buttons */
            .form-actions button, .form-actions a { width: 100%; margin-left: 0;}
        }
        @media screen and (max-width: 480px) {
            .admin-header { padding: 0 16px; }
            .profile-icon { width: 36px; height: 36px; }
            .admin-name { font-size: 1rem; }
            .logout-btn, .back-btn { padding: 8px 14px; font-size: 0.9rem;}
            .content-container { padding: 16px; }
            .edit-topic-form h1 { font-size: 1.5em; }
            .edit-topic-form input[type="text"] { padding: 10px; }
            .form-actions button, .form-actions a { padding: 10px 15px; font-size: 0.95rem;}
        }

    </style>
    <%-- End Inline CSS --%>
</head>
<body>

    <header class="admin-header">
         <div class="header-content">
             <div class="admin-profile">
                  <div class="profile-icon">A</div>
                  <span class="admin-name">Admin</span>
             </div>
             <div class="header-actions">
                 <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="logout-form">
                     <input type="hidden" name="logoutRequest" value="true">
                     <input type="hidden" name="dashboardURL" value="admin.jsp">
                     <button type="submit" class="logout-btn">Logout</button>
                </form>
             </div>
         </div>
    </header>

    <%-- Wrapper for Sidebar and Main Content --%>
    <div class="dashboard-wrapper">

        <%-- Standard Admin Sidebar --%>
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
                <%-- Mark Library link as active --%>
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

        <%-- Main Content Area --%>
        <main class="admin-main-content">
             <%-- Removed extra content-wrapper div if not needed --%>
            <div class="content-container edit-topic-form">
                <h1>Edit Topic</h1>

                <%-- Error Message Handling --%>
                <c:if test="${not empty requestScope.errorMessage}">
                    <p class="error-message"><c:out value="${requestScope.errorMessage}"/></p>
                </c:if>

                <%-- Check if topic object exists --%>
                <c:if test="${empty topic}">
                    <p class="error-message">Error: Topic data not found. Cannot edit.</p>
                    <a href="${pageContext.request.contextPath}/admin/topics?action=list" class="back-link">← Back to Topic List</a>
                </c:if>

                <c:if test="${not empty topic}">
                    <form action="${pageContext.request.contextPath}/admin/topics" method="post">
                        <%-- Hidden fields --%>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="topicId" value="${topic.topicId}">

                        <div class="form-group">
                            <label for="topicName">Topic Name:</label>
                            <input type="text" id="topicName" name="topicName" value="<c:out value='${topic.topicName}'/>" required maxlength="250">
                        </div>

                        <div class="form-actions">
                            <%-- Use library dashboard link for cancel consistency --%>
                            <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="cancel-link">Cancel</a>
                            <button type="submit">Update Topic</button>
                        </div>
                    </form>
                </c:if> <%-- End check for topic object --%>

                 <%-- Consistent back link style/location --%>
                 <a href="${pageContext.request.contextPath}/libraryDashboard.jsp" class="back-link">← Back to Library Dashboard</a>

            </div> <%-- End content-container --%>
        </main> <%-- End admin-main-content --%>

    </div> <%-- End dashboard-wrapper --%>

    <%-- Standard Admin Footer --%>
    <footer class="admin-footer">
        <jsp:include page="includes/footer.jsp" />
        <%-- <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p> --%>
    </footer>

</body>
</html>