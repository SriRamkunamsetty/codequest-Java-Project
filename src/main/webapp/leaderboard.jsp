<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.dao.UserDAO" %>
<%
    List<User> leaderboard = (List<User>) request.getAttribute("leaderboardList");
    if (leaderboard == null) {
        UserDAO udao = new UserDAO();
        leaderboard = udao.getLeaderboard();
    }

    Integer currentUserId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Leaderboard &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <!-- Header -->
        <div style="text-align: center; margin-bottom: 2.5rem;">
            <div class="hero-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="8" r="7"></circle>
                    <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                </svg>
                <span>Live MySQL Ranking Engine</span>
            </div>
            <h1 style="font-size: 2.5rem; font-weight: 800; letter-spacing: -0.02em;">Global Leaderboard</h1>
            <p style="color: var(--text-secondary); font-size: 1rem; max-width: 580px; margin: 0.5rem auto 0 auto;">
                Compete with developers across all tracks. Ranks update dynamically with every solved mission.
            </p>
        </div>

        <%
            if (leaderboard == null || leaderboard.isEmpty()) {
        %>
            <!-- Empty State (Module 11 Requirement) -->
            <div class="card" style="text-align: center; padding: 4.5rem 2rem; max-width: 540px; margin: 0 auto;">
                <div style="display: inline-flex; width: 64px; height: 64px; border-radius: 50%; background: var(--bg-surface-elevated); border: 1px solid var(--border-medium); align-items: center; justify-content: center; color: var(--text-muted); margin-bottom: 1.25rem;">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="8" y1="12" x2="16" y2="12"></line>
                    </svg>
                </div>
                <h2 style="font-size: 1.4rem; font-weight: 700; margin-bottom: 0.5rem;">No players registered yet!</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;">
                    Be the very first developer to register an account, complete a mission, and take the #1 crown.
                </p>
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary">Join CodeQuest Now</a>
            </div>
        <%
            } else {
                // Top 3 Podium Display (Module 11 Special Indicators)
                User rank1 = (leaderboard.size() >= 1) ? leaderboard.get(0) : null;
                User rank2 = (leaderboard.size() >= 2) ? leaderboard.get(1) : null;
                User rank3 = (leaderboard.size() >= 3) ? leaderboard.get(2) : null;
        %>
            <% if (rank1 != null) { %>
                <div class="podium-container">
                    <!-- Rank 2 Podium (Silver) -->
                    <div>
                        <% if (rank2 != null) { %>
                            <div class="podium-card podium-2">
                                <div class="podium-rank-badge">2</div>
                                <div style="width: 52px; height: 52px; border-radius: 14px; background: linear-gradient(135deg, #64748b, #94a3b8); margin: 0 auto 0.75rem auto; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; font-weight: 800; color: #fff;">
                                    <%= rank2.getUsername().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="podium-username"><%= rank2.getUsername() %></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 0.5rem;">
                                    Level <%= rank2.getPlayerLevel() %> &bull; <%= rank2.getCompletedMissionsCount() %> Solved
                                </div>
                                <div class="podium-xp"><%= rank2.getTotalXp() %> XP</div>
                            </div>
                        <% } %>
                    </div>

                    <!-- Rank 1 Podium (Gold - Elevated) -->
                    <div>
                        <div class="podium-card podium-1">
                            <div class="podium-rank-badge">👑 1</div>
                            <div style="width: 64px; height: 64px; border-radius: 18px; background: linear-gradient(135deg, #f59e0b, #d97706); margin: 0 auto 0.75rem auto; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; font-weight: 800; color: #fff; box-shadow: 0 4px 18px rgba(245, 158, 11, 0.4);">
                                <%= rank1.getUsername().substring(0, 1).toUpperCase() %>
                            </div>
                            <div class="podium-username" style="font-size: 1.3rem;"><%= rank1.getUsername() %></div>
                            <div style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 0.6rem;">
                                Level <%= rank1.getPlayerLevel() %> Grandmaster &bull; <%= rank1.getCompletedMissionsCount() %> Solved
                            </div>
                            <div class="podium-xp" style="font-size: 1.6rem;"><%= rank1.getTotalXp() %> XP</div>
                        </div>
                    </div>

                    <!-- Rank 3 Podium (Bronze) -->
                    <div>
                        <% if (rank3 != null) { %>
                            <div class="podium-card podium-3">
                                <div class="podium-rank-badge">3</div>
                                <div style="width: 52px; height: 52px; border-radius: 14px; background: linear-gradient(135deg, #92400e, #d97706); margin: 0 auto 0.75rem auto; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; font-weight: 800; color: #fff;">
                                    <%= rank3.getUsername().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="podium-username"><%= rank3.getUsername() %></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 0.5rem;">
                                    Level <%= rank3.getPlayerLevel() %> &bull; <%= rank3.getCompletedMissionsCount() %> Solved
                                </div>
                                <div class="podium-xp"><%= rank3.getTotalXp() %> XP</div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <!-- Complete Standings Table (Module 11) -->
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 90px; text-align: center;">Rank</th>
                            <th>Student Developer</th>
                            <th style="width: 140px;">Current Level</th>
                            <th style="width: 180px;">Completed Missions</th>
                            <th style="width: 160px; text-align: right;">Total Experience</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (User player : leaderboard) {
                                boolean isSelf = (currentUserId != null && currentUserId == player.getId());
                                int rankNum = player.getRank();
                        %>
                            <tr class="<%= isSelf ? "highlight-current-user" : "" %>">
                                <td style="text-align: center;">
                                    <% if (rankNum == 1) { %>
                                        <span class="badge" style="background: var(--xp-amber-bg); color: var(--xp-amber-light); border: 1px solid rgba(245, 158, 11, 0.4); font-weight: 800;">
                                            🥇 #1
                                        </span>
                                    <% } else if (rankNum == 2) { %>
                                        <span class="badge" style="background: rgba(148, 163, 184, 0.15); color: #cbd5e1; border: 1px solid rgba(148, 163, 184, 0.4); font-weight: 800;">
                                            🥈 #2
                                        </span>
                                    <% } else if (rankNum == 3) { %>
                                        <span class="badge" style="background: rgba(180, 83, 9, 0.15); color: #fb923c; border: 1px solid rgba(180, 83, 9, 0.4); font-weight: 800;">
                                            🥉 #3
                                        </span>
                                    <% } else { %>
                                        <span style="font-family: var(--font-mono); color: var(--text-muted); font-weight: 600;">
                                            #<%= rankNum %>
                                        </span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                        <div class="user-avatar" style="width: 32px; height: 32px; font-size: 0.85rem;">
                                            <%= player.getUsername().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div>
                                            <span style="font-weight: 700; color: var(--text-primary);"><%= player.getUsername() %></span>
                                            <% if (isSelf) { %>
                                                <span class="badge badge-easy" style="margin-left: 0.4rem; padding: 0.15rem 0.45rem; font-size: 0.7rem;">YOU</span>
                                            <% } %>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge" style="background: rgba(99, 102, 241, 0.12); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">
                                        Level <%= player.getPlayerLevel() %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: var(--text-secondary);">
                                        <%= player.getCompletedMissionsCount() %> missions solved
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <span style="font-family: var(--font-mono); font-size: 1.05rem; font-weight: 800; color: var(--xp-amber-light);">
                                        <%= player.getTotalXp() %> XP
                                    </span>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        <%
            }
        %>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
