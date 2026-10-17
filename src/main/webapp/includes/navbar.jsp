<%@ page import="com.codequest.model.User" %>
<%
    String currentUri = request.getRequestURI();
    String cp = request.getContextPath();

    Integer navUserId = (Integer) session.getAttribute("userId");
    String navUsername = (String) session.getAttribute("username");
    User navUser = (User) session.getAttribute("user");

    Integer navAdminId = (Integer) session.getAttribute("adminId");
    String navAdminUsername = (String) session.getAttribute("adminUsername");
%>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= cp %>/index.html" class="brand">
            <div class="brand-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                    <polyline points="2 17 12 22 22 17"></polyline>
                    <polyline points="2 12 12 17 22 12"></polyline>
                </svg>
            </div>
            <span>Code<span class="brand-quest">Quest</span></span>
        </a>

        <ul class="nav-links">
            <li>
                <a href="<%= cp %>/index.html" class="nav-item <%= currentUri.endsWith("index.html") || currentUri.endsWith("/") ? "active" : "" %>">
                    Home
                </a>
            </li>
            <li>
                <a href="<%= cp %>/missions" class="nav-item <%= currentUri.contains("mission") ? "active" : "" %>">
                    Missions
                </a>
            </li>
            <li>
                <a href="<%= cp %>/leaderboard" class="nav-item <%= currentUri.contains("leaderboard") ? "active" : "" %>">
                    Leaderboard
                </a>
            </li>

            <% if (navAdminId != null) { %>
                <!-- Admin Navigation Links -->
                <li>
                    <a href="<%= cp %>/admin-dashboard" class="nav-item <%= currentUri.contains("admin-dashboard") ? "active" : "" %>">
                        Admin Dashboard
                    </a>
                </li>
                <li>
                    <a href="<%= cp %>/add-question" class="nav-item <%= currentUri.contains("add-question") ? "active" : "" %>">
                        Add Question
                    </a>
                </li>
                <li>
                    <a href="<%= cp %>/view-questions" class="nav-item <%= currentUri.contains("view-questions") ? "active" : "" %>">
                        Manage Questions
                    </a>
                </li>
                <li>
                    <a href="<%= cp %>/admin-database.jsp" class="nav-item <%= currentUri.contains("admin-database") ? "active" : "" %>" style="color: var(--xp-amber-light);">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                            <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                            <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                        </svg>
                        Database Inspector
                    </a>
                </li>
            <% } else if (navUserId != null) { %>
                <!-- Student Dashboard Link -->
                <li>
                    <a href="<%= cp %>/dashboard" class="nav-item <%= currentUri.contains("dashboard") ? "active" : "" %>">
                        My Dashboard
                    </a>
                </li>
            <% } %>
        </ul>

        <div class="nav-auth-group">
            <% if (navAdminId != null) { %>
                <div class="user-badge" style="border-color: rgba(99, 102, 241, 0.4);">
                    <div class="user-avatar" style="background: linear-gradient(135deg, #4f46e5, #9333ea);">A</div>
                    <span style="font-weight: 600;"><%= navAdminUsername != null ? navAdminUsername : "Administrator" %></span>
                </div>
                <a href="<%= cp %>/admin-logout" class="btn btn-outline btn-sm">Admin Logout</a>

            <% } else if (navUserId != null) { %>
                <div class="user-badge">
                    <div class="user-avatar"><%= navUsername != null && !navUsername.isEmpty() ? navUsername.substring(0, 1).toUpperCase() : "U" %></div>
                    <span style="font-weight: 600;"><%= navUsername %></span>
                    <% if (navUser != null) { %>
                        <span class="badge badge-xp"><%= navUser.getTotalXp() %> XP</span>
                    <% } %>
                </div>
                <a href="<%= cp %>/logout" class="btn btn-outline btn-sm">Logout</a>

            <% } else { %>
                <a href="<%= cp %>/login.jsp" class="btn btn-outline btn-sm">Student Login</a>
                <a href="<%= cp %>/register.jsp" class="btn btn-primary btn-sm">Register</a>
                <a href="<%= cp %>/admin-login.jsp" class="btn btn-secondary btn-sm" title="Admin Portal" style="padding: 0.4rem 0.6rem;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                </a>
            <% } %>
        </div>
    </div>
</nav>
