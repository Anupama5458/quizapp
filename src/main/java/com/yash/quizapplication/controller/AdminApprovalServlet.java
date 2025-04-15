package com.yash.quizapplication.controller;

import com.yash.quizapplication.service.UserService;
import com.yash.quizapplication.serviceimpl.UserServiceImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AdminApprovalServlet")
public class AdminApprovalServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve any stored popup message from session
        HttpSession session = request.getSession();
        String requestStatus = (String) session.getAttribute("requestStatus");
        String requestMessage = (String) session.getAttribute("requestMessage");

        // Set attributes if exists and then remove from session
        if (requestStatus != null && requestMessage != null) {
            request.setAttribute("requestStatus", requestStatus);
            request.setAttribute("requestMessage", requestMessage);

            // Remove attributes from session after setting
            session.removeAttribute("requestStatus");
            session.removeAttribute("requestMessage");
        }

        // Get pending users and forward to JSP
        request.setAttribute("pendingUsers", userService.getPendingUsers());
        request.getRequestDispatcher("approve_requests.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String action = request.getParameter("action");
        System.out.println("Admin action received: " + action + " for email: " + email);

        HttpSession session = request.getSession();

        try {
            if ("approve".equals(action)) {

                userService.updateUserStatus(email, "approved");
                session.setAttribute("requestStatus", "approved");
                session.setAttribute("requestMessage", "User registration approved successfully!");
            } else if ("rejected".equals(action)) {

                userService.updateUserStatus(email, "rejected");
                session.setAttribute("requestStatus", "rejected");
                session.setAttribute("requestMessage", "User registration has been denied.");
            }
        } catch (Exception e) {
            System.err.println("Error processing user status: " + e.getMessage());
            session.setAttribute("requestStatus", "error");
            session.setAttribute("requestMessage", "An error occurred while processing the request.");
        }

        // Redirect to doGet to display the page with popup and to display the updated list
        response.sendRedirect("AdminApprovalServlet");
    }
}