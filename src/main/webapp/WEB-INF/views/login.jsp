<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập – Language Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #d2e1f3; /* Màu nền xám xanh nhạt ngoài viền */
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
        }

        .login-wrapper {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            display: flex;
            width: 100%;
            max-width: 950px;
            min-height: 600px;
            overflow: hidden;
            position: relative;
        }

        /* ─── CỘT TRÁI: BLUE PANEL ─── */
        .blue-panel {
            background: linear-gradient(145deg, #1058d1 0%, #0a3d99 100%);
            width: 45%;
            padding: 50px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .blue-panel h4 {
            font-weight: 400;
            margin-bottom: 30px;
            font-size: 20px;
        }

        .logo-circle {
            width: 90px;
            height: 90px;
            background: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .logo-circle i {
            font-size: 45px;
            color: #1058d1;
        }

        .brand-text {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 30px;
            letter-spacing: 0.5px;
        }

        .panel-desc {
            font-size: 13px;
            color: rgba(255,255,255,0.7);
            line-height: 1.6;
            margin-bottom: auto;
        }

        .panel-footer {
            font-size: 11px;
            color: rgba(255,255,255,0.5);
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-top: 40px;
        }

        /* ─── HIỆU ỨNG MÂY (CLOUD DIVIDER) ─── */
        .cloud-divider {
            position: absolute;
            right: -2px; /* Kéo nhẹ sang phải để xóa viền hở */
            top: 0;
            height: 100%;
            width: 90px;
            z-index: 2;
        }

        /* ─── CỘT PHẢI: FORM ĐĂNG NHẬP ─── */
        .form-panel {
            width: 55%;
            padding: 60px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            z-index: 3;
            background: #ffffff;
        }

        .form-title {
            color: #333;
            font-weight: 600;
            font-size: 24px;
            margin-bottom: 40px;
            text-align: center;
        }

        /* Tùy chỉnh Input để chỉ có viền dưới như Template */
        .form-group-custom {
            margin-bottom: 30px;
            position: relative;
        }

        .form-group-custom label {
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
            display: block;
        }

        .form-control-custom {
            width: 100%;
            border: none;
            border-bottom: 2px solid #e0e4e9;
            border-radius: 0;
            padding: 10px 30px 10px 0;
            font-size: 15px;
            color: #333;
            background: transparent;
            transition: border-color 0.3s;
        }

        .form-control-custom:focus {
            outline: none;
            border-bottom-color: #1058d1;
        }

        .form-control-custom::placeholder {
            color: #a9b4c0;
            font-weight: 400;
            font-size: 14px;
        }

        /* Icon nằm đè lên input ở góc phải */
        .input-icon {
            position: absolute;
            right: 0;
            bottom: 12px;
            color: #79c5e7;
            font-size: 20px;
        }
        
        .pw-toggle {
            cursor: pointer;
            color: #79c5e7;
            transition: color 0.3s;
        }
        
        .pw-toggle:hover {
            color: #1058d1;
        }

        /* Checkbox Terms */
        .custom-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #7f8c8d;
            margin-bottom: 35px;
        }
        
        .custom-checkbox input[type="checkbox"] {
            accent-color: #1058d1;
            width: 16px;
            height: 16px;
        }

        /* Buttons dạng Pill */
        .btn-pill {
            border-radius: 50px;
            padding: 10px 40px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
        }

        .btn-primary-custom {
            background: linear-gradient(145deg, #1058d1, #0a3d99);
            color: white;
            border: none;
            box-shadow: 0 8px 15px rgba(16, 88, 209, 0.3);
        }

        .btn-primary-custom:hover {
            background: linear-gradient(145deg, #0a3d99, #1058d1);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(16, 88, 209, 0.4);
        }

        .btn-outline-custom {
            background: transparent;
            color: #a9b4c0;
            border: 1.5px solid #e0e4e9;
        }

        .btn-outline-custom:hover {
            border-color: #1058d1;
            color: #1058d1;
        }

        /* Khu vực Test Account */
        .test-accounts {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px dashed #e0e4e9;
            text-align: center;
        }

        /* MOBILE RESPONSIVE */
        @media (max-width: 768px) {
            .login-wrapper {
                flex-direction: column;
                min-height: 100vh;
                border-radius: 0;
            }
            body { padding: 0; background: #fff; }
            .blue-panel {
                width: 100%;
                padding: 40px 20px;
                border-radius: 0 0 40px 40px;
            }
            .form-panel {
                width: 100%;
                padding: 40px 25px;
            }
            .cloud-divider { display: none; }
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    
    <%-- ─── CỘT TRÁI (BLUE PANEL) ─── --%>
    <div class="blue-panel">
        <h4>Welcome to</h4>
        <div class="logo-circle">
            <i class="bi bi-mortarboard-fill"></i>
        </div>
        <div class="brand-text">Language Center</div>
        
        <p class="panel-desc">
            Hệ thống quản lý trung tâm ngoại ngữ toàn diện. Nền tảng học tập và theo dõi tiến độ tối ưu dành riêng cho học viên, giảng viên và ban quản trị.
        </p>

        <div class="panel-footer">
            Team 5 | Java MVC
        </div>

        <%-- SVG Layer Mây nhiều lớp ghép vào viền phải --%>
        <svg class="cloud-divider" viewBox="0 0 100 100" preserveAspectRatio="none">
            <!-- Lớp mây mờ ngoài cùng -->
            <path fill="rgba(255,255,255,0.2)" d="M100,0 L70,0 Q30,10 60,25 T40,45 T70,65 T30,85 T60,100 L100,100 Z"></path>
            <!-- Lớp mây giữa -->
            <path fill="rgba(255,255,255,0.5)" d="M100,0 L80,0 Q40,15 70,30 T50,55 T80,75 T40,90 T70,100 L100,100 Z"></path>
            <!-- Lớp mây trắng trong cùng -->
            <path fill="#ffffff" d="M100,0 L90,0 Q60,20 85,35 T60,60 T85,80 T60,95 L90,100 L100,100 Z"></path>
        </svg>
    </div>

    <%-- ─── CỘT PHẢI (FORM PANEL) ─── --%>
    <div class="form-panel">
        
        <h4 class="form-title">Login to your account</h4>

        <%-- Hiển thị lỗi đăng nhập --%>
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
        <div class="alert alert-danger alert-dismissible fade show py-2 mb-4" role="alert" style="border-radius: 10px;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><small><%= errorMsg %></small>
            <button type="button" class="btn-close btn-sm" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="POST" novalidate>
            
            <%-- Input: Username --%>
            <div class="form-group-custom">
                <label for="username">Tài khoản</label>
                <input type="text" 
                       class="form-control-custom" 
                       id="username" 
                       name="username" 
                       placeholder="Enter your username"
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                       autofocus required>
                <i class="bi bi-check2 input-icon"></i>
            </div>

            <%-- Input: Password --%>
            <div class="form-group-custom">
                <label for="password">Mật khẩu</label>
                <input type="password" 
                       class="form-control-custom" 
                       id="password" 
                       name="password" 
                       placeholder="Enter your password" 
                       required>
                <i class="bi bi-eye-slash input-icon pw-toggle" id="togglePwIcon" onclick="togglePassword()" title="Hiện/ẩn mật khẩu"></i>
            </div>

            <%-- Checkbox (Decor) --%>
            <div class="custom-checkbox">
                <input type="checkbox" id="rememberMe" checked>
                <label for="rememberMe" class="mb-0">By Signing in, I agree with <a href="#" class="text-decoration-none" style="color: #1058d1;">Terms & Conditions</a></label>
            </div>

            <%-- Nút bấm --%>
            <div class="d-flex gap-3 align-items-center">
                <button type="submit" class="btn btn-primary-custom btn-pill">
                    Đăng nhập
                </button>
                <button type="button" class="btn btn-outline-custom btn-pill">
                    Đăng ký
                </button>
            </div>
        </form>

        <%-- Khu vực Nút điền nhanh (Test Data) --%>
        <div class="test-accounts">
            <p class="text-muted small mb-3">Tài khoản test (password: <code>123456</code>)</p>
            <div class="d-flex gap-2 justify-content-center flex-wrap">
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="fillLogin('admin')">Admin</button>
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="fillLogin('teacher01')">Teacher</button>
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="fillLogin('sv001')">Student</button>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Logic ẩn/hiện mật khẩu
    function togglePassword() {
        const pw = document.getElementById('password');
        const icon = document.getElementById('togglePwIcon');
        if (pw.type === 'password') {
            pw.type = 'text';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        } else {
            pw.type = 'password';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        }
    }

    // Logic điền nhanh tài khoản test
    function fillLogin(username) {
        document.getElementById('username').value = username;
        document.getElementById('password').value = '123456';
    }
</script>
</body>
</html>