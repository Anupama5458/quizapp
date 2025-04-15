package com.yash.quizapplication.service;

import com.yash.quizapplication.domain.Topic;
import java.util.List;

public interface TopicService {

    boolean addTopic(Topic topic);
    Topic getTopicById(int topicId);

    List<Topic> getAllTopics();

    boolean updateTopic(Topic topic);

    boolean deleteTopic(int topicId);
}