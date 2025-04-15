package com.yash.quizapplication.domain;

import java.util.Objects;

public class LibraryQuestion {

    private int libQuestionId;
    private String questionText;
    private String questionType;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private String correctOption;

    public LibraryQuestion() {
    }

    public LibraryQuestion(int libQuestionId, String questionText, String questionType, String option1, String option2, String option3, String option4, String correctOption) {
        this.libQuestionId = libQuestionId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.option1 = option1;
        this.option2 = option2;
        this.option3 = option3;
        this.option4 = option4;
        this.correctOption = correctOption;
    }

    public int getLibQuestionId() {
        return libQuestionId;
    }

    public void setLibQuestionId(int libQuestionId) {
        this.libQuestionId = libQuestionId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getOption1() {
        return option1;
    }

    public void setOption1(String option1) {
        this.option1 = option1;
    }

    public String getOption2() {
        return option2;
    }

    public void setOption2(String option2) {
        this.option2 = option2;
    }

    public String getOption3() {
        return option3;
    }

    public void setOption3(String option3) {
        this.option3 = option3;
    }

    public String getOption4() {
        return option4;
    }

    public void setOption4(String option4) {
        this.option4 = option4;
    }

    public String getCorrectOption() {
        return correctOption;
    }

    public void setCorrectOption(String correctOption) {
        this.correctOption = correctOption;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LibraryQuestion that = (LibraryQuestion) o;
        return libQuestionId == that.libQuestionId &&
                Objects.equals(questionText, that.questionText) &&
                Objects.equals(questionType, that.questionType) &&
                Objects.equals(option1, that.option1) &&
                Objects.equals(option2, that.option2) &&
                Objects.equals(option3, that.option3) &&
                Objects.equals(option4, that.option4) &&
                Objects.equals(correctOption, that.correctOption);
    }

    @Override
    public int hashCode() {
        return Objects.hash(libQuestionId, questionText, questionType, option1, option2, option3, option4, correctOption);
    }

    @Override
    public String toString() {
        return "LibraryQuestion{" +
                "libQuestionId=" + libQuestionId +
                ", questionText='" + questionText + '\'' +
                ", questionType='" + questionType + '\'' +
                ", option1='" + option1 + '\'' +
                ", option2='" + option2 + '\'' +
                ", option3='" + option3 + '\'' +
                ", option4='" + option4 + '\'' +
                ", correctOption='" + correctOption + '\'' +
                '}';
    }
}