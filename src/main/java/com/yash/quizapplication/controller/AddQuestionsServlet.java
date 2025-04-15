package com.yash.quizapplication.controller;

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

@WebServlet("/AddQuestionsServlet")
public class AddQuestionsServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
        Integer currentQuestionCount = (Integer) session.getAttribute("currentQuestionCount");

        System.out.println("Before processing - Total Questions: " + totalQuestions + ", Current Count: " + currentQuestionCount);

        int quizId = Integer.parseInt(request.getParameter("quizId"));

        if(totalQuestions == null) {
            totalQuestions = quizService.getTotalQuestions(quizId);
            if(totalQuestions <= 0) {
                totalQuestions = 10;
            }
            session.setAttribute("totalQuestions", totalQuestions);
        }

        if(currentQuestionCount == null) {
            currentQuestionCount = 0;
            session.setAttribute("currentQuestionCount", currentQuestionCount);
        }

        session.setAttribute("selectedQuizId", quizId);

        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");

        //now we are setting these values to QuizQuestion object
        QuizQuestion question = new QuizQuestion();
        question.setQuizId(quizId);
        question.setQuestionText(questionText);
        question.setOptionA(optionA);
        question.setOptionB(optionB);
        question.setOptionC(optionC);
        question.setOptionD(optionD);
        question.setCorrectOption(correctOption);

        boolean isAdded = quizService.addQuestionToQuiz(question);

        if(isAdded) {
            currentQuestionCount++;
            session.setAttribute("currentQuestionCount", currentQuestionCount);

            if(currentQuestionCount >= totalQuestions) {
                // All questions added successfully (success popup)
                response.sendRedirect("add_questions.jsp?quizId=" + quizId + "&success=All questions added successfully!");
                // Reset question counter after completing all questions
                session.setAttribute("currentQuestionCount", 0);
            } else {
                response.sendRedirect("add_questions.jsp?quizId=" + quizId);
            }
        } else {
            response.sendRedirect("add_questions.jsp?quizId=" + quizId + "&error=Failed to add question");
        }
    }
}