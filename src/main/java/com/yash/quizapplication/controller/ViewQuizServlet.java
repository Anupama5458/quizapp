package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.domain.QuizQuestion;
import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder; // for other potential errors if needed
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/ViewQuizServlet")
public class ViewQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuizService quizService = new QuizServiceImpl();

    private static final double MINUTES_PER_QUESTION = 0.5; // 30 seconds per question
    private static final int MINIMUM_TIME_LIMIT_MINUTES = 1; // Minimum 1 minute
    private static final int FALLBACK_DEFAULT_TIME_MINUTES = 5; // Default if calculation fails completely

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ViewQuizServlet: doGet called.");
        int quizId = -1;
        String subjectName = request.getParameter("subjectName");

        try {
            quizId = Integer.parseInt(request.getParameter("quizId"));
            System.out.println("ViewQuizServlet: Processing quizId = " + quizId);
        } catch (NumberFormatException e) {
            System.err.println("ViewQuizServlet: Invalid quizId format: " + request.getParameter("quizId"));
            String errorMsg = URLEncoder.encode("Invalid Quiz ID provided.", "UTF-8");
            response.sendRedirect("homepage.jsp?error=" + errorMsg);
            return;
        }

        QuizMetadata quizMetadata = quizService.getQuizMetadataById(quizId);
        System.out.println("ViewQuizServlet: Fetched QuizMetadata: " + (quizMetadata != null ? "OK" : "NULL"));

        List<QuizQuestion> questions = quizService.getQuizQuestionsByQuizId(quizId);
        System.out.println("ViewQuizServlet: Fetched Questions List: " + (questions != null ? questions.size() + " questions" : "NULL"));

        int calculatedTimeLimitMinutes = FALLBACK_DEFAULT_TIME_MINUTES;
        int questionCountForCalc = 0;

        if (questions != null && !questions.isEmpty()) {
            questionCountForCalc = questions.size();
            System.out.println("ViewQuizServlet: Using actual fetched question count for timer: " + questionCountForCalc);
        } else if (quizMetadata != null && quizMetadata.getTotalQuestions() > 0) {
            questionCountForCalc = quizMetadata.getTotalQuestions();
            System.out.println("ViewQuizServlet: Warning - Fetched questions empty/null. Using metadata count: " + questionCountForCalc);
        } else {
            System.out.println("ViewQuizServlet: No questions found based on fetch or metadata. Timer calculation using 0.");
            questionCountForCalc = 0;
        }


        if (questionCountForCalc > 0) {
            calculatedTimeLimitMinutes = (int) Math.ceil(questionCountForCalc * MINUTES_PER_QUESTION);
            System.out.println("ViewQuizServlet: Initial calculated time: " + calculatedTimeLimitMinutes + " min");

            if (calculatedTimeLimitMinutes < MINIMUM_TIME_LIMIT_MINUTES) {
                calculatedTimeLimitMinutes = MINIMUM_TIME_LIMIT_MINUTES;
                System.out.println("ViewQuizServlet: Enforced minimum time limit: " + calculatedTimeLimitMinutes + " min");
            }
        } else {
            // but we set a minimum/default for consistency if needed elsewhere.
            calculatedTimeLimitMinutes = MINIMUM_TIME_LIMIT_MINUTES; // Set minimum if 0 questions
            System.out.println("ViewQuizServlet: Question count is zero. Setting timer to minimum: " + calculatedTimeLimitMinutes + " min");
        }

        System.out.println("ViewQuizServlet: Final calculated time limit for quiz " + quizId + ": " + calculatedTimeLimitMinutes + " minutes");


        HttpSession session = request.getSession();

        // Clear potentially stale quiz data
        session.removeAttribute("questions");
        session.removeAttribute("currentQuestionIndex");
        session.removeAttribute("userAnswers");
        session.removeAttribute("questionStatuses");
        session.removeAttribute("timeLeftMinutes");
        session.removeAttribute("timeLeftSeconds");
        session.removeAttribute("quizId");
        session.removeAttribute("subjectName");
        session.removeAttribute("quizTitle");
        System.out.println("ViewQuizServlet: Cleared previous quiz state from session.");

        String username = (String) session.getAttribute("username");
        System.out.println("ViewQuizServlet: User= " + username);

        session.setAttribute("subjectName", subjectName);
        if (quizMetadata != null) {
            session.setAttribute("quizTitle", quizMetadata.getQuizTitle());
        } else {
            session.setAttribute("quizTitle", "Quiz");
        }
        session.setAttribute("quizId", quizId);
        session.setAttribute("questions", questions);
        session.setAttribute("currentQuestionIndex", 0);
        session.setAttribute("userAnswers", new HashMap<Integer, String>());

        List<String> questionStatuses = new ArrayList<>();
        if (questions != null) {
            for (int i = 0; i < questions.size(); i++) {
                questionStatuses.add("grey");
            }
        }
        session.setAttribute("questionStatuses", questionStatuses);

        session.setAttribute("timeLeftMinutes", calculatedTimeLimitMinutes);
        session.setAttribute("timeLeftSeconds", 0);
        System.out.println("ViewQuizServlet: Set session attributes - questions=" + (questions == null ? "null" : questions.size()) + ", timeLeftMinutes=" + calculatedTimeLimitMinutes);

        // 6. Forward to Quiz Page (This will now happen even if questions is null/empty)
        boolean isAdmin = (session.getAttribute("isAdmin") != null && (boolean) session.getAttribute("isAdmin"));

        if (isAdmin) {
            System.out.println("ViewQuizServlet: Forwarding admin to java_quiz.jsp");
            request.getRequestDispatcher("java_quiz.jsp").forward(request, response);
        } else {
            System.out.println("ViewQuizServlet: Forwarding user to java_quiz.jsp");
            request.getRequestDispatcher("java_quiz.jsp").forward(request, response);
        }
    }
}