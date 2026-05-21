<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.langcenter.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Language Center</title>

  <!-- Favicons -->
  <link href="<%= contextPath %>/assets/img/favicon.png" rel="icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="<%= contextPath %>/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="<%= contextPath %>/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="<%= contextPath %>/assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">

  <!-- NiceAdmin Main CSS -->
  <link href="<%= contextPath %>/assets/css/style.css" rel="stylesheet">

</head>
<body>

<!-- ======= Header ======= -->
<header id="header" class="header fixed-top d-flex align-items-center">

  <div class="d-flex align-items-center justify-content-between">
    <a href="<%= contextPath %>/admin/dashboard" class="logo d-flex align-items-center">
      <span class="d-none d-lg-block">🎓 Language Center</span>
    </a>
    <i class="bi bi-list toggle-sidebar-btn"></i>
  </div><!-- End Logo -->

  <nav class="header-nav ms-auto">
    <ul class="d-flex align-items-center">

      <% if (loggedUser != null) { %>

      <!-- Role badge -->
      <li class="nav-item d-none d-sm-block pe-3">
        <%
          String role = loggedUser.getRole();
          String badgeColor = "primary";
          if ("admin".equals(role))        badgeColor = "danger";
          else if ("teacher".equals(role)) badgeColor = "success";
        %>
        <span class="badge bg-<%= badgeColor %> text-uppercase"><%= role %></span>
      </li>

      <!-- Profile Nav -->
      <li class="nav-item dropdown pe-3">
        <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
          <!-- Avatar chữ cái đầu -->
          <span class="d-flex align-items-center justify-content-center rounded-circle text-white fw-bold"
                style="width:36px;height:36px;background:#0d6efd;font-size:14px;flex-shrink:0;">
            <%= loggedUser.getFullName().substring(0, 1).toUpperCase() %>
          </span>
          <span class="d-none d-md-block dropdown-toggle ps-2">
            <%= loggedUser.getFullName() %>
          </span>
        </a>

        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
          <li class="dropdown-header">
            <h6><%= loggedUser.getFullName() %></h6>
            <span><%= loggedUser.getEmail() %></span>
          </li>
          <li><hr class="dropdown-divider"></li>
          <li>
            <a class="dropdown-item d-flex align-items-center" href="<%= contextPath %>/profile">
              <i class="bi bi-person"></i>
              <span>Hồ sơ cá nhân</span>
            </a>
          </li>
          <li><hr class="dropdown-divider"></li>
          <li>
            <a class="dropdown-item d-flex align-items-center text-danger" href="<%= contextPath %>/logout">
              <i class="bi bi-box-arrow-right"></i>
              <span>Đăng xuất</span>
            </a>
          </li>
        </ul>
      </li><!-- End Profile Nav -->

      <% } %>

    </ul>
  </nav><!-- End Icons Navigation -->

</header><!-- End Header -->
