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
import java.net.URLEncoder;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/ViewQuizServlet")
public class ViewQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuizService quizService = new QuizServiceImpl();

    // --- Define timer rules (ensure these are consistent) ---
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
        } else if (quizMetadata != null && quizMetadata.getTotalQuestions() > 0) {
            questionCountForCalc = quizMetadata.getTotalQuestions();
        }

        if (questionCountForCalc > 0) {
            calculatedTimeLimitMinutes = (int) Math.ceil(questionCountForCalc * MINUTES_PER_QUESTION);
            if (calculatedTimeLimitMinutes < MINIMUM_TIME_LIMIT_MINUTES) {
                calculatedTimeLimitMinutes = MINIMUM_TIME_LIMIT_MINUTES;
            }
        } else {
            calculatedTimeLimitMinutes = MINIMUM_TIME_LIMIT_MINUTES;
        }
        System.out.println("ViewQuizServlet: Calculated time limit for quiz " + quizId + ": " + calculatedTimeLimitMinutes + " minutes (used for user session)");


        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username"); // Needed for role check
        boolean isAdmin = (session.getAttribute("isAdmin") != null && (boolean) session.getAttribute("isAdmin"));
        System.out.println("ViewQuizServlet: User=" + username + ", isAdmin=" + isAdmin);

        if (!isAdmin) {
            session.removeAttribute("questions");
            session.removeAttribute("currentQuestionIndex");
            session.removeAttribute("userAnswers");
            session.removeAttribute("questionStatuses");
            session.removeAttribute("timeLeftMinutes");
            session.removeAttribute("timeLeftSeconds");
            session.removeAttribute("quizId");
            session.removeAttribute("subjectName");
            session.removeAttribute("quizTitle");
            System.out.println("ViewQuizServlet: Cleared previous user quiz state from session.");

            session.setAttribute("subjectName", subjectName);
            if (quizMetadata != null) {
                session.setAttribute("quizTitle", quizMetadata.getQuizTitle());
            } else {
                session.setAttribute("quizTitle", "Quiz");
            }
            session.setAttribute("quizId", quizId);
            session.setAttribute("questions", questions); // Can be null/empty, JSP handles it
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
            System.out.println("ViewQuizServlet: Set up USER session for taking quiz.");
        } else {
            System.out.println("ViewQuizServlet: Admin view requested, skipping user session setup for quiz taking.");
        }

        if (isAdmin) {
            request.setAttribute("quizId", quizId);
            request.setAttribute("questions", questions); // Pass the fetched questions
            request.setAttribute("quizMetadata", quizMetadata); // Pass metadata if needed by view_quiz.jsp
            request.setAttribute("subjectName", subjectName); // Pass subject if needed by view_quiz.jsp

            System.out.println("ViewQuizServlet: Forwarding ADMIN to view_quiz.jsp");
            request.getRequestDispatcher("view_quiz.jsp").forward(request, response); // <-- Use admin JSP
        } else {
            System.out.println("ViewQuizServlet: Forwarding USER to java_quiz.jsp");
            request.getRequestDispatcher("java_quiz.jsp").forward(request, response); // <-- Use user JSP
        }
    }
}