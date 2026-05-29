<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.langcenter.model.User" %>
<%
    User s_user = (User) session.getAttribute("loggedUser");
    String s_role = (s_user != null) ? s_user.getRole() : "student";
    String s_ctx  = request.getContextPath();
    String s_uri  = request.getRequestURI();

    // Helper để check active
    boolean isAdmin   = "admin".equals(s_role);
    boolean isTeacher = "teacher".equals(s_role);
    boolean isStudent = "student".equals(s_role);
%>

<!-- ═══════════════════════════════════ SIDEBAR ═══════════════════════════════════ -->
<nav id="lc-sidebar">

  <% if (isStudent) { %>
  <%-- ══════════ STUDENT SIDEBAR ══════════ --%>

  <a href="<%= s_ctx %>/student/dashboard"
     class="lc-nav-item <%= s_uri.contains("/student/dashboard") ? "active" : "" %>">
    <i class="bi bi-grid-1x2"></i>
    Tổng quan
  </a>

  <!-- Khóa học (có submenu) -->
  <div class="lc-nav-item <%= s_uri.contains("/student/courses") || s_uri.contains("/student/my-classes") ? "active expanded" : "" %>"
       onclick="toggleSubmenu(this, 'sub-courses')">
    <i class="bi bi-book"></i>
    Khóa học
    <i class="bi bi-chevron-right nav-arrow"></i>
  </div>
  <div class="lc-submenu <%= s_uri.contains("/student/courses") || s_uri.contains("/student/my-classes") ? "open" : "" %>"
       id="sub-courses">
    <a href="<%= s_ctx %>/student/my-classes"
       class="<%= s_uri.contains("/student/my-classes") ? "active" : "" %>">
      Khóa học của tôi
    </a>
    <a href="<%= s_ctx %>/student/courses"
       class="<%= s_uri.contains("/student/courses") && !s_uri.contains("my-classes") ? "active" : "" %>">
      Khóa học để xuất
    </a>
  </div>

  <a href="<%= s_ctx %>/student/schedule"
     class="lc-nav-item <%= s_uri.contains("/student/schedule") ? "active" : "" %>">
    <i class="bi bi-calendar-week"></i>
    Lịch học
  </a>

  <!-- Tài liệu học tập (có submenu) -->
  <div class="lc-nav-item"
       onclick="toggleSubmenu(this, 'sub-docs')">
    <i class="bi bi-folder2-open"></i>
    Tài liệu học tập
    <i class="bi bi-chevron-right nav-arrow"></i>
  </div>
  <div class="lc-submenu" id="sub-docs">
    <a href="#">Tất cả</a>
    <a href="#">Tài liệu của tôi</a>
  </div>

  <a href="<%= s_ctx %>/student/grades"
     class="lc-nav-item <%= s_uri.contains("/student/grades") ? "active" : "" %>">
    <i class="bi bi-bar-chart-line"></i>
    Điểm số
  </a>

  <!-- Phân cách -->
  <div style="height:1px;background:var(--border);margin:8px 12px;"></div>

  <a href="<%= s_ctx %>/student/ai-consult"
     class="lc-nav-item <%= s_uri.contains("/student/ai-consult") ? "active" : "" %>">
    <i class="bi bi-robot"></i>
    Tư vấn AI lộ trình
  </a>

  <a href="#" class="lc-nav-item">
    <i class="bi bi-stars"></i>
    Chấm điểm IELTS AI
  </a>

  <a href="#" class="lc-nav-item">
    <i class="bi bi-cpu"></i>
    Chấm điểm TOEIC AI
  </a>

  <a href="#" class="lc-nav-item">
    <i class="bi bi-pencil-square"></i>
    Test online
  </a>

  <a href="#" class="lc-nav-item">
    <i class="bi bi-newspaper"></i>
    Tin tức và sự kiện
  </a>

  <!-- Phân cách -->
  <div style="height:1px;background:var(--border);margin:8px 12px;"></div>

  <!-- Góp ý (có submenu) -->
  <div class="lc-nav-item"
       onclick="toggleSubmenu(this, 'sub-support')">
    <i class="bi bi-question-circle"></i>
    Góp ý và yêu cầu hỗ trợ
    <i class="bi bi-chevron-right nav-arrow"></i>
  </div>
  <div class="lc-submenu" id="sub-support">
    <a href="#">Tất cả</a>
    <a href="#">Tạo yêu cầu mới</a>
    <a href="#">Báo lỗi</a>
  </div>

  <% } else if (isAdmin) { %>
  <%-- ══════════ ADMIN SIDEBAR ══════════ --%>

  <a href="<%= s_ctx %>/admin/dashboard"
     class="lc-nav-item <%= s_uri.contains("/admin/dashboard") ? "active" : "" %>">
    <i class="bi bi-grid-1x2"></i>
    Tổng quan
  </a>

  <div style="padding:6px 16px 4px;font-size:10px;font-weight:700;
              color:var(--text-light);letter-spacing:.8px;text-transform:uppercase;">
    QUẢN LÝ
  </div>

  <a href="<%= s_ctx %>/admin/courses"
     class="lc-nav-item <%= s_uri.contains("/admin/courses") ? "active" : "" %>">
    <i class="bi bi-book"></i>
    Khóa học
  </a>

  <a href="<%= s_ctx %>/admin/classes"
     class="lc-nav-item <%= s_uri.contains("/admin/classes") ? "active" : "" %>">
    <i class="bi bi-door-open"></i>
    Lớp học
  </a>

  <a href="<%= s_ctx %>/admin/students"
     class="lc-nav-item <%= s_uri.contains("/admin/students") ? "active" : "" %>">
    <i class="bi bi-people"></i>
    Học viên
  </a>

  <a href="<%= s_ctx %>/admin/enrollments"
     class="lc-nav-item <%= s_uri.contains("/admin/enrollments") ? "active" : "" %>">
    <i class="bi bi-card-checklist"></i>
    Duyệt đăng ký
  </a>

  <div style="padding:6px 16px 4px;font-size:10px;font-weight:700;
              color:var(--text-light);letter-spacing:.8px;text-transform:uppercase;">
    HỌC VỤ
  </div>

  <a href="<%= s_ctx %>/admin/schedules"
     class="lc-nav-item <%= s_uri.contains("/admin/schedules") ? "active" : "" %>">
    <i class="bi bi-calendar3"></i>
    Thời khóa biểu
  </a>

  <a href="<%= s_ctx %>/admin/grades"
     class="lc-nav-item <%= s_uri.contains("/admin/grades") ? "active" : "" %>">
    <i class="bi bi-award"></i>
    Điểm số
  </a>

  <% } %>

</nav>

<!-- ═══════════════════════════════════ MAIN ═══════════════════════════════════ -->
<main id="lc-main">
