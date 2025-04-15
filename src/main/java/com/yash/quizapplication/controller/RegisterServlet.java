package com.yash.quizapplication.controller;

import com.yash.quizapplication.service.UserService;
import com.yash.quizapplication.serviceimpl.UserServiceImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet{
    private final UserService userService= new UserServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String passkey= request.getParameter("passkey");

        boolean isRegistered = userService.registerUser(email, username, passkey);

        if(isRegistered){
            request.setAttribute("message", "Registered Successfully! Your request has been sent for approval.<br>"+"You can log in once your request gets approved.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        else{
            request.setAttribute("errorMessage", "Registration failed. Please try again");
            request.getRequestDispatcher("index.jsp?form=register").forward(request, response);
        }
    }
}


