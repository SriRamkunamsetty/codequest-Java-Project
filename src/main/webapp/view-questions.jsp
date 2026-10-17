<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.codequest.model.Mission" %>
<%@ page import="com.codequest.dao.MissionDAO" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    List<Mission> missionsList = (List<Mission>) request.getAttribute("missionsList");
    if (missionsList == null) {
        MissionDAO mdao = new MissionDAO();
        missionsList = mdao.getAllMissions();
    }

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Management &bull; CodeQuest Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <a href="<%= request.getContextPath() %>/admin-dashboard" style="color: var(--text-muted); font-size: 0.85rem; display: flex; align-items: center; gap: 0.4rem; margin-bottom: 0.4rem;">
                    &larr; Back to Admin Dashboard
                </a>
                <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">Question Management</h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">
                    View, audit, and manage all dynamically stored missions in the MySQL database.
                </p>
            </div>

            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/add-question" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Add New Question</span>
                </a>
                <a href="<%= request.getContextPath() %>/view-questions" class="btn btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"></polyline>
                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                    </svg>
                    <span>Refresh</span>
                </a>
            </div>
        </div>

        <% if ("created".equals(msg)) { %>
            <div class="alert alert-success">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                <span>Mission successfully published and stored into MySQL database!</span>
            </div>
        <% } %>

        <% if ("deleted".equals(msg)) { %>
            <div class="alert alert-info">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                </svg>
                <span>Mission record removed from database.</span>
            </div>
        <% } %>

        <!-- Module 7: Questions Table Rendered Dynamically Using JSP Scriptlets -->
        <div class="table-wrapper">
            <table class="table">
                <thead>
                    <tr>
                        <th style="width: 60px;">ID</th>
                        <th>Question Title</th>
                        <th style="width: 120px;">Category</th>
                        <th style="width: 120px;">Difficulty</th>
                        <th style="width: 110px;">XP Reward</th>
                        <th>Correct Answer Choice</th>
                        <th style="width: 100px; text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (missionsList == null || missionsList.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                <div>No programming questions found in the database.</div>
                                <div style="margin-top: 0.75rem;">
                                    <a href="<%= request.getContextPath() %>/add-question" class="btn btn-primary btn-sm">Create First Question</a>
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Mission m : missionsList) {
                                String catClass = "badge-java";
                                if ("SQL".equalsIgnoreCase(m.getCategory())) catClass = "badge-sql";
                                else if ("DSA".equalsIgnoreCase(m.getCategory())) catClass = "badge-dsa";

                                String diffClass = "badge-medium";
                                if ("Easy".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-easy";
                                else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";
                    %>
                        <tr>
                            <td style="font-family: var(--font-mono); color: var(--text-muted);">#<%= m.getId() %></td>
                            <td>
                                <div style="font-weight: 600; color: var(--text-primary);"><%= m.getTitle() %></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.2rem; max-width: 480px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    <%= m.getDescription() != null ? m.getDescription().replace("\n", " ") : "" %>
                                </div>
                            </td>
                            <td>
                                <span class="badge <%= catClass %>"><%= m.getCategory() %></span>
                            </td>
                            <td>
                                <span class="badge <%= diffClass %>"><%= m.getDifficulty() %></span>
                            </td>
                            <td>
                                <span class="badge badge-xp">+<%= m.getXpReward() %> XP</span>
                            </td>
                            <td>
                                <span style="font-family: var(--font-mono); font-size: 0.85rem; color: var(--success-jade);">
                                    <%= m.getCorrectAnswer() %>
                                </span>
                            </td>
                            <td style="text-align: center;">
                                <form action="<%= request.getContextPath() %>/delete-question" method="POST" 
                                      onsubmit="return confirm('Are you sure you want to delete mission #<%= m.getId() %>?');" 
                                      style="display: inline;">
                                    <input type="hidden" name="id" value="<%= m.getId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete mission" style="padding: 0.35rem 0.6rem;">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="3 6 5 6 21 6"></polyline>
                                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                        </svg>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
