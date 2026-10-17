<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String usernameVal = (String) request.getAttribute("usernameVal");
    if (usernameVal == null) usernameVal = "";

    String configPortalTitle = (String) request.getAttribute("configPortalTitle");
    if (configPortalTitle == null) configPortalTitle = "CodeQuest Admin Portal";

    String configSecurityTier = (String) request.getAttribute("configSecurityTier");
    if (configSecurityTier == null) configSecurityTier = "Role-Based Administrative Guard";

    String contextAppName = (String) request.getAttribute("contextAppName");
    if (contextAppName == null) {
        contextAppName = (String) application.getAttribute("appName");
        if (contextAppName == null) contextAppName = "CodeQuest";
    }

    String loggedOut = request.getParameter("loggedOut");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Access &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content" style="max-width: 480px; padding-top: 3.5rem;">
        <div class="card" style="padding: 2.25rem; border-color: rgba(99, 102, 241, 0.3);">
            <div style="text-align: center; margin-bottom: 2rem;">
                <div style="display: inline-flex; width: 50px; height: 50px; border-radius: 12px; background: linear-gradient(135deg, rgba(79, 70, 229, 0.2), rgba(147, 51, 234, 0.2)); border: 1px solid rgba(99, 102, 241, 0.4); align-items: center; justify-content: center; color: var(--brand-indigo-light); margin-bottom: 1rem;">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                </div>
                <h1 style="font-size: 1.65rem; font-weight: 800; letter-spacing: -0.02em;"><%= configPortalTitle %></h1>
                <p style="color: var(--text-secondary); font-size: 0.85rem; margin-top: 0.35rem;">
                    Security Tier: <span style="color: var(--brand-indigo-light); font-weight: 600;"><%= configSecurityTier %></span>
                </p>
                <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.2rem;">
                    Context: <%= contextAppName %>
                </div>
            </div>

            <% if ("true".equals(loggedOut)) { %>
                <div class="alert alert-info">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="16" x2="12" y2="12"></line>
                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                    </svg>
                    <span>Administrator session ended securely.</span>
                </div>
            <% } %>

            <% if ("unauthorized".equals(error)) { %>
                <div class="alert alert-danger">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
                    </svg>
                    <span>Administrator authentication required to access this resource.</span>
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-danger">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Module 4: Separate Admin Login Form -->
            <form action="<%= request.getContextPath() %>/admin-login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Administrator Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="Enter admin ID" required 
                           value="<%= usernameVal %>" autocomplete="username">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Administrator Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter master password" required 
                           autocomplete="current-password">
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 0.5rem; background: linear-gradient(135deg, var(--brand-indigo), #3730a3);">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Authenticate as Administrator</span>
                </button>
            </form>

            <!-- Pre-seeded Admin Credentials Box -->
            <div style="margin-top: 1.5rem; padding: 1rem; background: var(--bg-surface-elevated); border: 1px dashed rgba(99, 102, 241, 0.4); border-radius: var(--radius-sm); font-size: 0.8rem;">
                <div style="font-weight: 700; color: var(--text-secondary); margin-bottom: 0.25rem;">Default Admin Credentials:</div>
                <div style="color: var(--text-muted); font-family: var(--font-mono);">
                    Username: <span style="color: var(--brand-indigo-light);">admin</span> &bull; Password: <span style="color: var(--brand-indigo-light);">admin123</span>
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid var(--border-subtle); font-size: 0.88rem; color: var(--text-secondary);">
                Looking for student sign in? 
                <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--brand-indigo-light); font-weight: 600;">Student Portal &rarr;</a>
            </div>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
