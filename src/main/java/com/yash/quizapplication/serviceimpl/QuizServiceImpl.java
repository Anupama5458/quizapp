// QuizServiceImpl.java
package com.yash.quizapplication.serviceimpl;

import com.yash.quizapplication.dao.QuizDao;
import com.yash.quizapplication.daoimpl.QuizDaoImpl;
import com.yash.quizapplication.domain.QuizQuestion;
import com.yash.quizapplication.domain.QuizMetadata;
import com.yash.quizapplication.domain.QuizResult;
import com.yash.quizapplication.service.QuizService;
import javax.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import com.yash.quizapplication.util.ExcelReader;

public class QuizServiceImpl implements QuizService {

    private final QuizDao quizDao = new QuizDaoImpl();

    @Override
    public List<QuizMetadata> getQuizzesBySubject(String subjectName) {
        return quizDao.getQuizzesBySubject(subjectName);
    }

    @Override
    public List<QuizQuestion> getQuizQuestionsByQuizId(int quizId) {
        System.out.println("ServiceImpl getQuizQuestionsByQuizId method working");
        return quizDao.getQuizQuestionsByQuizId(quizId);
    }

    @Override
    public int evaluateQuiz(HttpServletRequest request, int quizId, int totalQuestions, String subjectName, String quizTitle) {
        List<QuizQuestion> questions = quizDao.getQuizQuestionsByQuizId(quizId);
        int score = 0;

        for (QuizQuestion question : questions) {
            int questionId = question.getId();
            String userAnswer = request.getParameter("answer_" + questionId);  // Key change

            if (userAnswer != null && question.getCorrectOption().equalsIgnoreCase(userAnswer)) {
                score++;
            }
        }
        String email = (String) request.getSession().getAttribute("email");
        System.out.println("evaluate quiz; QuizService email= " + email + " Title " + quizTitle + " sbjct " + subjectName);
        quizDao.saveQuizResult(email, quizId, score, subjectName, quizTitle);

        return score;
    }

    @Override
    public boolean createQuiz(QuizMetadata quiz) {
        return quizDao.saveQuiz(quiz);
    }

    @Override
    public int getTotalQuestions(int quizId) {
        return quizDao.getTotalQuestions(quizId);
    }

    public int getQuizIdByTitleAndSubject(String quizTitle, String subjectName) {
        return quizDao.getQuizIdByTitleAndSubject(quizTitle, subjectName);
    }

    @Override
    public boolean addQuestionToQuiz(QuizQuestion question) {
        System.out.println("ServiceImpl: adding question to db: " + question.getQuestionText());
        return quizDao.addQuestionToQuiz(question);
    }

    @Override
    public List<QuizMetadata> getAllQuizzes() {
        return quizDao.getAllQuizzes();
    }

    @Override
    public boolean uploadQuestions(InputStream fileContent, int numQuestions, int quizId) {  // Modified
        List<QuizQuestion> questionList = ExcelReader.readQuestionsFromExcel(fileContent);

        for (QuizQuestion question : questionList) { // Iterate through questions and set QuizId
            question.setQuizId(quizId);  // NEW: Set the quizId on each question
        }
        Collections.shuffle(questionList);

        List<QuizQuestion> selectedQuestions = questionList.subList(0, Math.min(numQuestions, questionList.size()));

        return quizDao.insertQuestions(selectedQuestions);
    }

    @Override
    public boolean deleteQuiz(int quizId) {
        return quizDao.deleteQuiz(quizId);
    }

    @Override
    public List<QuizResult> getAllQuizResults() {
        return quizDao.getAllQuizResults();
    }

    @Override
    public QuizMetadata getQuizMetadataById(int quizId) {
        return quizDao.getQuizMetadataById(quizId);
    }

    @Override
    public List<QuizResult> getQuizResultsByUser(String userEmail) {
        return quizDao.getQuizResultsByUser(userEmail);
    }

    @Override
    public boolean addLibraryQuestionsToQuiz(int quizId, List<Integer> libraryQuestionIds) {
        //basic validation
        if (quizId <= 0 || libraryQuestionIds == null) {
            System.err.println("Invalid input to addLibraryQuestionsToQuiz service method.");
            return false;
        }
        return quizDao.addLibraryQuestionsToQuiz(quizId, libraryQuestionIds);
    }
}