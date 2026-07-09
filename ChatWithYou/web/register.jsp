<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChatWithYou - 注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        .register-card {
            width: 100%;
            max-width: 400px;
            padding: 40px;
            background: var(--bg-card);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-medium);
            position: relative;
            z-index: 10;
        }

        .register-logo {
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

        .register-title {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            text-align: center;
            margin-bottom: 8px;
        }

        .register-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
            text-align: center;
            margin-bottom: 30px;
        }

        .register-actions {
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

    <div class="register-card">
        <div class="register-logo">C</div>
        <div class="register-title">创建账号</div>
        <div class="register-subtitle">加入 ChatWithYou 开始聊天</div>

        <% if(request.getAttribute("msg") != null) { %>
        <div class="alert-danger">
            <%= request.getAttribute("msg") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-input" placeholder="请设置登录账号" required>
            </div>

            <div class="form-group">
                <input type="text" name="nickname" class="form-input" placeholder="请设置昵称" required>
            </div>

            <div class="form-group">
                <input type="email" name="email" class="form-input" placeholder="请输入邮箱">
            </div>

            <div class="form-group">
                <input type="password" name="password" class="form-input" placeholder="请设置密码" required>
            </div>

            <div class="form-group">
                <input type="password" name="repassword" class="form-input" placeholder="请确认密码" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 8px;">立即注册</button>
        </form>

        <div class="register-actions">
            已有账号？<a href="${pageContext.request.contextPath}/login.jsp" class="text-link">返回登录</a>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/theme.js"></script>
</body>
</html>