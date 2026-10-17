package com.codequest.servlet;

import com.codequest.dao.AdminDAO;
import com.codequest.model.Admin;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

/**
 * Module 4: Admin Login Servlet.
 * Demonstrates the use of ServletConfig and ServletContext.
 * Handles separate administrator authentication and session creation.
 */
@WebServlet(
    name = "AdminLoginServlet", 
    urlPatterns = {"/admin-login"},
    initParams = {
        @WebInitParam(name = "adminPortalTitle", value = "CodeQuest HQ Command Center"),
        @WebInitParam(name = "securityTier", value = "Strict Role-Based Access")
    }
)
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private String adminPortalTitle;
    private String securityTier;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        adminDAO = new AdminDAO();
        
        // Demonstrating ServletConfig usage
        this.adminPortalTitle = config.getInitParameter("adminPortalTitle");
        this.securityTier = config.getInitParameter("securityTier");
        if (this.adminPortalTitle == null) {
            this.adminPortalTitle = "CodeQuest Admin Portal";
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }

        // Pass ServletConfig and ServletContext demonstration attributes to JSP
        request.setAttribute("configPortalTitle", this.adminPortalTitle);
        request.setAttribute("configSecurityTier", this.securityTier);
        
        ServletContext context = getServletContext();
        String appName = context.getInitParameter("appName");
        if (appName == null) {
            appName = (String) context.getAttribute("appName");
        }
        request.setAttribute("contextAppName", appName != null ? appName : "CodeQuest Learning Platform");

        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        username = (username != null) ? username.trim() : "";
        password = (password != null) ? password.trim() : "";

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Administrator username and password are required.");
            request.setAttribute("usernameVal", username);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.authenticate(username, password);

        if (admin != null) {
            // Create separate admin session
            HttpSession session = request.getSession(true);
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminUsername", admin.getUsername());

            // Demonstrating ServletContext updates
            ServletContext context = getServletContext();
            synchronized (context) {
                Integer loginCount = (Integer) context.getAttribute("adminLoginCounter");
                if (loginCount == null) {
                    loginCount = 1;
                } else {
                    loginCount++;
                }
                context.setAttribute("adminLoginCounter", loginCount);
                context.setAttribute("lastAdminLoginTime", new Date().toString());
            }

            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator credentials. Access restricted.");
            request.setAttribute("usernameVal", username);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        }
    }
}
