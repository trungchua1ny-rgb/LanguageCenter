<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.langcenter.model.User" %>
<%
    // Khai báo lại với tên biến khác (s_...) để Eclipse không báo lỗi "cannot be resolved"
    // và Tomcat cũng không báo lỗi trùng lặp khi gộp file.
    User s_user = (User) session.getAttribute("loggedUser");
    String s_role = (s_user != null) ? s_user.getRole() : "student";
    String s_contextPath = request.getContextPath();
    String s_uri = request.getRequestURI();
%>

<style>
  /* ── Sidebar ──────────────────────────────────────────────── */
  #sidebar {
    width: 230px; min-width: 230px; background: #fff;
    border-right: 1px solid #e3e6f0; display: flex; flex-direction: column;
    padding: 12px 0; overflow-y: auto;
  }
  .sidebar-section-label {
    font-size: 10px; font-weight: 700; color: #adb5bd;
    text-transform: uppercase; letter-spacing: 1px; padding: 14px 20px 4px;
  }
  .sidebar-link {
    display: flex; align-items: center; gap: 10px; padding: 9px 20px;
    font-size: 14px; color: #495057; text-decoration: none; border-radius: 0;
    transition: background .15s, color .15s; border-left: 3px solid transparent;
  }
  .sidebar-link:hover { background: #f0f4ff; color: #1a73e8; }
  .sidebar-link.active {
    background: #e8f0fe; color: #1a73e8; font-weight: 600; border-left-color: #1a73e8;
  }
  .sidebar-link i { font-size: 17px; width: 20px; text-align: center; }

  /* Mobile overlay */
  @media (max-width: 768px) {
    #sidebar {
      position: fixed; left: -230px; top: 56px; height: calc(100vh - 56px);
      z-index: 1025; transition: left .25s; box-shadow: 4px 0 16px rgba(0,0,0,.1);
    }
    #sidebar.show { left: 0; }
  }
</style>

<nav id="sidebar">

  <div class="sidebar-section-label">Tổng quan</div>
  <a href="<%= s_contextPath %>/admin/dashboard" class="sidebar-link <%= s_uri.contains("/dashboard") ? "active" : "" %>">
    <i class="bi bi-grid-1x2"></i> Dashboard
  </a>

  <% if ("admin".equals(s_role)) { %>
  <div class="sidebar-section-label">Quản lý</div>
  
  <a href="<%= s_contextPath %>/admin/users" class="sidebar-link <%= s_uri.contains("/admin/users") ? "active" : "" %>">
    <i class="bi bi-people"></i> Người dùng
  </a>
  
  <%-- 2 menu mới được thêm vào đây --%>
  <a href="<%= s_contextPath %>/admin/students" class="sidebar-link <%= s_uri.contains("/admin/students") ? "active" : "" %>">
    <i class="bi bi-person-lines-fill"></i> Quản lý Học viên
  </a>
  
  <a href="<%= s_contextPath %>/admin/courses" class="sidebar-link <%= s_uri.contains("/admin/courses") ? "active" : "" %>">
    <i class="bi bi-book"></i> Khóa học
  </a>
  
  <a href="<%= s_contextPath %>/admin/enrollments" class="sidebar-link <%= s_uri.contains("/admin/enrollments") ? "active" : "" %>">
    <i class="bi bi-card-checklist"></i> Duyệt Đăng ký
  </a>

  <a href="<%= s_contextPath %>/admin/classes" class="sidebar-link <%= s_uri.contains("/admin/classes") ? "active" : "" %>">
    <i class="bi bi-door-open"></i> Lớp học
  </a>

  <% } else if ("teacher".equals(s_role)) { %>
  <div class="sidebar-section-label">Giảng dạy</div>
  <a href="<%= s_contextPath %>/teacher/classes" class="sidebar-link <%= s_uri.contains("/teacher/classes") ? "active" : "" %>">
    <i class="bi bi-door-open"></i> Lớp của tôi
  </a>
  <a href="<%= s_contextPath %>/teacher/grades" class="sidebar-link <%= s_uri.contains("/teacher/grades") ? "active" : "" %>">
    <i class="bi bi-patch-check"></i> Nhập điểm
  </a>

  <% } else { %>
  <div class="sidebar-section-label">Học tập</div>
  <a href="<%= s_contextPath %>/student/courses" class="sidebar-link <%= s_uri.contains("/student/courses") ? "active" : "" %>">
    <i class="bi bi-book"></i> Khóa học
  </a>
  <a href="<%= s_contextPath %>/student/my-classes" class="sidebar-link <%= s_uri.contains("/student/my-classes") ? "active" : "" %>">
    <i class="bi bi-journal-bookmark"></i> Lớp đã đăng ký
  </a>
  <% } %>

  <div class="sidebar-section-label">Tài khoản</div>
  <a href="<%= s_contextPath %>/profile" class="sidebar-link <%= s_uri.contains("/profile") ? "active" : "" %>">
    <i class="bi bi-person-circle"></i> Hồ sơ cá nhân
  </a>

</nav>

<div class="page-content">