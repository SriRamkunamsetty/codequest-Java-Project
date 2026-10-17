<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp?error=unauthorized");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String titleVal = (String) request.getAttribute("titleVal");
    String descriptionVal = (String) request.getAttribute("descriptionVal");
    String categoryVal = (String) request.getAttribute("categoryVal");
    String difficultyVal = (String) request.getAttribute("difficultyVal");
    String optionAVal = (String) request.getAttribute("optionAVal");
    String optionBVal = (String) request.getAttribute("optionBVal");
    String optionCVal = (String) request.getAttribute("optionCVal");
    String optionDVal = (String) request.getAttribute("optionDVal");
    String xpRewardVal = (String) request.getAttribute("xpRewardVal");

    if (titleVal == null) titleVal = "";
    if (descriptionVal == null) descriptionVal = "";
    if (categoryVal == null) categoryVal = "Java";
    if (difficultyVal == null) difficultyVal = "Medium";
    if (optionAVal == null) optionAVal = "";
    if (optionBVal == null) optionBVal = "";
    if (optionCVal == null) optionCVal = "";
    if (optionDVal == null) optionDVal = "";
    if (xpRewardVal == null) xpRewardVal = "50";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Mission &bull; CodeQuest Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Navbar Include -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="main-content" style="max-width: 840px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.75rem;">
            <div>
                <a href="<%= request.getContextPath() %>/admin-dashboard" style="color: var(--text-muted); font-size: 0.85rem; display: flex; align-items: center; gap: 0.4rem; margin-bottom: 0.4rem;">
                    &larr; Back to Admin Dashboard
                </a>
                <h1 style="font-size: 1.85rem; font-weight: 800; letter-spacing: -0.02em;">Add Programming Question</h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                    Dynamically insert Java, SQL, or DSA questions into the MySQL missions table.
                </p>
            </div>
            <a href="<%= request.getContextPath() %>/view-questions" class="btn btn-secondary btn-sm">
                View Question Catalog &rarr;
            </a>
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

        <div class="card" style="padding: 2.25rem;">
            <!-- Module 6: Question Creation Form -->
            <form action="<%= request.getContextPath() %>/add-question" method="POST">
                
                <!-- Section 1: Question Meta -->
                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="title">Question Title</label>
                        <input type="text" id="title" name="title" class="form-control" 
                               placeholder="e.g. Polymorphism &amp; Late Binding" required 
                               value="<%= titleVal %>">
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="category">Category</label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="Java" <%= "Java".equals(categoryVal) ? "selected" : "" %>>Java</option>
                            <option value="SQL" <%= "SQL".equals(categoryVal) ? "selected" : "" %>>SQL</option>
                            <option value="DSA" <%= "DSA".equals(categoryVal) ? "selected" : "" %>>DSA</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="difficulty">Difficulty</label>
                        <select id="difficulty" name="difficulty" class="form-control" required>
                            <option value="Easy" <%= "Easy".equals(difficultyVal) ? "selected" : "" %>>Easy</option>
                            <option value="Medium" <%= "Medium".equals(difficultyVal) ? "selected" : "" %>>Medium</option>
                            <option value="Hard" <%= "Hard".equals(difficultyVal) ? "selected" : "" %>>Hard</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="xpReward">XP Reward</label>
                        <input type="number" id="xpReward" name="xpReward" class="form-control" 
                               min="10" max="500" step="10" required 
                               value="<%= xpRewardVal %>">
                    </div>
                </div>

                <!-- Section 2: Question Description / Code Snippet -->
                <div class="form-group">
                    <label class="form-label" for="description">
                        Question Description / Code Snippet
                        <span style="font-weight: 400; color: var(--text-muted);">(Plain text or formatted code block)</span>
                    </label>
                    <textarea id="description" name="description" class="form-control" rows="6" 
                              placeholder="Provide the complete problem statement, scenario, or Java/SQL/C++ code snippet..." required><%= descriptionVal %></textarea>
                </div>

                <!-- Section 3: Four Answer Choices + Correct Answer Selection -->
                <div style="margin-top: 1.75rem; border-top: 1px solid var(--border-subtle); padding-top: 1.5rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <label class="form-label" style="margin-bottom: 0; font-size: 0.95rem;">
                            Four Answer Choices
                        </label>
                        <span style="font-size: 0.8rem; color: var(--text-muted);">
                            Mark the radio button of the <strong style="color: var(--success-jade);">correct answer</strong>
                        </span>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 0.85rem;">
                        <!-- Option A -->
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <div style="display: flex; align-items: center; justify-content: center; width: 42px; height: 42px; background: var(--bg-surface-elevated); border: 1px solid var(--border-medium); border-radius: var(--radius-sm); font-weight: 700; color: var(--text-secondary); flex-shrink: 0;">
                                <label style="display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; cursor: pointer;" title="Mark Option A as correct">
                                    <input type="radio" name="correctOptionChoice" value="A" checked style="cursor: pointer;">
                                </label>
                            </div>
                            <input type="text" name="optionA" class="form-control" placeholder="Answer Choice A" required value="<%= optionAVal %>">
                        </div>

                        <!-- Option B -->
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <div style="display: flex; align-items: center; justify-content: center; width: 42px; height: 42px; background: var(--bg-surface-elevated); border: 1px solid var(--border-medium); border-radius: var(--radius-sm); font-weight: 700; color: var(--text-secondary); flex-shrink: 0;">
                                <label style="display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; cursor: pointer;" title="Mark Option B as correct">
                                    <input type="radio" name="correctOptionChoice" value="B" style="cursor: pointer;">
                                </label>
                            </div>
                            <input type="text" name="optionB" class="form-control" placeholder="Answer Choice B" required value="<%= optionBVal %>">
                        </div>

                        <!-- Option C -->
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <div style="display: flex; align-items: center; justify-content: center; width: 42px; height: 42px; background: var(--bg-surface-elevated); border: 1px solid var(--border-medium); border-radius: var(--radius-sm); font-weight: 700; color: var(--text-secondary); flex-shrink: 0;">
                                <label style="display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; cursor: pointer;" title="Mark Option C as correct">
                                    <input type="radio" name="correctOptionChoice" value="C" style="cursor: pointer;">
                                </label>
                            </div>
                            <input type="text" name="optionC" class="form-control" placeholder="Answer Choice C" required value="<%= optionCVal %>">
                        </div>

                        <!-- Option D -->
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <div style="display: flex; align-items: center; justify-content: center; width: 42px; height: 42px; background: var(--bg-surface-elevated); border: 1px solid var(--border-medium); border-radius: var(--radius-sm); font-weight: 700; color: var(--text-secondary); flex-shrink: 0;">
                                <label style="display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; cursor: pointer;" title="Mark Option D as correct">
                                    <input type="radio" name="correctOptionChoice" value="D" style="cursor: pointer;">
                                </label>
                            </div>
                            <input type="text" name="optionD" class="form-control" placeholder="Answer Choice D" required value="<%= optionDVal %>">
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/view-questions" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                            <polyline points="17 21 17 13 7 13 7 21"></polyline>
                            <polyline points="7 3 7 8 15 8"></polyline>
                        </svg>
                        <span>Save &amp; Publish Question</span>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Unified Footer Include -->
    <jsp:include page="/includes/footer.jsp" />

</body>
</html>
