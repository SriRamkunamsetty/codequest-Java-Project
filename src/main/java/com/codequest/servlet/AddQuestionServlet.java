package com.codequest.servlet;

import com.codequest.dao.MissionDAO;
import com.codequest.model.Mission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module 6: Admin Question Creation Servlet.
 * Allows authenticated administrators to dynamically add new programming missions.
 */
@WebServlet(name = "AddQuestionServlet", urlPatterns = {"/add-question"})
public class AddQuestionServlet extends HttpServlet {
    private MissionDAO missionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }

        request.getRequestDispatcher("/add-question.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("adminId");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOptionChoice = request.getParameter("correctOptionChoice"); // A, B, C, D
        String xpRewardStr = request.getParameter("xpReward");

        // Trim inputs
        title = (title != null) ? title.trim() : "";
        description = (description != null) ? description.trim() : "";
        category = (category != null) ? category.trim() : "Java";
        difficulty = (difficulty != null) ? difficulty.trim() : "Easy";
        optionA = (optionA != null) ? optionA.trim() : "";
        optionB = (optionB != null) ? optionB.trim() : "";
        optionC = (optionC != null) ? optionC.trim() : "";
        optionD = (optionD != null) ? optionD.trim() : "";
        correctOptionChoice = (correctOptionChoice != null) ? correctOptionChoice.trim() : "A";

        // Validate required fields
        if (title.isEmpty() || description.isEmpty() || optionA.isEmpty() || 
            optionB.isEmpty() || optionC.isEmpty() || optionD.isEmpty()) {
            request.setAttribute("errorMessage", "All fields including question title, description, and 4 choices are required.");
            retainFormData(request, title, description, category, difficulty, optionA, optionB, optionC, optionD, xpRewardStr);
            request.getRequestDispatcher("/add-question.jsp").forward(request, response);
            return;
        }

        // Parse XP reward
        int xpReward = 50;
        try {
            if (xpRewardStr != null && !xpRewardStr.trim().isEmpty()) {
                xpReward = Integer.parseInt(xpRewardStr.trim());
                if (xpReward <= 0) xpReward = 50;
            }
        } catch (NumberFormatException e) {
            xpReward = 50;
        }

        // Determine correct answer text based on radio choice
        String correctAnswer;
        if ("B".equalsIgnoreCase(correctOptionChoice)) {
            correctAnswer = optionB;
        } else if ("C".equalsIgnoreCase(correctOptionChoice)) {
            correctAnswer = optionC;
        } else if ("D".equalsIgnoreCase(correctOptionChoice)) {
            correctAnswer = optionD;
        } else {
            correctAnswer = optionA;
        }

        Mission mission = new Mission();
        mission.setTitle(title);
        mission.setDescription(description);
        mission.setCategory(category);
        mission.setDifficulty(difficulty);
        mission.setOptionA(optionA);
        mission.setOptionB(optionB);
        mission.setOptionC(optionC);
        mission.setOptionD(optionD);
        mission.setCorrectAnswer(correctAnswer);
        mission.setXpReward(xpReward);
        mission.setCreatedBy(adminId);

        boolean added = missionDAO.addMission(mission);

        if (added) {
            response.sendRedirect(request.getContextPath() + "/view-questions?msg=created");
        } else {
            request.setAttribute("errorMessage", "Database error: Failed to save the question. Please verify input data.");
            retainFormData(request, title, description, category, difficulty, optionA, optionB, optionC, optionD, xpRewardStr);
            request.getRequestDispatcher("/add-question.jsp").forward(request, response);
        }
    }

    private void retainFormData(HttpServletRequest request, String title, String description,
                                String category, String difficulty, String optionA, String optionB,
                                String optionC, String optionD, String xpRewardStr) {
        request.setAttribute("titleVal", title);
        request.setAttribute("descriptionVal", description);
        request.setAttribute("categoryVal", category);
        request.setAttribute("difficultyVal", difficulty);
        request.setAttribute("optionAVal", optionA);
        request.setAttribute("optionBVal", optionB);
        request.setAttribute("optionCVal", optionC);
        request.setAttribute("optionDVal", optionD);
        request.setAttribute("xpRewardVal", xpRewardStr);
    }
}
