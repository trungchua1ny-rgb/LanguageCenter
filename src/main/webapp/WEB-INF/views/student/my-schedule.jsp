<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Thời khóa biểu</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Thời khóa biểu</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">

  <%-- ══ STATS ══ --%>
  <div class="row g-3 mb-3">
    <div class="col-6 col-md-3">
      <div class="card text-center">
        <div class="card-body py-3">
          <div class="h3 fw-bold text-primary mb-0">${totalSessions}</div>
          <div class="small text-muted">Tổng buổi/tuần</div>
        </div>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="card text-center">
        <div class="card-body py-3">
          <c:set var="activeDays" value="0"/>
          <c:forEach var="entry" items="${scheduleByDay}">
            <c:if test="${not empty entry.value}">
              <c:set var="activeDays" value="${activeDays + 1}"/>
            </c:if>
          </c:forEach>
          <div class="h3 fw-bold text-success mb-0">${activeDays}</div>
          <div class="small text-muted">Ngày học/tuần</div>
        </div>
      </div>
    </div>
    <div class="col-12 col-md-6 d-flex align-items-center">
      <div class="alert alert-info py-2 mb-0 w-100" style="font-size:13px">
        <i class="bi bi-info-circle me-1"></i>
        Chỉ hiển thị các lớp đã thanh toán & đang / sắp khai giảng.
      </div>
    </div>
  </div>

  <%-- ══ KIỂM TRA CÓ DỮ LIỆU KHÔNG ══ --%>
  <c:choose>

    <c:when test="${empty allSchedules}">
      <div class="card">
        <div class="card-body text-center py-5 text-muted">
          <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
          <p class="mb-3">Bạn chưa có lịch học nào.</p>
          <a href="${pageContext.request.contextPath}/student/courses"
             class="btn btn-primary btn-sm">
            <i class="bi bi-search me-1"></i>Xem khóa học
          </a>
        </div>
      </div>
    </c:when>

    <c:otherwise>

      <%-- ══ LỊCH TUẦN DẠNG CARD ══ --%>
      <div class="card mb-4">
        <div class="card-body">
          <h5 class="card-title pt-3">Lịch học theo tuần</h5>
          <div class="row g-3">
            <c:forEach var="entry" items="${scheduleByDay}">
              <c:set var="dayKey"      value="${entry.key}"/>
              <c:set var="daySessions" value="${entry.value}"/>

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
                <div class="border rounded-3 h-100
                             ${empty daySessions ? 'opacity-50' : ''}">

                  <div class="px-3 py-2 rounded-top-3 d-flex justify-content-between align-items-center
                               ${empty daySessions ? 'bg-light' : 'bg-primary bg-opacity-10'}">
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

                  <div class="p-2">
                    <c:choose>
                      <c:when test="${empty daySessions}">
                        <p class="text-muted small text-center py-3 mb-0">Không có lịch học</p>
                      </c:when>
                      <c:otherwise>
                        <c:forEach var="sc" items="${daySessions}">
                          <div class="d-flex align-items-start gap-2 mb-2 p-2 rounded bg-white border">
                            <div class="text-center" style="min-width:52px">
                              <div class="fw-bold text-primary small">${sc.startTime}</div>
                              <div class="text-muted" style="font-size:10px">│</div>
                              <div class="fw-bold text-primary small">${sc.endTime}</div>
                            </div>
                            <div class="flex-grow-1 overflow-hidden">
                              <div class="fw-semibold text-truncate small">${sc.courseName}</div>
                              <div class="text-muted" style="font-size:11px">
                                <i class="bi bi-building me-1"></i>${sc.className}
                              </div>
                              <div class="text-muted" style="font-size:11px">
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
          </div>
        </div>
      </div><!-- End Card Weekly -->

      <%-- ══ BẢNG DANH SÁCH ══ --%>
      <div class="card">
        <div class="card-body">
          <h5 class="card-title pt-3">Toàn bộ lịch học (dạng danh sách)</h5>
          <div class="table-responsive">
            <table class="table table-hover align-middle" style="font-size:14px">
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
      </div><!-- End Card List -->

    </c:otherwise>
  </c:choose>

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
