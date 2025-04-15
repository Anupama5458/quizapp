package com.yash.quizapplication.daoimpl;

import com.yash.quizapplication.dao.LibraryQuestionTopicDao;
import com.yash.quizapplication.domain.Topic;
import com.yash.quizapplication.util.JdbcUtility;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibraryQuestionTopicDaoImpl implements LibraryQuestionTopicDao {

    public boolean assignQuestionToTopic(int questionId, int topicId) {
        String sqlCheck = "SELECT 1 FROM library_question_topics WHERE lib_question_id = ? AND topic_id = ?";
        String sqlInsert = "INSERT INTO library_question_topics (lib_question_id, topic_id) VALUES (?, ?)";
        boolean assigned = false;

        try (Connection conn = JdbcUtility.getConnection()) {
            boolean exists = false;
            try (PreparedStatement checkPstmt = conn.prepareStatement(sqlCheck)) {
                checkPstmt.setInt(1, questionId);
                checkPstmt.setInt(2, topicId);
                try (ResultSet rs = checkPstmt.executeQuery()) {
                    if (rs.next()) {
                        exists = true;
                        assigned = true;
                        System.out.println("Link already exists for Q:" + questionId + " T:" + topicId);
                    }
                }
            }

            if (!exists) {
                try (PreparedStatement insertPstmt = conn.prepareStatement(sqlInsert)) {
                    insertPstmt.setInt(1, questionId);
                    insertPstmt.setInt(2, topicId);
                    assigned = insertPstmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error assigning question to topic: " + e.getMessage());
        }
        return assigned;
    }


    public boolean removeQuestionFromTopic(int questionId, int topicId) {
        String sql = "DELETE FROM library_question_topics WHERE lib_question_id = ? AND topic_id = ?";
        boolean removed = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            pstmt.setInt(2, topicId);
            removed = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error removing question from topic: " + e.getMessage());
        }
        return removed;
    }

    public boolean removeAllTopicsForQuestion(int questionId) {
        String sql = "DELETE FROM library_question_topics WHERE lib_question_id = ?";
        boolean removed = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            // This will return the number of assignments deleted, >0 means success if any existed
            pstmt.executeUpdate();
            removed = true; // Consider successful even if no assignments existed

        } catch (SQLException e) {
            System.err.println("Error removing all topics for question: " + e.getMessage());
            removed = false;
        }
        return removed;
    }


    public List<Integer> getTopicIdsForQuestion(int questionId) {
        List<Integer> topicIds = new ArrayList<>();
        String sql = "SELECT topic_id FROM library_question_topics WHERE lib_question_id = ?";
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    topicIds.add(rs.getInt("topic_id"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting topic IDs for question: " + e.getMessage());
        }
        return topicIds;
    }

    public List<Topic> getTopicsForQuestion(int questionId) {
        List<Topic> topics = new ArrayList<>();
        String sql = "SELECT t.* FROM topics t " +
                "JOIN library_question_topics lqt ON t.topic_id = lqt.topic_id " +
                "WHERE lqt.lib_question_id = ? ORDER BY t.topic_name";

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Topic topic = new Topic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTopicName(rs.getString("topic_name"));
                    topic.setCreatedAt(rs.getTimestamp("created_at"));
                    topics.add(topic);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting topics for question: " + e.getMessage());
        }
        return topics;
    }
}