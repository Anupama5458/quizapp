package com.yash.quizapplication.daoimpl;

import com.yash.quizapplication.dao.LibraryQuestionDao;
import com.yash.quizapplication.domain.LibraryQuestion;
import com.yash.quizapplication.util.JdbcUtility;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibraryQuestionDaoImpl implements LibraryQuestionDao {

    public int addLibraryQuestion(LibraryQuestion question) {
        String sql = "INSERT INTO library_questions (question_text, question_type, option_1, option_2, option_3, option_4, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, question.getQuestionText());
            pstmt.setString(2, question.getQuestionType()); // Should likely be "MCQ"
            pstmt.setString(3, question.getOption1());
            pstmt.setString(4, question.getOption2());
            pstmt.setString(5, question.getOption3());
            pstmt.setString(6, question.getOption4());
            pstmt.setString(7, question.getCorrectOption());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedId = generatedKeys.getInt(1);
                        question.setLibQuestionId(generatedId); // Set ID back on the object
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding library question: " + e.getMessage());
        }
        return generatedId;
    }

    public LibraryQuestion getLibraryQuestionById(int questionId) {
        String sql = "SELECT * FROM library_questions WHERE lib_question_id = ?";
        LibraryQuestion question = null;

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    question = mapRowToLibraryQuestion(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting library question by ID: " + e.getMessage());
        }
        return question;
    }

    public List<LibraryQuestion> getAllLibraryQuestions() {
        List<LibraryQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM library_questions ORDER BY lib_question_id"; // Or order by text

        try (Connection conn = JdbcUtility.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                questions.add(mapRowToLibraryQuestion(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all library questions: " + e.getMessage());
        }
        return questions;
    }

    public List<LibraryQuestion> getQuestionsByTopicId(int topicId) {
        List<LibraryQuestion> questions = new ArrayList<>();
        String sql = "SELECT q.* FROM library_questions q " +
                "JOIN library_question_topics lqt ON q.lib_question_id = lqt.lib_question_id " +
                "WHERE lqt.topic_id = ? ORDER BY q.lib_question_id";

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, topicId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    questions.add(mapRowToLibraryQuestion(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting questions by topic ID: " + e.getMessage());
        }
        return questions;
    }

    public boolean updateLibraryQuestion(LibraryQuestion question) {
        String sql = "UPDATE library_questions SET question_text = ?, question_type = ?, " +
                "option_1 = ?, option_2 = ?, option_3 = ?, option_4 = ?, correct_option = ? " +
                "WHERE lib_question_id = ?";
        boolean rowUpdated = false;

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, question.getQuestionText());
            pstmt.setString(2, question.getQuestionType());
            pstmt.setString(3, question.getOption1());
            pstmt.setString(4, question.getOption2());
            pstmt.setString(5, question.getOption3());
            pstmt.setString(6, question.getOption4());
            pstmt.setString(7, question.getCorrectOption());
            pstmt.setInt(8, question.getLibQuestionId());

            rowUpdated = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating library question: " + e.getMessage());
        }
        return rowUpdated;
    }

    public boolean deleteLibraryQuestion(int questionId) {
        String sql = "DELETE FROM library_questions WHERE lib_question_id = ?";
        boolean rowDeleted = false;
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            rowDeleted = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting library question: " + e.getMessage());
        }
        return rowDeleted;
    }

    // Helper method to map a ResultSet row to a LibraryQuestion object
    private LibraryQuestion mapRowToLibraryQuestion(ResultSet rs) throws SQLException {
        LibraryQuestion question = new LibraryQuestion();
        question.setLibQuestionId(rs.getInt("lib_question_id"));
        question.setQuestionText(rs.getString("question_text"));
        question.setQuestionType(rs.getString("question_type"));
        question.setOption1(rs.getString("option_1"));
        question.setOption2(rs.getString("option_2"));
        question.setOption3(rs.getString("option_3"));
        question.setOption4(rs.getString("option_4"));
        question.setCorrectOption(rs.getString("correct_option"));
        return question;
    }
}