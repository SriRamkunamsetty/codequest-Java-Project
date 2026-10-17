<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Boolean isCorrect = (Boolean) session.getAttribute("eval_isCorrect");
    if (isCorrect == null) {
        response.sendRedirect(request.getContextPath() + "/missions");
        return;
    }

    String missionTitle = (String) session.getAttribute("eval_missionTitle");
    String category = (String) session.getAttribute("eval_category");
    String difficulty = (String) session.getAttribute("eval_difficulty");
    String selectedAnswer = (String) session.getAttribute("eval_selectedAnswer");
    Integer xpAwarded = (Integer) session.getAttribute("eval_xpAwarded");
    Integer oldXp = (Integer) session.getAttribute("eval_oldXp");
    Integer newXp = (Integer) session.getAttribute("eval_newXp");
    Integer oldLevel = (Integer) session.getAttribute("eval_oldLevel");
    Integer newLevel = (Integer) session.getAttribute("eval_newLevel");
    Boolean leveledUp = (Boolean) session.getAttribute("eval_leveledUp");

    if (xpAwarded == null) xpAwarded = 0;
    if (oldXp == null) oldXp = 0;
    if (newXp == null) newXp = oldXp;
    if (oldLevel == null) oldLevel = 1;
    if (newLevel == null) newLevel = oldLevel;
    if (leveledUp == null) leveledUp = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mission Evaluation &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        #confettiCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 999;
        }
    </style>
</head>
<body>

    <!-- Confetti canvas for victory celebration micro-animation -->
    <% if (isCorrect) { %>
        <canvas id="confettiCanvas"></canvas>
    <% } %>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content" style="max-width: 680px; padding-top: 3.5rem;">
        <div class="card animate-pop" style="padding: 2.75rem 2.25rem; text-align: center; border-color: <%= isCorrect ? "var(--success-jade-border)" : "var(--danger-rose-border)" %>;">
            
            <% if (isCorrect) { %>
                <!-- Victory Celebration Icon -->
                <div style="display: inline-flex; width: 72px; height: 72px; border-radius: 50%; background: var(--success-jade-bg); border: 2px solid var(--success-jade); align-items: center; justify-content: center; color: var(--success-jade); margin-bottom: 1.5rem; box-shadow: 0 0 24px rgba(16, 185, 129, 0.3);">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>

                <div class="badge badge-easy" style="margin-bottom: 0.75rem; font-size: 0.85rem;">
                    Mission Accomplished
                </div>

                <h1 style="font-size: 2.1rem; font-weight: 800; letter-spacing: -0.02em; margin-bottom: 0.5rem; color: #fff;">
                    Correct Answer!
                </h1>

                <p style="color: var(--text-secondary); font-size: 1rem; max-width: 480px; margin: 0 auto 1.75rem auto;">
                    Great job on <strong><%= missionTitle %></strong>. Your solution matches the expected evaluation output.
                </p>

                <!-- XP Reward Award Banner -->
                <div style="display: inline-flex; align-items: center; gap: 0.75rem; padding: 0.85rem 1.75rem; background: var(--xp-amber-bg); border: 1px solid rgba(245, 158, 11, 0.4); border-radius: var(--radius-full); margin-bottom: 2rem;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--xp-amber-light);">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                    <span style="font-size: 1.25rem; font-weight: 800; color: var(--xp-amber-light); font-family: var(--font-mono);">
                        +<%= xpAwarded %> XP Awarded
                    </span>
                </div>

                <!-- Level Up Special Card (if threshold crossed) -->
                <% if (leveledUp) { %>
                    <div style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(245, 158, 11, 0.15)); border: 1px solid var(--brand-indigo-light); border-radius: var(--radius-md); padding: 1.25rem; margin-bottom: 2rem;">
                        <div style="font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: var(--xp-amber-light); letter-spacing: 0.05em; margin-bottom: 0.25rem;">
                            🎉 Milestone Unlocked
                        </div>
                        <div style="font-size: 1.35rem; font-weight: 800; color: #fff;">
                            Level Up! You reached Level <%= newLevel %>
                        </div>
                        <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.25rem;">
                            Your skills are climbing higher on the CodeQuest leaderboards.
                        </p>
                    </div>
                <% } %>

            <% } else { %>
                <!-- Incorrect Result Card -->
                <div style="display: inline-flex; width: 72px; height: 72px; border-radius: 50%; background: var(--danger-rose-bg); border: 2px solid var(--danger-rose); align-items: center; justify-content: center; color: var(--danger-rose); margin-bottom: 1.5rem; box-shadow: 0 0 24px rgba(244, 63, 94, 0.25);">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </div>

                <div class="badge badge-hard" style="margin-bottom: 0.75rem; font-size: 0.85rem;">
                    Mission Attempt Incomplete
                </div>

                <h1 style="font-size: 2.1rem; font-weight: 800; letter-spacing: -0.02em; margin-bottom: 0.5rem; color: #fff;">
                    Incorrect Solution
                </h1>

                <p style="color: var(--text-secondary); font-size: 1rem; max-width: 480px; margin: 0 auto 1.5rem auto;">
                    Your choice did not match the expected answer for <strong><%= missionTitle %></strong>.
                    Per the one-attempt rule, this mission is closed, but you can conquer more challenges!
                </p>

                <div style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1.25rem; background: rgba(255, 255, 255, 0.04); border-radius: var(--radius-full); margin-bottom: 2rem; font-size: 0.85rem; color: var(--text-muted);">
                    <span>Your submitted answer:</span>
                    <strong style="color: var(--text-primary); font-family: var(--font-mono);"><%= selectedAnswer %></strong>
                </div>
            <% } %>

            <!-- Progress Summary Table -->
            <div style="background: var(--bg-surface-elevated); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 1.25rem; margin-bottom: 2rem; display: flex; justify-content: space-around; text-align: center;">
                <div>
                    <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Total XP</div>
                    <div style="font-size: 1.4rem; font-weight: 800; color: var(--xp-amber-light); font-family: var(--font-mono); margin-top: 0.2rem;">
                        <%= newXp %> XP
                    </div>
                </div>

                <div style="width: 1px; background: var(--border-subtle);"></div>

                <div>
                    <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Player Level</div>
                    <div style="font-size: 1.4rem; font-weight: 800; color: var(--brand-indigo-light); margin-top: 0.2rem;">
                        Level <%= newLevel %>
                    </div>
                </div>

                <div style="width: 1px; background: var(--border-subtle);"></div>

                <div>
                    <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Track &amp; Tier</div>
                    <div style="font-size: 1rem; font-weight: 700; color: var(--text-primary); margin-top: 0.4rem;">
                        <%= category %> &bull; <%= difficulty %>
                    </div>
                </div>
            </div>

            <!-- Navigation Actions -->
            <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/missions" class="btn btn-primary btn-lg">
                    <span>Continue Missions</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </a>
                <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary btn-lg">
                    <span>Return to Dashboard</span>
                </a>
                <a href="<%= request.getContextPath() %>/leaderboard" class="btn btn-outline btn-lg">
                    <span>View Leaderboard</span>
                </a>
            </div>

        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
