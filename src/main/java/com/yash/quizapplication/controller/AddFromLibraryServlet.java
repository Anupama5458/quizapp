package com.yash.quizapplication.controller;

import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddFromLibraryServlet")
public class AddFromLibraryServlet extends HttpServlet {

    private QuizService quizService;

    @Override
    public void init() throws ServletException {
        this.quizService = new QuizServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String quizIdStr = request.getParameter("quizId");
        String[] selectedLibIdStrings = request.getParameterValues("selectedLibIds");

        Integer quizId = null;
        List<Integer> libraryQuestionIds = new ArrayList<>();
        boolean error = false;
        String redirectParams = "";

        if (quizIdStr != null && !quizIdStr.isEmpty()) {
            try {
                quizId = Integer.parseInt(quizIdStr);
                redirectParams += "?quizId=" + quizId;
            } catch (NumberFormatException e) {
                System.err.println("Invalid Quiz ID received in AddFromLibraryServlet: " + quizIdStr);
                error = true;
                redirectParams = "?error=InvalidQuizID";
            }
        } else {
            System.err.println("Missing Quiz ID in AddFromLibraryServlet");
            error = true;
            redirectParams = "?error=MissingQuizID";
        }

        String methodParam = request.getParameter("method");
        String topicIdParam = request.getParameter("topicId");

        if (methodParam == null || methodParam.isEmpty()) methodParam = "library";
        if (topicIdParam == null) topicIdParam = "";

        redirectParams += "&method=" + methodParam;
        if (!topicIdParam.isEmpty()) {
            redirectParams += "&topicId=" + topicIdParam;
        }

        if (!error) {
            if (selectedLibIdStrings != null && selectedLibIdStrings.length > 0) {
                for (String idStr : selectedLibIdStrings) {
                    try {
                        libraryQuestionIds.add(Integer.parseInt(idStr));
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid Library Question ID received: " + idStr);
                        error = true;
                        redirectParams += "&error=InvalidLibID";
                        break;
                    }
                }
            } else {
                System.out.println("No Library Question IDs selected to add for quiz " + quizId);
                response.sendRedirect(request.getContextPath() + "/add_questions.jsp" + redirectParams + "&info=NoQuestionsSelected");
                return;
            }
        }


        if (error) {
            response.sendRedirect(request.getContextPath() + "/add_questions.jsp" + redirectParams);
            return;
        }

        boolean success = false;
        if (!libraryQuestionIds.isEmpty() && quizId != null && quizId > 0) {
            try {
                success = quizService.addLibraryQuestionsToQuiz(quizId, libraryQuestionIds);
            } catch (Exception e) {
                System.err.println("Error calling service to add library questions for quiz " + quizId + ": " + e.getMessage());
                e.printStackTrace();
                success = false;
            }
        } else if (libraryQuestionIds.isEmpty()) {
            success = true;
        }

        redirectParams += "&addFromLibSuccess=" + success;
        response.sendRedirect(request.getContextPath() + "/add_questions.jsp" + redirectParams);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/admin.jsp");
    }
}