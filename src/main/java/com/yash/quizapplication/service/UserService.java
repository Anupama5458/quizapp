package com.yash.quizapplication.service;

import com.yash.quizapplication.exception.InvalidCredentialsException;
import com.yash.quizapplication.domain.Users;
import java.util.List;

public interface UserService  {
    boolean login(String email, String passkey) throws InvalidCredentialsException;
    boolean isAdmin(String email);
    boolean registerUser(String email, String username, String passkey);
    List<Users> getPendingUsers();
    void updateUserStatus(String email, String status);
    boolean isApprovedUser(String email);
    boolean isRejectedUser(String email);
}
