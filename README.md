# 🎓 Language Center Management System

Dự án Quản lý Trung tâm Ngoại ngữ - Java Web MVC.

## 🚀 Hướng dẫn Setup Môi trường cho Dev

### 1. Database (MariaDB)
1. Mở phần mềm quản lý (HeidiSQL, DBeaver, MySQL Workbench...).
2. Tạo database mới tên là `language_center` (Collation: `utf8mb4_unicode_ci`).
3. Mở file `database/schema_language_center.sql` trong source code và chạy để tự động tạo các bảng và dữ liệu mẫu.

### 2. Cấu hình Kết nối Database
**⚠️ LƯU Ý BẢO MẬT:** Tuyệt đối không push file chứa mật khẩu thật lên Git.
1. Truy cập vào thư mục `src/main/resources/`.
2. Tìm file `db.properties.example`, copy nó ra và đổi tên bản copy thành `db.properties`.
3. Mở file `db.properties` vừa tạo, thay dòng `nhap_mat_khau_cua_ban_vao_day` bằng mật khẩu MariaDB trên máy cá nhân của bạn.

### 3. Chạy Project
1. Import source code vào Eclipse dưới dạng **Maven Project**.
2. Chuột phải vào project -> Chọn `Maven` -> `Update Project...` (đợi load xong thư viện).
3. Add project vào **Tomcat 9**, chọn `Publish` và `Start`.
4. Truy cập web: `http://localhost:8081/LanguageCenter/login` (hoặc cổng 8080 tùy cấu hình Tomcat của bạn).
5. **Tài khoản Admin để test:** username: `admin` / password: `123456`

---

## 🌿 Quy trình Làm việc với Git (Git Flow)

Để đảm bảo source code không bị conflict (đụng độ) và "vỡ" dự án, toàn team tuân thủ nghiêm ngặt quy tắc sau:

1. **KHÔNG BAO GIỜ** code và push trực tiếp lên nhánh `main` (nhánh production) hay `develop` (nhánh base code chung).
2. Base code đã được khởi tạo và chia sẵn nhánh cho từng người. Sau khi `git clone` về máy, bạn cần chuyển sang đúng nhánh của mình để code:
   - Nhánh Đăng ký học: `git checkout feature/enrollment`
   - Nhánh Lịch học: `git checkout feature/schedule`
   - Nhánh Điểm số: `git checkout feature/grades`
   - Nhánh AI Chat: `git checkout feature/gemini-ai`
3. Chỉ code, commit và push lên nhánh `feature/xxx` của cá nhân mình.
4. Khi code xong một tính năng và test chạy ổn định, lên GitHub tạo **Pull Request (PR)** yêu cầu gộp nhánh của bạn vào nhánh `develop`.
5. Tech Lead sẽ review code. Nếu OK sẽ bấm Merge (gộp).