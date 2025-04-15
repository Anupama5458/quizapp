package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizResult;
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

@WebServlet("/UserQuizHistoryServlet")
public class UserQuizHistoryServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user's email from the session
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email"); // Or "email", depending on what you named it

        if (userEmail == null || userEmail.isEmpty()) {
            // Handle the case where the user is not logged in properly
            request.setAttribute("errorMessage", "You must be logged in to view your quiz history.");
            request.getRequestDispatcher("login.jsp").forward(request, response); // Or your login page
            return;
        }

        List<QuizResult> quizResults = quizService.getQuizResultsByUser(userEmail);

        System.out.println("UserQuizHistoryServlet: quizResults is " + (quizResults == null ? "null" : (quizResults.isEmpty() ? "empty" : "not empty")) + ", size=" + (quizResults == null ? 0 : quizResults.size()));

        request.setAttribute("quizResults", quizResults);

        request.getRequestDispatcher("user_quiz_history.jsp").forward(request, response);
    }
}
