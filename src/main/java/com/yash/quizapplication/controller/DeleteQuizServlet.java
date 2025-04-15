package com.yash.quizapplication.controller;

import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteQuizServlet")
public class DeleteQuizServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        boolean isDeleted = quizService.deleteQuiz(quizId);

        if(isDeleted){
            response.sendRedirect("quiz_list.jsp?msg=deleted");
        } else{
            response.sendRedirect("quiz_list.jsp?msg=error");
        }
    }
}
