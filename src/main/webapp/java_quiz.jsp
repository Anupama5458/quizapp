<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yash.quizapplication.domain.QuizQuestion" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Dynamically set title if needed, or keep static --%>
    <title>Quizzy - Take Quiz</title>
    <%-- Link to the new CSS file --%>
    <link rel="stylesheet" href="java_quiz.css">
    <%-- Link to Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <script type="text/javascript">
        // Initialize timer values from server
        let minutes = <%= (Integer) session.getAttribute("timeLeftMinutes") != null ? (Integer) session.getAttribute("timeLeftMinutes") : 5 %>;
        let seconds = <%= (Integer) session.getAttribute("timeLeftSeconds") != null ? (Integer) session.getAttribute("timeLeftSeconds") : 0 %>;
        let timerInterval;

        let isSubmitting = false;

        function startTimer() {
            if (timerInterval) {
                clearInterval(timerInterval);
            }
            timerInterval = setInterval(function() {
                if (seconds === 0) {
                    if (minutes === 0) {
                        clearInterval(timerInterval);
                        if (!isSubmitting) {
                            isSubmitting = true;
                            console.log("Timer expired. Submitting quiz...");
                            const submitBtn = document.getElementById('submitBtn');
                            if (submitBtn) {
                                submitBtn.disabled = true;
                                submitBtn.innerText = 'Submitting...';
                            }
                            document.getElementById('quizForm').submit();
                        }
                        return;
                    }
                    minutes--;
                    seconds = 59;
                } else {
                    seconds--;
                }
                const timerDisplay = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                const timerElement = document.querySelector('.quiz-status-sidebar .timer');
                if(timerElement) {
                    timerElement.innerHTML = timerDisplay;
                    if (minutes < 1) {
                        timerElement.style.color = 'red';
                    } else {
                         timerElement.style.color = 'var(--text-color)'; // Revert color if time > 1 min
                    }
                }
                // Update hidden fields (keep this)
                const minutesHidden = document.getElementById('timeLeftMinutes');
                const secondsHidden = document.getElementById('timeLeftSeconds');
                if (minutesHidden) minutesHidden.value = minutes;
                if (secondsHidden) secondsHidden.value = seconds;
            }, 1000);
        }

        window.onload = function() {
            startTimer();
            const quizForm = document.getElementById('quizForm');
            if (quizForm) {
                quizForm.addEventListener('submit', function(event) {
                    if (isSubmitting) {
                        console.log("Submission already in progress. Preventing duplicate manual submit.");
                        event.preventDefault();
                        return false;
                    }
                    isSubmitting = true;
                    const submitBtn = document.getElementById('submitBtn');
                     if (submitBtn) {
                         submitBtn.disabled = true;
                         submitBtn.innerText = 'Submitting...';
                     }
                });
            }
        };

        function updateAnswer(questionId, answer) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "UpdateAnswerServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function() {
                if (xhr.status === 200) {
                    console.log("Answer updated:", xhr.responseText);
                     // Update status button immediately
                     <%
                        Integer currentIdxForUpdate = (Integer) session.getAttribute("currentQuestionIndex");
                        if (currentIdxForUpdate == null) currentIdxForUpdate = 0;
                     %>
                     const currentQIndex = <%= currentIdxForUpdate %>;
                     const statusButtonsUpdate = document.querySelectorAll('.quiz-status-sidebar .question-status');
                     if (statusButtonsUpdate && currentQIndex < statusButtonsUpdate.length) {
                        const currentBtn = statusButtonsUpdate[currentQIndex];
                        currentBtn.classList.remove('status-red', 'status-grey');
                        currentBtn.classList.add('status-green');
                     }
                } else {
                    console.error("Error updating answer:", xhr.statusText);
                }
            };
            xhr.onerror = function() {
                console.error("Network error updating answer");
            };
            xhr.send("questionId=" + questionId + "&answer=" + answer + "&timeLeftMinutes=" + minutes + "&timeLeftSeconds=" + seconds);
        }

        function clearAnswer(questionId) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "SubmitQuizServlet", true); // Still points to SubmitQuizServlet as per original
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function() {
                if (xhr.status === 200) {
                    console.log("Answer cleared on server:", xhr.responseText);
                    // UI updates
                    const radioButtons = document.querySelectorAll('input[type="radio"][name="answer_' + questionId + '"]');
                    radioButtons.forEach(radio => { radio.checked = false; });
                    <%
                       Integer currentIdxForClear = (Integer) session.getAttribute("currentQuestionIndex");
                       if (currentIdxForClear == null) currentIdxForClear = 0;
                    %>
                    const currentQuestionIndex = <%= currentIdxForClear %>;
                    const statusButtons = document.querySelectorAll('.quiz-status-sidebar .question-status');
                    if (statusButtons && currentQuestionIndex < statusButtons.length) {
                       const currentStatusButton = statusButtons[currentQuestionIndex];
                       currentStatusButton.classList.remove('status-green', 'status-grey');
                       currentStatusButton.classList.add('status-red');
                    }
                } else {
                    console.error("Error clearing answer:", xhr.statusText);
                    alert("Could not clear the answer. Please try again.");
                }
            };
            xhr.onerror = function() {
                console.error("Network error clearing answer");
                alert("Network error. Could not clear the answer.");
            };
            xhr.send("clear=" + questionId + "&timeLeftMinutes=" + minutes + "&timeLeftSeconds=" + seconds);
        }

        function updateTimerFields(minutesFieldId, secondsFieldId) {
            const minutesField = document.getElementById(minutesFieldId);
            const secondsField = document.getElementById(secondsFieldId);
            if (minutesField) minutesField.value = minutes;
            if (secondsField) secondsField.value = seconds;
        }

        function jumpToQuestion(questionIndex) {
            if (isSubmitting) {
                console.log("Cannot jump, submission in progress.");
                return;
            }
            var form = document.createElement("form");
            form.setAttribute("method", "get");
            form.setAttribute("action", "QuestionJumpServlet");

            var indexField = document.createElement("input"); indexField.setAttribute("type", "hidden"); indexField.setAttribute("name", "questionIndex"); indexField.setAttribute("value", questionIndex); form.appendChild(indexField);
            var minutesField = document.createElement("input"); minutesField.setAttribute("type", "hidden"); minutesField.setAttribute("name", "timeLeftMinutes"); minutesField.setAttribute("value", minutes); form.appendChild(minutesField);
            var secondsField = document.createElement("input"); secondsField.setAttribute("type", "hidden"); secondsField.setAttribute("name", "timeLeftSeconds"); secondsField.setAttribute("value", seconds); form.appendChild(secondsField);

            document.body.appendChild(form);
            form.submit();
        }
    </script>
</head>
<body>
    <%-- Header matching admin theme --%>
    <header class="admin-header">
        <div class="header-content">
            <div class="logo-container"> <%-- Keep logo if desired --%>
                 <img src="images/yash_tech1.png" alt="Yash Technologies" class="logo">
            </div>
            <%-- Adjusted header right for consistency --%>
            <div class="header-actions">
                <a href="homepage.jsp" class="back-btn">Quit Quiz</a> <%-- Changed text --%>
            </div>
        </div>
    </header>

    <%-- Wrapper for the two main columns --%>
    <div class="quiz-page-wrapper">
        <%
            // --- Java/JSP Logic remains the same ---
            List<QuizQuestion> questions = (List<QuizQuestion>) session.getAttribute("questions");
            Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            List<String> questionStatuses = (List<String>) session.getAttribute("questionStatuses");

            // Initial setup logic... (same as before)
            if (questions == null) {
                 Object questionsObj = request.getAttribute("questions");
                 if (questionsObj instanceof List) { questions = (List<QuizQuestion>) questionsObj; session.setAttribute("questions", questions); }
                 else { out.println("<p class='error-message'>Error: Quiz questions not loaded correctly.</p>"); return; }
                 Integer quizIdObj = (Integer) request.getAttribute("quizId");
                 if(quizIdObj != null) { session.setAttribute("quizId", quizIdObj); }
                 session.setAttribute("currentQuestionIndex", 0);
                 userAnswers = new HashMap<>(); session.setAttribute("userAnswers", userAnswers);
                 questionStatuses = new ArrayList<>();
                 if (questions != null) { for (int i = 0; i < questions.size(); i++) { questionStatuses.add("grey"); } }
                 session.setAttribute("questionStatuses", questionStatuses);
                 currentQuestionIndex = 0;
                 if (session.getAttribute("timeLeftMinutes") == null) { session.setAttribute("timeLeftMinutes", 5); session.setAttribute("timeLeftSeconds", 0); }
            }
            if (currentQuestionIndex == null) currentQuestionIndex = 0;
            if (userAnswers == null) userAnswers = new HashMap<>();
            if (questionStatuses == null) questionStatuses = new ArrayList<>();
            if (questions != null && !questions.isEmpty() && currentQuestionIndex >= questions.size()){ currentQuestionIndex = questions.size() - 1; }
            else if (questions == null || questions.isEmpty()) { currentQuestionIndex = -1; }
            // --- End Setup ---

            // --- Check if quiz can proceed ---
            boolean quizReady = (questions != null && !questions.isEmpty() && currentQuestionIndex >= 0);
            QuizQuestion currentQuestion = quizReady ? questions.get(currentQuestionIndex) : null;
            String userAnswer = (quizReady && userAnswers != null && userAnswers.get(currentQuestion.getId()) != null) ? userAnswers.get(currentQuestion.getId()) : "";

            // Update status logic (same as before)
            if(quizReady && userAnswer.isEmpty() && questionStatuses != null && currentQuestionIndex < questionStatuses.size() && "grey".equals(questionStatuses.get(currentQuestionIndex))) {
                 questionStatuses.set(currentQuestionIndex, "red");
                 session.setAttribute("questionStatuses", questionStatuses);
            }

            // Timer display logic (same as before)
            Integer timeLeftMinutes = (Integer) session.getAttribute("timeLeftMinutes");
            Integer timeLeftSeconds = (Integer) session.getAttribute("timeLeftSeconds");
            String formattedTime = (timeLeftMinutes == null || timeLeftSeconds == null) ? "5:00" : String.format("%d:%02d", timeLeftMinutes, timeLeftSeconds);
        %>

        <% if (quizReady) { %>
            <%-- Main Quiz Question Area (Left Column) --%>
            <div class="quiz-main-area">
                 <%-- Card container for the question --%>
                <div class="content-card question-display-card">
                    <h2>Quiz Question</h2> <%-- Added heading --%>
                    <div class="question-text">
                        <p><span class="q-number"><%= (currentQuestionIndex + 1) %>.</span> <%= currentQuestion.getQuestionText() %></p>
                    </div>

                    <div class="options-container">
                        <%-- Unique name for radio buttons per question --%>
                        <label class="option">
                            <input type="radio" name="answer_<%= currentQuestion.getId() %>" value="A" <%= "A".equals(userAnswer) ? "checked" : "" %> onclick="updateAnswer('<%= currentQuestion.getId() %>', 'A')">
                            <span class="option-letter">A.</span> <span class="option-text"><%= currentQuestion.getOptionA() %></span>
                        </label>
                        <label class="option">
                            <input type="radio" name="answer_<%= currentQuestion.getId() %>" value="B" <%= "B".equals(userAnswer) ? "checked" : "" %> onclick="updateAnswer('<%= currentQuestion.getId() %>', 'B')">
                            <span class="option-letter">B.</span> <span class="option-text"><%= currentQuestion.getOptionB() %></span>
                        </label>
                        <label class="option">
                            <input type="radio" name="answer_<%= currentQuestion.getId() %>" value="C" <%= "C".equals(userAnswer) ? "checked" : "" %> onclick="updateAnswer('<%= currentQuestion.getId() %>', 'C')">
                            <span class="option-letter">C.</span> <span class="option-text"><%= currentQuestion.getOptionC() %></span>
                        </label>
                        <label class="option">
                            <input type="radio" name="answer_<%= currentQuestion.getId() %>" value="D" <%= "D".equals(userAnswer) ? "checked" : "" %> onclick="updateAnswer('<%= currentQuestion.getId() %>', 'D')">
                            <span class="option-letter">D.</span> <span class="option-text"><%= currentQuestion.getOptionD() %></span>
                        </label>
                    </div>

                    <div class="action-buttons-area">
                         <button type="button" class="action-button clear-btn" onclick="clearAnswer('<%= currentQuestion.getId() %>')">Clear Selection</button>

                        <div class="navigation-buttons">
                            <% if (currentQuestionIndex > 0) { %>
                                <form action="QuestionNavigationServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="previous">
                                    <input type="hidden" name="timeLeftMinutes" id="prevTimeLeftMinutes" value="">
                                    <input type="hidden" name="timeLeftSeconds" id="prevTimeLeftSeconds" value="">
                                    <button type="submit" class="action-button nav-btn" onclick="updateTimerFields('prevTimeLeftMinutes', 'prevTimeLeftSeconds')">Previous</button>
                                </form>
                            <% } else { %>
                                <button type="button" class="action-button nav-btn disabled" disabled>Previous</button> <%-- Disabled placeholder --%>
                            <% } %>
                            <% if (currentQuestionIndex < questions.size() - 1) { %>
                                 <form action="QuestionNavigationServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="next">
                                    <input type="hidden" name="timeLeftMinutes" id="nextTimeLeftMinutes" value="">
                                    <input type="hidden" name="timeLeftSeconds" id="nextTimeLeftSeconds" value="">
                                    <button type="submit" class="action-button nav-btn" onclick="updateTimerFields('nextTimeLeftMinutes', 'nextTimeLeftSeconds')">Next</button>
                                </form>
                            <% } else { %>
                                 <button type="button" class="action-button nav-btn disabled" disabled>Next</button> <%-- Disabled placeholder --%>
                            <% } %>
                        </div>
                    </div>
                </div> <%-- End content-card --%>

                <%-- Submit Quiz Form (Positioned below card) --%>
                <form id="quizForm" action="SubmitQuizServlet" method="post" class="submit-form-area">
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="quizId" value="<%= session.getAttribute("quizId") %>">
                    <input type="hidden" name="totalQuestions" value="<%= questions.size() %>">
                    <input type="hidden" name="currentQuestionIndex" value="<%= currentQuestionIndex %>">
                    <input type="hidden" id="timeLeftMinutes" name="timeLeftMinutes" value="">
                    <input type="hidden" id="timeLeftSeconds" name="timeLeftSeconds" value="">

                    <button type="submit" id="submitBtn" class="action-button submit-btn">Submit Quiz</button>
                </form>

            </div> <%-- End quiz-main-area --%>

            <%-- Quiz Status Sidebar (Right Column) --%>
            <aside class="quiz-status-sidebar">
                <div class="timer-container content-card"> <%-- Style like a card --%>
                    <h3>Time Left</h3>
                    <div class="timer" id="timer"><%= formattedTime %></div>
                </div>

                <div class="question-status-area content-card"> <%-- Style like a card --%>
                     <h3>Question Status</h3>
                    <div class="status-indicators">
                        <div class="status-indicator">
                            <span class="color-box status-green"></span> Answered
                        </div>
                         <div class="status-indicator">
                            <span class="color-box status-red"></span> Not Answered
                        </div>
                        <div class="status-indicator">
                            <span class="color-box status-grey"></span> Not Visited
                        </div>
                    </div>
                    <div class="question-status-container">
                        <% if (questions != null && questionStatuses != null) {
                               for (int i = 0; i < questions.size(); i++) {
                                   String status = (i < questionStatuses.size()) ? questionStatuses.get(i) : "grey";
                                   if (!"red".equals(status) && !"green".equals(status)) { status = "grey"; }
                                   String statusClass = "status-" + status;
                        %>
                            <button type="button" onclick="jumpToQuestion(<%= i %>)" class="question-status <%= statusClass %> <%= (i == currentQuestionIndex) ? "current" : "" %>"><%= (i + 1) %></button>
                        <%
                               }
                           }
                        %>
                    </div>
                </div>
            </aside> <%-- End quiz-status-sidebar --%>

        <% } else { %>
            <%-- Error/No Questions State --%>
            <div class="quiz-main-area">
                <div class="content-card error-card">
                    <h2>Quiz Not Available</h2>
                    <p>No quiz questions are available at this time, or an error occurred loading the quiz.</p>
                    <div class="action-footer" style="margin-top: 20px;">
                         <a href="homepage.jsp" class="action-button back-btn">Return to Homepage</a>
                    </div>
                </div>
            </div>
            <%-- Optional: Show an empty status sidebar or hide it --%>
             <aside class="quiz-status-sidebar empty-sidebar">
                 <%-- Maybe add a message here too --%>
             </aside>
        <% } // End of main if (quizReady) %>

    </div> <%-- End quiz-page-wrapper --%>

    <%-- Footer matching admin theme --%>
    <footer class="admin-footer">
        <p>© 2025 Yash Technologies Pvt. Ltd. All rights reserved.</p>
    </footer>
</body>
</html>