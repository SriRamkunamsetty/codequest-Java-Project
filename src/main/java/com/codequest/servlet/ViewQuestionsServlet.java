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
 * Module 7: Admin Question Management Servlet.
 * Retrieves all stored questions via JDBC and forwards to view-questions.jsp via RequestDispatcher.
 */
@WebServlet(name = "ViewQuestionsServlet", urlPatterns = {"/view-questions"})
public class ViewQuestionsServlet extends HttpServlet {
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

        // Retrieve all missions dynamically from MySQL
        List<Mission> missions = missionDAO.getAllMissions();
        request.setAttribute("missionsList", missions);

        // Forward to view-questions.jsp using RequestDispatcher
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view-questions.jsp");
        dispatcher.forward(request, response);
    }
}
