package com.codequest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module 3: Student Logout Servlet.
 * Invalidates the active HTTP session and redirects to the login screen.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

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
            // Remove user specific attributes and invalidate session
            session.removeAttribute("userId");
            session.removeAttribute("username");
            session.removeAttribute("email");
            session.removeAttribute("user");
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp?loggedOut=true");
    }
}
