<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.dao.MissionDAO" %>
<%@ page import="com.codequest.dao.UserDAO" %>
<%@ page import="com.codequest.dao.SubmissionDAO" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    String adminUsername = (String) session.getAttribute("adminUsername");

    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    // Auto-fetch metrics if accessed directly without servlet
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer totalMissions = (Integer) request.getAttribute("totalMissions");
    Integer totalSubmissions = (Integer) request.getAttribute("totalSubmissions");
    Integer javaMissions = (Integer) request.getAttribute("javaMissions");
    Integer sqlMissions = (Integer) request.getAttribute("sqlMissions");
    Integer dsaMissions = (Integer) request.getAttribute("dsaMissions");

    if (totalStudents == null) {
        UserDAO udao = new UserDAO();
        MissionDAO mdao = new MissionDAO();
        SubmissionDAO sdao = new SubmissionDAO();
        totalStudents = udao.getTotalStudentsCount();
        totalMissions = mdao.getTotalMissionsCount();
        totalSubmissions = sdao.getTotalSubmissionsCount();
        javaMissions = mdao.getMissionsCountByCategory("Java");
        sqlMissions = mdao.getMissionsCountByCategory("SQL");
        dsaMissions = mdao.getMissionsCountByCategory("DSA");
    }

    // Demonstrating ServletContext access in JSP
    String serverInfo = application.getServerInfo();
    Object adminLoginCount = application.getAttribute("adminLoginCounter");
    Object lastLoginTime = application.getAttribute("lastAdminLoginTime");
    String appName = (String) application.getAttribute("appName");
    String appVersion = (String) application.getAttribute("appVersion");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard &bull; CodeQuest HQ</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <!-- Dashboard Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.35rem;">
                    <span class="badge" style="background: rgba(99, 102, 241, 0.2); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.4);">
                        Super Admin Active
                    </span>
                    <span style="font-size: 0.85rem; color: var(--text-muted); font-family: var(--font-mono);">Session ID: <%= session.getId().substring(0, Math.min(10, session.getId().length())) %>...</span>
                </div>
                <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">
                    Welcome, Administrator <%= adminUsername != null ? adminUsername : "" %>
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">
                    CodeQuest Management Command Center &bull; Live Question &amp; Curriculum Control
                </p>
            </div>

            <!-- Action Buttons Required by Module 4 -->
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/add-question" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Add New Question</span>
                </a>
                <a href="<%= request.getContextPath() %>/view-questions" class="btn btn-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="8" y1="6" x2="21" y2="6"></line>
                        <line x1="8" y1="12" x2="21" y2="12"></line>
                        <line x1="8" y1="18" x2="21" y2="18"></line>
                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                    </svg>
                    <span>View Existing Questions</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-logout" class="btn btn-outline" style="color: var(--danger-rose);">
                    <span>Log Out</span>
                </a>
            </div>
        </div>

        <!-- Metrics Overview Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="color: var(--brand-indigo-light);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value"><%= totalStudents %></div>
                    <div class="stat-label">Registered Students</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: var(--xp-amber-light);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value"><%= totalMissions %></div>
                    <div class="stat-label">Active Missions</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: var(--success-jade);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value"><%= totalSubmissions %></div>
                    <div class="stat-label">Student Submissions</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: #38bdf8;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="8" r="7"></circle>
                        <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                    </svg>
                </div>
                <div class="stat-info">
                    <div class="stat-value">3 Tracks</div>
                    <div class="stat-label">Java &bull; SQL &bull; DSA</div>
                </div>
            </div>
        </div>

        <!-- Curriculum Breakdown & Quick Links -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-top: 1.5rem;">
            <!-- Category Distribution Card -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                            <line x1="8" y1="21" x2="16" y2="21"></line>
                            <line x1="12" y1="17" x2="12" y2="21"></line>
                        </svg>
                        <span>Curriculum Inventory by Category</span>
                    </h2>
                    <a href="<%= request.getContextPath() %>/view-questions" class="btn btn-outline btn-sm">Full Catalog &rarr;</a>
                </div>

                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-top: 1rem;">
                    <div style="padding: 1.25rem; background: var(--bg-surface-elevated); border: 1px solid var(--cat-java-border); border-radius: var(--radius-sm); text-align: center;">
                        <span class="badge badge-java">Java Track</span>
                        <div style="font-size: 2rem; font-weight: 800; margin: 0.5rem 0; color: var(--cat-java-text);"><%= javaMissions %></div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);">Stored Questions</div>
                    </div>

                    <div style="padding: 1.25rem; background: var(--bg-surface-elevated); border: 1px solid var(--cat-sql-border); border-radius: var(--radius-sm); text-align: center;">
                        <span class="badge badge-sql">SQL Track</span>
                        <div style="font-size: 2rem; font-weight: 800; margin: 0.5rem 0; color: var(--cat-sql-text);"><%= sqlMissions %></div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);">Stored Questions</div>
                    </div>

                    <div style="padding: 1.25rem; background: var(--bg-surface-elevated); border: 1px solid var(--cat-dsa-border); border-radius: var(--radius-sm); text-align: center;">
                        <span class="badge badge-dsa">DSA Track</span>
                        <div style="font-size: 2rem; font-weight: 800; margin: 0.5rem 0; color: var(--cat-dsa-text);"><%= dsaMissions %></div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);">Stored Questions</div>
                    </div>
                </div>

                <div style="margin-top: 1.5rem; padding: 1rem; background: rgba(255, 255, 255, 0.02); border-radius: var(--radius-sm); font-size: 0.85rem; color: var(--text-secondary);">
                    <strong>Module 6 &amp; 7 Notice:</strong> Questions are stored dynamically in the <code>missions</code> table of <code>codequest_db</code> using JDBC PreparedStatements. Admin users can insert and preview questions without touching JSP templates.
                </div>
            </div>

            <!-- ServletContext & Telemetry Card (Demonstrating Module 4 & 12 requirements) -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                        </svg>
                        <span>System Architecture</span>
                    </h2>
                </div>

                <div style="font-size: 0.85rem; display: flex; flex-direction: column; gap: 0.85rem;">
                    <div>
                        <div style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Application Context</div>
                        <div style="font-weight: 600; color: var(--text-primary);"><%= appName != null ? appName : "CodeQuest" %></div>
                        <div style="color: var(--brand-indigo-light); font-family: var(--font-mono); font-size: 0.75rem;">v<%= appVersion != null ? appVersion : "1.0" %></div>
                    </div>

                    <div>
                        <div style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Runtime Container</div>
                        <div style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-secondary);"><%= serverInfo %></div>
                    </div>

                    <div>
                        <div style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Admin Session Counters (ServletContext)</div>
                        <div style="font-weight: 600;">Total Logins: <span style="color: var(--xp-amber-light);"><%= adminLoginCount != null ? adminLoginCount : "1" %></span></div>
                        <div style="color: var(--text-muted); font-size: 0.75rem;">Last Login: <%= lastLoginTime != null ? lastLoginTime : "Just now" %></div>
                    </div>

                    <div>
                        <div style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Database Connection</div>
                        <div style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--success-jade);">MySQL 8.0 &bull; codequest_db</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
