package com.codequest.dao;

import com.codequest.model.Submission;
import com.codequest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for student mission submissions.
 */
public class SubmissionDAO {

    /**
     * Checks if the student has already submitted an answer for this mission.
     * Enforces the one-attempt-per-mission rule.
     */
    public boolean hasAttempted(int userId, int missionId) {
        String sql = "SELECT id FROM mission_submissions WHERE user_id = ? AND mission_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, missionId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
    }

    /**
     * Records a submission within an active database transaction.
     */
    public boolean recordSubmission(Connection conn, Submission sub) throws SQLException {
        String sql = "INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, sub.getUserId());
            ps.setInt(2, sub.getMissionId());
            ps.setString(3, sub.getAnswer());
            ps.setBoolean(4, sub.isCorrect());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    sub.setId(rs.getInt(1));
                }
                DBConnection.closeQuietly(rs);
                return true;
            }
            return false;
        } finally {
            DBConnection.closeQuietly(ps);
        }
    }

    /**
     * Retrieves submission history for a specific student, enriched with mission details.
     */
    public List<Submission> getSubmissionsByUser(int userId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.id, s.user_id, s.mission_id, s.answer, s.is_correct, s.completed_at, " +
                     "m.title, m.category, m.difficulty, m.xp_reward " +
                     "FROM mission_submissions s " +
                     "JOIN missions m ON s.mission_id = m.id " +
                     "WHERE s.user_id = ? " +
                     "ORDER BY s.completed_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Submission sub = new Submission();
                sub.setId(rs.getInt("id"));
                sub.setUserId(rs.getInt("user_id"));
                sub.setMissionId(rs.getInt("mission_id"));
                sub.setAnswer(rs.getString("answer"));
                sub.setCorrect(rs.getBoolean("is_correct"));
                sub.setCompletedAt(rs.getTimestamp("completed_at"));
                sub.setMissionTitle(rs.getString("title"));
                sub.setMissionCategory(rs.getString("category"));
                sub.setMissionDifficulty(rs.getString("difficulty"));
                sub.setXpEarned(sub.isCorrect() ? rs.getInt("xp_reward") : 0);
                list.add(sub);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves a single submission for a user on a given mission.
     */
    public Submission getSubmission(int userId, int missionId) {
        String sql = "SELECT id, user_id, mission_id, answer, is_correct, completed_at FROM mission_submissions WHERE user_id = ? AND mission_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, missionId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Submission s = new Submission();
                s.setId(rs.getInt("id"));
                s.setUserId(rs.getInt("user_id"));
                s.setMissionId(rs.getInt("mission_id"));
                s.setAnswer(rs.getString("answer"));
                s.setCorrect(rs.getBoolean("is_correct"));
                s.setCompletedAt(rs.getTimestamp("completed_at"));
                return s;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
    }

    /**
     * Total number of submissions in the entire platform.
     */
    public int getTotalSubmissionsCount() {
        String sql = "SELECT COUNT(*) FROM mission_submissions";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
    }
}
