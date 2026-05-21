<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.langcenter.model.User" %>
<%
    User s_user = (User) session.getAttribute("loggedUser");
    String s_role = (s_user != null) ? s_user.getRole() : "student";
    String s_contextPath = request.getContextPath();
    String s_uri = request.getRequestURI();
%>

<!-- ======= Sidebar ======= -->
<aside id="sidebar" class="sidebar">

  <ul class="sidebar-nav" id="sidebar-nav">

    <%-- ══════════════════════════════════════ ADMIN ══ --%>
    <% if ("admin".equals(s_role)) { %>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/dashboard") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/dashboard">
          <i class="bi bi-grid"></i>
          <span>Dashboard</span>
        </a>
      </li>

      <li class="nav-heading">Quản lý</li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/courses") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/courses">
          <i class="bi bi-book"></i>
          <span>Khóa học</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/classes") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/classes">
          <i class="bi bi-door-open"></i>
          <span>Lớp học</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/students") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/students">
          <i class="bi bi-people"></i>
          <span>Học viên</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/enrollments") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/enrollments">
          <i class="bi bi-card-checklist"></i>
          <span>Duyệt Đăng ký</span>
        </a>
      </li>

      <li class="nav-heading">Học vụ</li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/schedules") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/schedules">
          <i class="bi bi-calendar3"></i>
          <span>Thời khóa biểu</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/admin/grades") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/admin/grades">
          <i class="bi bi-award"></i>
          <span>Điểm số</span>
        </a>
      </li>

    <%-- ══════════════════════════════════════ TEACHER ══ --%>
    <% } else if ("teacher".equals(s_role)) { %>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/teacher/dashboard") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/teacher/dashboard">
          <i class="bi bi-grid"></i>
          <span>Dashboard</span>
        </a>
      </li>

      <li class="nav-heading">Giảng dạy</li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/teacher/classes") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/teacher/classes">
          <i class="bi bi-door-open"></i>
          <span>Lớp của tôi</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/teacher/grades") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/teacher/grades">
          <i class="bi bi-patch-check"></i>
          <span>Nhập điểm</span>
        </a>
      </li>

    <%-- ══════════════════════════════════════ STUDENT ══ --%>
    <% } else { %>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/dashboard") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/dashboard">
          <i class="bi bi-grid"></i>
          <span>Trang chủ</span>
        </a>
      </li>

      <li class="nav-heading">Học tập</li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/courses") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/courses">
          <i class="bi bi-book"></i>
          <span>Khóa học</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/my-classes") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/my-classes">
          <i class="bi bi-journal-bookmark"></i>
          <span>Lớp đã đăng ký</span>
        </a>
      </li>

      <li class="nav-heading">Học vụ</li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/schedule") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/schedule">
          <i class="bi bi-calendar-week"></i>
          <span>Thời khóa biểu</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/grades") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/grades">
          <i class="bi bi-award"></i>
          <span>Điểm số</span>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link <%= s_uri.contains("/student/ai-consult") ? "" : "collapsed" %>"
           href="<%= s_contextPath %>/student/ai-consult">
          <i class="bi bi-robot"></i>
          <span>Tư vấn AI</span>
        </a>
      </li>

    <% } %>

    <%-- ── CHUNG cho mọi role ── --%>
    <li class="nav-heading">Tài khoản</li>

    <li class="nav-item">
      <a class="nav-link <%= s_uri.contains("/profile") ? "" : "collapsed" %>"
         href="<%= s_contextPath %>/profile">
        <i class="bi bi-person-circle"></i>
        <span>Hồ sơ cá nhân</span>
      </a>
    </li>

  </ul>

</aside><!-- End Sidebar -->

<main id="main" class="main">
