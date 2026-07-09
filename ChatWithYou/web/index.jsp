<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="liyu.model.User" %>
<%
    // ========== 页面初始化：登录验证 ==========
    // 从 Session 中获取当前登录用户对象（LoginServlet 登录成功后存入的）
    User loginUser = (User) session.getAttribute("loginUser");
    
    // 如果用户未登录（Session中没有loginUser），跳转到登录页面
    // 联动：LoginServlet 登录成功后会把用户对象存入 session.setAttribute("loginUser", user)
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // 获取用户名作为昵称显示（实际项目中可以用 nickname 字段）
    String nickname = loginUser.getUsername();
    // 取用户名最后一个字符作为头像显示
    String avatarText = nickname.charAt(nickname.length() - 1) + "";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChatWithYou - 消息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        body {
            height: 100vh;
            overflow: hidden;
        }

        body.theme-pink .top-nav { background: var(--bg-nav); border-bottom-color: var(--border-color); }
        body.theme-pink .nav-logo { color: var(--accent-dark); }
        body.theme-pink .nav-user a, body.theme-pink .nav-user .nav-btn { color: var(--accent-dark); }
        body.theme-pink .nav-user a:hover, body.theme-pink .nav-user .nav-btn:hover { background: rgba(255, 137, 163, 0.08); }
        body.theme-pink .session-panel { background: rgba(255, 255, 255, 0.5); border-right-color: var(--border-color); }
        body.theme-pink .search-bar { background: var(--bg-panel); border-bottom-color: var(--border-color); }
        body.theme-pink .search-bar input { background: var(--accent-bg); border-color: transparent; }
        body.theme-pink .search-bar input:focus { border-color: var(--accent-primary); }
        body.theme-pink .search-result { background: var(--bg-card); border-color: var(--border-color); }
        body.theme-pink .search-result-item { border-bottom-color: var(--border-color); }
        body.theme-pink .search-result-item:hover { background: var(--accent-light); }
        body.theme-pink .session-item { border-bottom-color: var(--border-color); }
        body.theme-pink .session-item:hover { background: var(--bg-panel); }
        body.theme-pink .session-item.active { background: var(--accent-light); }
        body.theme-pink .session-name { color: var(--text-primary); }
        body.theme-pink .session-last-msg { color: var(--text-secondary); }
        body.theme-pink .session-time { color: var(--text-secondary); }
        body.theme-pink .chat-panel { background: transparent; }
        body.theme-pink .chat-header { background: var(--bg-card); border-bottom-color: var(--border-color); }
        body.theme-pink .chat-title { color: var(--text-primary); }
        body.theme-pink .chat-empty-tip, body.theme-pink .chat-empty { color: var(--text-secondary); }
        body.theme-pink .msg-bubble { background: var(--bg-card); }
        body.theme-pink .message-row.self .msg-bubble { background: var(--accent-dark); color: white; }
        body.theme-pink .message-row.self .msg-bubble::after { border-left-color: var(--accent-dark); }
        body.theme-pink .chat-input { background: var(--bg-card); border-top-color: var(--border-color); }
        body.theme-pink .input-main textarea { background: var(--accent-bg); border-color: var(--border-color); }
        body.theme-pink .input-main textarea:focus { border-color: var(--accent-primary); }
        body.theme-pink .input-tools span:hover { color: var(--accent-dark); }
        body.theme-pink .btn-send { background: var(--accent-dark); color: white; }
        body.theme-pink .modal-box { background: var(--bg-card); border-color: var(--border-color); }
        body.theme-pink .modal-header { border-bottom-color: var(--border-color); color: var(--text-primary); }
        body.theme-pink .request-item { border-bottom-color: var(--border-color); }
        body.theme-pink .request-info .name { color: var(--text-primary); }
        body.theme-pink .request-info .remark { color: var(--text-secondary); }
        body.theme-pink .btn-refuse { background: var(--accent-bg); }
        body.theme-pink .empty-tip, body.theme-pink .session-empty { color: var(--text-secondary); }
        body.theme-pink .msg-time { color: var(--text-secondary); }

        .top-nav {
            height: 56px;
            background: rgba(255, 255, 255, 0.5);
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            position: relative;
            z-index: 10;
            box-shadow: none;
        }

        .nav-logo {
            font-size: 18px;
            font-weight: 700;
            color: var(--accent-dark);
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
            background: var(--accent-primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 15px;
            flex-shrink: 0;
        }

        .nav-user a, .nav-user .nav-btn {
            color: var(--accent-dark);
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

        .nav-user a:hover, .nav-user .nav-btn:hover {
            background: rgba(22, 101, 52, 0.08);
        }

        /* 好友申请红点提示 */
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

        .main-container {
            height: calc(100vh - 56px);
            display: flex;
            margin: 16px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: none;
            border: 2px solid var(--border-color);
            position: relative;
            z-index: 5;
            background: transparent;
        }

        .session-panel {
            width: 300px;
            background: rgba(255, 255, 255, 0.3);
            border-right: 2px solid var(--border-color);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            transition: transform 0.3s ease;
            z-index: 20;
        }

        .search-bar {
            padding: 14px 16px;
            border-bottom: 2px solid var(--border-color);
            position: relative;
            background: rgba(255, 255, 255, 0.4);
        }

        .search-bar input {
            width: 100%;
            height: 36px;
            border-radius: var(--radius-sm);
            border: 1px solid transparent;
            background: var(--accent-bg);
            padding: 0 16px;
            font-size: 14px;
            outline: none;
            transition: 0.25s;
        }

        .search-bar input:focus {
            background: var(--bg-card);
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(134, 239, 172, 0.15);
        }

        .search-result {
            position: absolute;
            top: 58px;
            left: 16px;
            right: 16px;
            background: var(--bg-card);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-hover);
            max-height: 320px;
            overflow-y: auto;
            z-index: 100;
            display: none;
            border: 1px solid var(--border-color);
        }

        .search-result-item {
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            cursor: pointer;
            font-size: 14px;
            transition: 0.2s;
            color: var(--text-primary);
        }

        .search-result-item:hover {
            background: var(--accent-light);
        }

        .search-result-item:last-child {
            border-bottom: none;
        }

        .add-friend-btn {
            font-size: 12px;
            color: var(--accent-dark);
            cursor: pointer;
            padding: 4px 12px;
            border-radius: var(--radius-full);
            background: var(--accent-light);
            transition: 0.2s;
            font-weight: 600;
        }

        .add-friend-btn:hover {
            background: var(--accent-primary);
            color: white;
        }

        .session-list {
            flex: 1;
            overflow-y: auto;
        }

        .session-empty {
            padding: 70px 20px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 13px;
        }

        .session-item {
            padding: 14px 16px;
            display: flex;
            gap: 14px;
            cursor: pointer;
            border-bottom: 1px solid var(--border-color);
            transition: 0.2s;
        }

        .session-item:hover {
            background: var(--bg-page);
        }

        .session-item.active {
            background: var(--accent-light);
            border-left: 3px solid var(--accent-primary);
            padding-left: 13px;
        }

        .session-avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: var(--accent-primary);
            color: white;
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
            color: var(--text-primary);
        }

        .session-time {
            font-size: 11px;
            color: var(--text-secondary);
        }

        .session-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .session-last-msg {
            font-size: 12px;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex: 1;
        }

        /* 未读消息徽章 */
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

        /* AI机器人样式 */
        .ai-session {
            background: var(--accent-light);
            border-bottom: 2px solid var(--border-color);
        }
        
        .ai-session:hover {
            background: var(--accent-bg);
        }
        
        .ai-session.active {
            border-left: 3px solid var(--accent-primary);
            padding-left: 13px;
        }
        
        .ai-avatar {
            font-size: 20px;
            background: linear-gradient(135deg, #4285F4 0%, #DB4437 50%, #F4B400 100%);
        }
        
        body.theme-pink .ai-session { background: rgba(255, 137, 163, 0.08); }
        body.theme-pink .ai-session:hover { background: var(--accent-bg); }
        
        /* AI思考动画 */
        .typing-indicator {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 8px 12px;
        }
        
        .typing-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--accent-dark);
            animation: typingBounce 1.4s infinite ease-in-out both;
        }
        
        .typing-dot:nth-child(1) { animation-delay: -0.32s; }
        .typing-dot:nth-child(2) { animation-delay: -0.16s; }
        
        @keyframes typingBounce {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
        
        body.theme-pink .typing-dot { background: var(--accent-dark); }

        /* ========== 移动端菜单按钮 ========== */
        /* 移动端隐藏会话列表，点击按钮展开 */
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

        .chat-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            position: relative;
            background: transparent;
        }

        .chat-header {
            height: 56px;
            background: rgba(255, 255, 255, 0.4);
            border-bottom: 2px solid var(--border-color);
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
            color: var(--text-primary);
            display: none;
        }

        .chat-empty-tip {
            color: var(--text-secondary);
            font-size: 14px;
        }

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
            color: var(--text-secondary);
            font-size: 14px;
        }

        .message-row {
            display: flex;
            gap: 12px;
            max-width: 65%;
            animation: msgFadeIn 0.25s ease-out;
        }

        @keyframes msgFadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .message-row.self {
            align-self: flex-end;
            flex-direction: row-reverse;
        }

        .msg-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--border-color);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-primary);
            font-size: 15px;
            font-weight: 700;
        }

        .message-row.self .msg-avatar {
            background: var(--accent-primary);
            color: white;
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
            background: var(--bg-card);
            color: var(--text-primary);
            font-size: 14.5px;
            line-height: 1.6;
            box-shadow: var(--shadow-light);
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
            border-right-color: var(--bg-card);
        }

        .message-row.self .msg-bubble {
            background: var(--accent-dark);
            color: white;
            border-top-left-radius: 18px;
            border-top-right-radius: 4px;
        }

        .message-row.self .msg-bubble::after {
            left: auto;
            right: -6px;
            border-right-color: transparent;
            border-left-color: var(--accent-dark);
        }

        .msg-meta {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: var(--text-secondary);
        }

        .message-row.self .msg-meta {
            justify-content: flex-end;
        }

        .msg-time {
            color: var(--text-secondary);
        }

        .msg-status {
            color: var(--accent-dark);
        }

        .chat-input {
            background: rgba(255, 255, 255, 0.5);
            border-top: 2px solid var(--border-color);
            padding: 14px 24px 18px;
            position: relative;
            z-index: 2;
            box-shadow: none;
        }

        .input-tools {
            display: flex;
            gap: 20px;
            margin-bottom: 10px;
            color: var(--text-secondary);
            font-size: 19px;
        }

        .input-tools span {
            cursor: pointer;
            transition: 0.2s;
            padding: 2px;
            border-radius: 4px;
        }

        .input-tools span:hover {
            color: var(--accent-dark);
            transform: scale(1.15);
        }

        .input-main {
            display: flex;
            gap: 14px;
            align-items: flex-end;
        }

        .input-main textarea {
            flex: 1;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            resize: none;
            height: 72px;
            outline: none;
            font-size: 14.5px;
            font-family: inherit;
            transition: 0.25s;
            background: var(--accent-bg);
        }

        .input-main textarea:focus {
            border-color: var(--accent-primary);
            background: var(--bg-card);
            box-shadow: 0 0 0 3px rgba(134, 239, 172, 0.15);
        }

        .btn-send {
            padding: 0 28px;
            height: 42px;
            border-radius: var(--radius-md);
            background: var(--accent-dark);
            color: white;
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
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #9ca3af; }
        ::-webkit-scrollbar-track { background: transparent; }

        /* ========== 弹窗样式 ========== */
        /* 好友申请弹窗 */
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

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        .modal-box {
            width: 420px;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            animation: slideUp 0.25s ease-out;
        }

        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

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

        /* 好友申请项 */
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
        /* 移动端适配 */
        @media (max-width: 768px) {
            .main-container { margin: 0; border-radius: 0; }
            .mobile-menu-btn { display: block; }
            .session-panel {
                position: absolute;
                top: 0;
                left: 0;
                height: 100%;
                width: 85%;
                max-width: 300px;
                transform: translateX(-100%);
                transition: transform 0.3s ease !important;
                box-shadow: 2px 0 12px rgba(0, 0, 0, 0.06);
            }
            .session-panel.show { transform: translateX(0) !important; }
            .chat-messages { padding: 16px 20px; }
            .message-row { max-width: 80%; }
            .chat-header { padding: 0 16px; }
            .chat-input { padding: 12px 16px 16px; }
        }

        /* ===== 表情选择器 ===== */
        .emoji-picker {
            position: fixed;
            display: none;
            flex-direction: column;
            width: 340px;
            max-height: 300px;
            background: rgba(255, 255, 255, 0.97);
            border: 2px solid var(--border-color);
            border-radius: 14px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.12);
            z-index: 9999;
            overflow: visible;
        }
        .emoji-picker-header {
            display: flex;
            gap: 2px;
            padding: 8px 10px 6px;
            border-bottom: 1px solid var(--border-color);
            background: var(--bg-panel);
            flex-wrap: wrap;
        }
        .emoji-tab {
            cursor: pointer;
            font-size: 16px;
            padding: 3px 7px;
            border-radius: 8px;
            transition: 0.2s;
            opacity: 0.5;
            line-height: 1;
        }
        .emoji-tab:hover { opacity: 0.8; background: var(--accent-light); }
        .emoji-tab.active { opacity: 1; background: var(--accent-light); }
        .emoji-picker-body {
            padding: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 2px;
            overflow-y: auto;
            max-height: 200px;
            align-content: flex-start;
        }
        .emoji-picker-body span {
            cursor: pointer;
            font-size: 22px;
            padding: 3px;
            border-radius: 6px;
            transition: 0.1s;
            width: 34px;
            height: 34px;
            display: flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
        }
        .emoji-picker-body span:hover {
            background: var(--accent-light);
            transform: scale(1.2);
        }
        .emoji-picker-body::-webkit-scrollbar {
            width: 4px;
        }
        .emoji-picker-body::-webkit-scrollbar-thumb {
            background: var(--accent-primary);
            border-radius: 2px;
        }
    </style>
</head>
<body>
<!-- ========== 顶部导航栏 ========== -->
<!-- 显示用户信息、主题切换、个人主页、好友申请、管理员入口、退出登录 -->
<div class="top-nav">
    <!-- 网站Logo -->
    <div class="nav-logo">ChatWithYou</div>
    
    <!-- 用户操作区域 -->
    <div class="nav-user">
        <!-- 用户头像（取用户名最后一个字符） -->
        <div class="user-avatar"><%= avatarText %></div>
        <!-- 用户名 -->
        <span><%= nickname %></span>
        <!-- 主题切换按钮（存储在 localStorage） -->
        <button class="nav-btn" id="themeToggle" title="切换主题">🎨</button>
        <!-- 个人主页按钮（跳转 ProfileServlet） -->
        <button class="nav-btn" id="profileBtn">个人主页</button>
        <!-- 好友申请按钮（打开申请弹窗） -->
        <button class="nav-btn" id="requestBtn">
            好友申请
            <!-- 红点提示（有未处理申请时显示） -->
            <span class="request-dot" id="requestDot"></span>
        </button>
        <!-- 管理员入口（只有 role=1 的管理员才能看到） -->
        <!-- 联动：UserDao 查询用户时会返回 role 字段，判断是否为管理员 -->
        <% if (loginUser.getRole() != null && loginUser.getRole() == 1) { %>
        <a href="${pageContext.request.contextPath}/admin" class="nav-btn" style="font-weight:600;">🔧 管理</a>
        <% } %>
        <!-- 退出登录（跳转 LogoutServlet） -->
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<!-- ========== 主体内容区域 ========== -->
<div class="main-container">
    <!-- ========== 左侧会话列表 ========== -->
    <!-- 显示好友列表，点击后进入聊天 -->
    <div class="session-panel" id="sessionPanel">
        <!-- 搜索框（搜索用户添加好友） -->
        <!-- 联动：SearchFriendServlet - 根据关键词搜索用户 -->
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="搜索用户 / 添加好友">
            <!-- 搜索结果下拉框 -->
            <div class="search-result" id="searchResult"></div>
        </div>
        
        <!-- AI机器人会话项 -->
        <div class="session-item ai-session" id="aiSessionItem">
            <div class="session-avatar ai-avatar">🤖</div>
            <div class="session-info">
                <div class="session-top">
                    <div class="session-name">AI助手</div>
                    <span class="session-time"></span>
                </div>
                <div class="session-bottom">
                    <div class="session-last-msg">点击开始对话</div>
                </div>
            </div>
        </div>
        
        <!-- 好友列表 -->
        <!-- 联动：FriendListServlet - 获取当前用户的好友列表 -->
        <div class="session-list" id="friendList">
            <div class="session-empty">加载中...</div>
        </div>
    </div>

    <!-- ========== 右侧聊天窗口 ========== -->
    <!-- 显示聊天消息和输入框 -->
    <div class="chat-panel">
        <!-- 聊天窗口头部 -->
        <div class="chat-header">
            <!-- 移动端菜单按钮 -->
            <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
            <!-- 未选择好友时的提示 -->
            <div class="chat-empty-tip" id="chatHeaderTip">请选择左侧好友开始聊天</div>
            <!-- 选中好友后的名称 -->
            <div class="chat-title" id="chatTitle" style="cursor: pointer;" title="点击查看资料"></div>
        </div>
        
        <!-- 消息显示区域 -->
        <!-- 联动：GetPrivateMsgServlet - 获取与好友的聊天记录 -->
        <div class="chat-messages" id="msgContainer">
            <div class="chat-empty">选择好友后开始对话</div>
        </div>
        
        <!-- 消息输入区域 -->
        <!-- 联动：SendPrivateMsgServlet - 发送私信 -->
        <div class="chat-input">
            <!-- 工具栏（表情、图片、文件、语音） -->
            <div class="input-tools">
                <span title="表情" id="emojiBtn" onclick="toggleEmojiPicker()">😊</span>
                <span title="图片">🖼️</span>
                <span title="文件">📁</span>
                <span title="语音消息">🎤</span>
            </div>
            <!-- 输入框和发送按钮 -->
            <div class="input-main">
                <textarea id="msgInput" placeholder="选择好友后发送消息" disabled></textarea>
                <button class="btn-send" id="sendBtn" disabled>发送</button>
            </div>
        </div>
    </div>
</div>

<!-- ========== 表情选择器（独立容器，避免被overflow:hidden裁剪） ========== -->
<div class="emoji-picker" id="emojiPicker" style="display:none;">
    <div class="emoji-picker-header">
        <span class="emoji-tab active" data-category="recent">🕐</span>
        <span class="emoji-tab" data-category="smileys">😊</span>
        <span class="emoji-tab" data-category="gestures">👋</span>
        <span class="emoji-tab" data-category="hearts">❤️</span>
        <span class="emoji-tab" data-category="objects">🎁</span>
        <span class="emoji-tab" data-category="food">🍕</span>
        <span class="emoji-tab" data-category="nature">🌻</span>
        <span class="emoji-tab" data-category="travel">🚗</span>
    </div>
    <div class="emoji-picker-body" id="emojiBody"></div>
</div>

<!-- ========== 好友申请弹窗 ========== -->
<!-- 显示待处理的好友申请，可同意或拒绝 -->
<div class="modal-mask" id="requestModal">
    <div class="modal-box">
        <div class="modal-header">
            <span>好友申请</span>
            <span class="modal-close" id="closeModal">×</span>
        </div>
        <!-- 好友申请列表 -->
        <!-- 联动：FriendRequestListServlet - 获取好友申请列表 -->
        <!-- 联动：HandleFriendRequestServlet - 处理好友申请（同意/拒绝） -->
        <div class="modal-body" id="requestList">
            <div class="empty-tip">加载中...</div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/theme.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
<script>
    MathJax = {
        tex: {
            inlineMath: [['$', '$'], ['\\(', '\\)']]
        },
        svg: {
            fontCache: 'global'
        }
    };
</script>
<script>
    // ========== 全局变量 ==========
    const ctx = '${pageContext.request.contextPath}';  // 项目上下文路径（如 /ChatWithYou）
    const userAvatarText = '<%= avatarText %>';       // 当前用户头像文字
    const userId = <%= loginUser.getId() %>;          // 当前用户ID
    let currentFriendId = null;                       // 当前选中的好友ID
    let currentFriendName = '';                       // 当前选中的好友名称
    let msgTimer = null;                              // 消息轮询定时器
    let lastMsgId = 0;                                // 最后一条消息ID（用于判断是否有新消息）
    let isAIChat = false;                             // 是否在AI聊天模式
    let aiTypingTimer = null;                         // AI打字效果定时器

    window.onload = function() {
        loadFriendList();      // 加载好友列表
        initSearch();          // 初始化搜索功能
        initRequestModal();    // 初始化好友申请弹窗
        initSendMsg();         // 初始化消息发送功能
        refreshRequestDot();   // 刷新好友申请红点
        initShortcuts();       // 初始化快捷键
        initMobileMenu();      // 初始化移动端菜单
        initAIChat();          // 初始化AI聊天功能

        // 个人主页按钮点击事件（跳转 ProfileServlet）
        document.getElementById('profileBtn').addEventListener('click', function() {
            window.location.href = ctx + '/profile';
        });
    };

    // ========== 消息轮询功能 ==========
    // 每隔2秒向服务器请求新消息，实现实时聊天效果
    // 联动：GetPrivateMsgServlet - GET /getPrivateMsg?friendId=xxx
    function startMsgPolling() {
        // 如果已有定时器，先清除
        if (msgTimer) clearInterval(msgTimer);
        
        // 每2秒执行一次
        msgTimer = setInterval(function() {
            // 只有选中好友后才轮询
            if (currentFriendId) {
                const xhr = new XMLHttpRequest();
                // 请求后端获取与好友的消息列表
                xhr.open('GET', ctx + '/getPrivateMsg?friendId=' + currentFriendId, true);
                
                xhr.onload = function() {
                    if (xhr.status !== 200) return;
                    try {
                        // 解析后端返回的 JSON 消息列表
                        const list = JSON.parse(xhr.responseText);
                        if (list.length === 0) return;

                        // 判断是否有新消息（消息ID大于 lastMsgId）
                        let hasNew = false;
                        for (let i = 0; i < list.length; i++) {
                            if (list[i].id > lastMsgId) {
                                hasNew = true;
                                break;
                            }
                        }

                        // 如果有新消息，追加到界面
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
        }, 2000);  // 2秒轮询一次
    }

    // ========== 追加新消息 ==========
    // 将新消息添加到消息容器中
    function appendNewMessages(list) {
        const msgContainer = document.getElementById('msgContainer');
        let hasNew = false;
        
        for (let i = 0; i < list.length; i++) {
            const msg = list[i];
            // 只添加ID大于 lastMsgId 的新消息
            if (msg.id > lastMsgId) {
                msgContainer.insertAdjacentHTML('beforeend', buildMsgHtml(msg));
                lastMsgId = msg.id;
                hasNew = true;
            }
        }
        
        // 如果有新消息，滚动到底部并刷新好友列表（更新未读计数）
        if (hasNew) {
            msgContainer.scrollTop = msgContainer.scrollHeight;
            loadFriendList();
        }
    }

    // ========== 停止消息轮询 ==========
    function stopMsgPolling() {
        if (msgTimer) {
            clearInterval(msgTimer);
            msgTimer = null;
        }
    }

    // ========== 追加单条消息 ==========
    function appendMessage(msg) {
        const msgContainer = document.getElementById('msgContainer');
        // 如果有"空"提示，先清除
        if (msgContainer.querySelector('.chat-empty')) {
            msgContainer.innerHTML = '';
        }
        // 添加消息HTML
        msgContainer.insertAdjacentHTML('beforeend', buildMsgHtml(msg));
        // 滚动到底部
        msgContainer.scrollTop = msgContainer.scrollHeight;
        // 更新最后消息ID
        if (msg.id) {
            lastMsgId = msg.id;
        }
    }

    // ========== 主题切换功能 ==========
    // 切换暗黑/浅色主题，状态存储在 localStorage


    // ========== 快捷键功能 ==========
    // Ctrl+F 聚焦搜索框，Esc 关闭弹窗
    function initShortcuts() {
        document.addEventListener('keydown', function(e) {
            // Ctrl+F 聚焦搜索框
            if (e.ctrlKey && e.key.toLowerCase() === 'f') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
            // Esc 关闭好友申请弹窗
            if (e.key === 'Escape') {
                document.getElementById('requestModal').style.display = 'none';
            }
        });
    }

    // ========== 移动端菜单功能 ==========
    // 控制会话列表的展开和收缩
    function initMobileMenu() {
        const menuBtn = document.getElementById('mobileMenuBtn');
        const panel = document.getElementById('sessionPanel');
        
        // 点击菜单按钮切换显示/隐藏
        menuBtn.addEventListener('click', function() {
            panel.classList.toggle('show');
        });
        
        // 点击聊天区域隐藏会话列表（移动端）
        document.querySelector('.chat-panel').addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                panel.classList.remove('show');
            }
        });
        
        // 窗口大小变化时，如果宽度>768px，自动显示会话列表
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                panel.classList.add('show');
            }
        });
    }

    // ========== 时间格式化 ==========
    // 将时间戳转换为友好的时间格式（刚刚、x分钟前、HH:mm）
    function formatTime(timestamp) {
        if (!timestamp) return '';
        const date = new Date(timestamp);
        const now = new Date();
        const diff = now - date;
        
        if (diff < 60000) return '刚刚';           // 1分钟内
        if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前';  // 1小时内
        return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
    }

    // ========== 加载好友列表 ==========
    // 从服务器获取好友列表并显示
    // 联动：FriendListServlet - GET /friendList
    function loadFriendList() {
        const friendListEl = document.getElementById('friendList');
        const xhr = new XMLHttpRequest();
        
        // 请求后端获取好友列表
        xhr.open('GET', ctx + '/friendList', true);
        
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                // 解析好友列表
                const list = JSON.parse(xhr.responseText);
                
                if (list.length === 0) {
                    friendListEl.innerHTML = '<div class="session-empty">暂无好友，去搜索添加吧</div>';
                    return;
                }
                
                // 构建好友列表HTML
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
                
                // 绑定好友点击事件（排除AI会话项）
                const items = document.querySelectorAll('.session-item:not(.ai-session)');
                for (let i = 0; i < items.length; i++) {
                    items[i].addEventListener('click', function() {
                        // 移除其他好友的激活状态（包括AI会话）
                        document.querySelectorAll('.session-item').forEach(item => item.classList.remove('active'));
                        // 添加当前好友的激活状态
                        this.classList.add('active');
                        
                        // 记录当前选中的好友信息
                        currentFriendId = this.getAttribute('data-id');
                        currentFriendName = this.getAttribute('data-name');
                        lastMsgId = 0;
                        isAIChat = false;
                        
                        // 打开聊天窗口
                        openChatWindow(currentFriendName);
                        // 加载历史消息
                        loadHistoryMsg();
                        // 开始消息轮询
                        startMsgPolling();
                        
                        // 移动端点击好友后隐藏会话列表
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

    // ========== 打开聊天窗口 ==========
    // 更新聊天窗口头部，启用输入框
    function openChatWindow(name) {
        document.getElementById('chatHeaderTip').style.display = 'none';
        document.getElementById('chatTitle').style.display = 'block';
        document.getElementById('chatTitle').innerText = name;
        document.getElementById('msgInput').disabled = false;
        document.getElementById('sendBtn').disabled = false;
        document.getElementById('msgInput').placeholder = '输入消息...';
        
        document.getElementById('chatTitle').onclick = function() {
            window.location.href = ctx + '/profile?userId=' + currentFriendId;
        };
    }

    // ========== 加载历史消息 ==========
    // 获取与好友的聊天记录并显示
    // 联动：GetPrivateMsgServlet - GET /getPrivateMsg?friendId=xxx
    function loadHistoryMsg() {
        if (!currentFriendId) return;
        
        const msgContainer = document.getElementById('msgContainer');
        const xhr = new XMLHttpRequest();
        
        // 请求后端获取聊天记录
        xhr.open('GET', ctx + '/getPrivateMsg?friendId=' + currentFriendId, true);
        
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);
                
                // 如果是首次加载或消息区域为空，清空并重新渲染
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
                
                // 否则只添加新消息
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
                
                // 刷新好友列表（更新未读计数）
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

    // ========== 构建消息HTML ==========
    // 将消息对象转换为HTML字符串
    function buildMsgHtml(msg) {
        const timeStr = formatTime(msg.createTime);
        
        // 如果是自己发送的消息
        if (msg.isSelf === 1) {
            return '<div class="message-row self">' +
                '<div class="msg-avatar">' + userAvatarText + '</div>' +
                '<div class="msg-bubble-wrap">' +
                '<div class="msg-bubble">' + msg.content + '</div>' +
                '<div class="msg-meta"><span class="msg-time">' + timeStr + '</span></div>' +
                '</div>' +
                '</div>';
        } else {
            // 对方发送的消息
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

    // ========== 搜索用户功能 ==========
    // 搜索其他用户并显示添加好友按钮
    // 联动：SearchFriendServlet - GET /searchFriend?keyword=xxx
    function initSearch() {
        const searchInput = document.getElementById('searchInput');
        const searchResult = document.getElementById('searchResult');
        let timer = null;
        
        // 输入事件（防抖：停止输入300ms后才搜索）
        searchInput.addEventListener('input', function() {
            clearTimeout(timer);
            const keyword = this.value.trim();
            
            // 如果没有关键词，隐藏搜索结果
            if (!keyword) {
                searchResult.style.display = 'none';
                return;
            }
            
            // 300ms后执行搜索
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
                            
                            // 绑定添加好友按钮事件
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
        
        // 点击其他地方隐藏搜索结果
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.search-bar')) {
                searchResult.style.display = 'none';
            }
        });
    }

    // ========== 发送好友请求 ==========
    // 向指定用户发送好友请求
    // 联动：SendFriendRequestServlet - POST /sendFriendRequest
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
                    // 成功后清空搜索框和结果
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
        
        // 发送请求参数：目标用户ID和备注
        xhr.send('toUserId=' + encodeURIComponent(toUserId) + '&remark=' + encodeURIComponent('你好，加个好友'));
    }

    // ========== 初始化好友申请弹窗 ==========
    // 控制好友申请弹窗的显示和隐藏
    function initRequestModal() {
        const requestBtn = document.getElementById('requestBtn');
        const requestModal = document.getElementById('requestModal');
        const closeModal = document.getElementById('closeModal');
        
        // 点击按钮打开弹窗并加载申请列表
        requestBtn.addEventListener('click', function() {
            requestModal.style.display = 'flex';
            loadRequestList();
        });
        
        // 点击关闭按钮
        closeModal.addEventListener('click', function() {
            requestModal.style.display = 'none';
        });
        
        // 点击遮罩层关闭弹窗
        requestModal.addEventListener('click', function(e) {
            if (e.target === requestModal) requestModal.style.display = 'none';
        });
    }

    // ========== 加载好友申请列表 ==========
    // 获取待处理的好友申请
    // 联动：FriendRequestListServlet - GET /friendRequestList
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
                
                // 构建申请列表HTML
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
                
                // 绑定同意按钮事件
                document.querySelectorAll('.btn-agree').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        handleRequest(this.getAttribute('data-id'), 1);  // 1=同意
                    });
                });
                
                // 绑定拒绝按钮事件
                document.querySelectorAll('.btn-refuse').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        handleRequest(this.getAttribute('data-id'), 2);  // 2=拒绝
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

    // ========== 处理好友申请 ==========
    // 同意或拒绝好友申请
    // 联动：HandleFriendRequestServlet - POST /handleFriendRequest
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
                    // 成功后刷新申请列表、好友列表和红点
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
        
        // 发送请求参数：申请ID和处理状态（1=同意，2=拒绝）
        xhr.send('requestId=' + encodeURIComponent(requestId) + '&status=' + encodeURIComponent(status));
    }

    var aiChatHistory = [];

    // ========== AI聊天功能 ==========
    function initAIChat() {
        const aiSession = document.getElementById('aiSessionItem');
        
        aiSession.addEventListener('click', function() {
            document.querySelectorAll('.session-item').forEach(item => item.classList.remove('active'));
            this.classList.add('active');
            
            isAIChat = true;
            currentFriendId = null;
            currentFriendName = 'AI助手';
            
            stopMsgPolling();
            openAIChatWindow();
            loadAIChatHistory();
            
            if (window.innerWidth <= 768) {
                document.getElementById('sessionPanel').classList.remove('show');
            }
        });
    }
    
    function openAIChatWindow() {
        document.getElementById('chatHeaderTip').style.display = 'none';
        document.getElementById('chatTitle').style.display = 'block';
        document.getElementById('chatTitle').innerText = 'AI助手';
        document.getElementById('chatTitle').onclick = null;
        document.getElementById('msgInput').disabled = false;
        document.getElementById('sendBtn').disabled = false;
        document.getElementById('msgInput').placeholder = '输入消息给AI助手...';
    }
    
    function loadAIChatHistory() {
        const msgContainer = document.getElementById('msgContainer');
        msgContainer.innerHTML = '';
        
        if (aiChatHistory.length === 0) {
            msgContainer.innerHTML = '<div class="chat-empty">与AI助手开始对话吧</div>';
        } else {
            aiChatHistory.forEach(msg => {
                appendMessage({
                    isSelf: msg.isSelf,
                    content: msg.content,
                    fromNickname: msg.isSelf ? null : 'AI助手',
                    createTime: msg.createTime
                });
            });
        }
    }
    
    function sendAIMessage() {
        console.log('[DEBUG] sendAIMessage called');
        const msgInput = document.getElementById('msgInput');
        const content = msgInput.value.trim();
        console.log('[DEBUG] Input content:', content);
        
        if (!content) {
            console.log('[DEBUG] Content is empty, returning');
            return;
        }
        
        msgInput.value = '';
        
        appendMessage({
            isSelf: 1,
            content: content,
            createTime: new Date().getTime()
        });
        
        aiChatHistory.push({isSelf: 1, content: content, createTime: new Date().getTime()});
        
        showAITyping();
        
        const formattedHistory = aiChatHistory.slice(0, -1).map(item => ({
            role: item.isSelf ? 'user' : 'assistant',
            content: item.content
        }));
        
        const url = ctx + '/ai/chat';
        console.log('[DEBUG] Fetch URL:', url);
        
        const requestBody = JSON.stringify({
            message: content,
            history: formattedHistory
        });
        console.log('[DEBUG] Request body:', requestBody.substring(0, 150) + (requestBody.length > 150 ? '...' : ''));
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: requestBody
        })
        .then(response => {
            console.log('[DEBUG] Response status:', response.status);
            console.log('[DEBUG] Response headers:', Object.fromEntries(response.headers));
            
            if (!response.ok) {
                console.error('[DEBUG] HTTP error:', response.status);
                throw new Error('HTTP error ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('[DEBUG] Response data:', JSON.stringify(data).substring(0, 200) + (JSON.stringify(data).length > 200 ? '...' : ''));
            hideAITyping();
            
            if (data.success !== undefined && !data.success) {
                console.log('[DEBUG] AI response failed:', data.msg);
                appendMessage({
                    isSelf: 0,
                    content: data.msg || 'AI服务错误',
                    fromNickname: 'AI助手',
                    createTime: new Date().getTime()
                });
            } else if (data.choices && data.choices.length > 0) {
                const aiMessage = data.choices[0].message;
                const aiContent = aiMessage && aiMessage.content ? aiMessage.content : 'AI未返回有效内容';
                console.log('[DEBUG] AI response content:', aiContent);
                appendMessage({
                    isSelf: 0,
                    content: aiContent,
                    fromNickname: 'AI助手',
                    createTime: new Date().getTime()
                });
                aiChatHistory.push({isSelf: 0, content: aiContent, createTime: new Date().getTime()});
                if (window.MathJax && typeof MathJax.typesetPromise === 'function') {
                    MathJax.typesetPromise();
                }
            } else {
                appendMessage({
                    isSelf: 0,
                    content: 'AI服务返回未知格式',
                    fromNickname: 'AI助手',
                    createTime: new Date().getTime()
                });
            }
        })
        .catch(error => {
            hideAITyping();
            appendMessage({
                isSelf: 0,
                content: 'AI服务暂时不可用，请稍后重试: ' + error.message,
                fromNickname: 'AI助手',
                createTime: new Date().getTime()
            });
        });
    }
    
    function showAITyping() {
        const msgContainer = document.getElementById('msgContainer');
        if (msgContainer.querySelector('.chat-empty')) {
            msgContainer.innerHTML = '';
        }
        
        const typingHtml = '<div class="message-row" id="aiTyping">' +
            '<div class="msg-avatar">🤖</div>' +
            '<div class="msg-bubble-wrap">' +
            '<div class="msg-bubble">' +
            '<div class="typing-indicator">' +
            '<span class="typing-dot"></span>' +
            '<span class="typing-dot"></span>' +
            '<span class="typing-dot"></span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        
        msgContainer.insertAdjacentHTML('beforeend', typingHtml);
        msgContainer.scrollTop = msgContainer.scrollHeight;
    }
    
    function hideAITyping() {
        const typingEl = document.getElementById('aiTyping');
        if (typingEl) {
            typingEl.remove();
        }
    }
    
    function updateAIResponse(content) {
        const typingEl = document.getElementById('aiTyping');
        if (typingEl) {
            const bubble = typingEl.querySelector('.msg-bubble');
            if (bubble) {
                bubble.innerHTML = escapeHtml(content);
            }
            const msgContainer = document.getElementById('msgContainer');
            msgContainer.scrollTop = msgContainer.scrollHeight;
        }
    }
    
    function renderMath() {
        if (window.MathJax) {
            MathJax.typesetPromise();
        }
    }
    
    function escapeHtml(str) {
        if (str == null) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;')
                  .replace(/'/g, '&#039;')
                  .replace(/\n/g, '<br>');
    }
    
    // ========== 刷新好友申请红点 ==========
    // 检查是否有未处理的好友申请，显示或隐藏红点
    function refreshRequestDot() {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', ctx + '/friendRequestList', true);
        
        xhr.onload = function() {
            if (xhr.status !== 200) return;
            try {
                const list = JSON.parse(xhr.responseText);
                const dot = document.getElementById('requestDot');
                // 如果有申请，显示红点；否则隐藏
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

    // ========== 初始化消息发送功能 ==========
    // 绑定发送按钮和回车键事件
    // 联动：SendPrivateMsgServlet - POST /sendPrivateMsg
    function initSendMsg() {
        const msgInput = document.getElementById('msgInput');
        const sendBtn = document.getElementById('sendBtn');
        
        // 发送消息函数
        function sendMessage() {
            console.log('=== sendMessage called ===');
            const content = msgInput.value.trim();
            console.log('Content:', content);
            console.log('isAIChat:', isAIChat);
            console.log('currentFriendId:', currentFriendId);
            console.log('ctx:', ctx);
            
            // 如果内容为空，不发送
            if (!content) {
                console.log('Content is empty, returning');
                return;
            }
            
            // 如果是AI聊天模式
            if (isAIChat) {
                console.log('AI chat mode, calling sendAIMessage');
                if (typeof sendAIMessage === 'function') {
                    console.log('sendAIMessage function exists');
                    sendAIMessage();
                } else {
                    console.error('ERROR: sendAIMessage function not found!');
                }
                return;
            }
            
            // 如果没有选中好友，不发送
            if (!currentFriendId) {
                console.log('No friend selected, returning');
                return;
            }
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', ctx + '/sendPrivateMsg', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                if (xhr.status !== 200) return;
                try {
                    const data = JSON.parse(xhr.responseText);
                    
                    if (data.success) {
                        // 成功后重新加载历史消息和好友列表
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
            
            // 发送请求参数：目标用户ID和消息内容
            xhr.send('toUserId=' + currentFriendId + '&content=' + encodeURIComponent(content));
            
            // 清空输入框
            msgInput.value = '';
        }
        
        // 点击发送按钮
        sendBtn.addEventListener('click', sendMessage);
        
        // 回车键发送（Shift+Enter换行）
        msgInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    }
    // ========== 表情选择器（全局函数，支持内联调用） ==========
    const emojiData = {
        smileys: ['😀','😃','😄','😁','😅','😂','🤣','☺️','😊','😇','🙂','😉','😌','😍','🥰','😘','😗','😋','😛','😜','🤪','😝','🤑','🤗','🤭','🤔','🤐','😑','😶','😏','😒','🙄','😬','😮','😯','😲','😳','🥺','😢','😭','😤','😡','😠','🤬','💀','☠️','👻','👽','🤡','💩'],
        gestures: ['👋','✋','🖐️','✌️','🤞','🤟','🤘','🤙','👈','👉','👆','🖕','👇','👍','👎','✊','👊','🤛','🤜','👏','🙌','👐','🤲','🤝','🙏','💪','🦵','🦶'],
        hearts: ['❤️','🧡','💛','💚','💙','💜','🖤','🤍','🤎','💕','💞','💗','💖','💘','💝','❣️','💟','🫶','💔'],
        objects: ['🎁','🎀','🎗️','🎫','🎟️','🎭','🎨','🎪','🎤','🎧','🎶','🎵','🎹','🎸','🎺','🎻','🥁','📱','💻','⌚️','📷','🔫','💡','🔦','🔑','🗝️','💎','🕶️','👑','🎒','📚','✏️','🖊️','📌','📎','🧷'],
        food: ['🍕','🍔','🍟','🌭','🥪','🥙','🥗','🥘','🍝','🍜','🍲','🍛','🍣','🥟','🍱','🍤','🍙','🍚','🍘','🍥','🥮','🍡','🍧','🍨','🍦','🍰','🎂','🍫','🍬','🍭','🍩','🍪','☕️','🍵','🥤','🧃'],
        nature: ['🌻','🌺','🌸','🌼','🌷','🌹','🌿','🍀','🌵','🌲','🌴','🍄','🐶','🐱','🐭','🐹','🐰','🦊','🐻','🐼','🐨','🐯','🦁','🐮','🐷','🐸','🐵','🐔','🐧','🐦','🦄','🐴','🦋','🐛','🐝','🐞'],
        travel: ['🚗','🚕','🚙','🚌','🚎','🏎️','🚓','🚑','🚒','🚐','🚚','🚛','🚜','🏍️','✈️','🚁','🚀','🛸','🚂','🚢','🛳️','🚲','🛴','🏠','🏡','🏢','🏤','🏥','🏪','🏫','🏔️','🏖️','🏝️','🌋','🏰','🗼','🗽']
    };
    let recentEmojis = JSON.parse(localStorage.getItem('recentEmojis') || '[]');

    function renderEmojis(category) {
        const body = document.getElementById('emojiBody');
        let emojis = category === 'recent' ? recentEmojis : (emojiData[category] || []);
        if (emojis.length === 0) {
            if (category === 'recent') { body.innerHTML = '<span style="color:var(--text-secondary);font-size:13px;padding:10px;width:100%;text-align:center;">暂无最近使用的表情</span>'; return; }
            emojis = emojiData.smileys;
        }
        body.innerHTML = emojis.map(e => `<span>${e}</span>`).join('');
    }

    function insertEmoji(emoji) {
        const input = document.getElementById('msgInput');
        const start = input.selectionStart;
        const end = input.selectionEnd;
        const text = input.value;
        input.value = text.substring(0, start) + emoji + text.substring(end);
        input.selectionStart = input.selectionEnd = start + emoji.length;
        input.focus();
        if (!recentEmojis.includes(emoji)) {
            recentEmojis.unshift(emoji);
            if (recentEmojis.length > 30) recentEmojis.pop();
            localStorage.setItem('recentEmojis', JSON.stringify(recentEmojis));
        }
    }

    let emojiPickerVisible = false;

    function toggleEmojiPicker() {
        const picker = document.getElementById('emojiPicker');
        const btn = document.getElementById('emojiBtn');
        if (!picker || !btn) { console.error('emojiPicker or emojiBtn not found'); return; }
        emojiPickerVisible = !emojiPickerVisible;
        if (emojiPickerVisible) {
            const rect = btn.getBoundingClientRect();
            picker.style.left = rect.left + 'px';
            picker.style.bottom = (window.innerHeight - rect.top + 4) + 'px';
            picker.style.display = 'flex';
            picker.style.flexDirection = 'column';
            renderEmojis('recent');
        } else {
            picker.style.display = 'none';
        }
        console.log('toggleEmojiPicker: visible=' + emojiPickerVisible);
    }

    // 点击表情插入到输入框
    document.getElementById('emojiBody').addEventListener('click', function(e) {
        const span = e.target.closest('span');
        if (span && span.textContent) {
            const emoji = span.textContent.trim();
            if (emoji) {
                insertEmoji(emoji);
                document.getElementById('emojiPicker').style.display = 'none';
                emojiPickerVisible = false;
            }
        }
    });

    // 点击外部区域关闭表情选择器
    document.addEventListener('click', function(e) {
        const picker = document.getElementById('emojiPicker');
        const btn = document.getElementById('emojiBtn');
        if (!picker || !btn) return;
        if (!picker.contains(e.target) && e.target !== btn) {
            picker.style.display = 'none';
            emojiPickerVisible = false;
        }
    });

    // 分类标签切换
    document.querySelectorAll('.emoji-tab').forEach(tab => {
        tab.addEventListener('click', function(e) {
            e.stopPropagation();
            document.querySelectorAll('.emoji-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            renderEmojis(this.dataset.category);
        });
    });

    // 页面加载完成后初始化表情列表
    renderEmojis('recent');
</script>
</body>
</html>