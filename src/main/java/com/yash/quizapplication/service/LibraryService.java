package com.yash.quizapplication.service;

import com.yash.quizapplication.domain.LibraryQuestion;
import com.yash.quizapplication.domain.LibraryQuestion;
import com.yash.quizapplication.domain.Topic;

import java.util.List;

public interface LibraryService {

    boolean addQuestionToLibrary(LibraryQuestion question, List<Integer> topicIds);
    LibraryQuestion getLibraryQuestionById(int questionId);

    List<LibraryQuestion> getAllLibraryQuestions();
    List<LibraryQuestion> getQuestionsByTopic(int topicId);

    boolean updateQuestionInLibrary(LibraryQuestion question, List<Integer> newTopicIds);
    boolean deleteLibraryQuestion(int questionId);

    List<Integer> getTopicIdsForQuestion(int questionId);
    List<Topic> getTopicsForQuestion(int questionId);

}