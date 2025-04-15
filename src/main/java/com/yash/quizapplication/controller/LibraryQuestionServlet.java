package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.LibraryQuestion;
import com.yash.quizapplication.domain.Topic;
import com.yash.quizapplication.service.LibraryService;
import com.yash.quizapplication.service.TopicService;
import com.yash.quizapplication.serviceimpl.LibraryServiceImpl;
import com.yash.quizapplication.serviceimpl.TopicServiceImpl;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "LibraryQuestionServlet", urlPatterns = {"/admin/library/questions"})
public class LibraryQuestionServlet extends HttpServlet {

    private LibraryService libraryService;
    private TopicService topicService;

    @Override
    public void init() throws ServletException {
        super.init();
        libraryService = new LibraryServiceImpl();
        topicService = new TopicServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "addForm":
                    showAddQuestionForm(request, response);
                    break;
                case "editForm":
                    showEditQuestionForm(request, response);
                    break;
                case "delete":
                    deleteQuestion(request, response);
                    break;
                case "listByTopic":
                    listQuestionsByTopic(request, response);
                    break;
                case "list":
                default:
                    listAllQuestions(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in LibraryQuestionServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=true");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addQuestion(request, response);
                    break;
                case "update":
                    updateQuestion(request, response);
                    break;
                case "delete":
                    deleteQuestion(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=true");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in LibraryQuestionServlet doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=true");
        }
    }

    // --- Action Methods ---

    private void listAllQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<LibraryQuestion> questions = libraryService.getAllLibraryQuestions();
        request.setAttribute("questions", questions);
        // Also make topics available for filtering dropdown perhaps
        List<Topic> topics = topicService.getAllTopics();
        request.setAttribute("topics", topics);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manageLibraryQuestions.jsp");
        dispatcher.forward(request, response);
    }

    private void listQuestionsByTopic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<LibraryQuestion> questions;
        List<Topic> topics = topicService.getAllTopics(); // Still need all topics for filter dropdown
        request.setAttribute("topics", topics);
        int selectedTopicId = 0;

        try {
            selectedTopicId = Integer.parseInt(request.getParameter("topicId"));
            if (selectedTopicId > 0) {
                questions = libraryService.getQuestionsByTopic(selectedTopicId);
                request.setAttribute("selectedTopicId", selectedTopicId);
            } else {
                questions = libraryService.getAllLibraryQuestions();
            }
        } catch (NumberFormatException | NullPointerException e) {
            questions = libraryService.getAllLibraryQuestions();
        }

        request.setAttribute("questions", questions);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manageLibraryQuestions.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddQuestionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Topic> topics = topicService.getAllTopics();
        request.setAttribute("allTopics", topics);
        request.setAttribute("isAddForm", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/editLibraryQuestion.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditQuestionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            LibraryQuestion question = libraryService.getLibraryQuestionById(questionId);

            if (question != null) {
                List<Topic> allTopics = topicService.getAllTopics();
                List<Integer> assignedTopicIds = libraryService.getTopicIdsForQuestion(questionId);

                request.setAttribute("question", question);
                request.setAttribute("allTopics", allTopics);
                request.setAttribute("assignedTopicIds", assignedTopicIds); // For pre-selecting checkboxes/multi-select

                RequestDispatcher dispatcher = request.getRequestDispatcher("/editLibraryQuestion.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=notFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=invalidId");
        }
    }

    private void addQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        LibraryQuestion question = new LibraryQuestion();
        question.setQuestionText(request.getParameter("questionText"));
        question.setQuestionType("MCQ");
        question.setOption1(request.getParameter("option1"));
        question.setOption2(request.getParameter("option2"));
        question.setOption3(request.getParameter("option3"));
        question.setOption4(request.getParameter("option4"));
        question.setCorrectOption(request.getParameter("correctOption"));

        String[] topicIdStrings = request.getParameterValues("topicIds");
        List<Integer> topicIds = new ArrayList<>();
        if (topicIdStrings != null) {
            for (String idStr : topicIdStrings) {
                try {
                    topicIds.add(Integer.parseInt(idStr));
                } catch (NumberFormatException e) {
                    System.err.println("Invalid topic ID received: " + idStr);
                }
            }
        }

        boolean success = libraryService.addQuestionToLibrary(question, topicIds);
        response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&addSuccess=" + success);
    }


    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));

            LibraryQuestion question = new LibraryQuestion();
            question.setLibQuestionId(questionId);
            question.setQuestionText(request.getParameter("questionText"));
            question.setQuestionType("MCQ");
            question.setOption1(request.getParameter("option1"));
            question.setOption2(request.getParameter("option2"));
            question.setOption3(request.getParameter("option3"));
            question.setOption4(request.getParameter("option4"));
            question.setCorrectOption(request.getParameter("correctOption"));

            String[] topicIdStrings = request.getParameterValues("topicIds");
            List<Integer> topicIds = new ArrayList<>();
            if (topicIdStrings != null) {
                topicIds = Arrays.stream(topicIdStrings)
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
            }

            boolean success = libraryService.updateQuestionInLibrary(question, topicIds);
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&updateSuccess=" + success);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=invalidId");
        } catch (Exception e) {
            System.err.println("Error during update parsing: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=true");
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            boolean success = libraryService.deleteLibraryQuestion(questionId);
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&deleteSuccess=" + success);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/library/questions?action=list&error=invalidId");
        }
    }
}