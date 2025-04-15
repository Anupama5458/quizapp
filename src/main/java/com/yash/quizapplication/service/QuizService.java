package com.yash.quizapplication.service;

import com.yash.quizapplication.domain.QuizQuestion;
import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.domain.QuizResult;

import java.io.InputStream;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

public interface QuizService {
    List<QuizMetadata> getQuizzesBySubject(String subjectName);
    List<QuizQuestion> getQuizQuestionsByQuizId(int quizId);
    int evaluateQuiz(HttpServletRequest request, int quizId, int totalQuestions,  String subjectName, String quizTitle);
    boolean createQuiz(QuizMetadata quiz);
    int getTotalQuestions(int quizId);
    int getQuizIdByTitleAndSubject(String quizTitle, String subjectName);
    boolean addQuestionToQuiz(QuizQuestion question);
    List<QuizMetadata> getAllQuizzes();
    boolean uploadQuestions(InputStream fileContent, int numQuestions, int quizId);
    boolean deleteQuiz(int quizId);
    List<QuizResult> getAllQuizResults();
    QuizMetadata getQuizMetadataById(int quizId);
    List<QuizResult> getQuizResultsByUser(String userEmail);
    boolean addLibraryQuestionsToQuiz(int quizId, List<Integer> libraryQuestionIds);
}
