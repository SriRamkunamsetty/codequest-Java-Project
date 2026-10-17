package com.codequest.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Date;

/**
 * Demonstrates ServletContextListener lifecycle management.
 * Initializes application context parameters, sets up database configuration,
 * and maintains global platform metrics.
 */
@WebListener
public class AppLifecycleListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        
        String dbUrl = context.getInitParameter("dbUrl");
        String dbUser = context.getInitParameter("dbUser");
        String dbPassword = context.getInitParameter("dbPassword");

        if (dbUrl != null || dbUser != null || dbPassword != null) {
            DBConnection.configure(dbUrl, dbUser, dbPassword);
        }

        // Global ServletContext application attributes
        context.setAttribute("appName", "CodeQuest - Programming Learning Game");
        context.setAttribute("appVersion", "1.0-RELEASE");
        context.setAttribute("startupTime", new Date().toString());
        context.setAttribute("adminLoginCounter", 0);
        context.setAttribute("lastAdminLoginTime", "No logins yet");

        System.out.println("[CodeQuest] Application initialized successfully on " + context.getServerInfo());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[CodeQuest] Application shutdown completed.");
    }
}
