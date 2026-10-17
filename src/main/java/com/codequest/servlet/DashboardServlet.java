package com.codequest.servlet;

import com.codequest.dao.SubmissionDAO;
import com.codequest.dao.UserDAO;
import com.codequest.model.Submission;
import com.codequest.model.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Module 8: Student Dashboard Servlet.
 * Fetches personalized student progress, XP, Level, completion statistics,
 * and recent submissions history using the student's session ID.
 */
@WebServlet(
    name = "DashboardServlet",
    urlPatterns = {"/dashboard"},
    initParams = {
        @WebInitParam(name = "motivationalTag", value = "Code your way to the top of the leaderboard!"),
        @WebInitParam(name = "xpStepPerLevel", value = "100")
    }
)
public class DashboardServlet extends HttpServlet {
    private UserDAO userDAO;
    private SubmissionDAO submissionDAO;
    private String motivationalTag;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        userDAO = new UserDAO();
        submissionDAO = new SubmissionDAO();
        motivationalTag = config.getInitParameter("motivationalTag");
        if (motivationalTag == null) {
            motivationalTag = "Master algorithms, level up your developer rank!";
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Fetch fresh student profile and statistics from DB
        User user = userDAO.getUserById(userId);
        if (user == null) {
            // User was removed or invalid session
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Update session user snapshot
        session.setAttribute("user", user);
        session.setAttribute("username", user.getUsername());

        // Fetch recent submission history
        List<Submission> recentSubmissions = submissionDAO.getSubmissionsByUser(userId);

        // Progress calculations:
        int currentXp = user.getTotalXp();
        int currentLevel = user.getPlayerLevel();
        int baseLevelXp = (currentLevel - 1) * 100;
        int nextLevelXp = currentLevel * 100;
        int progressXp = Math.max(0, currentXp - baseLevelXp);
        int progressPercent = Math.min(100, Math.max(0, (progressXp * 100) / 100));

        request.setAttribute("student", user);
        request.setAttribute("recentSubmissions", recentSubmissions);
        request.setAttribute("currentXp", currentXp);
        request.setAttribute("currentLevel", currentLevel);
        request.setAttribute("baseLevelXp", baseLevelXp);
        request.setAttribute("nextLevelXp", nextLevelXp);
        request.setAttribute("progressXp", progressXp);
        request.setAttribute("progressPercent", progressPercent);
        request.setAttribute("motivationalTag", motivationalTag);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
