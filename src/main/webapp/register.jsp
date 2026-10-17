<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String usernameVal = (String) request.getAttribute("usernameVal");
    String emailVal = (String) request.getAttribute("emailVal");
    if (usernameVal == null) usernameVal = "";
    if (emailVal == null) emailVal = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content" style="max-width: 520px; padding-top: 3.5rem;">
        <div class="card" style="padding: 2.25rem;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <div style="display: inline-flex; width: 48px; height: 48px; border-radius: 12px; background: rgba(99, 102, 241, 0.15); border: 1px solid rgba(99, 102, 241, 0.3); align-items: center; justify-content: center; color: var(--brand-indigo-light); margin-bottom: 1rem;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                        <line x1="20" y1="8" x2="20" y2="14"></line>
                        <line x1="23" y1="11" x2="17" y2="11"></line>
                    </svg>
                </div>
                <h1 style="font-size: 1.65rem; font-weight: 800; letter-spacing: -0.02em;">Create Student Account</h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.35rem;">
                    Begin your quest at <strong>Level 1 (0 XP)</strong> and rise on the leaderboard.
                </p>
            </div>

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

            <!-- Module 2: Registration Form -->
            <form action="<%= request.getContextPath() %>/register" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Student Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="e.g. byte_coder" required minlength="3" maxlength="30"
                           value="<%= usernameVal %>" autocomplete="username">
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="student@example.edu" required 
                           value="<%= emailVal %>" autocomplete="email">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Minimum 6 characters" required minlength="6"
                           autocomplete="new-password">
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           placeholder="Re-enter password" required minlength="6"
                           autocomplete="new-password">
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 1rem;">
                    <span>Complete Registration</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border-subtle); font-size: 0.88rem; color: var(--text-secondary);">
                Already have an account? 
                <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--brand-indigo-light); font-weight: 600;">Sign in here</a>
            </div>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
