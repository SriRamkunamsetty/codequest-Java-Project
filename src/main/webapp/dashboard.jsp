<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.model.Submission" %>
<%@ page import="com.codequest.dao.UserDAO" %>
<%@ page import="com.codequest.dao.SubmissionDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }

    User student = (User) request.getAttribute("student");
    List<Submission> recentSubmissions = (List<Submission>) request.getAttribute("recentSubmissions");

    if (student == null) {
        UserDAO udao = new UserDAO();
        student = udao.getUserById(userId);
        SubmissionDAO sdao = new SubmissionDAO();
        recentSubmissions = sdao.getSubmissionsByUser(userId);
    }

    if (student == null) {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int currentXp = student.getTotalXp();
    int currentLevel = student.getPlayerLevel();
    int baseLevelXp = (currentLevel - 1) * 100;
    int nextLevelXp = currentLevel * 100;
    int progressXp = Math.max(0, currentXp - baseLevelXp);
    int progressPercent = Math.min(100, Math.max(0, (progressXp * 100) / 100));

    String motivationalTag = (String) request.getAttribute("motivationalTag");
    if (motivationalTag == null) {
        motivationalTag = "Solve programming missions and climb to the top rank!";
    }

    // Determine Gamer Rank Title based on player level
    String rankTitle = "Apprentice Coder";
    if (currentLevel >= 5) rankTitle = "Grandmaster Architect";
    else if (currentLevel >= 4) rankTitle = "Principal Developer";
    else if (currentLevel >= 3) rankTitle = "Senior Engineer";
    else if (currentLevel >= 2) rankTitle = "Journeyman Hacker";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= student.getUsername() %>'s Dashboard &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <!-- Player Overview Hero Card (Module 8) -->
        <div class="card" style="padding: 2.25rem; margin-bottom: 2rem; background: linear-gradient(180deg, var(--bg-surface-elevated) 0%, var(--bg-surface) 100%);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div style="width: 72px; height: 72px; border-radius: 20px; background: linear-gradient(135deg, var(--brand-indigo), #06b6d4); display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 800; color: #fff; box-shadow: 0 8px 24px var(--brand-indigo-glow);">
                        <%= student.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.6rem; margin-bottom: 0.25rem;">
                            <h1 style="font-size: 1.85rem; font-weight: 800; letter-spacing: -0.02em;">
                                <%= student.getUsername() %>
                            </h1>
                            <span class="badge" style="background: rgba(99, 102, 241, 0.2); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.4);">
                                <%= rankTitle %>
                            </span>
                        </div>
                        <p style="color: var(--text-secondary); font-size: 0.9rem;">
                            <%= student.getEmail() %> &bull; <%= motivationalTag %>
                        </p>
                    </div>
                </div>

                <div style="display: flex; gap: 0.75rem;">
                    <a href="<%= request.getContextPath() %>/missions" class="btn btn-primary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="5 3 19 12 5 21 5 3"></polygon>
                        </svg>
                        <span>Start Next Mission</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/leaderboard" class="btn btn-secondary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="8" r="7"></circle>
                            <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                        </svg>
                        <span>Leaderboard</span>
                    </a>
                </div>
            </div>

            <!-- XP Progress toward Next Level (Module 8 Requirement) -->
            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border-subtle);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.4rem; font-size: 0.9rem;">
                    <div>
                        <strong style="color: var(--text-primary);">Level <%= currentLevel %> Progress:</strong>
                        <span style="color: var(--text-secondary); margin-left: 0.4rem;"><%= progressXp %> / 100 XP to Level <%= currentLevel + 1 %></span>
                    </div>
                    <div style="font-weight: 700; color: var(--xp-amber-light); font-family: var(--font-mono);">
                        <%= progressPercent %>% Complete
                    </div>
                </div>

                <div class="progress-bar-container" style="height: 14px;">
                    <div class="progress-bar-fill gold" style="width: <%= progressPercent %>%;"></div>
                </div>

                <div style="display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono); margin-top: 0.35rem;">
                    <span>Level <%= currentLevel %> Base (<%= baseLevelXp %> XP)</span>
                    <span>Level <%= currentLevel + 1 %> Threshold (<%= nextLevelXp %> XP)</span>
                </div>
            </div>
        </div>

        <!-- Four Statistics Grid (Module 8 Requirement) -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="color: var(--xp-amber-light);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value"><%= currentXp %></div>
                    <div class="stat-label">Total Experience Points</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: var(--brand-indigo-light);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                        <path d="M2 17l10 5 10-5"></path>
                        <path d="M2 12l10 5 10-5"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value">Level <%= currentLevel %></div>
                    <div class="stat-label">Current Player Level</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: var(--success-jade);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value"><%= student.getCompletedMissionsCount() %></div>
                    <div class="stat-label">Missions Solved Correctly</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: #38bdf8;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                        <polyline points="17 6 23 6 23 12"></polyline>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value">
                        <%= (recentSubmissions != null && !recentSubmissions.isEmpty()) ? recentSubmissions.size() : 0 %>
                    </div>
                    <div class="stat-label">Total Missions Attempted</div>
                </div>
            </div>
        </div>

        <!-- Recent Submissions History (Module 8 & 10 Integration) -->
        <div class="card" style="margin-top: 2rem;">
            <div class="card-header">
                <h2 class="card-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                    <span>Your Mission Submissions History</span>
                </h2>
                <a href="<%= request.getContextPath() %>/missions" class="btn btn-outline btn-sm">Find More Missions &rarr;</a>
            </div>

            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mission Title</th>
                            <th style="width: 120px;">Category</th>
                            <th style="width: 120px;">Difficulty</th>
                            <th>Your Submitted Answer</th>
                            <th style="width: 130px;">Result Status</th>
                            <th style="width: 110px;">XP Earned</th>
                            <th style="width: 160px;">Date &amp; Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (recentSubmissions == null || recentSubmissions.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                    <div>You haven't completed any programming missions yet.</div>
                                    <div style="margin-top: 0.75rem;">
                                        <a href="<%= request.getContextPath() %>/missions" class="btn btn-primary btn-sm">Browse Available Missions</a>
                                    </div>
                                </td>
                            </tr>
                        <%
                            } else {
                                for (Submission sub : recentSubmissions) {
                                    String catClass = "badge-java";
                                    if ("SQL".equalsIgnoreCase(sub.getMissionCategory())) catClass = "badge-sql";
                                    else if ("DSA".equalsIgnoreCase(sub.getMissionCategory())) catClass = "badge-dsa";

                                    String diffClass = "badge-medium";
                                    if ("Easy".equalsIgnoreCase(sub.getMissionDifficulty())) diffClass = "badge-easy";
                                    else if ("Hard".equalsIgnoreCase(sub.getMissionDifficulty())) diffClass = "badge-hard";
                        %>
                            <tr>
                                <td>
                                    <strong style="color: var(--text-primary);"><%= sub.getMissionTitle() %></strong>
                                </td>
                                <td><span class="badge <%= catClass %>"><%= sub.getMissionCategory() %></span></td>
                                <td><span class="badge <%= diffClass %>"><%= sub.getMissionDifficulty() %></span></td>
                                <td>
                                    <span style="font-family: var(--font-mono); font-size: 0.85rem; color: var(--text-secondary);">
                                        <%= sub.getAnswer() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (sub.isCorrect()) { %>
                                        <span class="badge badge-easy">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                            Correct
                                        </span>
                                    <% } else { %>
                                        <span class="badge badge-hard">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                            Incorrect
                                        </span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (sub.isCorrect()) { %>
                                        <span class="badge badge-xp">+<%= sub.getXpEarned() %> XP</span>
                                    <% } else { %>
                                        <span style="color: var(--text-muted); font-size: 0.85rem; font-family: var(--font-mono);">0 XP</span>
                                    <% } %>
                                </td>
                                <td style="font-size: 0.8rem; color: var(--text-muted); font-family: var(--font-mono);">
                                    <%= sub.getCompletedAt() != null ? sub.getCompletedAt().toString().substring(0, 16) : "N/A" %>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
