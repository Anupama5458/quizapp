package com.yash.quizapplication.dao;

import com.yash.quizapplication.domain.Topic;

import java.util.List;

public interface TopicDao {

    boolean addTopic(Topic topic);

    Topic getTopicById(int topicId);
    List<Topic> getAllTopics();
    boolean updateTopic(Topic topic);
    boolean deleteTopic(int topicId);
}