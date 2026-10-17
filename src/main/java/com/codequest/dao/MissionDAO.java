package com.codequest.dao;

import com.codequest.model.Mission;
import com.codequest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for programming missions (questions).
 */
public class MissionDAO {

    /**
     * Adds a new mission into the missions table.
     */
    public boolean addMission(Mission mission) {
        String sql = "INSERT INTO missions (title, description, category, difficulty, " +
                     "option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, mission.getTitle());
            ps.setString(2, mission.getDescription());
            ps.setString(3, mission.getCategory());
            ps.setString(4, mission.getDifficulty());
            ps.setString(5, mission.getOptionA());
            ps.setString(6, mission.getOptionB());
            ps.setString(7, mission.getOptionC());
            ps.setString(8, mission.getOptionD());
            ps.setString(9, mission.getCorrectAnswer());
            ps.setInt(10, mission.getXpReward());
            if (mission.getCreatedBy() != null) {
                ps.setInt(11, mission.getCreatedBy());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    mission.setId(rs.getInt(1));
                }
                DBConnection.closeQuietly(rs);
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeQuietly(ps, conn);
        }
    }

    /**
     * Retrieves all missions (with answers included) for Admin management.
     */
    public List<Mission> getAllMissions() {
        List<Mission> list = new ArrayList<>();
        String sql = "SELECT id, title, description, category, difficulty, " +
                     "option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by " +
                     "FROM missions ORDER BY id ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Mission m = mapResultSetToMission(rs, true);
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves missions for a student view, sanitized (correct_answer is NULL),
     * and annotated with student's attempt status.
     */
    public List<Mission> getMissionsForStudent(int userId, String categoryFilter, String difficultyFilter) {
        List<Mission> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.id, m.title, m.description, m.category, m.difficulty, " +
            "m.option_a, m.option_b, m.option_c, m.option_d, m.xp_reward, " +
            "s.id AS submission_id, s.answer AS student_answer, s.is_correct " +
            "FROM missions m " +
            "LEFT JOIN mission_submissions s ON m.id = s.mission_id AND s.user_id = ? " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            sql.append("AND m.category = ? ");
            params.add(categoryFilter.trim());
        }

        if (difficultyFilter != null && !difficultyFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(difficultyFilter)) {
            sql.append("AND m.difficulty = ? ");
            params.add(difficultyFilter.trim());
        }

        sql.append("ORDER BY m.id ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Mission m = new Mission();
                m.setId(rs.getInt("id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setCategory(rs.getString("category"));
                m.setDifficulty(rs.getString("difficulty"));
                m.setOptionA(rs.getString("option_a"));
                m.setOptionB(rs.getString("option_b"));
                m.setOptionC(rs.getString("option_c"));
                m.setOptionD(rs.getString("option_d"));
                m.setXpReward(rs.getInt("xp_reward"));
                m.setCorrectAnswer(null); // CRITICAL: Strict requirement - never send correct answer to student

                int subId = rs.getInt("submission_id");
                if (!rs.wasNull() && subId > 0) {
                    m.setAttempted(true);
                    m.setSolved(rs.getBoolean("is_correct"));
                    m.setStudentAnswer(rs.getString("student_answer"));
                } else {
                    m.setAttempted(false);
                    m.setSolved(false);
                }
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves a single mission by ID with complete details (including correct answer).
     * Used by Answer evaluation Servlet and Admin.
     */
    public Mission getMissionById(int id) {
        String sql = "SELECT id, title, description, category, difficulty, " +
                     "option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by " +
                     "FROM missions WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToMission(rs, true);
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
     * Deletes a mission by ID.
     */
    public boolean deleteMission(int id) {
        String sql = "DELETE FROM missions WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeQuietly(ps, conn);
        }
    }

    /**
     * Total missions count.
     */
    public int getTotalMissionsCount() {
        String sql = "SELECT COUNT(*) FROM missions";
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

    /**
     * Total missions count by category.
     */
    public int getMissionsCountByCategory(String category) {
        String sql = "SELECT COUNT(*) FROM missions WHERE category = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, category);
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

    private Mission mapResultSetToMission(ResultSet rs, boolean includeAnswer) throws SQLException {
        Mission m = new Mission();
        m.setId(rs.getInt("id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        m.setCategory(rs.getString("category"));
        m.setDifficulty(rs.getString("difficulty"));
        m.setOptionA(rs.getString("option_a"));
        m.setOptionB(rs.getString("option_b"));
        m.setOptionC(rs.getString("option_c"));
        m.setOptionD(rs.getString("option_d"));
        m.setXpReward(rs.getInt("xp_reward"));
        m.setCreatedBy((Integer) rs.getObject("created_by"));
        if (includeAnswer) {
            m.setCorrectAnswer(rs.getString("correct_answer"));
        } else {
            m.setCorrectAnswer(null);
        }
        return m;
    }
}
