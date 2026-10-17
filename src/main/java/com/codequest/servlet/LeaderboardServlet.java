package com.codequest.servlet;

import com.codequest.dao.UserDAO;
import com.codequest.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Module 11: Global Leaderboard Servlet.
 * Retrieves all registered students ordered by total XP descending,
 * computes ranks and completed mission statistics, and forwards to leaderboard.jsp.
 */
@WebServlet(name = "LeaderboardServlet", urlPatterns = {"/leaderboard"})
public class LeaderboardServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve fresh ranked list of all players
        List<User> leaderboard = userDAO.getLeaderboard();
        request.setAttribute("leaderboardList", leaderboard);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/leaderboard.jsp");
        dispatcher.forward(request, response);
    }
}
