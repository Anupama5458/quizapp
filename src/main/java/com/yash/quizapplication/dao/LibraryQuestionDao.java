package com.yash.quizapplication.dao;

import com.yash.quizapplication.domain.LibraryQuestion;
import java.util.List;

public interface LibraryQuestionDao {

    int addLibraryQuestion(LibraryQuestion question);
    LibraryQuestion getLibraryQuestionById(int questionId);

    List<LibraryQuestion> getAllLibraryQuestions();

    List<LibraryQuestion> getQuestionsByTopicId(int topicId);

    boolean updateLibraryQuestion(LibraryQuestion question);
    boolean deleteLibraryQuestion(int questionId);
}