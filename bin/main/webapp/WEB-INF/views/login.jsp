<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đăng nhập – Language Center</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .login-card {
      width: 100%;
      max-width: 420px;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.25);
    }
    .login-logo {
      width: 60px;
      height: 60px;
      background: #1a73e8;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 28px;
      margin: 0 auto 16px;
    }
  </style>
</head>
<body>

<div class="card login-card p-4 p-md-5">

  <div class="text-center mb-4">
    <div class="login-logo">🎓</div>
    <h4 class="fw-bold mb-1">Language Center</h4>
    <p class="text-muted small">Đăng nhập để tiếp tục</p>
  </div>

  <%
    String errorMsg = (String) request.getAttribute("errorMsg");
    if (errorMsg != null && !errorMsg.isEmpty()) {
  %>
  <div class="alert alert-danger alert-dismissible fade show py-2" role="alert">
    <small><%= errorMsg %></small>
    <button type="button" class="btn-close btn-sm" data-bs-dismiss="alert"></button>
  </div>
  <% } %>

  <form action="<%= request.getContextPath() %>/login" method="POST" novalidate>

    <div class="mb-3">
      <label for="username" class="form-label fw-semibold">Tài khoản</label>
      <input type="text"
             class="form-control form-control-lg"
             id="username"
             name="username"
             placeholder="Nhập username"
             value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
             autofocus required>
    </div>

    <div class="mb-4">
      <label for="password" class="form-label fw-semibold">Mật khẩu</label>
      <div class="input-group">
        <input type="password"
               class="form-control form-control-lg"
               id="password"
               name="password"
               placeholder="Nhập mật khẩu"
               required>
        <button class="btn btn-outline-secondary" type="button"
                onclick="togglePassword()"
                title="Hiện/ẩn mật khẩu">👁</button>
      </div>
    </div>

    <div class="d-grid">
      <button type="submit" class="btn btn-primary btn-lg fw-semibold">
        Đăng nhập
      </button>
    </div>

  </form>

  <hr class="my-4">
  <p class="text-muted text-center small mb-2">Tài khoản test (password: <code>123456</code>)</p>
  <div class="d-flex gap-2 justify-content-center flex-wrap">
    <button class="btn btn-sm btn-outline-secondary" onclick="fillLogin('admin')">admin</button>
    <button class="btn btn-sm btn-outline-secondary" onclick="fillLogin('teacher01')">teacher01</button>
    <button class="btn btn-sm btn-outline-secondary" onclick="fillLogin('sv001')">sv001</button>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function togglePassword() {
    const pw = document.getElementById('password');
    pw.type = (pw.type === 'password') ? 'text' : 'password';
  }
  function fillLogin(username) {
    document.getElementById('username').value = username;
    document.getElementById('password').value = '123456';
  }
</script>
</body>
</html>