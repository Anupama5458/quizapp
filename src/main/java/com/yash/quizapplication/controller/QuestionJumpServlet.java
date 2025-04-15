package com.yash.quizapplication.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/QuestionJumpServlet")
public class QuestionJumpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int questionIndex = Integer.parseInt(request.getParameter("questionIndex"));
            session.setAttribute("currentQuestionIndex", questionIndex);

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
        } catch (NumberFormatException e) {
            // Handle invalid index (log it, redirect to homepage, etc.)
            e.printStackTrace(); // For debugging; replace with proper logging
            response.sendRedirect("homepage.jsp"); // Or display an error page
            return; // Important: Exit to avoid further processing
        }

        response.sendRedirect("java_quiz.jsp");
    }
}