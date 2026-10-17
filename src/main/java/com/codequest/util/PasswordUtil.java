package com.codequest.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility for hashing and verifying passwords securely.
 * Supports SHA-256 hashing with graceful fallback for pre-seeded demo credentials.
 */
public class PasswordUtil {

    /**
     * Hashes a raw password string using SHA-256.
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Verifies if raw password matches either the plain text or hashed value in DB.
     */
    public static boolean verifyPassword(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        // Direct equality match (e.g. initial seed records)
        if (storedPassword.equals(rawPassword)) {
            return true;
        }
        // SHA-256 hashed match
        String hashedInput = hashPassword(rawPassword);
        return storedPassword.equalsIgnoreCase(hashedInput);
    }
}
