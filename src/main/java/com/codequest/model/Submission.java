package com.codequest.model;

import java.sql.Timestamp;

/**
 * Model representing a student's submission to a programming mission.
 */
public class Submission {
    private int id;
    private int userId;
    private int missionId;
    private String answer;
    private boolean isCorrect;
    private Timestamp completedAt;

    // Derived properties for presentation
    private String missionTitle;
    private String missionCategory;
    private String missionDifficulty;
    private int xpEarned;
    private String username;

    public Submission() {
    }

    public Submission(int id, int userId, int missionId, String answer, boolean isCorrect, Timestamp completedAt) {
        this.id = id;
        this.userId = userId;
        this.missionId = missionId;
        this.answer = answer;
        this.isCorrect = isCorrect;
        this.completedAt = completedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getMissionId() {
        return missionId;
    }

    public void setMissionId(int missionId) {
        this.missionId = missionId;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getMissionTitle() {
        return missionTitle;
    }

    public void setMissionTitle(String missionTitle) {
        this.missionTitle = missionTitle;
    }

    public String getMissionCategory() {
        return missionCategory;
    }

    public void setMissionCategory(String missionCategory) {
        this.missionCategory = missionCategory;
    }

    public String getMissionDifficulty() {
        return missionDifficulty;
    }

    public void setMissionDifficulty(String missionDifficulty) {
        this.missionDifficulty = missionDifficulty;
    }

    public int getXpEarned() {
        return xpEarned;
    }

    public void setXpEarned(int xpEarned) {
        this.xpEarned = xpEarned;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
