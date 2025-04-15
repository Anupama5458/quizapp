package com.yash.quizapplication.controller;

import com.yash.quizapplication.serviceimpl.UserServiceImpl;
import com.yash.quizapplication.exception.InvalidCredentialsException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserServiceImpl userService = new UserServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String passkey = request.getParameter("passkey");
        System.out.println("doPost called");

        try {
            if (userService.login(email, passkey)) {
                HttpSession session = request.getSession();
                // Store the email in the session with the attribute name "email"
                session.setAttribute("email", email);  // Changed attribute name to "email" for consistency
                System.out.println("Email: " + email + " isAdmin " + userService.isAdmin(email) + " isApproved: " + userService.isApprovedUser(email));

                boolean isAdmin = userService.isAdmin(email);
                session.setAttribute("isAdmin", isAdmin);

                if (userService.isAdmin(email)) {
                    System.out.println("isAdmin working");
                    response.sendRedirect("admin.jsp");
                } else if (userService.isApprovedUser(email)) {
                    System.out.println("isApproved also working");
                    response.sendRedirect("homepage.jsp");
                } else if (userService.isRejectedUser(email)) {
                    request.setAttribute("errorMessage", "Your registration request has been declined");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Your account is not approved yet");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid email or passkey!");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (InvalidCredentialsException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (Exception e) {
            //          e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}