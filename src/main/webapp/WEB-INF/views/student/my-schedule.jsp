<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="main-content">
  <div class="container-fluid py-4">

    <%-- ── PAGE HEADER ─────────────────────────────────── --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h4 class="fw-bold mb-1">
          <i class="bi bi-calendar-week text-primary me-2"></i>Thời khóa biểu của tôi
        </h4>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb mb-0 small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Trang chủ</a></li>
            <li class="breadcrumb-item active">Thời khóa biểu</li>
          </ol>
        </nav>
      </div>
      <div class="text-muted small">
        <i class="bi bi-info-circle me-1"></i>Chỉ hiển thị các lớp đã thanh toán & đang / sắp khai giảng
      </div>
    </div>

    <%-- ── STATS BAR ────────────────────────────────────── --%>
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="card border-0 shadow-sm text-center py-3">
          <div class="h3 fw-bold text-primary mb-0">${totalSessions}</div>
          <div class="small text-muted">Tổng số buổi/tuần</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card border-0 shadow-sm text-center py-3">
          <div class="h3 fw-bold text-success mb-0">
            <%-- Đếm số ngày có lịch học --%>
            <c:set var="activeDays" value="0"/>
            <c:forEach var="entry" items="${scheduleByDay}">
              <c:if test="${not empty entry.value}">
                <c:set var="activeDays" value="${activeDays + 1}"/>
              </c:if>
            </c:forEach>
            ${activeDays}
          </div>
          <div class="small text-muted">Ngày học/tuần</div>
        </div>
      </div>
    </div>

    <%-- ── KIỂM TRA CÓ DỮ LIỆU KHÔNG ───────────────────── --%>
    <c:choose>
      <c:when test="${empty allSchedules}">
        <div class="card border-0 shadow-sm">
          <div class="card-body text-center py-5">
            <i class="bi bi-calendar-x text-muted" style="font-size:3rem;"></i>
            <h5 class="mt-3 text-muted">Bạn chưa có lịch học nào</h5>
            <p class="text-muted">Hãy đăng ký khóa học và hoàn tất thanh toán để xem thời khóa biểu.</p>
            <a href="${pageContext.request.contextPath}/student/courses"
               class="btn btn-primary mt-2">
              <i class="bi bi-search me-2"></i>Xem khóa học
            </a>
          </div>
        </div>
      </c:when>

      <c:otherwise>
        <%-- ── LỊCH TUẦN DẠNG CARD ──────────────────────── --%>
        <div class="card border-0 shadow-sm">
          <div class="card-header bg-white border-bottom py-3">
            <h6 class="fw-bold mb-0">
              <i class="bi bi-calendar3 me-2 text-primary"></i>Lịch học theo tuần
            </h6>
          </div>
          <div class="card-body p-3">
            <div class="row g-3">

              <c:forEach var="entry" items="${scheduleByDay}">
                <c:set var="dayKey" value="${entry.key}"/>
                <c:set var="daySessions" value="${entry.value}"/>

                <%-- Map dayKey → tên thứ Tiếng Việt --%>
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

                <div class="col-12 col-md-6 col-xl-4">
                  <div class="border rounded-3 h-100 ${empty daySessions ? 'border-dashed opacity-50' : 'border-primary-subtle'}">

                    <%-- Header ngày --%>
                    <div class="px-3 py-2 rounded-top-3
                                ${empty daySessions ? 'bg-light' : 'bg-primary bg-opacity-10'}
                                d-flex justify-content-between align-items-center">
                      <span class="fw-bold ${empty daySessions ? 'text-muted' : 'text-primary'}">
                        ${dayLabel}
                      </span>
                      <c:choose>
                        <c:when test="${not empty daySessions}">
                          <span class="badge bg-primary rounded-pill">${fn:length(daySessions)}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-secondary bg-opacity-25 text-secondary rounded-pill">0</span>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <%-- Danh sách buổi học trong ngày --%>
                    <div class="p-2">
                      <c:choose>
                        <c:when test="${empty daySessions}">
                          <p class="text-muted small text-center py-3 mb-0">Không có lịch học</p>
                        </c:when>
                        <c:otherwise>
                          <c:forEach var="sc" items="${daySessions}">
                            <div class="d-flex align-items-start gap-2 mb-2 p-2 rounded bg-white border">
                              <%-- Giờ --%>
                              <div class="text-center" style="min-width:52px;">
                                <div class="fw-bold text-primary small">${sc.startTime}</div>
                                <div class="text-muted" style="font-size:10px;">│</div>
                                <div class="fw-bold text-primary small">${sc.endTime}</div>
                              </div>
                              <%-- Thông tin môn --%>
                              <div class="flex-grow-1 overflow-hidden">
                                <div class="fw-semibold text-truncate small">${sc.courseName}</div>
                                <div class="text-muted" style="font-size:11px;">
                                  <i class="bi bi-building me-1"></i>${sc.className}
                                </div>
                                <div class="text-muted" style="font-size:11px;">
                                  <i class="bi bi-geo-alt me-1"></i>${sc.roomName}
                                </div>
                              </div>
                            </div>
                          </c:forEach>
                        </c:otherwise>
                      </c:choose>
                    </div>

                  </div>
                </div>

              </c:forEach>
            </div><%-- end row days --%>
          </div>
        </div>

        <%-- ── BẢNG LIST (responsive view) ──────────────── --%>
        <div class="card border-0 shadow-sm mt-4">
          <div class="card-header bg-white border-bottom py-3">
            <h6 class="fw-bold mb-0">
              <i class="bi bi-list-ul me-2"></i>Toàn bộ lịch học (dạng danh sách)
            </h6>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
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
                        <span class="badge bg-primary bg-opacity-10 text-primary fw-semibold">
                          ${sc.dayOfWeekVi}
                        </span>
                      </td>
                      <td>
                        <i class="bi bi-clock text-muted me-1"></i>
                        <strong>${sc.startTime}</strong>
                        <span class="text-muted mx-1">–</span>
                        <strong>${sc.endTime}</strong>
                      </td>
                      <td class="fw-semibold">${sc.courseName}</td>
                      <td class="text-muted">${sc.className}</td>
                      <td>
                        <i class="bi bi-geo-alt text-muted me-1"></i>${sc.roomName}
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>

      </c:otherwise>
    </c:choose>

  </div><%-- end container --%>
</div><%-- end main-content --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
