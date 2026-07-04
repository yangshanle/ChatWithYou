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
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>个人主页 - ChatWithYou</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/css/bootstrap.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      min-height: 100vh;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: linear-gradient(135deg, #dcfce7 0%, #f0fdf4 50%, #ecfdf5 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 0;
      overflow-y: auto;
      position: relative;
    }
    body::before {
      content: '';
      position: fixed;
      width: 500px;
      height: 500px;
      background: rgba(134, 239, 172, 0.2);
      border-radius: 50%;
      top: -180px;
      left: -180px;
      pointer-events: none;
    }
    body::after {
      content: '';
      position: fixed;
      width: 600px;
      height: 600px;
      background: rgba(187, 247, 208, 0.25);
      border-radius: 50%;
      bottom: -220px;
      right: -220px;
      pointer-events: none;
    }

    .profile-card {
      width: 460px;
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: blur(16px);
      border-radius: 16px;
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      position: relative;
      z-index: 10;
      border: 1px solid rgba(255, 255, 255, 0.6);
    }
    .profile-header {
      padding: 32px 40px 20px;
      text-align: center;
      border-bottom: 1px solid #f0fdf4;
      background: rgba(240, 253, 244, 0.5);
      position: relative;
    }
    .profile-avatar {
      width: 72px;
      height: 72px;
      margin: 0 auto 14px;
      border-radius: 50%;
      background: linear-gradient(135deg, #86efac 0%, #bbf7d0 100%);
      color: #166534;
      font-size: 30px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(134, 239, 172, 0.3);
    }
    .profile-name {
      font-size: 20px;
      font-weight: 600;
      color: #14532d;
      margin-bottom: 4px;
    }
    .profile-username {
      font-size: 13px;
      color: #6b7280;
    }
    .back-btn {
      position: absolute;
      top: 20px;
      left: 20px;
      color: #16a34a;
      text-decoration: none;
      font-size: 13px;
      font-weight: 500;
    }
    .back-btn:hover {
      text-decoration: underline;
    }

    .profile-body {
      padding: 24px 40px 32px;
    }
    .form-item {
      margin-bottom: 16px;
    }
    .form-item label {
      display: block;
      font-size: 13px;
      color: #374151;
      margin-bottom: 6px;
      font-weight: 500;
    }
    .form-item input {
      width: 100%;
      height: 42px;
      border: 1px solid #d1fae5;
      border-radius: 10px;
      padding: 0 16px;
      font-size: 14px;
      outline: none;
      transition: all 0.3s;
      background: rgba(255, 255, 255, 0.7);
    }
    .form-item input:focus {
      border-color: #86efac;
      background: white;
      box-shadow: 0 0 0 3px rgba(134, 239, 172, 0.2);
    }
    .form-item input:disabled {
      background: #f3f4f6;
      color: #9ca3af;
      cursor: not-allowed;
    }
    .divider {
      margin: 20px 0;
      border-top: 1px solid #e5e7eb;
      position: relative;
    }
    .divider span {
      position: absolute;
      top: -10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(255,255,255,0.85);
      padding: 0 10px;
      font-size: 12px;
      color: #9ca3af;
    }

    .btn-save {
      width: 100%;
      height: 44px;
      border: none;
      border-radius: 10px;
      background: linear-gradient(90deg, #4ade80 0%, #86efac 100%);
      color: #166534;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      box-shadow: 0 4px 12px rgba(74, 222, 128, 0.25);
      margin-top: 8px;
    }
    .btn-save:hover {
      filter: brightness(1.05);
      box-shadow: 0 6px 16px rgba(74, 222, 128, 0.35);
    }

    .alert {
      font-size: 13px;
      padding: 10px 14px;
      margin-bottom: 16px;
      border-radius: 8px;
      text-align: center;
    }
    .alert-success {
      background: #f0fdf4;
      color: #166534;
      border: 1px solid #bbf7d0;
    }
    .alert-danger {
      background: #fef2f2;
      color: #dc2626;
      border: 1px solid #fecaca;
    }

    @media (max-width: 500px) {
      .profile-card {
        width: 92%;
      }
      .profile-body {
        padding: 20px 24px 28px;
      }
      .profile-header {
        padding: 28px 24px 18px;
      }
    }
  </style>
</head>
<body>
<div class="profile-card">
  <a href="${pageContext.request.contextPath}/index.jsp" class="back-btn">← 返回聊天</a>
  <div class="profile-header">
    <div class="profile-avatar">
      <%= user.getNickname().charAt(user.getNickname().length() - 1) %>
    </div>
    <div class="profile-name"><%= user.getNickname() %></div>
    <div class="profile-username">账号：<%= user.getUsername() %></div>
  </div>
  <div class="profile-body">
    <% if(request.getAttribute("msg") != null) {
      String msg = (String) request.getAttribute("msg");
      String alertClass = "保存成功".equals(msg) ? "alert-success" : "alert-danger";
    %>
    <div class="alert <%= alertClass %>" role="alert">
      <%= msg %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/profile" method="post">
      <div class="form-item">
        <label>登录账号</label>
        <input type="text" value="<%= user.getUsername() %>" disabled>
      </div>
      <div class="form-item">
        <label>昵称</label>
        <input type="text" name="nickname" value="<%= user.getNickname() %>" required>
      </div>
      <div class="form-item">
        <label>邮箱</label>
        <input type="email" name="email" value="<%= user.getEmail() == null ? "" : user.getEmail() %>">
      </div>

      <div class="divider"><span>修改密码（不修改留空即可）</span></div>

      <div class="form-item">
        <label>旧密码</label>
        <input type="password" name="oldPassword" placeholder="请输入旧密码">
      </div>
      <div class="form-item">
        <label>新密码</label>
        <input type="password" name="newPassword" placeholder="至少6位">
      </div>
      <div class="form-item">
        <label>确认新密码</label>
        <input type="password" name="reNewPassword" placeholder="再次输入新密码">
      </div>

      <button type="submit" class="btn-save">保存修改</button>
    </form>
  </div>
</div>
<script src="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
</body>
</html>