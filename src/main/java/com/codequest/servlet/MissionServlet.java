package com.codequest.servlet;

import com.codequest.dao.MissionDAO;
import com.codequest.model.Mission;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Module 9: Programming Missions Display Servlet.
 * Dynamically queries programming questions organized by category (Java, SQL, DSA)
 * and difficulty (Easy, Medium, Hard). Sanitizes data so correct answers are NEVER sent to students.
 */
@WebServlet(name = "MissionServlet", urlPatterns = {"/missions"})
public class MissionServlet extends HttpServlet {
    private MissionDAO missionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Filter parameters
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        if (category == null || category.trim().isEmpty()) {
            category = "ALL";
        }
        if (difficulty == null || difficulty.trim().isEmpty()) {
            difficulty = "ALL";
        }

        // Retrieve student-sanitized missions (correct answer is excluded/null)
        List<Mission> missions = missionDAO.getMissionsForStudent(userId, category, difficulty);

        request.setAttribute("missionsList", missions);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedDifficulty", difficulty);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/missions.jsp");
        dispatcher.forward(request, response);
    }
}
