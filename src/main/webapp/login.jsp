<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String usernameVal = (String) request.getAttribute("usernameVal");
    String savedUsername = (String) request.getAttribute("savedUsername");

    if (savedUsername == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("cq_saved_user".equals(c.getName())) {
                    savedUsername = c.getValue();
                    break;
                }
            }
        }
    }

    if (usernameVal == null) {
        usernameVal = (savedUsername != null) ? savedUsername : "";
    }

    String registered = request.getParameter("registered");
    String loggedOut = request.getParameter("loggedOut");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content" style="max-width: 480px; padding-top: 3.5rem;">
        <div class="card" style="padding: 2.25rem;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <div style="display: inline-flex; width: 48px; height: 48px; border-radius: 12px; background: rgba(99, 102, 241, 0.15); border: 1px solid rgba(99, 102, 241, 0.3); align-items: center; justify-content: center; color: var(--brand-indigo-light); margin-bottom: 1rem;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                        <polyline points="10 17 15 12 10 7"></polyline>
                        <line x1="15" y1="12" x2="3" y2="12"></line>
                    </svg>
                </div>
                <h1 style="font-size: 1.65rem; font-weight: 800; letter-spacing: -0.02em;">Student Login</h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.35rem;">
                    Sign in to resume missions and track your XP.
                </p>
            </div>

            <!-- Contextual Status Banners -->
            <% if ("true".equals(registered)) { %>
                <div class="alert alert-success">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>Account created! You can now log in with your credentials.</span>
                </div>
            <% } %>

            <% if ("true".equals(loggedOut)) { %>
                <div class="alert alert-info">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="16" x2="12" y2="12"></line>
                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                    </svg>
                    <span>You have been safely logged out. See you next quest!</span>
                </div>
            <% } %>

            <% if ("login_required".equals(error) || "unauthorized".equals(error)) { %>
                <div class="alert alert-danger">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Please log in to access your missions and dashboard.</span>
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

            <!-- Module 3: Student Login Form -->
            <form action="<%= request.getContextPath() %>/login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="usernameOrEmail">Username or Email</label>
                    <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="form-control" 
                           placeholder="username or email@domain.com" required 
                           value="<%= usernameVal %>" autocomplete="username">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required 
                           autocomplete="current-password">
                </div>

                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.25rem; font-size: 0.85rem;">
                    <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; color: var(--text-secondary);">
                        <input type="checkbox" name="rememberMe" value="on" <%= (savedUsername != null && !savedUsername.isEmpty()) ? "checked" : "" %>>
                        <span>Remember username (Cookie)</span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                    <span>Sign In to CodeQuest</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </button>
            </form>

            <!-- Quick Demo Credentials Assistant -->
            <div style="margin-top: 1.5rem; padding: 1rem; background: var(--bg-surface-elevated); border: 1px dashed var(--border-medium); border-radius: var(--radius-sm); font-size: 0.8rem;">
                <div style="font-weight: 700; color: var(--text-secondary); margin-bottom: 0.25rem;">Pre-seeded Student Demo:</div>
                <div style="color: var(--text-muted); font-family: var(--font-mono);">
                    Username: <span style="color: var(--brand-indigo-light);">alex_coder</span> &bull; Password: <span style="color: var(--brand-indigo-light);">password123</span>
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid var(--border-subtle); font-size: 0.88rem; color: var(--text-secondary);">
                Don't have an account? 
                <a href="<%= request.getContextPath() %>/register.jsp" style="color: var(--brand-indigo-light); font-weight: 600;">Register here</a>
            </div>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
