package com.yash.quizapplication.domain;

import java.time.LocalDateTime;

public class QuizResult {
    private int id;
    private String email;
    private int score;
    private LocalDateTime quizDate;
    private int quizId;
    private String subjectName;
    private String quizTitle;

    public QuizResult() {}

    public QuizResult(int id, String email, int score, LocalDateTime quizDate, int quizId, String subjectName, String quizTitle) {
        this.id = id;
        this.email = email;
        this.score = score;
        this.quizDate = quizDate;
        this.quizId = quizId;
        this.subjectName = subjectName;
        this.quizTitle = quizTitle;
    }

    // Getters and setters for ALL fields
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public LocalDateTime getQuizDate() { return quizDate; }
    public void setQuizDate(LocalDateTime quizDate) { this.quizDate = quizDate; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }
}