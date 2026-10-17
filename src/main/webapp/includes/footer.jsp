<%
    String footerAppName = (String) application.getAttribute("appName");
    if (footerAppName == null) {
        footerAppName = application.getInitParameter("appName");
        if (footerAppName == null) footerAppName = "CodeQuest - Programming Learning Game";
    }
    String footerAppVersion = (String) application.getAttribute("appVersion");
    if (footerAppVersion == null) {
        footerAppVersion = application.getInitParameter("appVersion");
        if (footerAppVersion == null) footerAppVersion = "1.0";
    }
%>
<footer class="footer">
    <div class="footer-container">
        <div>
            <span style="font-weight: 700; color: var(--text-primary);"><%= footerAppName %></span>
            <span style="margin-left: 0.5rem; font-family: var(--font-mono); font-size: 0.75rem; color: var(--brand-indigo-light);">v<%= footerAppVersion %></span>
            <p style="margin-top: 0.25rem;">Built with JSP, Servlets, JDBC, and MySQL. Eclipse IDE &amp; Tomcat 10.1 Architecture.</p>
        </div>
        <div style="display: flex; gap: 1.25rem; font-size: 0.85rem;">
            <a href="<%= request.getContextPath() %>/index.html" style="color: var(--text-secondary);">Home</a>
            <a href="<%= request.getContextPath() %>/missions" style="color: var(--text-secondary);">Missions</a>
            <a href="<%= request.getContextPath() %>/leaderboard" style="color: var(--text-secondary);">Leaderboard</a>
            <a href="<%= request.getContextPath() %>/admin-login.jsp" style="color: var(--text-secondary);">Admin Portal</a>
        </div>
    </div>
</footer>
<script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
