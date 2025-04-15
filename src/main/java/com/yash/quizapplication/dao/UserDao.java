package com.yash.quizapplication.dao;

import java.util.List;
import com.yash.quizapplication.domain.Users;

public interface UserDao {
    boolean validateUser(String email, String passkey); //whether user/admin is entering valid credentials or not
    boolean isAdmin(String email);
    boolean registerUser(String email, String username, String passkey);//can login
    boolean isApprovedUser(String email); //directed to homepage after logging in
    boolean doesUserExist(String email); // if not, asking them to register first
    List<Users> getPendingUsers();
    void updateUserStatus(String email, String status);
    boolean isRejectedUser(String email);
}
