<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="liyu.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User user = (User) request.getAttribute("user");
    if (user == null) user = loginUser;
    boolean isOwnProfile = loginUser.getId().equals(user.getId());
    String nickname = user.getNickname() != null ? user.getNickname() : user.getUsername();
    String avatarText = nickname.charAt(nickname.length() - 1) + "";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人主页 - ChatWithYou</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
        }

        .profile-card {
            width: 100%;
            max-width: 460px;
            background: var(--bg-card);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-medium);
            overflow: hidden;
            position: relative;
            z-index: 10;
        }

        .profile-header {
            padding: 32px 40px 20px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            background: var(--accent-light);
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--accent-primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: 700;
            margin: 0 auto 16px;
        }

        .profile-name {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .profile-username {
            font-size: 13px;
            color: var(--text-secondary);
        }

        .profile-body {
            padding: 24px 40px;
        }

        .section-title {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-size: 14px;
            color: var(--text-secondary);
        }

        .info-value {
            font-size: 14px;
            color: var(--text-primary);
            font-weight: 500;
        }

        .info-value input {
            border: none;
            background: none;
            color: var(--text-primary);
            font-size: 14px;
            font-weight: 500;
            text-align: right;
            outline: none;
            width: 150px;
        }

        .btn-edit {
            background: none;
            border: none;
            color: var(--accent-dark);
            font-size: 12px;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 4px;
            transition: 0.2s;
        }

        .btn-edit:hover {
            background: var(--accent-light);
        }

        .profile-footer {
            padding: 20px 40px;
            border-top: 1px solid var(--border-color);
            text-align: center;
        }

        .btn-back {
            font-size: 13px;
            color: var(--text-secondary);
            text-decoration: none;
        }

        .btn-back:hover {
            color: var(--accent-dark);
        }
    </style>
</head>
<body>
    <button class="theme-toggle" id="themeToggle" title="切换主题">🎨</button>

    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-avatar"><%= avatarText %></div>
            <div class="profile-name"><%= nickname %></div>
            <div class="profile-username">@<%= user.getUsername() %></div>
        </div>

        <div class="profile-body">
            <% if (request.getAttribute("msg") != null) { %>
            <div style="padding: 12px; background: var(--accent-light); border-radius: var(--radius-sm); margin-bottom: 16px; text-align: center; color: var(--accent-dark); font-size: 13px;">
                <%= request.getAttribute("msg") %>
            </div>
            <% } %>

            <div class="section-title">基本资料</div>

            <div class="info-item" id="nicknameRow">
                <span class="info-label">昵称</span>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="info-value" id="nicknameDisplay"><%= nickname %></span>
                    <% if (isOwnProfile) { %>
                    <button class="btn-edit" onclick="toggleEdit()">编辑</button>
                    <% } %>
                </div>
            </div>

            <div class="info-item" id="emailRow">
                <span class="info-label">邮箱</span>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="info-value" id="emailDisplay"><%= user.getEmail() != null ? user.getEmail() : "未绑定" %></span>
                    <% if (isOwnProfile) { %>
                    <button class="btn-edit" onclick="toggleEdit()">编辑</button>
                    <% } %>
                </div>
            </div>

            <div class="info-item">
                <span class="info-label">角色</span>
                <span class="info-value"><%= user.getRole() != null && user.getRole() == 1 ? "管理员" : "普通用户" %></span>
            </div>

            <% if (isOwnProfile) { %>
            <div class="section-title" style="margin-top: 20px;">账号安全</div>

            <div class="info-item">
                <span class="info-label">修改密码</span>
                <a href="#" class="text-link" style="font-size: 13px;" onclick="showChangePassword()">点击修改</a>
            </div>
            <% } %>
        </div>

        <div class="profile-footer">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn-back">← 返回消息页面</a>
        </div>
    </div>

    <div class="modal-mask" id="passwordModal">
        <div class="modal-box" style="width: 380px;">
            <h3>修改密码</h3>
            <form id="passwordForm" action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="nickname" value="<%= nickname %>">
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">旧密码</label>
                    <input type="password" name="oldPassword" required class="form-input">
                </div>
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">新密码</label>
                    <input type="password" name="newPassword" required minlength="6" class="form-input">
                </div>
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">确认新密码</label>
                    <input type="password" name="reNewPassword" required class="form-input">
                </div>
                <div style="display: flex; gap: 10px;">
                    <button type="button" onclick="hideChangePassword()" style="flex: 1; padding: 12px; border: 1px solid var(--border-color); border-radius: var(--radius-md); font-size: 14px; font-weight: 500; cursor: pointer; transition: 0.2s; background: white; color: var(--text-primary);">取消</button>
                    <button type="submit" style="flex: 1; padding: 12px; border: none; border-radius: var(--radius-md); font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.2s; background: var(--accent-dark); color: white;">保存</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-mask" id="editModal">
        <div class="modal-box" style="width: 380px;">
            <h3>编辑资料</h3>
            <form id="editForm" action="${pageContext.request.contextPath}/profile" method="post">
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">昵称</label>
                    <input type="text" name="nickname" id="editNickname" required class="form-input">
                </div>
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">邮箱</label>
                    <input type="email" name="email" id="editEmail" class="form-input">
                </div>
                <div style="display: flex; gap: 10px;">
                    <button type="button" onclick="hideEdit()" style="flex: 1; padding: 12px; border: 1px solid var(--border-color); border-radius: var(--radius-md); font-size: 14px; font-weight: 500; cursor: pointer; transition: 0.2s; background: white; color: var(--text-primary);">取消</button>
                    <button type="submit" style="flex: 1; padding: 12px; border: none; border-radius: var(--radius-md); font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.2s; background: var(--accent-dark); color: white;">保存</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/theme.js"></script>
    <script>
        function toggleEdit() {
            var nickname = document.getElementById('nicknameDisplay').textContent;
            var email = document.getElementById('emailDisplay').textContent;
            if (email === '未绑定') email = '';
            document.getElementById('editNickname').value = nickname;
            document.getElementById('editEmail').value = email;
            document.getElementById('editModal').style.display = 'flex';
        }

        function hideEdit() {
            document.getElementById('editModal').style.display = 'none';
            document.getElementById('editForm').reset();
        }

        function showChangePassword() {
            document.getElementById('passwordModal').style.display = 'flex';
        }

        function hideChangePassword() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
        }
    </script>
</body>
</html>