<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizMetadata" %>
<%@ page import="com.yash.quizapplication.domain.Topic" %>
<%@ page import="com.yash.quizapplication.domain.LibraryQuestion" %>
<%@ page import="com.yash.quizapplication.service.QuizService" %>
<%@ page import="com.yash.quizapplication.service.TopicService" %>
<%@ page import="com.yash.quizapplication.service.LibraryService" %>
<%@ page import="com.yash.quizapplication.serviceimpl.QuizServiceImpl" %>
<%@ page import="com.yash.quizapplication.serviceimpl.TopicServiceImpl" %>
<%@ page import="com.yash.quizapplication.serviceimpl.LibraryServiceImpl" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  QuizService quizService = new QuizServiceImpl();
  List<QuizMetadata> quizzes = quizService.getAllQuizzes();
  TopicService topicService = new TopicServiceImpl();
  List<Topic> allTopics = topicService.getAllTopics();
  LibraryService libraryService = new LibraryServiceImpl();

  Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
  Integer currentQuestionCount = (Integer) session.getAttribute("currentQuestionCount");
  if(totalQuestions == null) totalQuestions = 0;
  if(currentQuestionCount == null) currentQuestionCount = 0;

  String quizIdParam = request.getParameter("quizId");
  Integer selectedQuizId = null;
  if(quizIdParam != null && !quizIdParam.isEmpty()) {
    try { selectedQuizId = Integer.parseInt(quizIdParam); session.setAttribute("selectedQuizId", selectedQuizId); }
    catch (NumberFormatException e) { selectedQuizId = (Integer) session.getAttribute("selectedQuizId"); }
  } else { selectedQuizId = (Integer) session.getAttribute("selectedQuizId"); }
  int selectedQuizIdForDisplay = (selectedQuizId == null) ? -1 : selectedQuizId;

  String method = request.getParameter("method");
  if (method == null) { method = (String) session.getAttribute("selectedMethod"); if (method == null) method = "manual"; }
  else { session.setAttribute("selectedMethod", method); }

  String topicIdParam = request.getParameter("topicId");
  Integer selectedTopicId = null;
  if (topicIdParam != null && !topicIdParam.isEmpty()) {
      try { selectedTopicId = Integer.parseInt(topicIdParam); }
      catch (NumberFormatException e) { /* ignore invalid */ }
  }

  // --- Fetch Library Questions (if topic selected for Library method) ---
  List<LibraryQuestion> libraryQuestionsToShow = new ArrayList<>();
  if ("library".equals(method) && selectedTopicId != null && selectedTopicId > 0) {
      libraryQuestionsToShow = libraryService.getQuestionsByTopic(selectedTopicId);
  }


  String successMessage = request.getParameter("success");
  boolean showPopup = (successMessage != null && !successMessage.isEmpty() && currentQuestionCount >= totalQuestions && totalQuestions > 0);
  String errorMessage = request.getParameter("error");
  String addFromLibSuccess = request.getParameter("addFromLibSuccess");

  pageContext.setAttribute("selectedQuizId", selectedQuizId);
  pageContext.setAttribute("selectedMethod", method);
  pageContext.setAttribute("allTopics", allTopics);
  pageContext.setAttribute("selectedTopicId", selectedTopicId);
  pageContext.setAttribute("libraryQuestionsToShow", libraryQuestionsToShow);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Questions</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/add_questions.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
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
                     <a href="${pageContext.request.contextPath}/generate_quiz.jsp" class="sidebar-link">
                         <span class="link-icon">🧩</span>
                         Generate New Quiz
                     </a>
                     <a href="${pageContext.request.contextPath}/quiz_list.jsp" class="sidebar-link">
                         <span class="link-icon">✏️</span>
                         Edit Existing Quiz
                     </a>
                      <%-- Assuming add_questions is related to generating/editing, mark one as active? --%>
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
                     <%-- <a href="#" class="sidebar-link"><span class="link-icon">⚙️</span> Settings</a> --%>
                 </nav>
             </aside>

             <main class="admin-main-content">
                <div class="dashboard-cards"> <%-- Keep this container for page-specific content grouping --%>
                    <div class="welcome-card">
                        <h1>Add Questions to Quiz</h1>
                        <p>Select a quiz and add questions manually, upload from Excel, or choose from the question library.</p>
                    </div>

                    <div class="content-card">
                        <c:if test="${selectedQuizId != null && selectedQuizId > 0 && totalQuestions > 0}">
                            <div class="progress-info">
                                <p>Adding question ${currentQuestionCount + 1} of ${totalQuestions} (Manual Count)</p>
                            </div>
                        </c:if>

                        <c:if test="${selectedQuizId == null || selectedQuizId <= 0}">
                            <div class="error-message">
                                <p>Please select a quiz first.</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div class="error-message">
                                <p>${param.error}</p> <%-- Use JSTL/EL if possible --%>
                            </div>
                        </c:if>

                        <c:if test="${param.addFromLibSuccess == 'true'}">
                            <div class="success-message">
                                <p>Successfully added questions from library.</p>
                            </div>
                        </c:if>

                        <c:if test="${param.addFromLibSuccess == 'false'}">
                            <div class="error-message">
                                <p>Failed to add some or all questions from library.</p>
                            </div>
                        </c:if>

                        <form action="add_questions.jsp" method="get" class="quiz-selection-form">
                            <div class="form-group">
                                <label for="quizId">Select Quiz:</label>
                                <select name="quizId" id="quizId" required onchange="this.form.submit()">
                                    <option value="-1">-- Select a Quiz --</option>
                                    <c:forEach var="quiz" items="<%= quizzes %>"> <%-- Using scriptlet variable here --%>
                                        <option value="${quiz.quizId}" ${quiz.quizId == selectedQuizId ? 'selected' : ''}>
                                            ${quiz.quizTitle} - ${quiz.subjectName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${selectedMethod == 'library' && selectedTopicId != null}">
                                    <input type="hidden" name="topicId" value="${selectedTopicId}">
                                </c:if>
                            </div>

                            <div class="method-selection">
                                <div class="method-options">
                                    <label class="method-label">
                                        <input type="radio" name="method" value="manual" ${selectedMethod == 'manual' ? 'checked' : ''}>
                                        Add Manually
                                    </label>
                                    <label class="method-label">
                                        <input type="radio" name="method" value="upload" ${selectedMethod == 'upload' ? 'checked' : ''}>
                                        Upload Excel
                                    </label>
                                    <label class="method-label">
                                        <input type="radio" name="method" value="library" ${selectedMethod == 'library' ? 'checked' : ''}>
                                        Add from Library
                                    </label>
                                </div>
                                <div class="button-container">
                                    <button type="submit" class="method-button">Select Method</button>
                                    <a href="${pageContext.request.contextPath}/admin.jsp" class="dashboard-button">Back to Dashboard</a>
                                </div>
                            </div>
                        </form>

                        <%-- Conditional Display Sections based on METHOD --%>
                        <c:choose>
                            <%-- Manual Entry Form --%>
                            <c:when test="${selectedMethod == 'manual' && selectedQuizId != null && selectedQuizId > 0}">
                                <div class="form-section" id="manual-form">
                                    <h2>Add Question Manually</h2>
                                    <form action="${pageContext.request.contextPath}/AddQuestionsServlet" method="post">
                                        <input type="hidden" name="quizId" value="${selectedQuizId}">
                                        <div class="question-container">
                                            <div class="form-group">
                                                <label>Question:</label>
                                                <textarea name="questionText" rows="3" required></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label>Option A:</label>
                                                <input type="text" name="optionA" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Option B:</label>
                                                <input type="text" name="optionB" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Option C:</label>
                                                <input type="text" name="optionC" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Option D:</label>
                                                <input type="text" name="optionD" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Correct Option:</label>
                                                <select name="correctOption" required>
                                                    <option value="A">A</option>
                                                    <option value="B">B</option>
                                                    <option value="C">C</option>
                                                    <option value="D">D</option>
                                                </select>
                                            </div>
                                        </div>
                                        <button type="submit" class="submit-button">Add Question</button>
                                    </form>
                                </div>
                            </c:when>

                            <%-- Upload from Excel --%>
                            <c:when test="${selectedMethod == 'upload' && selectedQuizId != null && selectedQuizId > 0}">
                                <div class="form-section" id="upload-form">
                                    <h2>Upload Questions from Excel</h2>
                                    <form action="${pageContext.request.contextPath}/UploadQuestionsServlet" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="quizId" value="${selectedQuizId}">
                                        <div class="form-group">
                                            <label>Number of Questions:</label>
                                            <input type="number" name="numQuestions" min="1" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Select Excel File:</label>
                                            <input type="file" name="file" accept=".xlsx, .csv" required>
                                            <div class="sample-file-info">
                                                <a href="${pageContext.request.contextPath}/downloads/sample_questions_template.xlsx" download class="sample-file-link">Download Sample Template</a>
                                                <span class="file-format-info">(Format: Question | Option A | Option B | Option C | Option D | Correct Option)</span>
                                            </div>
                                        </div>
                                        <button type="submit" class="submit-button">Upload Questions</button>
                                    </form>
                                </div>
                            </c:when>

                            <%-- Add from Library Inline Section --%>
                            <c:when test="${selectedMethod == 'library' && selectedQuizId != null && selectedQuizId > 0}">
                                <div class="form-section" id="library-section">
                                    <h2>Add Questions from Library</h2>

                                    <%-- Form 1: Select Topic and View Questions --%>
                                    <form action="add_questions.jsp" method="get" class="topic-view-form">
                                        <input type="hidden" name="quizId" value="${selectedQuizId}">
                                        <input type="hidden" name="method" value="library">
                                        <div class="form-group">
                                            <label for="inline-topic-select">Select Topic:</label>
                                            <select name="topicId" id="inline-topic-select">
                                                <option value="0">-- Select a Topic --</option>
                                                <c:forEach var="topic" items="${allTopics}">
                                                    <option value="${topic.topicId}" ${selectedTopicId == topic.topicId ? 'selected' : ''}>
                                                        <c:out value="${topic.topicName}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="submit-button view-questions-btn">View Questions</button>
                                        </div>
                                    </form>

                                    <%-- Form 2: Submit Selected Library Questions --%>
                                    <form action="${pageContext.request.contextPath}/AddFromLibraryServlet" method="post">
                                        <input type="hidden" name="quizId" value="${selectedQuizId}">

                                        <div id="inline-library-questions-list">
                                            <c:choose>
                                                <c:when test="${selectedTopicId == null || selectedTopicId <= 0}">
                                                    <div class="no-questions">Please select a topic and click 'View Questions'.</div>
                                                </c:when>
                                                <c:when test="${empty libraryQuestionsToShow}">
                                                    <div class="no-questions">No questions found for the selected topic.</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <h4>Select Questions:</h4>
                                                    <c:forEach var="q" items="${libraryQuestionsToShow}">
                                                        <div class="question-item-inline">
                                                            <label>
                                                                <input type="checkbox" name="selectedLibIds" value="${q.libQuestionId}">
                                                                <span><c:out value="${q.questionText}"/></span>
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <%-- Show submit button only if questions are displayed --%>
                                        <c:if test="${not empty libraryQuestionsToShow}">
                                            <div class="library-submit-area">
                                                <button type="submit" class="submit-button" id="inline-add-selected-btn">Add Selected Questions to Quiz</button>
                                            </div>
                                        </c:if>
                                    </form>
                                </div>
                            </c:when>
                        </c:choose>

                        <%-- Progress status --%>
                        <c:if test="${currentQuestionCount > 0 && currentQuestionCount < totalQuestions}">
                            <div class="progress-status">
                                <p>Questions added: ${currentQuestionCount} of ${totalQuestions}</p>
                            </div>
                         </c:if>
                    </div>
                </div>
                <%-- <div style="height: 500px; background: lightgreen; margin-top: 20px;">Extra space</div> --%>
            </main>
        </div>

        <%-- Enclose the included footer in a standard footer tag --%>
        <footer class="admin-footer">
             <jsp:include page="includes/footer.jsp" />
             <%-- Fallback content if include fails or is empty --%>
             <%-- <p>© Your Company 2023</p> --%>
        </footer>

    <%-- </div> --%> <%-- Closing optional container --%>

    <%-- Success Popup Modal (Assuming this part is styled correctly by original CSS) --%>
    <c:if test="<%= showPopup %>">
        <div class="popup-overlay">
            <div class="popup">
                <div class="popup-icon">✓</div>
                <h2>All Questions Added Successfully!</h2>
                <p>You have successfully added all questions to the quiz.</p>
                <div class="popup-buttons">
                    <a href="${pageContext.request.contextPath}/add_questions.jsp?quizId=${selectedQuizId}" class="popup-button continue-button">Add More Questions</a>
                    <a href="${pageContext.request.contextPath}/admin.jsp" class="popup-button dashboard-button">Return to Dashboard</a>
                </div>
            </div>
        </div>
    </c:if>
</body>
</html>