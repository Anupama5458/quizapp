package com.yash.quizapplication.domain;

import java.sql.Timestamp;

public class QuizMetadata {
    private int quizId;
    private String subjectName;
    private String quizTitle;
    private int totalQuestions;
    private Timestamp createdAt;

    public QuizMetadata(){
    }

    public QuizMetadata(int quizId, String subjectName, String quizTitle, int totalQuestions, Timestamp createdAt) {
        this.quizId = quizId;
        this.subjectName = subjectName;
        this.quizTitle = quizTitle;
        this.totalQuestions= totalQuestions;
        this.createdAt = createdAt;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "QuizMetadata{" + "quizId=" + quizId + ", subjectName='"+subjectName+ '\'' + ", quizTitle='"+ quizTitle + '\'' +",totaQuestions=" + totalQuestions + ", createdAt=" + createdAt + '}';

    }

}
