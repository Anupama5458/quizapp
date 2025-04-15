package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizResult;
import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminActivityServlet")
public class AdminActivityServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all quiz results from the service
        List<QuizResult> quizResults = quizService.getAllQuizResults();

        System.out.println("AdminQuizActivityServlet: quizResults is " + (quizResults == null ? "null" : (quizResults.isEmpty() ? "empty" : "not empty")) + ", size=" + (quizResults == null ? 0 : quizResults.size()));

        // Set the quiz results as an attribute in the request
        request.setAttribute("quizResults", quizResults);

        // Forward the request to the JSP page to display the results
        request.getRequestDispatcher("admin_quiz_activity.jsp").forward(request, response);
    }
}
