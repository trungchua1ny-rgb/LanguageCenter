<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.langcenter.model.User" %>
<%
    // KHAI BÁO BIẾN 1 LẦN DUY NHẤT TẠI ĐÂY
    User loggedUser = (User) session.getAttribute("loggedUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Language Center</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

  <style>
    /* ── Layout skeleton ────────────────────────────────────── */
    body { display: flex; flex-direction: column; min-height: 100vh; background: #f4f6fb; }
    .main-wrapper { display: flex; flex: 1; }
    .page-content { flex: 1; padding: 24px; overflow-y: auto; }

    /* ── Topbar ─────────────────────────────────────────────── */
    .topbar {
      height: 56px; background: #fff; border-bottom: 1px solid #e3e6f0;
      display: flex; align-items: center; padding: 0 20px;
      position: sticky; top: 0; z-index: 1030; gap: 12px;
    }
    .topbar-brand {
      font-weight: 700; font-size: 17px; color: #1a73e8;
      text-decoration: none; display: flex; align-items: center; gap: 8px; white-space: nowrap;
    }
    .topbar-brand span { font-size: 22px; }
    .topbar-spacer { flex: 1; }

    /* Role badge */
    .role-badge {
      font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px;
      text-transform: uppercase; letter-spacing: .5px;
    }
    .role-admin   { background: #fde8e8; color: #c0392b; }
    .role-teacher { background: #e8f5e9; color: #1b5e20; }
    .role-student { background: #e3f2fd; color: #0d47a1; }

    /* Avatar dropdown */
    .avatar-btn {
      width: 36px; height: 36px; border-radius: 50%; background: #1a73e8; color: #fff;
      font-weight: 600; font-size: 14px; border: none; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
    }

    /* Sidebar toggle btn (mobile) */
    #sidebarToggle { display: none; }
    @media (max-width: 768px) { #sidebarToggle { display: flex; } }
  </style>
</head>
<body>

<nav class="topbar">
  <button id="sidebarToggle" class="btn btn-sm btn-light me-2" onclick="document.getElementById('sidebar').classList.toggle('show')">
    <i class="bi bi-list fs-5"></i>
  </button>
  <a class="topbar-brand" href="<%= contextPath %>/dashboard"><span>🎓</span> Language Center</a>
  <div class="topbar-spacer"></div>

  <% if (loggedUser != null) { %>
  <span class="role-badge role-<%= loggedUser.getRole() %>"><%= loggedUser.getRole() %></span>
  <div class="dropdown">
    <button class="avatar-btn dropdown-toggle" data-bs-toggle="dropdown" title="<%= loggedUser.getFullName() %>" style="list-style:none">
      <%= loggedUser.getFullName().substring(0, 1).toUpperCase() %>
    </button>
    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
      <li>
        <div class="px-3 py-2">
          <div class="fw-semibold" style="font-size:14px"><%= loggedUser.getFullName() %></div>
          <div class="text-muted" style="font-size:12px"><%= loggedUser.getEmail() %></div>
        </div>
      </li>
      <li><hr class="dropdown-divider my-1"></li>
      <li><a class="dropdown-item" href="<%= contextPath %>/profile"><i class="bi bi-person me-2"></i>Hồ sơ cá nhân</a></li>
      <li><hr class="dropdown-divider my-1"></li>
      <li><a class="dropdown-item text-danger" href="<%= contextPath %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
    </ul>
  </div>
  <% } %>
</nav>

<div class="main-wrapper">