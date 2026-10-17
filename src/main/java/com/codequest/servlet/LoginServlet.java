package com.codequest.servlet;

import com.codequest.dao.UserDAO;
import com.codequest.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module 3: Student Login Servlet.
 * Authenticates students via username or email, sets up HTTP session, and handles remember-me cookies.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            // Already logged in as student, redirect directly to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Check for saved username in cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("cq_saved_user".equals(c.getName())) {
                    request.setAttribute("savedUsername", c.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        usernameOrEmail = (usernameOrEmail != null) ? usernameOrEmail.trim() : "";
        password = (password != null) ? password.trim() : "";

        if (usernameOrEmail.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Both username/email and password are required.");
            request.setAttribute("usernameVal", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(usernameOrEmail, password);

        if (user != null) {
            // Create fresh HTTP session
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("user", user);

            // Handle Remember Me cookie demonstration
            if ("on".equalsIgnoreCase(rememberMe) || "true".equalsIgnoreCase(rememberMe)) {
                Cookie cookie = new Cookie("cq_saved_user", user.getUsername());
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                response.addCookie(cookie);
            } else {
                // Clear saved cookie if unchecked
                Cookie cookie = new Cookie("cq_saved_user", "");
                cookie.setMaxAge(0);
                cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                response.addCookie(cookie);
            }

            // Redirect to student dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid credentials. Please verify your username/email and password.");
            request.setAttribute("usernameVal", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
