<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.Mission" %>
<%@ page import="com.codequest.dao.MissionDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
        return;
    }

    List<Mission> missionsList = (List<Mission>) request.getAttribute("missionsList");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedDifficulty = (String) request.getAttribute("selectedDifficulty");

    if (selectedCategory == null) selectedCategory = "ALL";
    if (selectedDifficulty == null) selectedDifficulty = "ALL";

    if (missionsList == null) {
        MissionDAO mdao = new MissionDAO();
        missionsList = mdao.getMissionsForStudent(userId, selectedCategory, selectedDifficulty);
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Programming Missions &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <!-- Header & Instructions -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.35rem;">
                    <span class="badge" style="background: rgba(99, 102, 241, 0.2); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.4);">
                        Active Curriculum
                    </span>
                    <span style="font-size: 0.85rem; color: var(--text-muted);">One attempt per mission policy</span>
                </div>
                <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">Programming Missions</h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">
                    Select an answer, submit for instant validation, and claim your XP rewards.
                </p>
            </div>

            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary btn-sm">
                    <span>My Dashboard</span>
                </a>
                <a href="<%= request.getContextPath() %>/leaderboard" class="btn btn-outline btn-sm">
                    <span>Leaderboard</span>
                </a>
            </div>
        </div>

        <!-- Feedback Alert Messages -->
        <% if ("already_attempted".equals(error)) { %>
            <div class="alert alert-danger">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span>You have already submitted an answer for this mission. Only one attempt is permitted per mission.</span>
            </div>
        <% } %>

        <% if ("missing_choice".equals(error)) { %>
            <div class="alert alert-danger">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span>Please select one of the four answer choices before submitting.</span>
            </div>
        <% } %>

        <!-- Filter Controls (Module 9 Requirement) -->
        <div class="card" style="padding: 1.25rem; margin-bottom: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <!-- Category Filters -->
                <div style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                    <span style="font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-right: 0.25rem;">Track:</span>
                    <a href="<%= request.getContextPath() %>/missions?category=ALL&difficulty=<%= selectedDifficulty %>" 
                       class="btn btn-sm <%= "ALL".equalsIgnoreCase(selectedCategory) ? "btn-primary" : "btn-outline" %>"
                       data-filter-cat="ALL">All Categories</a>
                    <a href="<%= request.getContextPath() %>/missions?category=Java&difficulty=<%= selectedDifficulty %>" 
                       class="btn btn-sm <%= "Java".equalsIgnoreCase(selectedCategory) ? "btn-primary" : "btn-outline" %>"
                       data-filter-cat="Java">Java</a>
                    <a href="<%= request.getContextPath() %>/missions?category=SQL&difficulty=<%= selectedDifficulty %>" 
                       class="btn btn-sm <%= "SQL".equalsIgnoreCase(selectedCategory) ? "btn-primary" : "btn-outline" %>"
                       data-filter-cat="SQL">SQL</a>
                    <a href="<%= request.getContextPath() %>/missions?category=DSA&difficulty=<%= selectedDifficulty %>" 
                       class="btn btn-sm <%= "DSA".equalsIgnoreCase(selectedCategory) ? "btn-primary" : "btn-outline" %>"
                       data-filter-cat="DSA">DSA</a>
                </div>

                <!-- Difficulty Filters -->
                <div style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                    <span style="font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-right: 0.25rem;">Tier:</span>
                    <a href="<%= request.getContextPath() %>/missions?category=<%= selectedCategory %>&difficulty=ALL" 
                       class="btn btn-sm <%= "ALL".equalsIgnoreCase(selectedDifficulty) ? "btn-primary" : "btn-outline" %>"
                       data-filter-diff="ALL">All Tiers</a>
                    <a href="<%= request.getContextPath() %>/missions?category=<%= selectedCategory %>&difficulty=Easy" 
                       class="btn btn-sm <%= "Easy".equalsIgnoreCase(selectedDifficulty) ? "btn-primary" : "btn-outline" %>"
                       data-filter-diff="Easy">Easy</a>
                    <a href="<%= request.getContextPath() %>/missions?category=<%= selectedCategory %>&difficulty=Medium" 
                       class="btn btn-sm <%= "Medium".equalsIgnoreCase(selectedDifficulty) ? "btn-primary" : "btn-outline" %>"
                       data-filter-diff="Medium">Medium</a>
                    <a href="<%= request.getContextPath() %>/missions?category=<%= selectedCategory %>&difficulty=Hard" 
                       class="btn btn-sm <%= "Hard".equalsIgnoreCase(selectedDifficulty) ? "btn-primary" : "btn-outline" %>"
                       data-filter-diff="Hard">Hard</a>
                </div>
            </div>
        </div>

        <!-- Missions List Grid (Module 9 & 10) -->
        <div style="display: flex; flex-direction: column; gap: 2rem;">
            <%
                if (missionsList == null || missionsList.isEmpty()) {
            %>
                <div class="card" style="text-align: center; padding: 4rem 2rem;">
                    <div style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 0.5rem;">
                        No missions found matching the selected filters.
                    </div>
                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;">
                        Try resetting your category or difficulty tier filter.
                    </p>
                    <a href="<%= request.getContextPath() %>/missions" class="btn btn-secondary">Reset Filters</a>
                </div>
            <%
                } else {
                    for (Mission m : missionsList) {
                        String catClass = "badge-java";
                        if ("SQL".equalsIgnoreCase(m.getCategory())) catClass = "badge-sql";
                        else if ("DSA".equalsIgnoreCase(m.getCategory())) catClass = "badge-dsa";

                        String diffClass = "badge-medium";
                        if ("Easy".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-easy";
                        else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";

                        boolean isAttempted = m.isAttempted();
                        boolean isSolved = m.isSolved();
            %>
                <div class="card mission-item" data-category="<%= m.getCategory() %>" data-difficulty="<%= m.getDifficulty() %>" style="padding: 2rem;">
                    
                    <!-- Card Header -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.25rem; flex-wrap: wrap; gap: 0.75rem;">
                        <div>
                            <div style="display: flex; align-items: center; gap: 0.6rem; margin-bottom: 0.5rem;">
                                <span class="badge <%= catClass %>"><%= m.getCategory() %></span>
                                <span class="badge <%= diffClass %>"><%= m.getDifficulty() %></span>
                                <span class="badge badge-xp">+<%= m.getXpReward() %> XP</span>

                                <% if (isAttempted) { %>
                                    <% if (isSolved) { %>
                                        <span class="badge badge-easy" style="border-radius: var(--radius-sm);">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                            Mission Solved (+<%= m.getXpReward() %> XP Claimed)
                                        </span>
                                    <% } else { %>
                                        <span class="badge badge-hard" style="border-radius: var(--radius-sm);">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                            Attempted (Incorrect)
                                        </span>
                                    <% } %>
                                <% } %>
                            </div>
                            <h2 style="font-size: 1.35rem; font-weight: 700; color: var(--text-primary);">
                                #<%= m.getId() %> &bull; <%= m.getTitle() %>
                            </h2>
                        </div>
                    </div>

                    <!-- Problem Statement / Description (with code block style) -->
                    <div style="background-color: var(--bg-surface-elevated); border: 1px solid var(--border-medium); border-radius: var(--radius-sm); padding: 1.25rem; margin-bottom: 1.5rem; font-family: var(--font-mono); font-size: 0.92rem; line-height: 1.6; white-space: pre-wrap; color: #e2e8f0;"><%= m.getDescription() %></div>

                    <!-- Module 9 & 10: Answer Form (Sanitized - correct answer is NEVER present) -->
                    <% if (!isAttempted) { %>
                        <form action="<%= request.getContextPath() %>/submit-answer" method="POST">
                            <input type="hidden" name="missionId" value="<%= m.getId() %>">

                            <div style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; margin-bottom: 0.75rem; letter-spacing: 0.05em;">
                                Select Your Answer:
                            </div>

                            <div class="options-grid">
                                <label class="option-card">
                                    <input type="radio" name="selectedAnswer" value="<%= m.getOptionA() %>" required>
                                    <span class="option-label">A</span>
                                    <span class="option-text"><%= m.getOptionA() %></span>
                                </label>

                                <label class="option-card">
                                    <input type="radio" name="selectedAnswer" value="<%= m.getOptionB() %>">
                                    <span class="option-label">B</span>
                                    <span class="option-text"><%= m.getOptionB() %></span>
                                </label>

                                <label class="option-card">
                                    <input type="radio" name="selectedAnswer" value="<%= m.getOptionC() %>">
                                    <span class="option-label">C</span>
                                    <span class="option-text"><%= m.getOptionC() %></span>
                                </label>

                                <label class="option-card">
                                    <input type="radio" name="selectedAnswer" value="<%= m.getOptionD() %>">
                                    <span class="option-label">D</span>
                                    <span class="option-text"><%= m.getOptionD() %></span>
                                </label>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid var(--border-subtle); flex-wrap: wrap; gap: 1rem;">
                                <div style="font-size: 0.82rem; color: var(--text-muted);">
                                    &bull; 1 attempt only &bull; XP instantly awarded upon submission
                                </div>
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <span>Lock In &amp; Submit Answer</span>
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                            </div>
                        </form>
                    <% } else { %>
                        <!-- Already Attempted Read-Only View -->
                        <div style="padding: 1.25rem; background: var(--bg-surface-elevated); border: 1px dashed var(--border-medium); border-radius: var(--radius-sm);">
                            <div style="display: flex; align-items: center; justify-content: space-between; font-size: 0.88rem;">
                                <div>
                                    <span style="color: var(--text-muted);">Your Recorded Submission:</span>
                                    <strong style="color: <%= isSolved ? "var(--success-jade)" : "var(--danger-rose)" %>; font-family: var(--font-mono); margin-left: 0.5rem;">
                                        <%= m.getStudentAnswer() != null ? m.getStudentAnswer() : "Submitted" %>
                                    </strong>
                                </div>
                                <span style="font-size: 0.8rem; color: var(--text-muted); font-family: var(--font-mono);">Attempt Limit Reached</span>
                            </div>
                        </div>
                    <% } %>

                </div>
            <%
                    }
                }
            %>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
