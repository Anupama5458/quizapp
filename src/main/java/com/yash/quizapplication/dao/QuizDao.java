package com.yash.quizapplication.dao;

import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.domain.QuizQuestion;
import com.yash.quizapplication.domain.QuizResult;

import java.util.List;

public interface QuizDao {
    boolean addQuiz(String subjectName, String quizTitle);//for admin to create a quiz
    int getQuizId(String quizTitle, String subjectName);
    boolean addQuestionsToQuiz(QuizQuestion questions);
    List<QuizQuestion> getQuizQuestionsByQuizId(int quizId);
    List<QuizMetadata> getQuizzesBySubject(String subjectName);
    void saveQuizResult(String username, int quizId, int score, String subjectName, String quizTitle);
    boolean saveQuiz(QuizMetadata quiz);
    int getTotalQuestions(int quizId);
    int getQuizIdByTitleAndSubject(String quizTitle, String subjectName);
    boolean addQuestionToQuiz(QuizQuestion question);
    List<QuizMetadata> getAllQuizzes();
    boolean insertQuestions(List<QuizQuestion> questions);
    boolean deleteQuiz(int quizId);
    List<QuizResult> getAllQuizResults();
    QuizMetadata getQuizMetadataById(int quizId);
    List<QuizResult> getQuizResultsByUser(String userEmail);
    boolean addLibraryQuestionsToQuiz(int quizId, List<Integer> libraryQuestionIds);
}
