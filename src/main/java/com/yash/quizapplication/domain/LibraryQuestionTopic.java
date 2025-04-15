package com.yash.quizapplication.domain;
import java.util.Objects;

public class LibraryQuestionTopic {

    private int libQuestionId;
    private int topicId;

    public LibraryQuestionTopic() {
    }

    public LibraryQuestionTopic(int libQuestionId, int topicId) {
        this.libQuestionId = libQuestionId;
        this.topicId = topicId;
    }

    public int getLibQuestionId() {
        return libQuestionId;
    }

    public void setLibQuestionId(int libQuestionId) {
        this.libQuestionId = libQuestionId;
    }

    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LibraryQuestionTopic that = (LibraryQuestionTopic) o;
        return libQuestionId == that.libQuestionId &&
                topicId == that.topicId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(libQuestionId, topicId);
    }

    @Override
    public String toString() {
        return "LibraryQuestionTopic{" +
                "libQuestionId=" + libQuestionId +
                ", topicId=" + topicId +
                '}';
    }
}