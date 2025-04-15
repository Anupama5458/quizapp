package com.yash.quizapplication.serviceimpl;

import com.yash.quizapplication.daoimpl.LibraryQuestionDaoImpl;
import com.yash.quizapplication.daoimpl.LibraryQuestionTopicDaoImpl;
import com.yash.quizapplication.domain.Topic;
import com.yash.quizapplication.dao.LibraryQuestionDao;
import com.yash.quizapplication.dao.LibraryQuestionTopicDao;
import com.yash.quizapplication.domain.LibraryQuestion;
import com.yash.quizapplication.service.LibraryService;

import java.util.List;

public class LibraryServiceImpl implements LibraryService {

    private LibraryQuestionDao questionDAO;
    private LibraryQuestionTopicDao questionTopicDAO;

    public LibraryServiceImpl() {
        this.questionDAO = new LibraryQuestionDaoImpl();
        this.questionTopicDAO = new LibraryQuestionTopicDaoImpl();
    }

    public boolean addQuestionToLibrary(LibraryQuestion question, List<Integer> topicIds) {
        int newQuestionId = questionDAO.addLibraryQuestion(question);
        if (newQuestionId <= 0) {
            System.err.println("Failed to add library question to DB.");
            return false;
        }

        if (topicIds != null && !topicIds.isEmpty()) {
            boolean allAssigned = true;
            for (int topicId : topicIds) {
                if (!questionTopicDAO.assignQuestionToTopic(newQuestionId, topicId)) {
                    System.err.println("Failed to assign question " + newQuestionId + " to topic " + topicId);
                    allAssigned = false;

                    questionDAO.deleteLibraryQuestion(newQuestionId);
                    return false;
                }
            }
            return allAssigned;
        }
        return true;
    }

    public LibraryQuestion getLibraryQuestionById(int questionId) {
        return questionDAO.getLibraryQuestionById(questionId);
    }

    public List<LibraryQuestion> getAllLibraryQuestions() {
        return questionDAO.getAllLibraryQuestions();
    }

    public List<LibraryQuestion> getQuestionsByTopic(int topicId) {
        return questionDAO.getQuestionsByTopicId(topicId);
    }

    public boolean updateQuestionInLibrary(LibraryQuestion question, List<Integer> newTopicIds) {
        boolean questionUpdated = questionDAO.updateLibraryQuestion(question);
        if (!questionUpdated) {
            System.err.println("Failed to update question details for ID: " + question.getLibQuestionId());
            return false;
        }

        boolean topicsCleared = questionTopicDAO.removeAllTopicsForQuestion(question.getLibQuestionId());
        if (!topicsCleared) {
            System.err.println("Failed to clear existing topic assignments for question ID: " + question.getLibQuestionId());
            return false;
        }

        boolean allAssigned = true;
        if (newTopicIds != null && !newTopicIds.isEmpty()) {
            for (int topicId : newTopicIds) {
                if (!questionTopicDAO.assignQuestionToTopic(question.getLibQuestionId(), topicId)) {
                    System.err.println("Failed to assign updated question " + question.getLibQuestionId() + " to topic " + topicId);
                    allAssigned = false;
                }
            }
        }
        return allAssigned;
    }

    public boolean deleteLibraryQuestion(int questionId) {
        return questionDAO.deleteLibraryQuestion(questionId);
    }

    public List<Integer> getTopicIdsForQuestion(int questionId) {
        return questionTopicDAO.getTopicIdsForQuestion(questionId);
    }

    public List<Topic> getTopicsForQuestion(int questionId) {
        return questionTopicDAO.getTopicsForQuestion(questionId);
    }
}