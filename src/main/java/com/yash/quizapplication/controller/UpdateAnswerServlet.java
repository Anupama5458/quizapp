package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizQuestion;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/UpdateAnswerServlet")
public class UpdateAnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        String answer = request.getParameter("answer");

        // Save timer state
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

        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");

        if (userAnswers != null) {
            userAnswers.put(questionId, answer);
            session.setAttribute("userAnswers", userAnswers);

            // Update question status to green when answered
            List<String> questionStatuses = (List<String>) session.getAttribute("questionStatuses");
            List<?> questions = (List<?>) session.getAttribute("questions"); // Use wildcard or actual type
            Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");

            if (questionStatuses != null && questions != null && currentQuestionIndex != null) {
                // Find the index of the question with the given ID
                for (int i = 0; i < questions.size(); i++) {
                    QuizQuestion question = (QuizQuestion) questions.get(i); // Cast if needed
                    if (question.getId() == questionId) {
                        questionStatuses.set(i, "green"); // Update status at correct index
                        break; // Exit the loop once found
                    }
                }
                session.setAttribute("questionStatuses", questionStatuses);
            }
        }

        response.setContentType("text/plain");
        response.getWriter().write("Answer updated successfully"); // Indicate success
    }
}