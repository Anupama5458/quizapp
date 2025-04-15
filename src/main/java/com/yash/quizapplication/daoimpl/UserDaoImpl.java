package com.yash.quizapplication.daoimpl;

import com.yash.quizapplication.dao.UserDao;
import com.yash.quizapplication.domain.Users;
import com.yash.quizapplication.util.JdbcUtility;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class UserDaoImpl implements UserDao {
    @Override
    public boolean validateUser(String email, String passkey) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "SELECT status FROM users WHERE email=? AND passkey=?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, passkey);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return "approved".equalsIgnoreCase(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    @Override
    public boolean isAdmin(String email){
      System.out.println("isAdmin");
      try (Connection conn = JdbcUtility.getConnection()) {
        String query = "SELECT role FROM users WHERE email=?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        //System.out.println("userDaoImpl IsAdmin");

        if(rs.next()){
            return "admin".equalsIgnoreCase(rs.getString("role"));
        }

      }
        catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean registerUser(String email, String username, String passkey) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "INSERT INTO users (email, username, passkey, status) VALUES (?, ?, ?, 'pending')";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, username);
            stmt.setString(3, passkey);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isApprovedUser(String email){
        try(Connection conn = JdbcUtility.getConnection()){
            String query = "SELECT status FROM users WHERE email=?";
            PreparedStatement stmt= conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if(rs.next() ){
                return "approved".equalsIgnoreCase(rs.getString("status"));
            }
        }
        catch(Exception e){
            System.out.println("not approved msg checking");
            e.printStackTrace();
        }
        return false;
    }

    public boolean doesUserExist(String email) {
        try(Connection conn= JdbcUtility.getConnection()){
            String query = "SELECT COUNT(*) FROM users WHERE email=?";
            PreparedStatement stmt= conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if(rs.next() && rs.getInt(1)>0){
                return true;
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Users> getPendingUsers() {
        List<Users> pendingUsers = new ArrayList<>();
        try(Connection conn = JdbcUtility.getConnection()){
            String query = "SELECT email, username FROM users WHERE status ='pending'";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {
                Users user =new Users(rs.getString("email"), rs.getString("username"),"", "pending");
                pendingUsers.add(user);
                System.out.println("Pending user found: " +user.getEmail());
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        System.out.println("Total Pending Users: " + pendingUsers.size());
        return pendingUsers;
    }


    @Override
    public void updateUserStatus(String email, String status){
        try(Connection conn = JdbcUtility.getConnection()) {
            String query = "UPDATE users SET status= ? WHERE email=?";
            PreparedStatement stmt= conn.prepareStatement(query);
            stmt.setString(1, status);
            stmt.setString(2, email);
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("User status updated: "+ rowsUpdated + " rows for "+ email);
            if(rowsUpdated == 0){
                System.out.println("no rows updated!! check if the email exists in ");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }


    @Override
    public boolean isRejectedUser(String email){
        try(Connection conn = JdbcUtility.getConnection()){
            String query = "SELECT * FROM users WHERE email = ? AND status = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, "rejected");
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return "rejected".equalsIgnoreCase(rs.getString("status"));
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

}
