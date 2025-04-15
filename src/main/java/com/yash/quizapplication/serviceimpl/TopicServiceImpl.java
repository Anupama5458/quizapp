package com.yash.quizapplication.serviceimpl;

import com.yash.quizapplication.dao.TopicDao;
import com.yash.quizapplication.daoimpl.TopicDaoImpl;
import com.yash.quizapplication.domain.Topic;
import com.yash.quizapplication.service.TopicService;

import java.util.List;

public class TopicServiceImpl implements TopicService {

    private TopicDao topicDAO;

    public TopicServiceImpl() {
        this.topicDAO = new TopicDaoImpl();
    }

    public boolean addTopic(Topic topic) {
        // Basic validation example
        if (topic == null || topic.getTopicName() == null || topic.getTopicName().trim().isEmpty()) {
            System.err.println("Topic name cannot be empty.");
            return false;
        }
        return topicDAO.addTopic(topic);
    }

    public Topic getTopicById(int topicId) {
        return topicDAO.getTopicById(topicId);
    }

    public List<Topic> getAllTopics() {
        return topicDAO.getAllTopics();
    }

    public boolean updateTopic(Topic topic) {
        if (topic == null || topic.getTopicName() == null || topic.getTopicName().trim().isEmpty()) {
            System.err.println("Topic name cannot be empty for update.");
            return false;
        }
        if (topic.getTopicId() <= 0) {
            System.err.println("Invalid Topic ID for update.");
            return false;
        }
        return topicDAO.updateTopic(topic);
    }

    public boolean deleteTopic(int topicId) {
        if (topicId <= 0) {
            System.err.println("Invalid Topic ID for delete.");
            return false;
        }
        return topicDAO.deleteTopic(topicId);
    }
}