package com.codequest.dao;

import com.codequest.model.User;
import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for student users.
 * Uses PreparedStatements for all database operations to prevent SQL injection.
 */
public class UserDAO {

    /**
     * Checks if a username is already registered.
     */
    public boolean isUsernameTaken(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
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
     * Checks if an email is already registered.
     */
    public boolean isEmailTaken(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
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
     * Registers a new student user in the database.
     * Default starting values: total_xp = 0, player_level = 1.
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (username, email, password, total_xp, player_level) VALUES (?, ?, ?, 0, 1)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                    user.setTotalXp(0);
                    user.setPlayerLevel(1);
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
     * Authenticates a student using either username or email and password.
     */
    public User authenticate(String usernameOrEmail, String password) {
        String sql = "SELECT id, username, email, password, total_xp, player_level, created_at FROM users WHERE username = ? OR email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setTotalXp(rs.getInt("total_xp"));
                    user.setPlayerLevel(rs.getInt("player_level"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    return user;
                }
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
     * Retrieves fresh student record by user ID.
     */
    public User getUserById(int userId) {
        String sql = "SELECT u.id, u.username, u.email, u.total_xp, u.player_level, u.created_at, " +
                     " (SELECT COUNT(*) FROM mission_submissions s WHERE s.user_id = u.id AND s.is_correct = TRUE) AS completed_count " +
                     " FROM users u WHERE u.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setTotalXp(rs.getInt("total_xp"));
                user.setPlayerLevel(rs.getInt("player_level"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setCompletedMissionsCount(rs.getInt("completed_count"));
                return user;
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
     * Updates XP and Level within an active transaction.
     */
    public boolean updateXpAndLevel(Connection conn, int userId, int addedXp, int newLevel) throws SQLException {
        String sql = "UPDATE users SET total_xp = total_xp + ?, player_level = ? WHERE id = ?";
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, addedXp);
            ps.setInt(2, newLevel);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeQuietly(ps);
        }
    }

    /**
     * Retrieves leaderboard list sorted by total_xp DESC.
     */
    public List<User> getLeaderboard() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.email, u.total_xp, u.player_level, u.created_at, " +
                     " (SELECT COUNT(*) FROM mission_submissions s WHERE s.user_id = u.id AND s.is_correct = TRUE) AS completed_count " +
                     " FROM users u ORDER BY u.total_xp DESC, completed_count DESC, u.created_at ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            int rank = 1;
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setTotalXp(rs.getInt("total_xp"));
                u.setPlayerLevel(rs.getInt("player_level"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setCompletedMissionsCount(rs.getInt("completed_count"));
                u.setRank(rank++);
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, ps, conn);
        }
        return list;
    }

    /**
     * Total count of registered students.
     */
    public int getTotalStudentsCount() {
        String sql = "SELECT COUNT(*) FROM users";
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
