package com.yash.quizapplication.controller;

import com.yash.quizapplication.domain.Topic;
import com.yash.quizapplication.service.TopicService;
import com.yash.quizapplication.serviceimpl.TopicServiceImpl;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TopicServlet", urlPatterns = {"/admin/topics"})
public class TopicServlet extends HttpServlet {

    private TopicService topicService;

    @Override
    public void init() throws ServletException {
        super.init();
        topicService = new TopicServiceImpl(); // Initialize service
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
                    showAddForm(request, response);
                    break;
                case "editForm":
                    showEditForm(request, response);
                    break;
                case "delete": // Usually done via POST, but simple example
                    deleteTopic(request, response);
                    break;
                case "list":
                default:
                    listTopics(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in TopicServlet doGet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=true");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addTopic(request, response);
                    break;
                case "update":
                    updateTopic(request, response);
                    break;
                case "delete":
                    deleteTopic(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=true");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in TopicServlet doPost: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=true");
        }
    }

    private void listTopics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Topic> topics = topicService.getAllTopics();
        request.setAttribute("topics", topics);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manageTopics.jsp"); // Path to your JSP
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isAddForm", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/editTopic.jsp"); // Or addTopic.jsp
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int topicId = Integer.parseInt(request.getParameter("topicId"));
            Topic topic = topicService.getTopicById(topicId);
            if (topic != null) {
                request.setAttribute("topic", topic);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/editTopic.jsp"); // Path to your JSP
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=notFound");
            }
        } catch (NumberFormatException e) {
            // to handle invalid ID
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=invalidId");
        }
    }

    private void addTopic(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String topicName = request.getParameter("topicName");

        Topic newTopic = new Topic();
        newTopic.setTopicName(topicName);

        boolean success = topicService.addTopic(newTopic);
        // Redirect back to list, possibly with success/error message
        response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&addSuccess=" + success);
    }

    private void updateTopic(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int topicId = Integer.parseInt(request.getParameter("topicId"));
            String topicName = request.getParameter("topicName");

            Topic topic = new Topic();
            topic.setTopicId(topicId);
            topic.setTopicName(topicName);
            // Note: createdAt is not typically updated manually

            boolean success = topicService.updateTopic(topic);
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&updateSuccess=" + success);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=invalidId");
        }
    }

    private void deleteTopic(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int topicId = Integer.parseInt(request.getParameter("topicId"));
            boolean success = topicService.deleteTopic(topicId);
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&deleteSuccess=" + success);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/topics?action=list&error=invalidId");
        }
    }
}