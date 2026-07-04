<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ChatWithYou - 注册</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/css/bootstrap.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      height: 100vh;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: linear-gradient(135deg, #dcfce7 0%, #f0fdf4 50%, #ecfdf5 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }
    body::before {
      content: '';
      position: absolute;
      width: 500px;
      height: 500px;
      background: rgba(134, 239, 172, 0.2);
      border-radius: 50%;
      top: -180px;
      left: -180px;
    }
    body::after {
      content: '';
      position: absolute;
      width: 600px;
      height: 600px;
      background: rgba(187, 247, 208, 0.25);
      border-radius: 50%;
      bottom: -220px;
      right: -220px;
    }

    .register-card {
      width: 420px;
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: blur(16px);
      border-radius: 16px;
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      position: relative;
      z-index: 10;
      border: 1px solid rgba(255, 255, 255, 0.6);
    }
    .register-header {
      padding: 40px 40px 20px;
      text-align: center;
    }
    .register-logo {
      width: 68px;
      height: 68px;
      margin: 0 auto 18px;
      border-radius: 16px;
      background: linear-gradient(135deg, #86efac 0%, #bbf7d0 100%);
      color: #166534;
      font-size: 28px;
      font-weight: 600;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(134, 239, 172, 0.3);
    }
    .register-title {
      font-size: 22px;
      font-weight: 600;
      color: #14532d;
      margin-bottom: 6px;
    }
    .register-subtitle {
      font-size: 13px;
      color: #6b7280;
    }

    .register-body {
      padding: 0 40px 32px;
    }
    .form-item {
      margin-bottom: 16px;
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

    .btn-register {
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
    .btn-register:hover {
      filter: brightness(1.05);
      box-shadow: 0 6px 16px rgba(74, 222, 128, 0.35);
    }

    .register-footer {
      padding: 18px;
      border-top: 1px solid #f0fdf4;
      text-align: center;
      font-size: 13px;
      color: #6b7280;
      background: rgba(240, 253, 244, 0.5);
    }
    .register-footer a {
      color: #16a34a;
      text-decoration: none;
      font-weight: 500;
    }
    .register-footer a:hover {
      text-decoration: underline;
    }

    .alert-danger {
      font-size: 13px;
      padding: 10px 14px;
      margin-bottom: 16px;
      border-radius: 8px;
      background: #fef2f2;
      border-color: #fecaca;
      color: #dc2626;
    }
  </style>
</head>
<body>
<div class="register-card">
  <div class="register-header">
    <div class="register-logo">C</div>
    <div class="register-title">创建账号</div>
    <div class="register-subtitle">加入 ChatWithYou 开始聊天</div>
  </div>
  <div class="register-body">
    <% if(request.getAttribute("msg") != null) { %>
    <div class="alert alert-danger" role="alert">
      <%= request.getAttribute("msg") %>
    </div>
    <% } %>
    <form action="${pageContext.request.contextPath}/register" method="post">
      <div class="form-item">
        <input type="text" name="username" placeholder="请设置登录账号" required>
      </div>
      <div class="form-item">
        <input type="text" name="nickname" placeholder="请设置昵称" required>
      </div>
      <div class="form-item">
        <input type="email" name="email" placeholder="请输入邮箱">
      </div>
      <div class="form-item">
        <input type="password" name="password" placeholder="请设置密码" required>
      </div>
      <div class="form-item">
        <input type="password" name="repassword" placeholder="请确认密码" required>
      </div>
      <button type="submit" class="btn-register">立即注册</button>
    </form>
  </div>
  <div class="register-footer">
    已有账号？<a href="${pageContext.request.contextPath}/login.jsp">返回登录</a>
  </div>
</div>
<script src="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
</body>
</html>