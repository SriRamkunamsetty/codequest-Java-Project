package com.codequest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module 4: Admin Logout Servlet.
 * Terminates the administrator session and redirects to the admin login page.
 */
@WebServlet(name = "AdminLogoutServlet", urlPatterns = {"/admin-logout"})
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("adminId");
            session.removeAttribute("adminUsername");
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?loggedOut=true");
    }
}
