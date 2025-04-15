package com.yash.quizapplication.dao;

import com.yash.quizapplication.domain.Topic;

import java.util.List;
public interface LibraryQuestionTopicDao {

    boolean assignQuestionToTopic(int questionId, int topicId);

    boolean removeQuestionFromTopic(int questionId, int topicId);
    boolean removeAllTopicsForQuestion(int questionId);

    List<Integer> getTopicIdsForQuestion(int questionId);
    List<Topic> getTopicsForQuestion(int questionId);

}