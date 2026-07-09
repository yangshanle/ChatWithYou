<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChatWithYou - 登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        .login-card {
            width: 100%;
            max-width: 380px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            border: 2px solid var(--border-color);
            box-shadow: none;
            position: relative;
            z-index: 10;
        }

        .login-logo {
            width: 48px;
            height: 48px;
            background: var(--accent-primary);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            font-weight: 700;
            color: white;
            margin: 0 auto 20px;
        }

        .login-title {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            text-align: center;
            margin-bottom: 8px;
        }

        .login-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
            text-align: center;
            margin-bottom: 30px;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .form-options label {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            color: var(--text-secondary);
        }

        .form-options input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--accent-primary);
        }

        .login-actions {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--text-secondary);
        }

        .alert-danger {
            font-size: 13px;
            padding: 10px 14px;
            margin-bottom: 18px;
            border-radius: var(--radius-sm);
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
        }
    </style>
</head>
<body>
    <button class="theme-toggle" id="themeToggle" title="切换主题">🎨</button>

    <div class="login-card">
        <div class="login-logo">C</div>
        <div class="login-title">ChatWithYou</div>
        <div class="login-subtitle">登录后开启聊天</div>

        <% if(request.getAttribute("msg") != null) { %>
        <div class="alert-danger">
            <%= request.getAttribute("msg") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-input" placeholder="请输入用户名" required>
            </div>

            <div class="form-group">
                <input type="password" name="password" class="form-input" placeholder="请输入密码" required>
            </div>

            <div class="form-options">
                <label>
                    <input type="checkbox">记住密码
                </label>
                <a href="#" class="text-link">忘记密码？</a>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%;">登录</button>
        </form>

        <div class="login-actions">
            还没有账号？<a href="${pageContext.request.contextPath}/register.jsp" class="text-link">立即注册</a>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/theme.js"></script>
</body>
</html>