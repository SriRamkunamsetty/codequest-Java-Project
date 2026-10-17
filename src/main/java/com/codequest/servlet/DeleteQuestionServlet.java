package com.codequest.servlet;

import com.codequest.dao.MissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller for deleting an existing question by Admin.
 */
@WebServlet(name = "DeleteQuestionServlet", urlPatterns = {"/delete-question"})
public class DeleteQuestionServlet extends HttpServlet {
    private MissionDAO missionDAO;

    @Override
    public void init() throws ServletException {
        missionDAO = new MissionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int missionId = Integer.parseInt(idStr);
                missionDAO.deleteMission(missionId);
            } catch (NumberFormatException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/view-questions?msg=deleted");
    }
}
