<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.util.DBConnection" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    String activeTab = request.getParameter("tab");
    if (activeTab == null || activeTab.trim().isEmpty()) {
        activeTab = "users";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Database Tables &bull; CodeQuest</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .tab-btn {
            padding: 0.65rem 1.35rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            border: 1px solid var(--border-medium);
            background: var(--bg-surface-elevated);
            color: var(--text-secondary);
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        .tab-btn:hover {
            color: var(--text-primary);
            background: var(--bg-surface-hover);
        }
        .tab-btn.active {
            background: var(--brand-indigo);
            color: #fff;
            border-color: var(--brand-indigo-light);
            box-shadow: 0 4px 12px var(--brand-indigo-glow);
        }
    </style>
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.75rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <a href="<%= request.getContextPath() %>/admin-dashboard" style="color: var(--text-muted); font-size: 0.85rem; display: flex; align-items: center; gap: 0.4rem; margin-bottom: 0.4rem;">
                    &larr; Back to Admin Dashboard
                </a>
                <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">Live MySQL Database Tables</h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">
                    Direct real-time records from <strong style="color: var(--brand-indigo-light); font-family: var(--font-mono);">codequest_db</strong>
                </p>
            </div>

            <div style="display: flex; gap: 0.5rem;">
                <a href="<%= request.getContextPath() %>/admin-database.jsp?tab=<%= activeTab %>" class="btn btn-secondary btn-sm">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"></polyline>
                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                    </svg>
                    <span>Refresh Data</span>
                </a>
            </div>
        </div>

        <!-- 4 Tables Tabs -->
        <div style="display: flex; gap: 0.75rem; margin-bottom: 1.75rem; flex-wrap: wrap;">
            <a href="<%= request.getContextPath() %>/admin-database.jsp?tab=users" class="tab-btn <%= "users".equals(activeTab) ? "active" : "" %>">
                <span>Table 1: users</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin-database.jsp?tab=admins" class="tab-btn <%= "admins".equals(activeTab) ? "active" : "" %>">
                <span>Table 2: admins</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin-database.jsp?tab=missions" class="tab-btn <%= "missions".equals(activeTab) ? "active" : "" %>">
                <span>Table 3: missions</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin-database.jsp?tab=mission_submissions" class="tab-btn <%= "mission_submissions".equals(activeTab) ? "active" : "" %>">
                <span>Table 4: mission_submissions</span>
            </a>
        </div>

        <!-- ============================================================== -->
        <!-- TAB 1: USERS (LIVE DATA ONLY)                                  -->
        <!-- ============================================================== -->
        <% if ("users".equals(activeTab)) { %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                        </svg>
                        <span>Live Data: <code>users</code></span>
                    </h2>
                    <span class="badge" style="background: rgba(99, 102, 241, 0.15); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">
                        MySQL Table
                    </span>
                </div>

                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">id</th>
                                <th>username</th>
                                <th>email</th>
                                <th>password</th>
                                <th style="width: 120px;">total_xp</th>
                                <th style="width: 130px;">player_level</th>
                                <th style="width: 180px;">created_at</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement st = null;
                                ResultSet rs = null;
                                try {
                                    conn = DBConnection.getConnection();
                                    st = conn.createStatement();
                                    rs = st.executeQuery("SELECT id, username, email, password, total_xp, player_level, created_at FROM users ORDER BY id ASC");
                                    while (rs.next()) {
                            %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700;">#<%= rs.getInt("id") %></td>
                                    <td><strong style="color: var(--brand-indigo-light);"><%= rs.getString("username") %></strong></td>
                                    <td><%= rs.getString("email") %></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.75rem; color: var(--text-muted); max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%= rs.getString("password") %></td>
                                    <td><span class="badge badge-xp"><%= rs.getInt("total_xp") %> XP</span></td>
                                    <td><span class="badge" style="background: rgba(99, 102, 241, 0.15); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">Level <%= rs.getInt("player_level") %></span></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-muted);"><%= rs.getTimestamp("created_at") %></td>
                                </tr>
                            <%
                                    }
                                } catch (Exception e) {
                            %>
                                <tr><td colspan="7" style="color: var(--danger-rose);">Database Error: <%= e.getMessage() %></td></tr>
                            <%
                                } finally {
                                    DBConnection.closeQuietly(rs, st, conn);
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- ============================================================== -->
        <!-- TAB 2: ADMINS (LIVE DATA ONLY)                                 -->
        <!-- ============================================================== -->
        <% if ("admins".equals(activeTab)) { %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>Live Data: <code>admins</code></span>
                    </h2>
                    <span class="badge" style="background: rgba(99, 102, 241, 0.15); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">
                        MySQL Table
                    </span>
                </div>

                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 80px;">id</th>
                                <th>username</th>
                                <th>password</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn2 = null;
                                Statement st2 = null;
                                ResultSet rs2 = null;
                                try {
                                    conn2 = DBConnection.getConnection();
                                    st2 = conn2.createStatement();
                                    rs2 = st2.executeQuery("SELECT id, username, password FROM admins ORDER BY id ASC");
                                    while (rs2.next()) {
                            %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700;">#<%= rs2.getInt("id") %></td>
                                    <td><strong style="color: var(--brand-indigo-light);"><%= rs2.getString("username") %></strong></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.9rem; color: var(--success-jade);"><%= rs2.getString("password") %></td>
                                </tr>
                            <%
                                    }
                                } catch (Exception e) {
                            %>
                                <tr><td colspan="3" style="color: var(--danger-rose);">Database Error: <%= e.getMessage() %></td></tr>
                            <%
                                } finally {
                                    DBConnection.closeQuietly(rs2, st2, conn2);
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- ============================================================== -->
        <!-- TAB 3: MISSIONS (LIVE DATA ONLY)                               -->
        <!-- ============================================================== -->
        <% if ("missions".equals(activeTab)) { %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                            <polyline points="2 17 12 22 22 17"></polyline>
                        </svg>
                        <span>Live Data: <code>missions</code></span>
                    </h2>
                    <span class="badge" style="background: rgba(99, 102, 241, 0.15); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">
                        MySQL Table
                    </span>
                </div>

                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">id</th>
                                <th>title</th>
                                <th style="width: 100px;">category</th>
                                <th style="width: 100px;">difficulty</th>
                                <th>option_a</th>
                                <th>option_b</th>
                                <th>option_c</th>
                                <th>option_d</th>
                                <th>correct_answer</th>
                                <th style="width: 100px;">xp_reward</th>
                                <th style="width: 90px;">created_by</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn3 = null;
                                Statement st3 = null;
                                ResultSet rs3 = null;
                                try {
                                    conn3 = DBConnection.getConnection();
                                    st3 = conn3.createStatement();
                                    rs3 = st3.executeQuery("SELECT id, title, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by FROM missions ORDER BY id ASC");
                                    while (rs3.next()) {
                                        String catClass = "badge-java";
                                        if ("SQL".equalsIgnoreCase(rs3.getString("category"))) catClass = "badge-sql";
                                        else if ("DSA".equalsIgnoreCase(rs3.getString("category"))) catClass = "badge-dsa";

                                        String diffClass = "badge-medium";
                                        if ("Easy".equalsIgnoreCase(rs3.getString("difficulty"))) diffClass = "badge-easy";
                                        else if ("Hard".equalsIgnoreCase(rs3.getString("difficulty"))) diffClass = "badge-hard";
                            %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700;">#<%= rs3.getInt("id") %></td>
                                    <td><strong><%= rs3.getString("title") %></strong></td>
                                    <td><span class="badge <%= catClass %>"><%= rs3.getString("category") %></span></td>
                                    <td><span class="badge <%= diffClass %>"><%= rs3.getString("difficulty") %></span></td>
                                    <td style="font-size: 0.8rem; color: var(--text-secondary);"><%= rs3.getString("option_a") %></td>
                                    <td style="font-size: 0.8rem; color: var(--text-secondary);"><%= rs3.getString("option_b") %></td>
                                    <td style="font-size: 0.8rem; color: var(--text-secondary);"><%= rs3.getString("option_c") %></td>
                                    <td style="font-size: 0.8rem; color: var(--text-secondary);"><%= rs3.getString("option_d") %></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.82rem; color: var(--success-jade); font-weight: 600;"><%= rs3.getString("correct_answer") %></td>
                                    <td><span class="badge badge-xp">+<%= rs3.getInt("xp_reward") %> XP</span></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-muted);">Admin #<%= rs3.getInt("created_by") %></td>
                                </tr>
                            <%
                                    }
                                } catch (Exception e) {
                            %>
                                <tr><td colspan="11" style="color: var(--danger-rose);">Database Error: <%= e.getMessage() %></td></tr>
                            <%
                                } finally {
                                    DBConnection.closeQuietly(rs3, st3, conn3);
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- ============================================================== -->
        <!-- TAB 4: MISSION_SUBMISSIONS (LIVE DATA ONLY)                    -->
        <!-- ============================================================== -->
        <% if ("mission_submissions".equals(activeTab)) { %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span>Live Data: <code>mission_submissions</code></span>
                    </h2>
                    <span class="badge" style="background: rgba(99, 102, 241, 0.15); color: var(--brand-indigo-light); border: 1px solid rgba(99, 102, 241, 0.3);">
                        MySQL Table
                    </span>
                </div>

                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">id</th>
                                <th>student</th>
                                <th>mission</th>
                                <th>submitted answer</th>
                                <th style="width: 140px;">is_correct</th>
                                <th style="width: 190px;">completed_at</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn4 = null;
                                Statement st4 = null;
                                ResultSet rs4 = null;
                                try {
                                    conn4 = DBConnection.getConnection();
                                    st4 = conn4.createStatement();
                                    rs4 = st4.executeQuery("SELECT s.id, u.username, m.title, s.answer, s.is_correct, s.completed_at FROM mission_submissions s JOIN users u ON s.user_id = u.id JOIN missions m ON s.mission_id = m.id ORDER BY s.id DESC");
                                    while (rs4.next()) {
                                        boolean isCor = rs4.getBoolean("is_correct");
                            %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700;">#<%= rs4.getInt("id") %></td>
                                    <td><strong style="color: var(--brand-indigo-light);"><%= rs4.getString("username") %></strong></td>
                                    <td><%= rs4.getString("title") %></td>
                                    <td style="font-family: var(--font-mono); font-size: 0.88rem;"><%= rs4.getString("answer") %></td>
                                    <td>
                                        <% if (isCor) { %>
                                            <span class="badge badge-easy">
                                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                TRUE (Correct)
                                            </span>
                                        <% } else { %>
                                            <span class="badge badge-hard">
                                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                                FALSE (Incorrect)
                                            </span>
                                        <% } %>
                                    </td>
                                    <td style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-muted);"><%= rs4.getTimestamp("completed_at") %></td>
                                </tr>
                            <%
                                    }
                                } catch (Exception e) {
                            %>
                                <tr><td colspan="6" style="color: var(--danger-rose);">Database Error: <%= e.getMessage() %></td></tr>
                            <%
                                } finally {
                                    DBConnection.closeQuietly(rs4, st4, conn4);
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
