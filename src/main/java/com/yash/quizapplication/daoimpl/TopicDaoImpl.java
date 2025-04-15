package com.yash.quizapplication.daoimpl;

import com.yash.quizapplication.dao.TopicDao;
import com.yash.quizapplication.util.JdbcUtility;
import com.yash.quizapplication.domain.Topic;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TopicDaoImpl implements TopicDao {

    // Add a new topic
    public boolean addTopic(Topic topic) {
        String sql = "INSERT INTO topics (topic_name) VALUES (?)";
        boolean rowInserted = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, topic.getTopicName());
            rowInserted = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding topic: " + e.getMessage());
        }
        return rowInserted;
    }

    public Topic getTopicById(int topicId) {
        String sql = "SELECT topic_id, topic_name, created_at FROM topics WHERE topic_id = ?";
        Topic topic = null;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, topicId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    topic = new Topic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTopicName(rs.getString("topic_name"));
                    topic.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting topic by ID: " + e.getMessage());
        }
        return topic;
    }

    public List<Topic> getAllTopics() {
        List<Topic> topics = new ArrayList<>();
        String sql = "SELECT topic_id, topic_name, created_at FROM topics ORDER BY topic_name";
        try (Connection conn = JdbcUtility.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Topic topic = new Topic();
                topic.setTopicId(rs.getInt("topic_id"));
                topic.setTopicName(rs.getString("topic_name"));
                topic.setCreatedAt(rs.getTimestamp("created_at"));
                topics.add(topic);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all topics: " + e.getMessage());
        }
        return topics;
    }

    public boolean updateTopic(Topic topic) {
        String sql = "UPDATE topics SET topic_name = ? WHERE topic_id = ?";
        boolean rowUpdated = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, topic.getTopicName());
            pstmt.setInt(2, topic.getTopicId());
            rowUpdated = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating topic: " + e.getMessage());
        }
        return rowUpdated;
    }

    // Delete a topic by ID
    public boolean deleteTopic(int topicId) {
        String sql = "DELETE FROM topics WHERE topic_id = ?";
        boolean rowDeleted = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, topicId);
            rowDeleted = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting topic: " + e.getMessage());
        }
        return rowDeleted;
    }
}