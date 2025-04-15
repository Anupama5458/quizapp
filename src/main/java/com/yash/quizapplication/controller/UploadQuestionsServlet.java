package com.yash.quizapplication.controller;

import com.yash.quizapplication.service.QuizService;
import com.yash.quizapplication.serviceimpl.QuizServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/UploadQuestionsServlet")
@MultipartConfig
public class UploadQuestionsServlet extends HttpServlet {
    private QuizService quizService = new QuizServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");
        InputStream fileContent = filePart.getInputStream();
        int numQuestions = Integer.parseInt(request.getParameter("numQuestions"));
        int quizId = Integer.parseInt(request.getParameter("quizId"));  // NEW: Get quizId from the request

        boolean isUploaded = quizService.uploadQuestions(fileContent, numQuestions, quizId);  // NEW: Pass quizId to the service

        if(isUploaded) {
            response.getWriter().write("Quiz questions uploaded successfully!");
        } else {
            response.getWriter().write("Failed to upload questions!");
        }
    }
}
