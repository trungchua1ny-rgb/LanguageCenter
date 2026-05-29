<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.langcenter.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    String contextPath = request.getContextPath();
    String fullName = (loggedUser != null) ? loggedUser.getFullName() : "Học viên";
    String role     = (loggedUser != null) ? loggedUser.getRole() : "student";
    String initials = fullName.trim().isEmpty() ? "U"
                    : String.valueOf(fullName.trim().charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Language Center</title>

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    /* ═══════════════════════════════════════════════
       CSS VARIABLES — Blue Theme
    ═══════════════════════════════════════════════ */
    :root {
      --primary:       #1e88e5;
      --primary-dark:  #1565c0;
      --primary-light: #e3f2fd;
      --primary-mid:   #bbdefb;
      --accent:        #f44336;
      --accent-orange: #ff7043;
      --sidebar-w:     200px;
      --header-h:      56px;
      --panel-w:       260px;
      --text-main:     #1a1a2e;
      --text-muted:    #6b7280;
      --text-light:    #9ca3af;
      --border:        #e5e7eb;
      --bg-page:       #f4f6f9;
      --bg-white:      #ffffff;
      --radius:        10px;
      --shadow-sm:     0 1px 3px rgba(0,0,0,.08);
      --shadow-md:     0 4px 12px rgba(0,0,0,.1);
      --font:          'Be Vietnam Pro', sans-serif;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: var(--font);
      background: var(--bg-page);
      color: var(--text-main);
      font-size: 14px;
      min-height: 100vh;
    }

    /* ═══════════════ HEADER ═══════════════ */
    #lc-header {
      position: fixed;
      top: 0; left: 0; right: 0;
      height: var(--header-h);
      background: var(--bg-white);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      padding: 0 16px;
      z-index: 1000;
      gap: 12px;
      box-shadow: var(--shadow-sm);
    }

    /* Logo */
    .lc-logo {
      display: flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
      width: var(--sidebar-w);
      flex-shrink: 0;
    }
    .lc-logo-icon {
      width: 36px; height: 36px;
      background: var(--primary);
      border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      color: white; font-weight: 800; font-size: 16px;
    }
    .lc-logo-text {
      font-size: 15px; font-weight: 700;
      color: var(--primary);
      line-height: 1.1;
    }
    .lc-logo-text span {
      display: block;
      font-size: 10px; font-weight: 400;
      color: var(--text-muted);
      letter-spacing: .5px;
    }

    /* Search */
    .lc-search {
      flex: 1;
      max-width: 480px;
      position: relative;
    }
    .lc-search input {
      width: 100%;
      height: 36px;
      border: 1.5px solid var(--border);
      border-radius: 20px;
      padding: 0 16px 0 38px;
      font-family: var(--font);
      font-size: 13px;
      outline: none;
      background: var(--bg-page);
      transition: border-color .2s, background .2s;
    }
    .lc-search input:focus {
      border-color: var(--primary);
      background: white;
    }
    .lc-search .search-icon {
      position: absolute;
      left: 12px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
      font-size: 14px;
    }

    /* Header right */
    .lc-header-right {
      display: flex;
      align-items: center;
      gap: 4px;
      margin-left: auto;
    }

    .lc-icon-btn {
      width: 36px; height: 36px;
      border-radius: 50%;
      border: none;
      background: transparent;
      display: flex; align-items: center; justify-content: center;
      color: var(--text-muted);
      font-size: 18px;
      cursor: pointer;
      position: relative;
      transition: background .15s;
    }
    .lc-icon-btn:hover { background: var(--primary-light); color: var(--primary); }

    .lc-badge {
      position: absolute; top: 4px; right: 4px;
      width: 8px; height: 8px;
      background: var(--accent);
      border-radius: 50%;
      border: 2px solid white;
    }

    /* Notification bell */
    .lc-notif-text {
      font-size: 13px; font-weight: 500;
      color: var(--text-main);
      cursor: pointer;
      padding: 4px 8px;
      border-radius: 6px;
      transition: background .15s;
      white-space: nowrap;
    }
    .lc-notif-text:hover { background: var(--primary-light); color: var(--primary); }

    /* User profile */
    .lc-user-area {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      padding: 4px 8px;
      border-radius: 8px;
      transition: background .15s;
      position: relative;
    }
    .lc-user-area:hover { background: var(--primary-light); }

    .lc-avatar {
      width: 32px; height: 32px;
      border-radius: 50%;
      background: var(--primary);
      color: white;
      display: flex; align-items: center; justify-content: center;
      font-size: 13px; font-weight: 700;
      flex-shrink: 0;
    }
    .lc-user-name {
      font-size: 13px; font-weight: 600;
      color: var(--text-main);
      max-width: 120px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* Dropdown menu */
    .lc-dropdown {
      position: absolute;
      top: calc(100% + 8px);
      right: 0;
      background: white;
      border-radius: var(--radius);
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
      min-width: 200px;
      padding: 6px 0;
      display: none;
      z-index: 999;
    }
    .lc-dropdown.open { display: block; }
    .lc-dropdown a {
      display: flex; align-items: center; gap: 10px;
      padding: 9px 16px;
      color: var(--text-main);
      text-decoration: none;
      font-size: 13px;
      transition: background .15s;
    }
    .lc-dropdown a:hover { background: var(--primary-light); color: var(--primary); }
    .lc-dropdown a.danger { color: var(--accent); }
    .lc-dropdown a.danger:hover { background: #fef2f2; }
    .lc-dropdown-divider {
      height: 1px; background: var(--border); margin: 4px 0;
    }

    /* ═══════════════ LAYOUT WRAPPER ═══════════════ */
    #lc-layout {
      display: flex;
      padding-top: var(--header-h);
      min-height: 100vh;
    }

    /* ═══════════════ SIDEBAR ═══════════════ */
    #lc-sidebar {
      position: fixed;
      top: var(--header-h);
      left: 0;
      width: var(--sidebar-w);
      height: calc(100vh - var(--header-h));
      background: var(--bg-white);
      border-right: 1px solid var(--border);
      overflow-y: auto;
      overflow-x: hidden;
      z-index: 100;
      padding: 12px 0;
    }

    /* Sidebar scrollbar */
    #lc-sidebar::-webkit-scrollbar { width: 3px; }
    #lc-sidebar::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

    .lc-nav-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 9px 16px;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 13px;
      font-weight: 500;
      border-radius: 0;
      cursor: pointer;
      transition: background .15s, color .15s;
      position: relative;
      border-left: 3px solid transparent;
    }
    .lc-nav-item:hover {
      background: var(--primary-light);
      color: var(--primary);
      text-decoration: none;
    }
    .lc-nav-item.active {
      background: var(--primary-light);
      color: var(--primary);
      border-left-color: var(--primary);
      font-weight: 600;
    }
    .lc-nav-item i {
      font-size: 16px;
      width: 18px;
      flex-shrink: 0;
    }
    .lc-nav-item .nav-arrow {
      margin-left: auto;
      font-size: 11px;
      transition: transform .2s;
    }
    .lc-nav-item.expanded .nav-arrow { transform: rotate(90deg); }

    /* Submenu */
    .lc-submenu {
      display: none;
      background: var(--bg-page);
    }
    .lc-submenu.open { display: block; }
    .lc-submenu a {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px 8px 44px;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 12.5px;
      transition: color .15s, background .15s;
      border-left: 3px solid transparent;
    }
    .lc-submenu a:hover { color: var(--primary); background: var(--primary-light); }
    .lc-submenu a.active {
      color: var(--primary); font-weight: 600;
      border-left-color: var(--primary);
    }
    .lc-submenu a::before {
      content: ''; width: 5px; height: 5px;
      border-radius: 50%;
      background: currentColor;
      flex-shrink: 0;
    }

    /* ═══════════════ MAIN CONTENT ═══════════════ */
    #lc-main {
      margin-left: var(--sidebar-w);
      flex: 1;
      min-width: 0;
      padding: 20px;
    }

    /* ═══════════════ UTILITY CLASSES ═══════════════ */
    .lc-card {
      background: var(--bg-white);
      border-radius: var(--radius);
      border: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
    }
    .lc-card-body { padding: 16px; }

    .lc-section-title {
      font-size: 16px;
      font-weight: 700;
      color: var(--text-main);
      margin-bottom: 12px;
    }
    .lc-section-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
    }
    .lc-view-all {
      font-size: 12px;
      color: var(--primary);
      text-decoration: none;
      font-weight: 500;
    }
    .lc-view-all:hover { text-decoration: underline; }

    /* Status badges */
    .lc-badge-status {
      font-size: 12px; font-weight: 600;
      padding: 2px 8px;
      border-radius: 20px;
    }
    .lc-badge-ongoing   { color: #16a34a; background: #dcfce7; }
    .lc-badge-upcoming  { color: var(--primary); background: var(--primary-light); }
    .lc-badge-finished  { color: #dc2626; background: #fee2e2; }
    .lc-badge-pending   { color: #d97706; background: #fef3c7; }
    .lc-badge-paid      { color: #16a34a; background: #dcfce7; }

    /* Progress ring (dùng cho stat cards) */
    .progress-ring-wrap {
      position: relative;
      width: 80px; height: 80px;
      flex-shrink: 0;
    }
    .progress-ring-wrap svg {
      transform: rotate(-90deg);
    }
    .progress-ring-center {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }

    /* Animations */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(12px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up { animation: fadeInUp .35s ease both; }

    /* Responsive */
    @media (max-width: 768px) {
      :root { --sidebar-w: 0px; }
      #lc-sidebar { transform: translateX(-200px); transition: transform .3s; }
      #lc-sidebar.mobile-open { transform: translateX(0); width: 200px; }
    }
  </style>
</head>
<body>

<!-- ═══════════════════════════════════ HEADER ═══════════════════════════════════ -->
<header id="lc-header">

  <!-- Logo -->
  <a href="<%= contextPath %>/student/dashboard" class="lc-logo">
    <div class="lc-logo-icon">LC</div>
    <div class="lc-logo-text">
      Language Center
      <span>Education & Training</span>
    </div>
  </a>

  <!-- Search -->
  <div class="lc-search">
    <i class="bi bi-search search-icon"></i>
    <input type="text" placeholder="Bạn đang tìm kiếm điều gì?">
  </div>

  <!-- Header Right -->
  <div class="lc-header-right">

    <!-- Notification -->
    <span class="lc-notif-text">
      <i class="bi bi-bell me-1"></i>Thông báo
    </span>

    <!-- Alert icon -->
    <button class="lc-icon-btn" title="Cảnh báo">
      <i class="bi bi-exclamation-triangle"></i>
    </button>

    <!-- Divider -->
    <div style="width:1px;height:24px;background:var(--border);margin:0 4px;"></div>

    <!-- User dropdown -->
    <div class="lc-user-area" onclick="toggleDropdown(this)">
      <div class="lc-avatar"><%= initials %></div>
      <span class="lc-user-name"><%= fullName %></span>
      <i class="bi bi-chevron-down" style="font-size:11px;color:var(--text-muted);"></i>

      <div class="lc-dropdown" id="userDropdown">
        <div style="padding:10px 16px 8px;">
          <div style="font-weight:700;font-size:13px;"><%= fullName %></div>
          <div style="font-size:11px;color:var(--text-muted);margin-top:2px;">
            <%=  "admin".equals(role) ? "Quản trị viên" : "teacher".equals(role) ? "Giáo viên" : "Học viên" %>
          </div>
        </div>
        <div class="lc-dropdown-divider"></div>
        <a href="<%= contextPath %>/profile">
          <i class="bi bi-person"></i> Hồ sơ cá nhân
        </a>
        <a href="#">
          <i class="bi bi-gear"></i> Cài đặt
        </a>
        <div class="lc-dropdown-divider"></div>
        <a href="<%= contextPath %>/logout" class="danger">
          <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
      </div>
    </div>

  </div>
</header>

<!-- ═══════════════════════════════════ LAYOUT ═══════════════════════════════════ -->
<div id="lc-layout">
