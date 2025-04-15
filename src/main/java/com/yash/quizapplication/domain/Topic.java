package com.yash.quizapplication.domain;
import java.sql.Timestamp;
import java.util.Objects;

public class Topic {

    private int topicId;
    private String topicName;
    private Timestamp createdAt;

    public Topic() {
    }

    public Topic(int topicId, String topicName, Timestamp createdAt) {
        this.topicId = topicId;
        this.topicName = topicName;
        this.createdAt = createdAt;
    }

    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    public String getTopicName() {
        return topicName;
    }

    public void setTopicName(String topicName) {
        this.topicName = topicName;
    }

    public Timestamp getCreatedAt() {
        return createdAt == null ? null : new Timestamp(createdAt.getTime());
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = (createdAt == null ? null : new Timestamp(createdAt.getTime()));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Topic topic = (Topic) o;
        return topicId == topic.topicId &&
                Objects.equals(topicName, topic.topicName) &&
                Objects.equals(createdAt, topic.createdAt);
    }

    @Override
    public int hashCode() {
        return Objects.hash(topicId, topicName, createdAt);
    }

    @Override
    public String toString() {
        return "Topic{" +
                "topicId=" + topicId +
                ", topicName='" + topicName + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}