package com.codequest.servlet;

import com.codequest.dao.MissionDAO;
import com.codequest.dao.SubmissionDAO;
import com.codequest.dao.UserDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module 4: Admin Dashboard Controller.
 * Ensures strict admin role-based authorization and aggregates system metrics.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private MissionDAO missionDAO;
    private UserDAO userDAO;
    private SubmissionDAO submissionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
        userDAO = new UserDAO();
        submissionDAO = new SubmissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }

        // Fetch aggregate metrics for admin command center
        int totalStudents = userDAO.getTotalStudentsCount();
        int totalMissions = missionDAO.getTotalMissionsCount();
        int totalSubmissions = submissionDAO.getTotalSubmissionsCount();

        int javaMissions = missionDAO.getMissionsCountByCategory("Java");
        int sqlMissions = missionDAO.getMissionsCountByCategory("SQL");
        int dsaMissions = missionDAO.getMissionsCountByCategory("DSA");

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalMissions", totalMissions);
        request.setAttribute("totalSubmissions", totalSubmissions);
        request.setAttribute("javaMissions", javaMissions);
        request.setAttribute("sqlMissions", sqlMissions);
        request.setAttribute("dsaMissions", dsaMissions);

        // Demonstrate ServletContext values
        ServletContext context = getServletContext();
        request.setAttribute("serverInfo", context.getServerInfo());
        request.setAttribute("adminLoginCount", context.getAttribute("adminLoginCounter"));
        request.setAttribute("lastLoginTime", context.getAttribute("lastAdminLoginTime"));

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
