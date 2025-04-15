// QuizDaoImpl.java
package com.yash.quizapplication.daoimpl;

import com.yash.quizapplication.dao.QuizDao;
import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.domain.QuizQuestion;
import com.yash.quizapplication.util.JdbcUtility;
import com.yash.quizapplication.domain.QuizResult;
import java.time.LocalDateTime;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class QuizDaoImpl implements QuizDao {

    @Override
    public boolean addQuiz(String subjectName, String quizTitle) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "INSERT INTO quiz_metadata (subject_name, quiz_title) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, subjectName);
            stmt.setString(2, quizTitle);
            int rows = stmt.executeUpdate();
            stmt.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int getQuizId(String quizTitle, String subjectName) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "SELECT quiz_id FROM quiz_metadata WHERE quiz_title = ? AND subject_name=?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, quizTitle);
            stmt.setString(2, subjectName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int quizId = rs.getInt("quiz_id");
                rs.close();
                stmt.close();
                return quizId;
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // if quiz is not found
    }

    @Override
    public boolean addQuestionsToQuiz(QuizQuestion questions) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "INSERT INTO quiz_ques (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, questions.getQuizId());
            stmt.setString(2, questions.getOptionA());
            stmt.setString(3, questions.getOptionB());
            stmt.setString(4, questions.getOptionC());
            stmt.setString(5, questions.getOptionD());
            stmt.setString(6, questions.getCorrectOption());
            int rows = stmt.executeUpdate();
            stmt.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<QuizQuestion> getQuizQuestionsByQuizId(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        // SQL query using LEFT JOIN to fetch data from library_questions if linked
        String query = "SELECT " +
                "    qq.id, qq.quiz_id, qq.source_lib_question_id, " +
                "    COALESCE(lq.question_text, qq.questions_text) AS effective_question_text, " +
                "    COALESCE(lq.option_1, qq.option_a) AS effective_option_a, " +
                "    COALESCE(lq.option_2, qq.option_b) AS effective_option_b, " +
                "    COALESCE(lq.option_3, qq.option_c) AS effective_option_c, " +
                "    COALESCE(lq.option_4, qq.option_d) AS effective_option_d, " +
                "    COALESCE(lq.correct_option, qq.correct_option) AS effective_correct_option " +
                "FROM " +
                "    quiz_ques qq " +
                "LEFT JOIN " +
                "    library_questions lq ON qq.source_lib_question_id = lq.lib_question_id " +
                "WHERE " +
                "    qq.quiz_id = ? " +
                "ORDER BY qq.id";

        System.out.println("Executing SQL query in dao: " + query + " with quiz id: " + quizId);

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, quizId);
            System.out.println("Set quizId parameter: " + quizId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion question = new QuizQuestion();
                    question.setId(rs.getInt("id"));
                    question.setQuizId(rs.getInt("quiz_id"));

                    Integer sourceId = (Integer) rs.getObject("source_lib_question_id");
                    if (rs.wasNull()) {
                        question.setSourceLibQuestionId(null);
                    } else {
                        question.setSourceLibQuestionId(sourceId);
                    }

                    question.setQuestionText(rs.getString("effective_question_text"));
                    question.setOptionA(rs.getString("effective_option_a"));
                    question.setOptionB(rs.getString("effective_option_b"));
                    question.setOptionC(rs.getString("effective_option_c"));
                    question.setOptionD(rs.getString("effective_option_d"));
                    question.setCorrectOption(rs.getString("effective_correct_option"));

                    questions.add(question);
                }
            }
            System.out.println("Total Questions retrieved from daoimpl: " + questions.size());

        } catch (SQLException e) {
            System.err.println("SQL Error retrieving quiz questions for quizId " + quizId + ": " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected Error retrieving quiz questions for quizId " + quizId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return questions;
    }

    @Override
    public List<QuizMetadata> getQuizzesBySubject(String subjectName) {
        List<QuizMetadata> quizzes = new ArrayList<>();
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "SELECT quiz_id, subject_name, quiz_title, total_questions, created_at FROM quiz_metadata WHERE subject_name = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, subjectName);
            System.out.println("from dao, subjectName: " + subjectName);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                quizzes.add(new QuizMetadata(rs.getInt("quiz_id"), rs.getString("subject_name"), rs.getString("quiz_title"), rs.getInt("total_questions"), rs.getTimestamp("created_at")));
            }
            System.out.println("in dao, Fetched : " + quizzes.size() + " quizzes for  subjectName: " + subjectName);
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return quizzes;

    }

    @Override
    public void saveQuizResult(String email, int quizId, int score, String subjectName, String quizTitle) {
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "INSERT INTO quiz_results (email, score, quiz_date, quiz_id, subject_name, quiz_title) VALUES (?, ?, NOW(), ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            System.out.println("SaveQuizResult DAO-email= " + email + ", quizId=" + quizId + ", score=" + score + ", subjectName=" + subjectName + ", quizTitle=" + quizTitle);

            // Check if email is null or empty and set it to "anonymous"
            if (email == null || email.isEmpty()) {
                email = "anonymous"; // Or throw exception for login user
            }

            stmt.setString(1, email);
            stmt.setInt(2, score);
            stmt.setInt(3, quizId);
            stmt.setString(4, subjectName);
            stmt.setString(5, quizTitle);
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Rows updated in quiz_results: " + rowsUpdated); // Add this line

        } catch (Exception e) {
            e.printStackTrace();  // Proper error handling needed here (logging)
        }
    }

    @Override
    public boolean saveQuiz(QuizMetadata quiz) {
        String query = "INSERT INTO quiz_metadata (subject_name, quiz_title, total_questions, created_at) VALUES (?, ?, ?, NOW())";
        System.out.println("SaveQuiz method of quizDaoImpl working ");
        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, quiz.getSubjectName());
            stmt.setString(2, quiz.getQuizTitle());
            stmt.setInt(3, quiz.getTotalQuestions());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getTotalQuestions(int quizId) {
        int totalQuestions = 0;
        try (Connection conn = JdbcUtility.getConnection()) {
            String query = "SELECT COUNT(*) FROM quiz_ques WHERE quiz_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, quizId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalQuestions = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalQuestions;
    }

    @Override
    public int getQuizIdByTitleAndSubject(String quizTitle, String subjectName) {
        int quizId = -1;
        String query = "SELECT quiz_id FROM quiz_metadata WHERE quiz_title = ? AND subject_name = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, quizTitle);
            stmt.setString(2, subjectName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                quizId = rs.getInt("quiz_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizId;
    }

    @Override
    public boolean addQuestionToQuiz(QuizQuestion question) {
        boolean isAdded = false;
        String query = "INSERT INTO quiz_ques (questions_text, option_a, option_b, option_c, option_d, correct_option, quiz_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);
            System.out.println("DAO Layer: Preparing to insert ques into db");

            stmt.setString(1, question.getQuestionText());
            stmt.setString(2, question.getOptionA());
            stmt.setString(3, question.getOptionB());
            stmt.setString(4, question.getOptionC());
            stmt.setString(5, question.getOptionD());
            stmt.setString(6, question.getCorrectOption());
            stmt.setInt(7, question.getQuizId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("DB insert status: " + rowsAffected);
            if (rowsAffected > 0) {
                isAdded = true;
            }
        } catch (SQLException e) {
            System.out.println("SQL exception occured: " + e.getMessage());
            e.printStackTrace();
        }
        return isAdded;
    }

    @Override
    public List<QuizMetadata> getAllQuizzes() {
        List<QuizMetadata> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quiz_metadata";
        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                QuizMetadata quiz = new QuizMetadata();
                quiz.setQuizId(rs.getInt("quiz_id"));
                quiz.setQuizTitle(rs.getString("quiz_title"));
                quiz.setSubjectName(rs.getString("subject_name"));
                quiz.setTotalQuestions(rs.getInt("total_questions"));
                quiz.setCreatedAt(rs.getTimestamp("created_at"));

                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }

    @Override
    public boolean insertQuestions(List<QuizQuestion> questions) {
        String query = "INSERT INTO quiz_ques(questions_text, option_a, option_b, option_c, option_d, correct_option, quiz_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);

            for (QuizQuestion question : questions) {
                stmt.setString(1, question.getQuestionText());
                stmt.setString(2, question.getOptionA());
                stmt.setString(3, question.getOptionB());
                stmt.setString(4, question.getOptionC());
                stmt.setString(5, question.getOptionD());
                stmt.setString(6, question.getCorrectOption());
                stmt.setInt(7, question.getQuizId());
                stmt.addBatch();
            }
            int[] result = stmt.executeBatch();
            return result.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteQuiz(int quizId) {
        String query = "DELETE FROM quiz_metadata WHERE quiz_id = ?";
        try (Connection conn = JdbcUtility.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);

            stmt.setInt(1, quizId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<QuizResult> getAllQuizResults() {
        List<QuizResult> results = new ArrayList<>();
        String query = "SELECT * FROM quiz_results ORDER BY quiz_date DESC";
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                QuizResult result = new QuizResult();
                result.setId(rs.getInt("id"));
                result.setEmail(rs.getString("email"));
                result.setScore(rs.getInt("score"));
                // handle date issue
                Timestamp timestamp = rs.getTimestamp("quiz_date");
                LocalDateTime dateTime = timestamp.toLocalDateTime();

                result.setQuizDate(dateTime);
                result.setQuizId(rs.getInt("quiz_id"));
                result.setSubjectName(rs.getString("subject_name"));
                result.setQuizTitle(rs.getString("quiz_title"));
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Proper error handling needed here (logging)
        }
        return results;
    }

    @Override
    public QuizMetadata getQuizMetadataById(int quizId) {
        QuizMetadata quizMetadata = null;
        String query = "SELECT quiz_id, subject_name, quiz_title, total_questions, created_at FROM quiz_metadata WHERE quiz_id = ?";
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, quizId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                quizMetadata = new QuizMetadata(
                        rs.getInt("quiz_id"),
                        rs.getString("subject_name"),
                        rs.getString("quiz_title"),
                        rs.getInt("total_questions"),
                        rs.getTimestamp("created_at")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Proper error handling needed here (logging)
        }
        return quizMetadata;
    }

    @Override
    public List<QuizResult> getQuizResultsByUser(String userEmail) {
        List<QuizResult> results = new ArrayList<>();
        String query = "SELECT * FROM quiz_results WHERE email = ? ORDER BY quiz_date DESC"; // Filter by email
        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, userEmail); // Set the email parameter

            ResultSet rs = stmt.executeQuery();

            System.out.println("getQuizResultsByUser DAO: Executing query: " + query + " with email: " + userEmail);  // Debug log

            while (rs.next()) {
                QuizResult result = new QuizResult();
                result.setId(rs.getInt("id"));
                result.setEmail(rs.getString("email"));
                result.setScore(rs.getInt("score"));
                Timestamp timestamp = rs.getTimestamp("quiz_date");
                LocalDateTime dateTime = timestamp.toLocalDateTime();
                result.setQuizDate(dateTime);
                result.setQuizId(rs.getInt("quiz_id"));
                result.setSubjectName(rs.getString("subject_name"));
                result.setQuizTitle(rs.getString("quiz_title"));
                results.add(result);
            }

            System.out.println("getQuizResultsByUser DAO: Retrieved " + results.size() + " results for email: " + userEmail);  // Debug log
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    @Override
    public boolean addLibraryQuestionsToQuiz(int quizId, List<Integer> libraryQuestionIds) {
        if (libraryQuestionIds == null || libraryQuestionIds.isEmpty()) {
            System.out.println("No library question IDs provided to add to quiz " + quizId);
            return true;
        }

        String sql = "INSERT INTO quiz_ques (quiz_id, source_lib_question_id, created_at) VALUES (?, ?, NOW())";

        int[] results;

        try (Connection conn = JdbcUtility.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("Preparing to batch insert library question links for quiz ID: " + quizId);

            for (Integer libId : libraryQuestionIds) {
                if (libId != null && libId > 0) {
                    pstmt.setInt(1, quizId);
                    pstmt.setInt(2, libId);
                    pstmt.addBatch();
                    System.out.println("  Adding link: quizId=" + quizId + ", source_lib_question_id=" + libId);
                } else {
                    System.err.println("Skipping invalid library question ID: " + libId);
                }
            }

            results = pstmt.executeBatch();
            System.out.println("Batch insert executed. Result array length: " + results.length);

            boolean success = true; // Assume success unless proven otherwise
            int successCount = 0;
            for (int result : results) {
                if (result >= 0 || result == Statement.SUCCESS_NO_INFO) {
                    successCount++;
                } else if (result == Statement.EXECUTE_FAILED) {
                    System.err.println("Batch insert failed for at least one statement.");
                    success = false;
                }
            }
            System.out.println("Successfully inserted/linked " + successCount + " library questions.");
            return success && (successCount == libraryQuestionIds.stream().filter(id -> id != null && id > 0).count());


        } catch (BatchUpdateException bue) {
            System.err.println("SQL Batch Error adding library questions to quiz " + quizId + ": " + bue.getMessage());
            System.err.println("Update counts: " + java.util.Arrays.toString(bue.getUpdateCounts()));
            bue.printStackTrace();
            return false;
        } catch (SQLException e) {
            System.err.println("SQL Error adding library questions to quiz " + quizId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Unexpected Error adding library questions to quiz " + quizId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}