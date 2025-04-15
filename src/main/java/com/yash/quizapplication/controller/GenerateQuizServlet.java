package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/GenerateQuizServlet")
public class GenerateQuizServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quizTitle = request.getParameter("quizTitle");
        String subjectName = request.getParameter("subject");
        int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions"));

        if(quizTitle == null || quizTitle.trim().isEmpty() || subjectName == null || subjectName.trim().isEmpty()){
            response.sendRedirect("generate_quiz.jsp?error=Please fill all fields");
            return;
        }

        QuizMetadata quiz = new QuizMetadata();
        quiz.setQuizTitle(quizTitle);
        quiz.setSubjectName(subjectName);
        quiz.setTotalQuestions(totalQuestions);

        boolean isCreated = quizService.createQuiz(quiz);

        if(isCreated) {
            int quizId = quizService.getQuizIdByTitleAndSubject(quizTitle, subjectName);

            HttpSession session = request.getSession();
            // Reset question count when starting a new quiz
            session.setAttribute("totalQuestions", totalQuestions);
            session.setAttribute("currentQuestionCount", 0);
            session.setAttribute("selectedQuizId", quizId);

            response.sendRedirect("add_questions.jsp?quizId=" + quizId);
        }
        else {
            response.sendRedirect("generate_quiz.jsp?error=Failed to create quiz");
        }
    }
}