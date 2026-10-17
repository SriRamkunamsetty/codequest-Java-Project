package com.codequest.servlet;

import com.codequest.dao.MissionDAO;
import com.codequest.dao.SubmissionDAO;
import com.codequest.dao.UserDAO;
import com.codequest.model.Mission;
import com.codequest.model.Submission;
import com.codequest.model.User;
import com.codequest.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Module 10: Answer Evaluation and XP Rewards Servlet.
 * Evaluates student answers against MySQL records.
 * Uses strict JDBC Transactions (setAutoCommit(false), commit, rollback)
 * to atomically record submissions, award XP, and recalculate player levels.
 * Strictly enforces the one-attempt-per-mission rule.
 */
@WebServlet(name = "SubmitAnswerServlet", urlPatterns = {"/submit-answer"})
public class SubmitAnswerServlet extends HttpServlet {
    private MissionDAO missionDAO;
    private SubmissionDAO submissionDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
        submissionDAO = new SubmissionDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String missionIdStr = request.getParameter("missionId");
        String selectedAnswer = request.getParameter("selectedAnswer");

        if (missionIdStr == null || selectedAnswer == null || selectedAnswer.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/missions?error=missing_choice");
            return;
        }

        int missionId;
        try {
            missionId = Integer.parseInt(missionIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/missions?error=invalid_id");
            return;
        }

        selectedAnswer = selectedAnswer.trim();

        // 1. Enforce one-attempt-per-mission rule
        if (submissionDAO.hasAttempted(userId, missionId)) {
            response.sendRedirect(request.getContextPath() + "/missions?error=already_attempted");
            return;
        }

        // 2. Fetch the mission with correct answer from DB for server-side evaluation
        Mission mission = missionDAO.getMissionById(missionId);
        if (mission == null) {
            response.sendRedirect(request.getContextPath() + "/missions?error=not_found");
            return;
        }

        // 3. Fetch latest student state
        User user = userDAO.getUserById(userId);
        if (user == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 4. Evaluate correctness
        boolean isCorrect = mission.getCorrectAnswer() != null && 
                            mission.getCorrectAnswer().trim().equalsIgnoreCase(selectedAnswer);

        int xpAwarded = isCorrect ? mission.getXpReward() : 0;
        int oldXp = user.getTotalXp();
        int newXp = oldXp + xpAwarded;
        
        int oldLevel = user.getPlayerLevel();
        // Level Formula: Level = 1 + (totalXp / 100)
        int newLevel = 1 + (newXp / 100);
        boolean leveledUp = (newLevel > oldLevel);

        // 5. Execute JDBC Transaction: atomicity of submission record and student XP/Level update
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // A. Insert submission record
            Submission sub = new Submission();
            sub.setUserId(userId);
            sub.setMissionId(missionId);
            sub.setAnswer(selectedAnswer);
            sub.setCorrect(isCorrect);
            submissionDAO.recordSubmission(conn, sub);

            // B. If correct answer, update student total XP and Level
            if (isCorrect && xpAwarded > 0) {
                userDAO.updateXpAndLevel(conn, userId, xpAwarded, newLevel);
            }

            // Commit atomic transaction
            conn.commit();

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/missions?error=tx_failed");
            return;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }

        // 6. Store evaluation result in session to support Post-Redirect-Get pattern
        session.setAttribute("eval_missionTitle", mission.getTitle());
        session.setAttribute("eval_category", mission.getCategory());
        session.setAttribute("eval_difficulty", mission.getDifficulty());
        session.setAttribute("eval_selectedAnswer", selectedAnswer);
        session.setAttribute("eval_isCorrect", isCorrect);
        session.setAttribute("eval_xpAwarded", xpAwarded);
        session.setAttribute("eval_oldXp", oldXp);
        session.setAttribute("eval_newXp", newXp);
        session.setAttribute("eval_oldLevel", oldLevel);
        session.setAttribute("eval_newLevel", newLevel);
        session.setAttribute("eval_leveledUp", leveledUp);

        // Redirect to mission result presentation
        response.sendRedirect(request.getContextPath() + "/mission-result.jsp");
    }
}
