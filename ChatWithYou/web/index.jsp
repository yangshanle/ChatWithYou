<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="liyu.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String nickname = loginUser.getUsername();
    String avatarText = nickname.charAt(nickname.length() - 1) + "";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChatWithYou - 消息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/css/bootstrap.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            overflow: hidden;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
            color: #1f2937;
            background: #f7f9f7;
            transition: background 0.3s, color 0.3s;
        }

        /* ========== 暗黑主题：分区深色界面 ========== */
        body.dark {
            color: #e8eaf6;
            background: #121212;
        }

        body.dark .top-nav {
            background: #1e1e1e;
            border-bottom: 1px solid #2f2f2f;
            color: #e8eaf6;
        }

        body.dark .nav-logo {
            color: #e8eaf6;
        }

        body.dark .nav-user a,
        body.dark .nav-user .nav-btn {
            color: #e8eaf6;
        }

        body.dark .nav-user a:hover,
        body.dark .nav-user .nav-btn:hover {
            background: rgba(255, 255, 255, 0.08);
        }

        body.dark .session-panel {
            background: #1e1e1e;
            border-right: 1px solid #2f2f2f;
        }

        body.dark .search-bar {
            background: #1e1e1e;
            border-bottom: 1px solid #2f2f2f;
        }

        body.dark .search-bar input {
            background: #2c2c2c;
            color: #e8eaf6;
            border: 1px solid #3a3a3a;
        }

        body.dark .search-bar input:focus {
            background: #2c2c2c;
            border-color: #69db7c;
            box-shadow: 0 0 0 3px rgba(105, 219, 124, 0.15);
        }

        body.dark .search-result {
            background: #1e1e1e;
            border: 1px solid #2f2f2f;
        }

        body.dark .search-result-item {
            border-bottom: 1px solid #2f2f2f;
            color: #e8eaf6;
        }

        body.dark .search-result-item:hover {
            background: #2c2c2c;
        }

        body.dark .session-item {
            border-bottom: 1px solid #2f2f2f;
        }

        body.dark .session-item:hover {
            background: #2c2c2c;
        }

        body.dark .session-item.active {
            background: #2a2a2a;
            border-left: 3px solid #69db7c;
        }

        body.dark .session-name {
            color: #e8eaf6;
        }

        body.dark .session-last-msg {
            color: #a0a0a0;
        }

        body.dark .session-time {
            color: #757575;
        }

        body.dark .chat-panel {
            background: #121212;
        }

        body.dark .chat-panel::before {
            background: rgba(18, 18, 18, 0.75);
        }

        body.dark .chat-header {
            background: #1e1e1e;
            border-bottom: 1px solid #2f2f2f;
        }

        body.dark .chat-title {
            color: #e8eaf6;
        }

        body.dark .chat-empty-tip,
        body.dark .chat-empty {
            color: #757575;
        }

        body.dark .msg-bubble {
            background: #2c2c2c;
            color: #e8eaf6;
        }

        body.dark .msg-bubble::after {
            border-right-color: #2c2c2c;
        }

        body.dark .message-row.self .msg-bubble {
            background: #69db7c;
            color: #14532d;
        }

        body.dark .message-row.self .msg-bubble::after {
            border-left-color: #69db7c;
        }

        body.dark .chat-input {
            background: #1e1e1e;
            border-top: 1px solid #2f2f2f;
        }

        body.dark .input-main textarea {
            background: #2c2c2c;
            border: 1px solid #3a3a3a;
            color: #e8eaf6;
        }

        body.dark .input-main textarea:focus {
            background: #2c2c2c;
            border-color: #69db7c;
            box-shadow: 0 0 0 3px rgba(105, 219, 124, 0.15);
        }

        body.dark .input-tools {
            color: #757575;
        }

        body.dark .input-tools span:hover {
            color: #69db7c;
        }

        body.dark .btn-send {
            background: linear-gradient(90deg, #69db7c 0%, #8ce99a 100%);
            color: #14532d;
        }

        body.dark .modal-box {
            background: #1e1e1e;
            border: 1px solid #2f2f2f;
        }

        body.dark .modal-header {
            border-bottom: 1px solid #2f2f2f;
            color: #e8eaf6;
        }

        body.dark .request-item {
            border-bottom: 1px solid #2f2f2f;
        }

        body.dark .request-info .name {
            color: #e8eaf6;
        }

        body.dark .request-info .remark {
            color: #a0a0a0;
        }

        body.dark .btn-refuse {
            background: #2c2c2c;
            color: #e8eaf6;
        }

        body.dark .btn-refuse:hover {
            background: #3a3a3a;
        }

        body.dark .empty-tip,
        body.dark .session-empty {
            color: #757575;
        }

        body.dark .msg-time {
            color: #757575;
        }

        body.dark .msg-status {
            color: #69db7c;
        }

        body.dark .mobile-menu-btn {
            color: #e8eaf6;
        }

        /* ========== 顶部导航栏 ========== */
        .top-nav {
            height: 56px;
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            position: relative;
            z-index: 10;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
        }

        .nav-logo {
            font-size: 18px;
            font-weight: 700;
            color: #166534;
            letter-spacing: 0.5px;
        }

        .nav-user {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }

        .user-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #86efac, #69db7c);
            color: #166534;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 15px;
            flex-shrink: 0;
        }

        .nav-user a,
        .nav-user .nav-btn {
            color: #166534;
            text-decoration: none;
            font-size: 13px;
            cursor: pointer;
            background: none;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            transition: 0.2s;
            position: relative;
        }

        .nav-user a:hover,
        .nav-user .nav-btn:hover {
            background: rgba(22, 101, 52, 0.08);
        }

        .request-dot {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 9px;
            height: 9px;
            border-radius: 50%;
            background: #ef4444;
            display: none;
            box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.25);
        }

        /* ========== 主体布局 ========== */
        .main-container {
            height: calc(100vh - 56px);
            display: flex;
            margin: 16px;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            border: 1px solid #e5e7eb;
            position: relative;
            z-index: 5;
        }

        body.dark .main-container {
            border-color: #2f2f2f;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18);
        }

        /* ========== 左侧会话列表 ========== */
        .session-panel {
            width: 300px;
            background: #ffffff;
            border-right: 2px solid #d1d5db;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            transition: transform 0.3s ease;
            z-index: 20;
            box-shadow: 1px 0 4px rgba(0, 0, 0, 06);
        }

        .search-bar {
            padding: 14px 16px;
            border-bottom: 1px solid #e5e7eb;
            position: relative;
            background: #fafafa;
        }

        .search-bar input {
            width: 100%;
            height: 36px;
            border-radius: 8px;
            border: 1px solid transparent;
            background: #f3f4f6;
            padding: 0 16px;
            font-size: 14px;
            outline: none;
            transition: 0.25s;
        }

        .search-bar input:focus {
            background: #ffffff;
            border-color: #69db7c;
            box-shadow: 0 0 0 3px rgba(105, 219, 124, 0.15);
        }

        .search-result {
            position: absolute;
            top: 58px;
            left: 16px;
            right: 16px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            max-height: 320px;
            overflow-y: auto;
            z-index: 100;
            display: none;
            border: 1px solid #e5e7eb;
        }

        .search-result-item {
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f3f4f6;
            cursor: pointer;
            font-size: 14px;
            transition: 0.2s;
            color: #1f2937;
        }

        .search-result-item:hover {
            background: #f0fdf4;
        }

        .search-result-item:last-child {
            border-bottom: none;
        }

        .add-friend-btn {
            font-size: 12px;
            color: #16a34a;
            cursor: pointer;
            padding: 4px 12px;
            border-radius: 12px;
            background: #dcfce7;
            transition: 0.2s;
            font-weight: 600;
        }

        .add-friend-btn:hover {
            background: #69db7c;
            color: #166534;
        }

        .session-list {
            flex: 1;
            overflow-y: auto;
        }

        .session-empty {
            padding: 70px 20px;
            text-align: center;
            color: #9ca3af;
            font-size: 13px;
        }

        .session-item {
            padding: 14px 16px;
            display: flex;
            gap: 14px;
            cursor: pointer;
            border-bottom: 1px solid #f3f4f6;
            transition: 0.2s;
        }

        .session-item:hover {
            background: #f9fafb;
        }

        .session-item.active {
            background: #f0fdf4;
            border-left: 3px solid #69db7c;
            padding-left: 13px;
        }

        .session-avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #86efac, #69db7c);
            color: #166534;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
        }

        .session-info {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .session-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .session-name {
            font-size: 15px;
            font-weight: 600;
            color: #1f2937;
        }

        .session-time {
            font-size: 11px;
            color: #9ca3af;
        }

        .session-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .session-last-msg {
            font-size: 12px;
            color: #6b7280;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex: 1;
        }

        .unread-badge {
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 9px;
            background: #ef4444;
            color: #ffffff;
            font-size: 11px;
            font-weight: 600;
            display: none;
            align-items: center;
            justify-content: center;
            margin-left: 8px;
        }

        /* ========== 移动端菜单按钮 ========== */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: inherit;
            margin-right: 12px;
            padding: 4px 8px;
            border-radius: 6px;
        }

        .mobile-menu-btn:hover {
            background: rgba(0, 0, 0, 0.05);
        }

        /* ========== 右侧聊天窗口 ========== */
        .chat-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            position: relative;
            background: #fafafa;
            /* ========== 聊天背景图修改位置 ========== */
            /* background: url('${pageContext.request.contextPath}/image/你的背景图.jpg') center/cover no-repeat; */
        }

        .chat-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(255, 255, 255, 0.35);
            pointer-events: none;
            z-index: 0;
        }

        .chat-header {
            height: 56px;
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            padding: 0 24px;
            gap: 14px;
            position: relative;
            z-index: 2;
        }

        .chat-title {
            font-size: 16px;
            font-weight: 600;
            color: #1f2937;
            display: none;
        }

        .chat-empty-tip {
            color: #6b7280;
            font-size: 14px;
        }

        /* ========== 消息区域 ========== */
        .chat-messages {
            flex: 1;
            padding: 24px 32px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 18px;
            position: relative;
            z-index: 1;
        }

        .chat-empty {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #9ca3af;
            font-size: 14px;
        }

        .message-row {
            display: flex;
            gap: 12px;
            max-width: 65%;
            animation: msgFadeIn 0.25s ease-out;
        }

        @keyframes msgFadeIn {
            from {
                opacity: 0;
                transform: translateY(6px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message-row.self {
            align-self: flex-end;
            flex-direction: row-reverse;
        }

        .msg-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e5e7eb;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #374151;
            font-size: 15px;
            font-weight: 700;
        }

        .message-row.self .msg-avatar {
            background: linear-gradient(135deg, #86efac, #69db7c);
            color: #166534;
        }

        .msg-bubble-wrap {
            display: flex;
            flex-direction: column;
            gap: 4px;
            max-width: 100%;
        }

        .msg-bubble {
            padding: 12px 16px;
            border-radius: 18px;
            background: #ffffff;
            color: #1f2937;
            font-size: 14.5px;
            line-height: 1.6;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
            word-break: break-word;
            border-top-left-radius: 4px;
            position: relative;
        }

        .msg-bubble::after {
            content: '';
            position: absolute;
            left: -6px;
            top: 14px;
            width: 0;
            height: 0;
            border: 6px solid transparent;
            border-right-color: #ffffff;
        }

        .message-row.self .msg-bubble {
            background: #dcfce7;
            color: #14532d;
            border-top-left-radius: 18px;
            border-top-right-radius: 4px;
        }

        .message-row.self .msg-bubble::after {
            left: auto;
            right: -6px;
            border-right-color: transparent;
            border-left-color: #dcfce7;
        }

        .msg-meta {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: #9ca3af;
        }

        .message-row.self .msg-meta {
            justify-content: flex-end;
        }

        .msg-time {
            color: #9ca3af;
        }

        .msg-status {
            color: #22c55e;
        }

        /* ========== 输入区域 ========== */
        .chat-input {
            background: #ffffff;
            border-top: 1px solid #e5e7eb;
            padding: 14px 24px 18px;
            position: relative;
            z-index: 2;
            box-shadow: 0 -1px 4px rgba(0, 0, 0, 0.04);
        }

        .input-tools {
            display: flex;
            gap: 20px;
            margin-bottom: 10px;
            color: #6b7280;
            font-size: 19px;
        }

        .input-tools span {
            cursor: pointer;
            transition: 0.2s;
            padding: 2px;
            border-radius: 4px;
        }

        .input-tools span:hover {
            color: #16a34a;
            transform: scale(1.15);
        }

        .input-main {
            display: flex;
            gap: 14px;
            align-items: flex-end;
        }

        .input-main textarea {
            flex: 1;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 12px 16px;
            resize: none;
            height: 72px;
            outline: none;
            font-size: 14.5px;
            font-family: inherit;
            transition: 0.25s;
            background: #f9fafb;
        }

        .input-main textarea:focus {
            border-color: #69db7c;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(105, 219, 124, 0.15);
        }

        .btn-send {
            padding: 0 28px;
            height: 42px;
            border-radius: 10px;
            background: linear-gradient(90deg, #69db7c 0%, #8ce99a 100%);
            color: #14532d;
            border: none;
            font-size: 14.5px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.25s;
        }

        .btn-send:hover {
            filter: brightness(1.05);
            box-shadow: 0 4px 12px rgba(105, 219, 124, 0.25);
        }

        .btn-send:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            box-shadow: none;
        }

        /* ========== 滚动条美化 ========== */
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }

        ::-webkit-scrollbar-track {
            background: transparent;
        }

        /* ========== 弹窗样式 ========== */
        .modal-mask {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.45);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            animation: fadeIn 0.2s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .modal-box {
            width: 420px;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            animation: slideUp 0.25s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            padding: 18px 22px;
            border-bottom: 1px solid #e5e7eb;
            font-weight: 600;
            font-size: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #1f2937;
        }

        .modal-close {
            cursor: pointer;
            color: #9ca3af;
            font-size: 20px;
            line-height: 1;
            transition: 0.2s;
        }

        .modal-close:hover {
            color: #374151;
        }

        .modal-body {
            padding: 8px 0;
            max-height: 420px;
            overflow-y: auto;
        }

        .request-item {
            padding: 14px 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f3f4f6;
        }

        .request-item:last-child {
            border-bottom: none;
        }

        .request-info .name {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .request-info .remark {
            font-size: 12px;
            color: #6b7280;
        }

        .request-op button {
            padding: 5px 14px;
            font-size: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-left: 8px;
            transition: 0.2s;
            font-weight: 600;
        }

        .btn-agree {
            background: #69db7c;
            color: #14532d;
        }

        .btn-agree:hover {
            filter: brightness(1.05);
        }

        .btn-refuse {
            background: #f3f4f6;
            color: #4b5563;
        }

        .btn-refuse:hover {
            background: #e5e7eb;
        }

        .empty-tip {
            padding: 50px;
            text-align: center;
            color: #9ca3af;
            font-size: 13px;
        }


        /* ========== 响应式适配 ========== */
        @media (max-width: 768px) {
            .main-container {
                margin: 0;
                border-radius: 0;
            }

            .mobile-menu-btn {
                display: block;
            }

            .session-panel {
                position: absolute;
                top: 0;
                left: 0;
                height: 100%;
                width: 85%;
                max-width: 300px;
                transform: translateX(-100%);
                transition: transform 0.3s ease !important; /* 加!important */
                box-shadow: 2px 0 12px rgba(0, 0, 0, 0.06);
            }

            .session-panel.show {
                transform: translateX(0) !important;
            }

            .chat-messages {
                padding: 16px 20px;
            }

            .message-row {
                max-width: 80%;
            }

            .chat-header {
                padding: 0 16px;
            }

            .chat-input {
                padding: 12px 16px 16px;
            }
        }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<div class="top-nav">
    <div class="nav-logo">ChatWithYou</div>
    <div class="nav-user">
        <div class="user-avatar"><%= avatarText %></div>
        <span><%= nickname %></span>
        <button class="nav-btn" id="themeToggle" title="切换主题">🌓</button>
        <button class="nav-btn" id="profileBtn">个人主页</button>
        <button class="nav-btn" id="requestBtn">
            好友申请
            <span class="request-dot" id="requestDot"></span>
        </button>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<!-- 主体内容 -->
<div class="main-container">
    <!-- 左侧会话列表 -->
    <div class="session-panel" id="sessionPanel">
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="搜索用户 / 添加好友">
            <div class="search-result" id="searchResult"></div>
        </div>
        <div class="session-list" id="friendList">
            <div class="session-empty">加载中...</div>
        </div>
    </div>

    <!-- 右侧聊天窗口 -->
    <div class="chat-panel">
        <div class="chat-header">
            <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
            <div class="chat-empty-tip" id="chatHeaderTip">请选择左侧好友开始聊天</div>
            <div class="chat-title" id="chatTitle"></div>
        </div>
        <div class="chat-messages" id="msgContainer">
            <div class="chat-empty">选择好友后开始对话</div>
        </div>
        <div class="chat-input">
            <div class="input-tools">
                <span title="表情">😊</span>
                <span title="图片">🖼️</span>
                <span title="文件">📁</span>
                <span title="语音消息">🎤</span>
            </div>
            <div class="input-main">
                <textarea id="msgInput" placeholder="选择好友后发送消息" disabled></textarea>
                <button class="btn-send" id="sendBtn" disabled>发送</button>
            </div>
        </div>
    </div>
</div>

<!-- 好友申请弹窗 -->
<div class="modal-mask" id="requestModal">
    <div class="modal-box">
        <div class="modal-header">
            <span>好友申请</span>
            <span class="modal-close" id="closeModal">×</span>
        </div>
        <div class="modal-body" id="requestList">
            <div class="empty-tip">加载中...</div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
<script>
    const ctx = '${pageContext.request.contextPath}';
    const userAvatarText = '<%= avatarText %>';
    const userId = <%= loginUser.getId() %>;
    let currentFriendId = null;
    let currentFriendName = '';
    let msgTimer = null;
    let lastMsgId = 0;

    window.onload = function() {
        initTheme();
        loadFriendList();
        initSearch();
        initRequestModal();
        initSendMsg();
        refreshRequestDot();
        initShortcuts();
        initMobileMenu();

        document.getElementById('profileBtn').addEventListener('click', function() {
            window.location.href = ctx + '/profile';
        });
    };

    function startMsgPolling() {
        if (msgTimer) clearInterval(msgTimer);
        msgTimer = setInterval(function() {
            if (currentFriendId) {
                const xhr = new XMLHttpRequest();
                xhr.open('GET', ctx + '/getPrivateMsg?friendId=' + currentFriendId, true);
                xhr.onload = function() {
                    if (xhr.status !== 200) return;
                    try {
                        const list = JSON.parse(xhr.responseText);
                        if (list.length === 0) return;

                        let hasNew = false;
                        for (let i = 0; i < list.length; i++) {
                            if (list[i].id > lastMsgId) {
                                hasNew = true;
                                break;
                            }
                        }

                        if (hasNew) {
                            appendNewMessages(list);
                        }
                    } catch (e) {
                        console.error('消息解析失败:', e);
                    }
                };
                xhr.onerror = function() {
                    console.error('消息轮询请求失败');
                };
                xhr.send();
            }
        }, 2000);
    }

    function appendNewMessages(list) {
        const msgContainer = document.getElementById('msgContainer');
        let hasNew = false;
        for (let i = 0; i < list.length; i++) {
            const msg = list[i];
            if (msg.id > lastMsgId) {
                msgContainer.insertAdjacentHTML('beforeend', buildMsgHtml(msg));
                lastMsgId = msg.id;
                hasNew = true;
            }
        }
        if (hasNew) {
            msgContainer.scrollTop = msgContainer.scrollHeight;
            loadFriendList();
        }
    }

    function stopMsgPolling() {
        if (msgTimer) {
            clearInterval(msgTimer);
            msgTimer = null;
        }
    }

    function appendMessage(msg) {
        const msgContainer = document.getElementById('msgContainer');
        if (msgContainer.querySelector('.chat-empty')) {
            msgContainer.innerHTML = '';
        }
        msgContainer.insertAdjacentHTML('beforeend', buildMsgHtml(msg));
        msgContainer.scrollTop = msgContainer.scrollHeight;
        if (msg.id) {
            lastMsgId = msg.id;
        }
    }

    function initTheme() {
        const saved = localStorage.getItem('chat-theme');
        if (saved === 'dark') {
            document.body.classList.add('dark');
        }
        document.getElementById('themeToggle').addEventListener('click', function() {
            document.body.classList.toggle('dark');
            const isDark = document.body.classList.contains('dark');
            localStorage.setItem('chat-theme', isDark ? 'dark' : 'light');
        });
    }

    function initShortcuts() {
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key.toLowerCase() === 'f') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
            if (e.key === 'Escape') {
                document.getElementById('requestModal').style.display = 'none';
            }
        });
    }

    function initMobileMenu() {
        const menuBtn = document.getElementById('mobileMenuBtn');
        const panel = document.getElementById('sessionPanel');
        menuBtn.addEventListener('click', function() {
            panel.classList.toggle('show');
        });
        document.querySelector('.chat-panel').addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                panel.classList.remove('show');
            }
        });
    }

    function formatTime(timestamp) {
        if (!timestamp) return '';
        const date = new Date(timestamp);
        const now = new Date();
        const diff = now - date;
        if (diff < 60000) return '刚刚';
        if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前';
        return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
    }

    function loadFriendList() {
        const friendListEl = document.getElementById('friendList');
        const xhr = new XMLHttpRequest();
        xhr.open('GET', ctx + '/friendList', true);
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);
                if (list.length === 0) {
                    friendListEl.innerHTML = '<div class="session-empty">暂无好友，去搜索添加吧</div>';
                    return;
                }
                let html = '';
                for (let i = 0; i < list.length; i++) {
                    const friend = list[i];
                    const name = friend.username;
                    const avatarChar = name.charAt(name.length - 1);
                    const unread = friend.unread || 0;
                    const unreadHtml = unread > 0 ? '<span class="unread-badge" style="display:flex;">' + unread + '</span>' : '<span class="unread-badge"></span>';
                    html += '<div class="session-item" data-id="' + friend.id + '" data-name="' + name + '">' +
                        '<div class="session-avatar">' + avatarChar + '</div>' +
                        '<div class="session-info">' +
                        '<div class="session-top">' +
                        '<div class="session-name">' + name + '</div>' +
                        '<span class="session-time"></span>' +
                        '</div>' +
                        '<div class="session-bottom">' +
                        '<div class="session-last-msg">点击开始聊天</div>' +
                        unreadHtml +
                        '</div>' +
                        '</div>' +
                        '</div>';
                }
                friendListEl.innerHTML = html;

                const items = document.querySelectorAll('.session-item');
                for (let i = 0; i < items.length; i++) {
                    items[i].addEventListener('click', function() {
                        for (let j = 0; j < items.length; j++) {
                            items[j].classList.remove('active');
                        }
                        this.classList.add('active');
                        currentFriendId = this.getAttribute('data-id');
                        currentFriendName = this.getAttribute('data-name');
                        lastMsgId = 0;
                        openChatWindow(currentFriendName);
                        loadHistoryMsg();
                        startMsgPolling();
                        if (window.innerWidth <= 768) {
                            document.getElementById('sessionPanel').classList.remove('show');
                        }
                    });
                }
            } catch (e) {
                console.error('加载好友列表失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('加载好友列表请求失败');
        };
        xhr.send();
    }

    function openChatWindow(name) {
        document.getElementById('chatHeaderTip').style.display = 'none';
        document.getElementById('chatTitle').style.display = 'block';
        document.getElementById('chatTitle').innerText = name;
        document.getElementById('msgInput').disabled = false;
        document.getElementById('sendBtn').disabled = false;
        document.getElementById('msgInput').placeholder = '输入消息...';
    }

    function loadHistoryMsg() {
        if (!currentFriendId) return;
        const msgContainer = document.getElementById('msgContainer');
        const xhr = new XMLHttpRequest();
        xhr.open('GET', ctx + '/getPrivateMsg?friendId=' + currentFriendId, true);
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);

                if (lastMsgId === 0 || msgContainer.querySelector('.chat-empty')) {
                    msgContainer.innerHTML = '';
                    if (list.length === 0) {
                        msgContainer.innerHTML = '<div class="chat-empty">暂无消息，开始对话吧</div>';
                        lastMsgId = 0;
                        return;
                    }
                    let html = '';
                    for (let i = 0; i < list.length; i++) {
                        const msg = list[i];
                        html += buildMsgHtml(msg);
                        lastMsgId = msg.id;
                    }
                    msgContainer.innerHTML = html;
                    msgContainer.scrollTop = msgContainer.scrollHeight;
                    return;
                }

                let hasNew = false;
                for (let i = 0; i < list.length; i++) {
                    const msg = list[i];
                    if (msg.id > lastMsgId) {
                        msgContainer.insertAdjacentHTML('beforeend', buildMsgHtml(msg));
                        lastMsgId = msg.id;
                        hasNew = true;
                    }
                }
                if (hasNew) {
                    msgContainer.scrollTop = msgContainer.scrollHeight;
                }
                loadFriendList();
            } catch (e) {
                console.error('加载历史消息失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('加载历史消息请求失败');
        };
        xhr.send();
    }

    function buildMsgHtml(msg) {
        const timeStr = formatTime(msg.createTime);

        if (msg.isSelf === 1) {
            return '<div class="message-row self">' +
                '<div class="msg-avatar">' + userAvatarText + '</div>' +
                '<div class="msg-bubble-wrap">' +
                '<div class="msg-bubble">' + msg.content + '</div>' +
                '<div class="msg-meta"><span class="msg-time">' + timeStr + '</span></div>' +
                '</div>' +
                '</div>';
        } else {
            const name = msg.fromNickname || '对方';
            const avatarChar = name.charAt(name.length - 1);
            return '<div class="message-row">' +
                '<div class="msg-avatar">' + avatarChar + '</div>' +
                '<div class="msg-bubble-wrap">' +
                '<div class="msg-bubble">' + msg.content + '</div>' +
                '<div class="msg-meta"><span class="msg-time">' + timeStr + '</span></div>' +
                '</div>' +
                '</div>';
        }
    }
    function initSearch() {
        const searchInput = document.getElementById('searchInput');
        const searchResult = document.getElementById('searchResult');
        let timer = null;

        searchInput.addEventListener('input', function() {
            clearTimeout(timer);
            const keyword = this.value.trim();
            if (!keyword) {
                searchResult.style.display = 'none';
                return;
            }
            timer = setTimeout(function() {
                const xhr = new XMLHttpRequest();
                xhr.open('GET', ctx + '/searchFriend?keyword=' + encodeURIComponent(keyword), true);
                xhr.onload = function() {
                    if (xhr.status !== 200) return;
                    try {
                        const list = JSON.parse(xhr.responseText);
                        if (list.length === 0) {
                            searchResult.innerHTML = '<div class="search-result-item">未找到用户</div>';
                        } else {
                            let html = '';
                            for (let i = 0; i < list.length; i++) {
                                const user = list[i];
                                html += '<div class="search-result-item">' +
                                    '<span>' + user.username + '（' + user.nickname + '）</span>' +
                                    '<span class="add-friend-btn" data-id="' + user.id + '">添加</span>' +
                                    '</div>';
                            }
                            searchResult.innerHTML = html;

                            const btns = document.querySelectorAll('.add-friend-btn');
                            for (let i = 0; i < btns.length; i++) {
                                btns[i].addEventListener('click', function(e) {
                                    e.stopPropagation();
                                    sendFriendRequest(this.getAttribute('data-id'));
                                });
                            }
                        }
                        searchResult.style.display = 'block';
                    } catch (e) {
                        console.error('搜索用户失败:', e);
                    }
                };
                xhr.onerror = function() {
                    console.error('搜索用户请求失败');
                };
                xhr.send();
            }, 300);
        });

        document.addEventListener('click', function(e) {
            if (!e.target.closest('.search-bar')) {
                searchResult.style.display = 'none';
            }
        });
    }

    function sendFriendRequest(toUserId) {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', ctx + '/sendFriendRequest', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const data = JSON.parse(xhr.responseText);
                alert(data.msg || '操作失败');
                if (data.success) {
                    document.getElementById('searchResult').style.display = 'none';
                    document.getElementById('searchInput').value = '';
                }
            } catch (e) {
                console.error('发送好友请求失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('发送好友请求失败');
            alert('网络错误，发送失败');
        };
        xhr.send('toUserId=' + encodeURIComponent(toUserId) + '&remark=' + encodeURIComponent('你好，加个好友'));
    }

    function initRequestModal() {
        const requestBtn = document.getElementById('requestBtn');
        const requestModal = document.getElementById('requestModal');
        const closeModal = document.getElementById('closeModal');

        requestBtn.addEventListener('click', function() {
            requestModal.style.display = 'flex';
            loadRequestList();
        });
        closeModal.addEventListener('click', function() {
            requestModal.style.display = 'none';
        });
        requestModal.addEventListener('click', function(e) {
            if (e.target === requestModal) requestModal.style.display = 'none';
        });
    }

    function loadRequestList() {
        const requestListEl = document.getElementById('requestList');
        const xhr = new XMLHttpRequest();
        xhr.open('GET', ctx + '/friendRequestList', true);
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);
                if (list.length === 0) {
                    requestListEl.innerHTML = '<div class="empty-tip">暂无好友申请</div>';
                    return;
                }
                let html = '';
                for (let i = 0; i < list.length; i++) {
                    const req = list[i];
                    html += '<div class="request-item">' +
                        '<div class="request-info">' +
                        '<div class="name">' + req.fromNickname + '</div>' +
                        '<div class="remark">' + (req.remark || '请求添加你为好友') + '</div>' +
                        '</div>' +
                        '<div class="request-op">' +
                        '<button class="btn-agree" data-id="' + req.id + '">同意</button>' +
                        '<button class="btn-refuse" data-id="' + req.id + '">拒绝</button>' +
                        '</div>' +
                        '</div>';
                }
                requestListEl.innerHTML = html;

                document.querySelectorAll('.btn-agree').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        handleRequest(this.getAttribute('data-id'), 1);
                    });
                });
                document.querySelectorAll('.btn-refuse').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        handleRequest(this.getAttribute('data-id'), 2);
                    });
                });
            } catch (e) {
                console.error('加载好友申请列表失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('加载好友申请列表请求失败');
        };
        xhr.send();
    }

    function handleRequest(requestId, status) {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', ctx + '/handleFriendRequest', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const data = JSON.parse(xhr.responseText);
                alert(data.msg || '操作失败');
                if (data.success) {
                    loadRequestList();
                    loadFriendList();
                    refreshRequestDot();
                }
            } catch (e) {
                console.error('处理好友申请失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('处理好友申请请求失败');
            alert('网络错误，操作失败');
        };
        xhr.send('requestId=' + encodeURIComponent(requestId) + '&status=' + encodeURIComponent(status));
    }

    function refreshRequestDot() {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', ctx + '/friendRequestList', true);
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);
                const dot = document.getElementById('requestDot');
                dot.style.display = list.length > 0 ? 'block' : 'none';
            } catch (e) {
                console.error('刷新请求红点失败:', e);
            }
        };
        xhr.onerror = function() {
            console.error('刷新请求红点请求失败');
        };
        xhr.send();
    }

    function initSendMsg() {
        const msgInput = document.getElementById('msgInput');
        const sendBtn = document.getElementById('sendBtn');

        function sendMessage() {
            const content = msgInput.value.trim();
            if (!content || !currentFriendId) return;

            const xhr = new XMLHttpRequest();
            xhr.open('POST', ctx + '/sendPrivateMsg', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function() {
                if (xhr.status !== 200) return;
                try {
                    const data = JSON.parse(xhr.responseText);
                    if (data.success) {
                        loadHistoryMsg();
                        loadFriendList();
                    } else {
                        alert(data.msg || '发送失败');
                    }
                } catch (e) {
                    console.error('发送消息解析失败:', e);
                }
            };
            xhr.onerror = function() {
                console.error('发送消息请求失败');
                alert('网络错误，发送失败');
            };
            xhr.send('toUserId=' + currentFriendId + '&content=' + encodeURIComponent(content));
            msgInput.value = '';
        }

        sendBtn.addEventListener('click', sendMessage);
        msgInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    }
</script>
</body>
</html>