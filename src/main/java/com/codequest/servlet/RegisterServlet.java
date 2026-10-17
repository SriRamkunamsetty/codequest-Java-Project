package com.codequest.servlet;

import com.codequest.dao.UserDAO;
import com.codequest.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Module 2: Student Registration Servlet.
 * Handles new student user registration with input validation and duplicate checks.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Trim inputs
        username = (username != null) ? username.trim() : "";
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password.trim() : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword.trim() : "";

        // Form validation
        if (username.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "All registration fields are required.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (username.length() < 3 || username.length() > 30) {
            request.setAttribute("errorMessage", "Username must be between 3 and 30 characters.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorMessage", "Please provide a valid email address.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please re-enter.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Uniqueness validation against DB
        if (userDAO.isUsernameTaken(username)) {
            request.setAttribute("errorMessage", "The username '" + username + "' is already taken.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailTaken(email)) {
            request.setAttribute("errorMessage", "An account with the email '" + email + "' already exists.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Persist new student with starting XP = 0 and Level = 1
        User newUser = new User(username, email, password);
        boolean registered = userDAO.register(newUser);

        if (registered) {
            // Redirect to login page with success notification
            response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
        } else {
            request.setAttribute("errorMessage", "An unexpected error occurred while saving your account. Please try again.");
            request.setAttribute("usernameVal", username);
            request.setAttribute("emailVal", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
