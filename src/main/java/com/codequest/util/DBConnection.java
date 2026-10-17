package com.codequest.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Reusable JDBC Connection manager for CodeQuest.
 * Provides unified connection creation, thread safety, and resource cleanup.
 */
public class DBConnection {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Default connection parameters
    private static String dbUrl = "jdbc:mysql://localhost:3306/codequest_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String dbUser = "root";
    private static String dbPassword = "moksha24491a44d6@";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Allows dynamic configuration override from ServletContext context-params in web.xml.
     */
    public static synchronized void configure(String url, String user, String password) {
        if (url != null && !url.trim().isEmpty()) {
            dbUrl = url.trim();
        }
        if (user != null && !user.trim().isEmpty()) {
            dbUser = user.trim();
        }
        if (password != null) {
            dbPassword = password.trim();
        }
    }

    /**
     * Obtains an active connection to the MySQL database.
     * If the configured password fails with 'root', it automatically attempts with empty password
     * to ensure seamless developer experience across various MySQL installations.
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (SQLException e) {
            // Fallback trial: If root/root fails with access denied (error 1045), try root/empty
            if (e.getErrorCode() == 1045 && "root".equals(dbPassword)) {
                try {
                    return DriverManager.getConnection(dbUrl, dbUser, "");
                } catch (SQLException ignored) {
                    // rethrow original exception below
                }
            }
            throw e;
        }
    }

    /**
     * Closes AutoCloseable resources safely without throwing exceptions.
     */
    public static void closeQuietly(AutoCloseable... resources) {
        if (resources != null) {
            for (AutoCloseable res : resources) {
                if (res != null) {
                    try {
                        res.close();
                    } catch (Exception ignored) {
                    }
                }
            }
        }
    }

    public static String getDbUrl() {
        return dbUrl;
    }

    public static String getDbUser() {
        return dbUser;
    }
}
