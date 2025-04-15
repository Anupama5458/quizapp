package com.yash.quizapplication.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/QuestionNavigationServlet")
public class QuestionNavigationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
        List<?> questions = (List<?>) session.getAttribute("questions");

        if (currentQuestionIndex == null || questions == null) {
            response.sendRedirect("homepage.jsp");
            return;
        }

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

        String action = request.getParameter("action");

        if ("next".equals(action)) {
            if (currentQuestionIndex < questions.size() - 1) {
                session.setAttribute("currentQuestionIndex", currentQuestionIndex + 1);
            }
        } else if ("previous".equals(action)) {
            if (currentQuestionIndex > 0) {
                session.setAttribute("currentQuestionIndex", currentQuestionIndex - 1);
            }
        } else if("submit".equals(action)){
            //submit button functionality should be handle in SubmitQuizServlet not here
        }

        response.sendRedirect("java_quiz.jsp");
    }
}