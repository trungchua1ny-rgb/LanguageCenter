<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ page import="com.langcenter.model.User" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
/* ── STAT CARDS ── */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
  margin-bottom: 22px;
}
.stat-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 18px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  text-decoration: none;
  transition: box-shadow .2s, transform .15s;
  border-left: 4px solid transparent;
}
.stat-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
  text-decoration: none;
}
.stat-icon {
  width: 48px; height: 48px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 22px; flex-shrink: 0;
}
.stat-info { flex: 1; min-width: 0; }
.stat-label {
  font-size: 11px; font-weight: 600; text-transform: uppercase;
  letter-spacing: .5px; color: var(--text-muted); margin-bottom: 4px;
}
.stat-value {
  font-size: 26px; font-weight: 800; color: var(--text-main); line-height: 1;
}
.stat-sub {
  font-size: 11px; color: var(--text-muted); margin-top: 3px;
}
/* Color variants */
.stat-blue  { border-left-color: var(--primary); }
.stat-blue  .stat-icon { background: var(--primary-light); color: var(--primary); }
.stat-green { border-left-color: #16a34a; }
.stat-green .stat-icon { background: #dcfce7; color: #16a34a; }
.stat-amber { border-left-color: #d97706; }
.stat-amber .stat-icon { background: #fef3c7; color: #d97706; }
.stat-purple{ border-left-color: #7c3aed; }
.stat-purple .stat-icon { background: #ede9fe; color: #7c3aed; }

/* ── SECTION HEADER ── */
.lc-section-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 12px;
}
.lc-section-title { font-size: 15px; font-weight: 700; color: var(--text-main); }
.lc-view-all {
  font-size: 12px; color: var(--primary); text-decoration: none; font-weight: 500;
}
.lc-view-all:hover { text-decoration: underline; }

/* ── WELCOME CARD ── */
.welcome-card {
  background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
  border-radius: var(--radius);
  padding: 20px 24px;
  color: white;
  margin-bottom: 20px;
  display: flex; align-items: center; justify-content: space-between;
}
.welcome-text h2 { font-size: 18px; font-weight: 700; margin-bottom: 4px; }
.welcome-text p  { font-size: 13px; opacity: .85; margin: 0; }
.welcome-badge {
  width: 52px; height: 52px; border-radius: 50%;
  background: rgba(255,255,255,.2);
  display: flex; align-items: center; justify-content: center;
  font-size: 26px; flex-shrink: 0;
}

/* ── TABLE CARD ── */
.table-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  margin-bottom: 20px;
}
.table-card-head {
  padding: 14px 18px;
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
}
.table-card-title { font-size: 14px; font-weight: 700; color: var(--text-main); }
.lc-table {
  width: 100%; border-collapse: collapse; font-size: 13px;
}
.lc-table th {
  padding: 10px 18px; text-align: left;
  background: #f9fafb; color: var(--text-muted);
  font-size: 11px; font-weight: 700; text-transform: uppercase;
  letter-spacing: .5px; border-bottom: 1px solid var(--border);
}
.lc-table td {
  padding: 11px 18px; border-bottom: 1px solid var(--border);
  color: var(--text-main); vertical-align: middle;
}
.lc-table tr:last-child td { border-bottom: none; }
.lc-table tr:hover td { background: var(--primary-light); }

/* Status badge */
.lc-tag {
  display: inline-block; padding: 3px 10px; border-radius: 20px;
  font-size: 11px; font-weight: 600;
}
.lc-tag-pending  { background: #fef3c7; color: #92400e; }
.lc-tag-paid     { background: #dcfce7; color: #166534; }
.lc-tag-refunded { background: #f3f4f6; color: #6b7280; }

/* Quick action links */
.quick-actions {
  display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px;
}
.qa-btn {
  display: flex; align-items: center; gap: 10px;
  padding: 12px 14px; border-radius: 9px;
  background: var(--bg-page); border: 1.5px solid var(--border);
  text-decoration: none; color: var(--text-main);
  font-size: 13px; font-weight: 500;
  transition: background .15s, border-color .15s, color .15s;
}
.qa-btn:hover {
  background: var(--primary-light);
  border-color: var(--primary);
  color: var(--primary);
  text-decoration: none;
}
.qa-btn i { font-size: 18px; color: var(--primary); }
</style>

<!-- Welcome -->
<div class="welcome-card fade-in-up">
  <div class="welcome-text">
    <h2>Xin chào, <%= loggedUser != null ? loggedUser.getFullName() : "Admin" %> 👋</h2>
    <p>Chào mừng bạn quay trở lại hệ thống quản lý Language Center.</p>
  </div>
  <div class="welcome-badge">🎓</div>
</div>

<!-- Stat Cards -->
<div class="stat-grid fade-in-up">

  <a href="${pageContext.request.contextPath}/admin/courses" class="stat-card stat-blue">
    <div class="stat-icon"><i class="bi bi-book-fill"></i></div>
    <div class="stat-info">
      <div class="stat-label">Khóa học</div>
      <div class="stat-value">${totalCourses != null ? totalCourses : 0}</div>
      <div class="stat-sub">tổng cộng</div>
    </div>
  </a>

  <a href="${pageContext.request.contextPath}/admin/classes" class="stat-card stat-green">
    <div class="stat-icon"><i class="bi bi-door-open-fill"></i></div>
    <div class="stat-info">
      <div class="stat-label">Lớp đang học</div>
      <div class="stat-value">${totalOngoingClasses != null ? totalOngoingClasses : 0}</div>
      <div class="stat-sub">đang hoạt động</div>
    </div>
  </a>

  <a href="${pageContext.request.contextPath}/admin/enrollments?status=pending" class="stat-card stat-amber">
    <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
    <div class="stat-info">
      <div class="stat-label">Chờ duyệt</div>
      <div class="stat-value">${totalPending != null ? totalPending : 0}</div>
      <div class="stat-sub">đơn đăng ký</div>
    </div>
  </a>

  <a href="${pageContext.request.contextPath}/admin/students" class="stat-card stat-purple">
    <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
    <div class="stat-info">
      <div class="stat-label">Học viên</div>
      <div class="stat-value">${totalStudents != null ? totalStudents : 0}</div>
      <div class="stat-sub">đã đăng ký</div>
    </div>
  </a>

</div>

<!-- Main content: Table + Quick actions -->
<div style="display:grid; grid-template-columns:1fr 280px; gap:18px; align-items:start;">

  <!-- Bảng đăng ký mới nhất -->
  <div>
    <div class="table-card fade-in-up">
      <div class="table-card-head">
        <div class="table-card-title">
          <i class="bi bi-clock-history me-2" style="color:var(--primary)"></i>
          Đăng ký mới nhất
        </div>
        <a href="${pageContext.request.contextPath}/admin/enrollments" class="lc-view-all">
          Xem tất cả &gt;
        </a>
      </div>
      <table class="lc-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Học viên</th>
            <th>Lớp học</th>
            <th>Ngày đăng ký</th>
            <th>Trạng thái</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty recentEnrollments}">
              <c:forEach var="en" items="${recentEnrollments}" varStatus="s">
                <tr>
                  <td style="color:var(--text-muted)">${s.count}</td>
                  <td style="font-weight:600">${en.studentName}</td>
                  <td>
                    <span style="background:var(--primary-light);color:var(--primary);
                                 padding:2px 9px;border-radius:20px;font-size:12px;font-weight:600;">
                      ${en.className}
                    </span>
                  </td>
                  <td style="color:var(--text-muted);font-size:12px">${en.enrolledDate}</td>
                  <td>
                    <c:choose>
                      <c:when test="${en.paymentStatus == 'pending'}">
                        <span class="lc-tag lc-tag-pending">Chờ thanh toán</span>
                      </c:when>
                      <c:when test="${en.paymentStatus == 'paid'}">
                        <span class="lc-tag lc-tag-paid">Đã thanh toán</span>
                      </c:when>
                      <c:otherwise>
                        <span class="lc-tag lc-tag-refunded">${en.paymentStatus}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="5" style="text-align:center;padding:36px;color:var(--text-muted)">
                  <i class="bi bi-inbox" style="font-size:2rem;display:block;
                     margin-bottom:8px;color:var(--primary-mid)"></i>
                  Chưa có đăng ký nào.
                </td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- Bảng lớp học đang hoạt động -->
    <div class="table-card fade-in-up">
      <div class="table-card-head">
        <div class="table-card-title">
          <i class="bi bi-door-open me-2" style="color:#16a34a"></i>
          Lớp đang hoạt động
        </div>
        <a href="${pageContext.request.contextPath}/admin/classes" class="lc-view-all">
          Xem tất cả &gt;
        </a>
      </div>
      <table class="lc-table">
        <thead>
          <tr>
            <th>Tên lớp</th>
            <th>Khóa học</th>
            <th>Giáo viên</th>
            <th>Khai giảng</th>
            <th>Trạng thái</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty ongoingClasses}">
              <c:forEach var="cl" items="${ongoingClasses}">
                <tr>
                  <td style="font-weight:700">${cl.className}</td>
                  <td style="color:var(--text-muted);font-size:12px">${cl.courseName}</td>
                  <td style="font-size:12px">${cl.teacherName}</td>
                  <td style="color:var(--text-muted);font-size:12px">${cl.startDate}</td>
                  <td>
                    <span style="background:#dcfce7;color:#166534;padding:2px 9px;
                                 border-radius:20px;font-size:11px;font-weight:700;">
                      Đang học
                    </span>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="5" style="text-align:center;padding:36px;color:var(--text-muted)">
                  <i class="bi bi-inbox" style="font-size:2rem;display:block;
                     margin-bottom:8px;color:var(--primary-mid)"></i>
                  Không có lớp nào đang hoạt động.
                </td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Right panel -->
  <div style="display:flex;flex-direction:column;gap:16px;">

    <!-- Quick actions -->
    <div style="background:var(--bg-white);border:1px solid var(--border);
                border-radius:var(--radius);padding:16px;" class="fade-in-up">
      <div style="font-size:13px;font-weight:700;margin-bottom:12px;color:var(--text-main);">
        <i class="bi bi-lightning-fill me-2" style="color:#f59e0b"></i>Thao tác nhanh
      </div>
      <div class="quick-actions">
        <a href="${pageContext.request.contextPath}/admin/courses?action=add" class="qa-btn">
          <i class="bi bi-plus-circle-fill"></i>
          <span>Thêm khóa học</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/classes?action=add" class="qa-btn">
          <i class="bi bi-plus-square-fill"></i>
          <span>Thêm lớp học</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/enrollments?status=pending" class="qa-btn">
          <i class="bi bi-card-checklist"></i>
          <span>Duyệt đăng ký</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/schedules" class="qa-btn">
          <i class="bi bi-calendar3"></i>
          <span>Xếp lịch học</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/students" class="qa-btn">
          <i class="bi bi-people-fill"></i>
          <span>Học viên</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/grades" class="qa-btn">
          <i class="bi bi-award-fill"></i>
          <span>Nhập điểm</span>
        </a>
      </div>
    </div>

    <!-- Pending alert -->
    <c:if test="${totalPending > 0}">
      <div style="background:#fffbeb;border:1.5px solid #fcd34d;border-radius:var(--radius);
                  padding:14px 16px;" class="fade-in-up">
        <div style="font-size:13px;font-weight:700;color:#92400e;margin-bottom:6px;">
          <i class="bi bi-exclamation-triangle-fill me-2"></i>Cần xử lý
        </div>
        <div style="font-size:13px;color:#78350f;">
          Có <strong>${totalPending}</strong> đơn đăng ký đang chờ duyệt.
        </div>
        <a href="${pageContext.request.contextPath}/admin/enrollments?status=pending"
           style="display:inline-block;margin-top:10px;padding:6px 14px;
                  background:#f59e0b;color:white;border-radius:6px;
                  text-decoration:none;font-size:12px;font-weight:700;">
          Duyệt ngay &rarr;
        </a>
      </div>
    </c:if>

    <!-- Thống kê nhanh -->
    <div style="background:var(--bg-white);border:1px solid var(--border);
                border-radius:var(--radius);padding:16px;" class="fade-in-up">
      <div style="font-size:13px;font-weight:700;margin-bottom:12px;color:var(--text-main);">
        <i class="bi bi-bar-chart-fill me-2" style="color:var(--primary)"></i>Tổng quan hệ thống
      </div>
      <div style="display:flex;flex-direction:column;gap:10px;">
        <div style="display:flex;justify-content:space-between;align-items:center;
                    padding:8px 12px;background:var(--primary-light);border-radius:8px;">
          <span style="font-size:12px;color:var(--primary);font-weight:500;">
            <i class="bi bi-book me-2"></i>Khóa học đang mở
          </span>
          <span style="font-weight:800;color:var(--primary);">${totalCourses != null ? totalCourses : 0}</span>
        </div>
        <div style="display:flex;justify-content:space-between;align-items:center;
                    padding:8px 12px;background:#dcfce7;border-radius:8px;">
          <span style="font-size:12px;color:#16a34a;font-weight:500;">
            <i class="bi bi-door-open me-2"></i>Lớp đang học
          </span>
          <span style="font-weight:800;color:#16a34a;">${totalOngoingClasses != null ? totalOngoingClasses : 0}</span>
        </div>
        <div style="display:flex;justify-content:space-between;align-items:center;
                    padding:8px 12px;background:#ede9fe;border-radius:8px;">
          <span style="font-size:12px;color:#7c3aed;font-weight:500;">
            <i class="bi bi-people me-2"></i>Tổng học viên
          </span>
          <span style="font-weight:800;color:#7c3aed;">${totalStudents != null ? totalStudents : 0}</span>
        </div>
      </div>
    </div>

  </div><!-- end right panel -->
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
