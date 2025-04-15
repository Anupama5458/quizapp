package com.yash.quizapplication.serviceimpl;

import com.yash.quizapplication.dao.UserDao;
import com.yash.quizapplication.daoimpl.UserDaoImpl;
import com.yash.quizapplication.service.UserService;
import com.yash.quizapplication.exception.InvalidCredentialsException;
import com.yash.quizapplication.domain.Users;
import java.util.List;

public class UserServiceImpl implements UserService{
    private final UserDao userDao = new UserDaoImpl();


    @Override
    public boolean login(String email, String passkey) throws InvalidCredentialsException{

        if(!userDao.doesUserExist(email)) {
            System.out.println("REGISTER FIRST IS WORKING");
          throw new InvalidCredentialsException("You're not registered yet, please register yourself");
        }

        if(userDao.isRejectedUser(email)){
            throw new InvalidCredentialsException("Your registration request has been declined");
        }

        if(!userDao.isApprovedUser(email)){
            throw new InvalidCredentialsException("Your request has not been approved yet");
        }

        if(!userDao.validateUser(email, passkey)){
            throw new InvalidCredentialsException("Invalid email or password.");
        }

        return true;
    }

    @Override
    public boolean isAdmin(String email){

        return userDao.isAdmin(email);
    }

    @Override
    public boolean registerUser(String email, String username, String passkey){
        return userDao.registerUser(email, username, passkey);
    }

    @Override
    public List<Users> getPendingUsers() {
        return  userDao.getPendingUsers();
    }

    @Override
    public void updateUserStatus(String email, String status) {
        userDao.updateUserStatus(email, status);
    }

    @Override
    public boolean isApprovedUser(String email){
        return userDao.isApprovedUser(email);
    }

    @Override
    public boolean isRejectedUser(String email) {
        return userDao.isRejectedUser(email);
    }

}
