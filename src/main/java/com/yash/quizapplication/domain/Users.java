package com.yash.quizapplication.domain;

public class Users {
    private String email;
    private String username;
    private String passkey;
    private String status;
    public Users() {}

    public Users(String email, String username, String passkey, String status){
        this.email=email;
        this.username=username;
        this.passkey=passkey;
        this.status=status;
    }

    //Getters and Setters
    public String getEmail(){
        return email;
    }
    public void setEmail(String email){
        this.email= email;
    }

    public String getUsername(){
        return username;
    }
    public void setUsername(String username){
        this.username= username;
    }

    public String getPasskey(){
        return passkey;
    }
    public void setPasskey(String passkey){
        this.passkey= passkey;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Users{" +
                "email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
