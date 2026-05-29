<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
/* ── DASHBOARD SPECIFIC ── */
.dash-grid {
  display: grid;
  grid-template-columns: 1fr var(--panel-w);
  gap: 20px;
  align-items: start;
}

/* Stat ring cards */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}
.stat-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  transition: box-shadow .2s, transform .2s;
}
.stat-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
.stat-label {
  font-size: 12px;
  color: var(--text-muted);
  text-align: center;
}
.stat-value {
  font-size: 22px;
  font-weight: 800;
  color: var(--text-main);
  line-height: 1;
}
.stat-unit {
  font-size: 12px;
  font-weight: 500;
  color: var(--text-muted);
}

/* SVG progress ring */
.ring-wrap { position: relative; width: 80px; height: 80px; }
.ring-wrap svg { width: 80px; height: 80px; transform: rotate(-90deg); }
.ring-bg  { fill: none; stroke: var(--primary-mid); stroke-width: 6; }
.ring-val { fill: none; stroke-width: 6; stroke-linecap: round;
            stroke-dasharray: 220; transition: stroke-dashoffset 1s ease; }
.ring-center {
  position: absolute; top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  text-align: center; pointer-events: none;
}
.ring-icon { font-size: 20px; color: var(--primary); }

/* Schedule next */
.schedule-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  margin-bottom: 20px;
}
.schedule-row {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr auto;
  gap: 12px;
  padding: 12px 16px;
  border-bottom: 1px solid var(--border);
  align-items: center;
}
.schedule-row:last-child { border-bottom: none; }
.schedule-row:hover { background: var(--primary-light); }
.sch-time { font-size: 12px; color: var(--text-muted); }
.sch-code { font-weight: 700; font-size: 14px; color: var(--text-main); }
.sch-teacher { font-size: 13px; color: var(--text-muted); }
.sch-countdown { font-size: 12px; color: var(--text-muted); }
.btn-enter {
  padding: 6px 14px;
  background: white;
  border: 1.5px solid var(--primary);
  border-radius: 6px;
  color: var(--primary);
  font-size: 12px; font-weight: 600;
  cursor: pointer;
  font-family: var(--font);
  transition: background .15s, color .15s;
  white-space: nowrap;
}
.btn-enter:hover { background: var(--primary); color: white; }

/* Course cards */
.course-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
.course-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 14px;
  transition: box-shadow .2s, transform .15s;
}
.course-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
.course-code { font-weight: 800; font-size: 15px; color: var(--text-main); margin-bottom: 8px; }
.course-info { display: flex; gap: 6px; align-items: flex-start; margin-bottom: 5px; }
.course-info i { color: var(--text-muted); flex-shrink: 0; margin-top: 1px; font-size: 12px; }
.course-info span { font-size: 12px; color: var(--text-muted); line-height: 1.4; }
.course-footer {
  display: flex; gap: 16px; margin-top: 10px;
  padding-top: 10px; border-top: 1px solid var(--border);
}
.course-stat { text-align: center; }
.course-stat-label {
  font-size: 9px; font-weight: 700; text-transform: uppercase;
  letter-spacing: .5px; color: var(--text-light); display: block;
}
.course-stat-val {
  font-size: 13px; font-weight: 700; color: var(--primary);
}

/* RIGHT PANEL */
.right-panel { display: flex; flex-direction: column; gap: 16px; }
.panel-card {
  background: var(--bg-white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px;
}
.goal-box {
  display: flex; flex-direction: column; align-items: center;
  gap: 6px; text-align: center; padding: 8px 0;
}
.goal-badge {
  width: 52px; height: 52px;
  border-radius: 12px;
  background: var(--primary-light);
  display: flex; align-items: center; justify-content: center;
  font-size: 22px;
}
.goal-title { font-size: 11px; color: var(--text-muted); }
.goal-value { font-size: 20px; font-weight: 800; color: var(--text-main); }

/* Attendance donut */
.attend-item {
  display: flex; align-items: center; gap: 8px;
  font-size: 12px; color: var(--text-muted);
  margin-bottom: 6px;
}
.attend-dot {
  width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0;
}

/* Quick links */
.quick-links { display: flex; flex-direction: column; gap: 6px; }
.quick-link {
  display: flex; align-items: center; gap: 10px;
  padding: 9px 12px;
  border-radius: 8px;
  background: var(--bg-page);
  color: var(--text-main);
  text-decoration: none;
  font-size: 13px;
  font-weight: 500;
  transition: background .15s, color .15s;
}
.quick-link:hover { background: var(--primary-light); color: var(--primary); }
.quick-link i { color: var(--primary); font-size: 15px; }
</style>

<!-- ────────────── PAGE CONTENT ────────────── -->

<div class="dash-grid fade-in-up">

  <!-- ══ LEFT / CENTER ══ -->
  <div>

    <!-- STAT RINGS -->
    <div class="stat-grid">
      <!-- Thời gian học -->
      <div class="stat-card">
        <div class="ring-wrap">
          <svg viewBox="0 0 80 80">
            <circle class="ring-bg" cx="40" cy="40" r="35"/>
            <circle class="ring-val" cx="40" cy="40" r="35"
                    stroke="var(--primary)"
                    style="stroke-dashoffset:${(1 - 0.7) * 220}"/>
          </svg>
          <div class="ring-center">
            <i class="bi bi-clock ring-icon"></i>
          </div>
        </div>
        <div class="stat-value">
          ${totalHours != null ? totalHours : 0}
          <span class="stat-unit">Giờ</span>
        </div>
        <div class="stat-label">Thời gian học</div>
      </div>

      <!-- Đang học -->
      <div class="stat-card">
        <div class="ring-wrap">
          <svg viewBox="0 0 80 80">
            <circle class="ring-bg" cx="40" cy="40" r="35"/>
            <circle class="ring-val" cx="40" cy="40" r="35"
                    stroke="#f59e0b"
                    style="stroke-dashoffset:${(1 - 0.4) * 220}"/>
          </svg>
          <div class="ring-center">
            <i class="bi bi-book ring-icon" style="color:#f59e0b"></i>
          </div>
        </div>
        <div class="stat-value">${activeCount != null ? activeCount : 0}</div>
        <div class="stat-label">Đang học</div>
      </div>

      <!-- Chờ lớp -->
      <div class="stat-card">
        <div class="ring-wrap">
          <svg viewBox="0 0 80 80">
            <circle class="ring-bg" cx="40" cy="40" r="35"/>
            <circle class="ring-val" cx="40" cy="40" r="35"
                    stroke="#06b6d4"
                    style="stroke-dashoffset:${(1 - 0.3) * 220}"/>
          </svg>
          <div class="ring-center">
            <i class="bi bi-hourglass-split ring-icon" style="color:#06b6d4"></i>
          </div>
        </div>
        <div class="stat-value">${pendingCount != null ? pendingCount : 0}</div>
        <div class="stat-label">Chờ lớp</div>
      </div>

      <!-- Hoàn thành -->
      <div class="stat-card">
        <div class="ring-wrap">
          <svg viewBox="0 0 80 80">
            <circle class="ring-bg" cx="40" cy="40" r="35"/>
            <circle class="ring-val" cx="40" cy="40" r="35"
                    stroke="#10b981"
                    style="stroke-dashoffset:${(1 - 0.6) * 220}"/>
          </svg>
          <div class="ring-center">
            <i class="bi bi-patch-check ring-icon" style="color:#10b981"></i>
          </div>
        </div>
        <div class="stat-value">${finishedCount != null ? finishedCount : 0}</div>
        <div class="stat-label">Hoàn thành</div>
      </div>
    </div>

    <!-- LỊCH HỌC TIẾP THEO -->
    <div class="lc-section-header">
      <div class="lc-section-title">Lịch học tiếp theo</div>
      <a href="${pageContext.request.contextPath}/student/schedule" class="lc-view-all">
        Xem tất cả &gt;
      </a>
    </div>

    <div class="schedule-card">
      <c:choose>
        <c:when test="${empty upcomingSchedules}">
          <%-- Demo rows khi chưa có dữ liệu --%>
          <div class="schedule-row" style="opacity:.5">
            <div>
              <div class="sch-time">Từ 17:45 đến 19:45 · Thứ Bảy</div>
              <div class="sch-code">Chưa có lịch học</div>
            </div>
            <div class="sch-teacher"><i class="bi bi-person me-1"></i>—</div>
            <div class="sch-countdown">—</div>
            <button class="btn-enter" disabled>Vào lớp</button>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="sc" items="${upcomingSchedules}">
            <div class="schedule-row">
              <div>
                <div class="sch-time">
                  Từ ${sc.startTime} đến ${sc.endTime} · ${sc.dayOfWeekVi}
                </div>
                <div class="sch-code">${sc.className}</div>
              </div>
              <div class="sch-teacher">
                <i class="bi bi-person me-1" style="color:var(--primary)"></i>
                ${sc.teacherName}
              </div>
              <div class="sch-countdown" style="font-size:12px;color:var(--text-muted)">
                Phòng: ${sc.roomName}
              </div>
              <button class="btn-enter">Xem TKB</button>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- KHÓA HỌC CỦA TÔI -->
    <div class="lc-section-header">
      <div class="lc-section-title">Khóa học của tôi</div>
      <a href="${pageContext.request.contextPath}/student/my-classes" class="lc-view-all">
        Xem tất cả &gt;
      </a>
    </div>

    <c:choose>
      <c:when test="${empty myClasses}">
        <div class="lc-card" style="padding:40px;text-align:center;color:var(--text-muted);">
          <i class="bi bi-inbox" style="font-size:2.5rem;color:var(--primary-mid);"></i>
          <p style="margin-top:10px;">Bạn chưa đăng ký lớp nào.</p>
          <a href="${pageContext.request.contextPath}/student/courses"
             style="display:inline-block;margin-top:8px;padding:8px 20px;
                    background:var(--primary);color:white;border-radius:8px;
                    text-decoration:none;font-size:13px;font-weight:600;">
            Xem khóa học đang mở
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="course-grid">
          <c:forEach var="cl" items="${myClasses}" end="5">
            <div class="course-card">
              <div class="course-code">${cl.className}</div>

              <div class="course-info">
                <i class="bi bi-calendar3"></i>
                <span>${cl.scheduleInfo != null ? cl.scheduleInfo : 'Chưa có lịch'}</span>
              </div>

              <div class="course-info">
                <i class="bi bi-geo-alt"></i>
                <span>Trung tâm Language Center</span>
              </div>

              <div class="course-info">
                <i class="bi bi-emoji-smile"></i>
                <span>
                  Tình trạng:
                  <strong class="
                    ${cl.classStatus == 'ongoing'  ? '' :
                      cl.classStatus == 'upcoming' ? '' : ''}
                  " style="color:
                    ${cl.classStatus == 'ongoing'  ? '#16a34a' :
                      cl.classStatus == 'upcoming' ? 'var(--primary)' :
                      cl.classStatus == 'finished' ? '#dc2626' : '#6b7280'}">
                    ${cl.classStatus == 'ongoing'  ? 'Đang học' :
                      cl.classStatus == 'upcoming' ? 'Sắp khai giảng' :
                      cl.classStatus == 'finished' ? 'Đã kết thúc' : cl.classStatus}
                  </strong>
                </span>
              </div>

              <div class="course-footer">
                <div class="course-stat">
                  <span class="course-stat-label">Lớp học</span>
                  <span class="course-stat-val">—/—</span>
                </div>
                <div class="course-stat">
                  <span class="course-stat-label">Chuyên cần</span>
                  <span class="course-stat-val">—/—</span>
                </div>
                <div class="course-stat">
                  <span class="course-stat-label">Bài tập</span>
                  <span class="course-stat-val">—/—</span>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- KHÓA HỌC ĐỀ XUẤT -->
    <div class="lc-section-header" style="margin-top:20px;">
      <div class="lc-section-title">Khóa học đề xuất</div>
      <a href="${pageContext.request.contextPath}/student/courses" class="lc-view-all">
        Xem tất cả &gt;
      </a>
    </div>
    <div class="lc-card" style="padding:40px;text-align:center;color:var(--text-muted);">
      <i class="bi bi-lightbulb" style="font-size:2rem;color:var(--primary-mid);"></i>
      <p style="margin-top:8px;font-size:13px;">Chưa có dữ liệu khóa học đề xuất</p>
    </div>

  </div><!-- end center -->

  <!-- ══ RIGHT PANEL ══ -->
  <div class="right-panel">

    <!-- Mục tiêu -->
    <div class="panel-card">
      <div class="goal-box">
        <div class="goal-badge">🎯</div>
        <div class="goal-title">Mục tiêu của bạn</div>
        <div class="goal-value" style="font-size:16px;color:var(--text-muted);">Chưa chọn</div>
      </div>
      <div style="display:flex;gap:8px;margin-top:10px;">
        <button style="flex:1;padding:7px;border:1.5px solid var(--border);border-radius:7px;
                       background:white;font-size:12px;font-weight:600;cursor:pointer;
                       font-family:var(--font);color:var(--text-muted);transition:.15s;"
                onmouseover="this.style.borderColor='var(--primary)';this.style.color='var(--primary)'"
                onmouseout="this.style.borderColor='var(--border)';this.style.color='var(--text-muted)'">
          Quay lại
        </button>
        <button style="flex:1;padding:7px;border:1.5px solid var(--primary);border-radius:7px;
                       background:var(--primary);color:white;font-size:12px;font-weight:600;
                       cursor:pointer;font-family:var(--font);">
          Xem tiếp
        </button>
      </div>
    </div>

    <!-- Báo cáo chuyên cần -->
    <div class="panel-card">
      <div style="font-size:13px;font-weight:700;margin-bottom:12px;">Báo cáo chuyên cần</div>
      <div style="display:flex;align-items:center;justify-content:center;
                  width:80px;height:80px;border-radius:50%;
                  background:var(--primary-light);border:3px solid var(--primary-mid);
                  margin:0 auto 12px;font-size:12px;font-weight:700;
                  text-align:center;color:var(--primary);line-height:1.2;">
        <div>Chưa<br>có dữ liệu</div>
      </div>
      <div class="attend-item">
        <div class="attend-dot" style="background:#1e88e5;"></div>
        Đã tham gia
        <span style="margin-left:auto;font-weight:600;color:var(--text-main);">0 buổi (0%)</span>
      </div>
      <div class="attend-item">
        <div class="attend-dot" style="background:#bbdefb;"></div>
        Đã nghỉ
        <span style="margin-left:auto;font-weight:600;color:var(--text-main);">0 buổi (0%)</span>
      </div>
      <div class="attend-item">
        <div class="attend-dot" style="background:#e5e7eb;"></div>
        Chưa tham gia
        <span style="margin-left:auto;font-weight:600;color:var(--text-main);">0 buổi (0%)</span>
      </div>
    </div>

    <!-- Truy cập nhanh -->
    <div class="panel-card">
      <div style="font-size:13px;font-weight:700;margin-bottom:10px;">Truy cập nhanh</div>
      <div class="quick-links">
        <a href="${pageContext.request.contextPath}/student/grades" class="quick-link">
          <i class="bi bi-bar-chart-line"></i> Xem điểm số
        </a>
        <a href="${pageContext.request.contextPath}/student/schedule" class="quick-link">
          <i class="bi bi-calendar-week"></i> Thời khóa biểu
        </a>
        <a href="${pageContext.request.contextPath}/student/courses" class="quick-link">
          <i class="bi bi-search"></i> Tìm khóa học
        </a>
        <a href="${pageContext.request.contextPath}/student/ai-consult" class="quick-link">
          <i class="bi bi-robot"></i> Tư vấn AI
        </a>
      </div>
    </div>

  </div><!-- end right panel -->

</div><!-- end dash-grid -->

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
