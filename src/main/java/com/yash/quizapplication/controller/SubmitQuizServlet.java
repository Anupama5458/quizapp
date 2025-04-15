package com.yash.quizapplication.controller;

import com.yash.quizapplication.daoimpl.QuizDaoImpl;
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
import java.util.List;
import java.util.Map;

@WebServlet("/SubmitQuizServlet")
public class SubmitQuizServlet extends HttpServlet {

    private QuizService quizService=new QuizServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Save timer state regardless of action
        String minutesStr = request.getParameter("timeLeftMinutes");
        String secondsStr = request.getParameter("timeLeftSeconds");

        if (minutesStr != null && secondsStr != null) {
            try {
                int minutes = Integer.parseInt(minutesStr);
                int seconds = Integer.parseInt(secondsStr);
                session.setAttribute("timeLeftMinutes", minutes);
                session.setAttribute("timeLeftSeconds", seconds);
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Log the error
            }
        }

        // Handle Clear Button
        String clearParam = request.getParameter("clear");
        if (clearParam != null) {
            try {
                int questionIdToClear = Integer.parseInt(clearParam);

                @SuppressWarnings("unchecked")
                Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
                if (userAnswers != null) {
                    userAnswers.remove(questionIdToClear);
                    session.setAttribute("userAnswers", userAnswers);
                }

                @SuppressWarnings("unchecked")
                List<String> questionStatuses = (List<String>) session.getAttribute("questionStatuses");
                @SuppressWarnings("unchecked")
                List<?> questions = (List<?>) session.getAttribute("questions"); // Use wildcard or actual type
                if (questionStatuses != null && questions != null) {
                    // Find the index of the question with the given ID
                    for (int i = 0; i < questions.size(); i++) {
                        QuizQuestion question = (QuizQuestion) questions.get(i); // Cast if needed
                        if (question.getId() == questionIdToClear) {
                            questionStatuses.set(i, "red"); // Update status at correct index
                            break; // Exit the loop once found
                        }
                    }
                    session.setAttribute("questionStatuses", questionStatuses);
                }

                // Send a success response (e.g., "Answer cleared")
                response.setContentType("text/plain");
                response.getWriter().write("Answer cleared successfully");
                return; // Important: Exit after clearing
            } catch (NumberFormatException e) {
                // Handle invalid question ID (log it)
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid question ID");
                return;
            }
        }

        // Handle action = submit
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            // Process the submission logic
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            @SuppressWarnings("unchecked")
            List<QuizQuestion> questions = (List<QuizQuestion>) session.getAttribute("questions");

            // Calculate score
            int score = 0;
            if (userAnswers != null && questions != null) {
                for (QuizQuestion question : questions) {
                    String userAnswer = userAnswers.get(question.getId());
                    if (userAnswer != null && userAnswer.equals(question.getCorrectOption())) {
                        score++;
                    }
                }

                // Set attributes for the result page
                request.setAttribute("score", score);
                request.setAttribute("totalQuestions", questions.size());
                String email = (String) session.getAttribute("email");
                int quizId=(Integer) session.getAttribute("quizId");
                QuizMetadata quizMetadata = quizService.getQuizMetadataById(quizId); //New
                QuizDaoImpl quizDao=new QuizDaoImpl();
                quizDao.saveQuizResult(email,quizId, score, quizMetadata.getSubjectName(), quizMetadata.getQuizTitle());
                // Forward to the result page (instead of redirect)
                request.getRequestDispatcher("quiz_result.jsp").forward(request, response);
                return;
            }
        }

        // If it's not a clear action or a submit, send an error
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
    }
}