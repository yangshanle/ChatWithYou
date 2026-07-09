<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="liyu.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<User> userList = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台管理 - ChatWithYou</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        body {
            min-height: 100vh;
            padding-top: 0;
        }

        .admin-header {
            background: var(--accent-dark);
            color: white;
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow-light);
        }

        .admin-header h1 { 
            font-size: 20px; 
            font-weight: 600; 
            margin: 0;
        }

        .admin-header .nav-links { 
            display: flex; 
            gap: 16px; 
        }

        .admin-header .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: 0.2s;
            font-size: 13px;
        }

        .admin-header .nav-links a:hover { 
            background: rgba(255,255,255,0.15); 
        }

        .admin-container { 
            max-width: 1200px; 
            margin: 32px auto; 
            padding: 0 24px; 
        }

        .table-container {
            background: var(--bg-card);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-medium);
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .table-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h2 { 
            font-size: 16px; 
            font-weight: 600; 
            color: var(--text-primary); 
            margin: 0;
        }

        .search-input {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 14px;
            width: 200px;
            outline: none;
            background: var(--accent-bg);
        }

        .search-input:focus {
            border-color: var(--accent-primary);
            background: white;
        }

        table { 
            width: 100%; 
            border-collapse: collapse; 
        }
        
        th {
            background: var(--accent-light);
            padding: 14px 24px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 1px solid var(--border-color);
        }
        
        td {
            padding: 14px 24px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-primary);
        }
        
        tr:hover { 
            background: var(--accent-light); 
        }

        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 600;
        }

        .role-admin { 
            background: rgba(59, 130, 246, 0.1); 
            color: #3b82f6; 
        }

        .role-user { 
            background: var(--accent-light); 
            color: var(--accent-dark); 
        }

        .btn {
            padding: 6px 16px;
            border: none;
            border-radius: var(--radius-sm);
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-edit { 
            background: rgba(96, 165, 250, 0.1); 
            color: #3b82f6; 
        }

        .btn-edit:hover { 
            background: rgba(96, 165, 250, 0.2); 
        }

        .btn-delete { 
            background: rgba(239, 68, 68, 0.1); 
            color: #dc2626; 
        }

        .btn-delete:hover { 
            background: rgba(239, 68, 68, 0.2); 
        }

        .modal-mask {
            position: fixed;
            top: 0; 
            left: 0; 
            right: 0; 
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-box {
            background: var(--bg-card);
            border-radius: var(--radius-md);
            padding: 24px;
            width: 360px;
            box-shadow: var(--shadow-hover);
            border: 1px solid var(--border-color);
        }

        .modal-box h3 { 
            font-size: 16px; 
            margin-bottom: 16px; 
            color: var(--text-primary);
        }

        .modal-box p { 
            color: var(--text-secondary); 
            margin-bottom: 20px; 
        }

        .modal-actions { 
            display: flex; 
            gap: 12px; 
            justify-content: flex-end; 
        }

        .modal-btn { 
            padding: 8px 20px; 
            border-radius: var(--radius-sm); 
            border: none; 
            cursor: pointer; 
            font-size: 14px; 
        }

        .modal-btn-cancel { 
            background: var(--accent-bg); 
            color: var(--text-primary); 
        }

        .modal-btn-cancel:hover {
            background: var(--border-color);
        }

        .modal-btn-confirm { 
            background: #ef4444; 
            color: white; 
        }

        .role-select {
            padding: 6px 12px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 14px;
            outline: none;
            background: white;
        }

        .role-select:focus { 
            border-color: var(--accent-primary); 
        }

        .empty-tip { 
            padding: 60px; 
            text-align: center; 
            color: var(--text-secondary); 
        }
    </style>
</head>
<body>
    <button class="theme-toggle" id="themeToggle" title="切换主题">🎨</button>

    <div class="admin-header">
        <h1>🔧 ChatWithYou 后台管理</h1>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">返回聊天</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>

    <div class="admin-container">
        <div class="table-container">
            <div class="table-header">
                <h2>用户管理</h2>
                <input type="text" class="search-input" placeholder="搜索用户名..." id="searchInput">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>昵称</th>
                        <th>邮箱</th>
                        <th>角色</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="userTable">
                    <% if (userList != null && !userList.isEmpty()) { %>
                        <% for (User user : userList) { %>
                        <tr data-id="<%= user.getId() %>">
                            <td><%= user.getId() %></td>
                            <td><%= user.getUsername() %></td>
                            <td><%= user.getNickname() != null ? user.getNickname() : "-" %></td>
                            <td><%= user.getEmail() != null ? user.getEmail() : "-" %></td>
                            <td>
                                <span class="role-badge <%= user.getRole() != null && user.getRole() == 1 ? "role-admin" : "role-user" %>">
                                    <%= user.getRole() != null && user.getRole() == 1 ? "管理员" : "普通用户" %>
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-edit" onclick="showEditModal(<%= user.getId() %>)">编辑</button>
                                <button class="btn btn-delete" onclick="showDeleteModal(<%= user.getId() %>)">删除</button>
                            </td>
                        </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="6" class="empty-tip">暂无用户数据</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal-mask" id="deleteModal">
        <div class="modal-box">
            <h3>确认删除</h3>
            <p>确定要删除该用户吗？此操作不可撤销。</p>
            <div class="modal-actions">
                <button class="modal-btn modal-btn-cancel" onclick="hideDeleteModal()">取消</button>
                <button class="modal-btn modal-btn-confirm" id="confirmDeleteBtn">确认删除</button>
            </div>
        </div>
    </div>

    <div class="modal-mask" id="editModal">
        <div class="modal-box">
            <h3>编辑用户</h3>
            <div style="margin-bottom: 16px;">
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">用户名</label>
                    <input type="text" id="editUsername" readonly style="width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: var(--radius-sm); background: var(--accent-bg); color: var(--text-secondary);">
                </div>
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">昵称</label>
                    <input type="text" id="editNickname" style="width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: var(--radius-sm);">
                </div>
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">邮箱</label>
                    <input type="text" id="editEmail" style="width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: var(--radius-sm);">
                </div>
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px;">角色</label>
                    <select id="editRole" style="width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: var(--radius-sm);">
                        <option value="0">普通用户</option>
                        <option value="1">管理员</option>
                    </select>
                </div>
            </div>
            <div class="modal-actions">
                <button class="modal-btn modal-btn-cancel" onclick="hideEditModal()">取消</button>
                <button class="modal-btn modal-btn-confirm" onclick="saveEdit()">保存</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/theme.js"></script>
    <script>
        let deleteUserId = null;
        let editUserId = null;

        function showDeleteModal(id) {
            deleteUserId = id;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        function hideDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            deleteUserId = null;
        }

        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (deleteUserId) {
                window.location.href = '${pageContext.request.contextPath}/admin?action=delete&id=' + deleteUserId;
            }
        });

        document.getElementById('searchInput').addEventListener('input', function() {
            const keyword = this.value.toLowerCase();
            const rows = document.querySelectorAll('#userTable tr');
            rows.forEach(row => {
                const username = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const nickname = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                if (username.includes(keyword) || nickname.includes(keyword)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        function showEditModal(id) {
            editUserId = id;
            const row = document.querySelector('tr[data-id="' + id + '"]');
            if (row) {
                document.getElementById('editUsername').value = row.querySelector('td:nth-child(2)').textContent;
                document.getElementById('editNickname').value = row.querySelector('td:nth-child(3)').textContent;
                document.getElementById('editEmail').value = row.querySelector('td:nth-child(4)').textContent;
                const roleText = row.querySelector('td:nth-child(5)').textContent;
                document.getElementById('editRole').value = roleText === '管理员' ? '1' : '0';
            }
            document.getElementById('editModal').style.display = 'flex';
        }

        function hideEditModal() {
            document.getElementById('editModal').style.display = 'none';
            editUserId = null;
        }

        function saveEdit() {
            if (!editUserId) return;

            const nickname = document.getElementById('editNickname').value;
            const email = document.getElementById('editEmail').value;
            const role = document.getElementById('editRole').value;

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/admin', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            xhr.onload = function() {
                if (xhr.status === 200) {
                    try {
                        const result = JSON.parse(xhr.responseText);
                        if (result.success) {
                            alert('修改成功');
                            hideEditModal();
                            window.location.reload();
                        } else {
                            alert('修改失败: ' + result.msg);
                        }
                    } catch (e) {
                        alert('修改失败');
                    }
                } else {
                    alert('请求失败');
                }
            };

            xhr.onerror = function() {
                alert('网络请求失败');
            };

            xhr.send('action=update&userId=' + editUserId + '&nickname=' + encodeURIComponent(nickname) + '&email=' + encodeURIComponent(email) + '&role=' + role);
        }
    </script>
</body>
</html>