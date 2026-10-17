package com.codequest.model;

import java.sql.Timestamp;

/**
 * Model representing a registered student user in CodeQuest.
 */
public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private int totalXp;
    private int playerLevel;
    private Timestamp createdAt;
    
    // Derived / Aggregated properties for presentation
    private int completedMissionsCount;
    private int rank;

    public User() {
        this.totalXp = 0;
        this.playerLevel = 1;
    }

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.totalXp = 0;
        this.playerLevel = 1;
    }

    public User(int id, String username, String email, String password, int totalXp, int playerLevel, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.totalXp = totalXp;
        this.playerLevel = playerLevel;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getTotalXp() {
        return totalXp;
    }

    public void setTotalXp(int totalXp) {
        this.totalXp = totalXp;
    }

    public int getPlayerLevel() {
        return playerLevel;
    }

    public void setPlayerLevel(int playerLevel) {
        this.playerLevel = playerLevel;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getCompletedMissionsCount() {
        return completedMissionsCount;
    }

    public void setCompletedMissionsCount(int completedMissionsCount) {
        this.completedMissionsCount = completedMissionsCount;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    /**
     * Calculates the XP required to reach the next level.
     * Tier threshold: Each level requires 100 XP.
     */
    public int getXpForCurrentLevelBase() {
        return (this.playerLevel - 1) * 100;
    }

    public int getXpForNextLevelThreshold() {
        return this.playerLevel * 100;
    }

    public int getXpProgressInCurrentLevel() {
        int base = getXpForCurrentLevelBase();
        int progress = this.totalXp - base;
        return Math.max(0, Math.min(100, progress));
    }
}
