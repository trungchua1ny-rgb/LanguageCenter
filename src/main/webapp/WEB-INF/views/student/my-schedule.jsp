<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
  /* ══ MY-SCHEDULE PAGE ══ */

  /* Stat cards */
  .lc-sched-stat {
    background: #fff; border: 1px solid #e5e7eb; border-radius: 10px;
    padding: 16px 20px; text-align: center; height: 100%;
  }
  .lc-sched-stat .num { font-size: 28px; font-weight: 800; line-height: 1; margin-bottom: 4px; }
  .lc-sched-stat .lbl { font-size: 12px; color: #9ca3af; font-weight: 500; }

  /* Week grid */
  .lc-week-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 14px;
    margin-bottom: 28px;
  }
  @media (max-width: 1100px) { .lc-week-grid { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width: 768px)  { .lc-week-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 480px)  { .lc-week-grid { grid-template-columns: 1fr; } }

  /* Day column */
  .lc-day-col {
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
    background: #fff;
    opacity: 1;
    transition: box-shadow .15s;
  }
  .lc-day-col.empty { opacity: .55; }
  .lc-day-col:not(.empty):hover { box-shadow: 0 4px 14px rgba(0,0,0,.10); }

  /* Day header */
  .lc-day-header {
    padding: 9px 14px;
    display: flex; align-items: center; justify-content: space-between;
    background: #f9fafb;
    border-bottom: 1px solid #e5e7eb;
  }
  .lc-day-col:not(.empty) .lc-day-header {
    background: #e8f1fd;
    border-bottom-color: #bfdbfe;
  }
  .lc-day-label {
    font-size: 13px; font-weight: 700;
    color: #9ca3af;
  }
  .lc-day-col:not(.empty) .lc-day-label { color: #0056d2; }

  /* Session item */
  .lc-session-list { padding: 8px; display: flex; flex-direction: column; gap: 6px; }
  .lc-session-item {
    display: flex; gap: 10px; align-items: flex-start;
    background: #f9fafb; border: 1px solid #f3f4f6;
    border-radius: 8px; padding: 9px 10px;
    transition: background .15s;
  }
  .lc-session-item:hover { background: #f0f7ff; border-color: #bfdbfe; }
  .lc-time-block {
    text-align: center; min-width: 50px;
  }
  .lc-time-start { font-size: 12px; font-weight: 700; color: #0056d2; }
  .lc-time-sep   { font-size: 9px; color: #d1d5db; }
  .lc-time-end   { font-size: 12px; font-weight: 700; color: #0056d2; }
  .lc-session-info { flex: 1; min-width: 0; }
  .lc-session-course {
    font-size: 12.5px; font-weight: 700; color: #1f2937;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
  }
  .lc-session-meta { font-size: 11px; color: #9ca3af; margin-top: 2px; }

  /* Empty day */
  .lc-day-empty-msg {
    text-align: center; padding: 16px 8px;
    font-size: 12px; color: #d1d5db; font-style: italic;
  }

  /* List table */
  .lc-sched-table {
    width: 100%; font-size: 14px;
    border-collapse: separate; border-spacing: 0;
  }
  .lc-sched-table thead th {
    background: #f9fafb; padding: 10px 14px;
    font-size: 12px; font-weight: 700;
    text-transform: uppercase; letter-spacing: .5px;
    color: #6b7280; border-bottom: 2px solid #e5e7eb;
  }
  .lc-sched-table tbody tr { border-bottom: 1px solid #f3f4f6; }
  .lc-sched-table tbody tr:hover { background: #f9fafb; }
  .lc-sched-table tbody td { padding: 11px 14px; vertical-align: middle; }

  /* Empty */
  .lc-empty { text-align: center; padding: 48px 20px; color: #9ca3af; }
  .lc-empty i { font-size: 44px; margin-bottom: 10px; display: block; }
</style>

<div class="pagetitle">
  <h1>Thời khóa biểu</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item">
        <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      </li>
      <li class="breadcrumb-item active">Thời khóa biểu</li>
    </ol>
  </nav>
</div>

<section class="section">

  <%-- ══ STATS ══ --%>
  <div class="row g-3 mb-4">
    <div class="col-6 col-md-3">
      <div class="lc-sched-stat">
        <div class="num text-primary">${totalSessions}</div>
        <div class="lbl">Tổng buổi / tuần</div>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="lc-sched-stat">
        <%-- đếm số ngày có lịch --%>
        <c:set var="activeDays" value="0"/>
        <c:forEach var="entry" items="${scheduleByDay}">
          <c:if test="${not empty entry.value}">
            <c:set var="activeDays" value="${activeDays + 1}"/>
          </c:if>
        </c:forEach>
        <div class="num text-success">${activeDays}</div>
        <div class="lbl">Ngày học / tuần</div>
      </div>
    </div>
    <div class="col-12 col-md-6 d-flex align-items-center">
      <div class="alert alert-info py-2 mb-0 w-100" style="font-size:13px; border-radius:8px;">
        <i class="bi bi-info-circle me-1"></i>
        Chỉ hiển thị lớp đã thanh toán &amp; đang / sắp khai giảng.
      </div>
    </div>
  </div>

  <c:choose>

    <c:when test="${empty allSchedules}">
      <div class="card" style="border-radius:10px;">
        <div class="card-body lc-empty">
          <i class="bi bi-calendar-x"></i>
          <p>Bạn chưa có lịch học nào.</p>
          <a href="${pageContext.request.contextPath}/student/courses"
             style="background:#0056d2;color:#fff;border-radius:6px;padding:9px 18px;
                    font-size:13px;font-weight:600;text-decoration:none;
                    display:inline-flex;align-items:center;gap:5px;">
            <i class="bi bi-search"></i>Xem khóa học
          </a>
        </div>
      </div>
    </c:when>

    <c:otherwise>

      <%-- ══ LỊCH TUẦN DẠNG GRID ══ --%>
      <div style="font-size:15px; font-weight:700; color:#1f2937; margin-bottom:14px;">
        📅 Lịch học theo tuần
      </div>

      <div class="lc-week-grid">
        <c:forEach var="entry" items="${scheduleByDay}">
          <c:set var="dayKey"      value="${entry.key}"/>
          <c:set var="daySessions" value="${entry.value}"/>

          <%-- Tên ngày tiếng Việt --%>
          <c:set var="dayLabel" value="${dayKey}"/>
          <c:choose>
            <c:when test="${dayKey == 'Mon'}"><c:set var="dayLabel" value="Thứ Hai"/></c:when>
            <c:when test="${dayKey == 'Tue'}"><c:set var="dayLabel" value="Thứ Ba"/></c:when>
            <c:when test="${dayKey == 'Wed'}"><c:set var="dayLabel" value="Thứ Tư"/></c:when>
            <c:when test="${dayKey == 'Thu'}"><c:set var="dayLabel" value="Thứ Năm"/></c:when>
            <c:when test="${dayKey == 'Fri'}"><c:set var="dayLabel" value="Thứ Sáu"/></c:when>
            <c:when test="${dayKey == 'Sat'}"><c:set var="dayLabel" value="Thứ Bảy"/></c:when>
            <c:when test="${dayKey == 'Sun'}"><c:set var="dayLabel" value="Chủ Nhật"/></c:when>
          </c:choose>

          <div class="lc-day-col ${empty daySessions ? 'empty' : ''}">

            <div class="lc-day-header">
              <span class="lc-day-label">${dayLabel}</span>
              <c:choose>
                <c:when test="${not empty daySessions}">
                  <span class="badge bg-primary rounded-pill"
                        style="font-size:11px;">${fn:length(daySessions)}</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary bg-opacity-25 text-secondary rounded-pill"
                        style="font-size:11px;">0</span>
                </c:otherwise>
              </c:choose>
            </div>

            <c:choose>
              <c:when test="${empty daySessions}">
                <div class="lc-day-empty-msg">Không có lịch học</div>
              </c:when>
              <c:otherwise>
                <div class="lc-session-list">
                  <c:forEach var="sc" items="${daySessions}">
                    <div class="lc-session-item">
                      <div class="lc-time-block">
                        <div class="lc-time-start">${sc.startTime}</div>
                        <div class="lc-time-sep">│</div>
                        <div class="lc-time-end">${sc.endTime}</div>
                      </div>
                      <div class="lc-session-info">
                        <div class="lc-session-course">${sc.courseName}</div>
                        <div class="lc-session-meta">
                          <i class="bi bi-building me-1"></i>${sc.className}
                        </div>
                        <div class="lc-session-meta">
                          <i class="bi bi-geo-alt me-1"></i>${sc.roomName}
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>

          </div>
        </c:forEach>
      </div><!-- End week grid -->

      <%-- ══ DANH SÁCH ĐẦY ĐỦ ══ --%>
      <div class="card" style="border-radius:10px; border:1px solid #e5e7eb; overflow:hidden; box-shadow:none;">
        <div style="padding:16px 20px; border-bottom:1px solid #f3f4f6;">
          <div style="font-size:15px; font-weight:700; color:#1f2937;">
            📋 Toàn bộ lịch học (dạng danh sách)
          </div>
        </div>
        <div class="table-responsive">
          <table class="lc-sched-table">
            <thead>
              <tr>
                <th>Thứ</th>
                <th>Giờ học</th>
                <th>Khóa học</th>
                <th>Lớp</th>
                <th>Phòng</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="sc" items="${allSchedules}">
                <tr>
                  <td>
                    <span style="background:#e8f1fd; color:#0056d2; font-size:12px;
                                 font-weight:700; padding:3px 10px; border-radius:20px;">
                      ${sc.dayOfWeekVi}
                    </span>
                  </td>
                  <td>
                    <div style="display:flex; align-items:center; gap:4px; font-size:13px;">
                      <i class="bi bi-clock text-muted"></i>
                      <strong>${sc.startTime}</strong>
                      <span style="color:#9ca3af;">–</span>
                      <strong>${sc.endTime}</strong>
                    </div>
                  </td>
                  <td style="font-weight:600;">${sc.courseName}</td>
                  <td style="color:#6b7280; font-size:13px;">${sc.className}</td>
                  <td style="font-size:13px;">
                    <i class="bi bi-geo-alt text-muted me-1"></i>${sc.roomName}
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>

    </c:otherwise>
  </c:choose>

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
