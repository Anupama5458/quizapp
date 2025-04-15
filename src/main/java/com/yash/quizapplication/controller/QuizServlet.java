package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {

    private QuizService quizService;

    @Override
    public void init() throws ServletException {
        quizService = new QuizServiceImpl();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String subjectName= request.getParameter("subjectName");
        System.out.println("retrieved subjectname in servlet: " + subjectName);

        List<QuizMetadata> quizzes= quizService.getQuizzesBySubject(subjectName);
        System.out.println("Quizzes retrieved in servlet from quizservlet: "+ quizzes.size());

        request.setAttribute("quizzes", quizzes);
        System.out.println("passing subject name to jsp"+subjectName);
        request.setAttribute("subjectName", subjectName);
        request.getRequestDispatcher("instructions.jsp").forward(request, response);
    }

}
