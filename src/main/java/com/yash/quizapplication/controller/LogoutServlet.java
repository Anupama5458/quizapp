package com.yash.quizapplication.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response); // Redirect GET requests to doPost
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String logoutRequest = request.getParameter("logoutRequest");
        String confirm = request.getParameter("confirm");

        // Determine the dashboard URL - very important to get this right!
        String dashboardURL = "admin.jsp"; // Default to admin dashboard
        if (request.getRequestURI().contains("homepage.jsp")) { // Check if the request is from the user dashboard
            dashboardURL = "homepage.jsp";
        }

        if ("true".equals(logoutRequest)) {
            // User clicked logout - display the confirmation page
            request.setAttribute("dashboardURL", dashboardURL);  // Pass the URL to the confirmation page
            request.getRequestDispatcher("logout.jsp").forward(request, response);  // Use correct JSP name

        } else if ("yes".equals(confirm)) {
            // User confirmed logout
            HttpSession session = request.getSession(false); // Get existing session
            if (session != null) {
                session.invalidate(); // Invalidate the session
            }
            response.sendRedirect("index.jsp"); // Redirect to the login page
        } else {
            // User cancelled logout - redirect back to the dashboard
            response.sendRedirect(dashboardURL);
        }
    }
}