<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Lớp học của tôi</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Lớp của tôi</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">

  <%-- ══ TIÊU ĐỀ + NÚT ══ --%>
  <div class="d-flex justify-content-between align-items-center mb-3">
    <p class="text-muted mb-0" style="font-size:14px">
      <strong>${activeCount}</strong> lớp đang học •
      <strong>${totalCount}</strong> tổng cộng
    </p>
    <a href="${pageContext.request.contextPath}/student/courses"
       class="btn btn-primary btn-sm">
      <i class="bi bi-plus-circle me-1"></i>Đăng ký thêm
    </a>
  </div>

  <%-- ══ THÔNG BÁO ══ --%>
  <c:if test="${not empty successMsg}">
    <div class="alert alert-success alert-dismissible fade show py-2">
      <i class="bi bi-check-circle me-1"></i>${successMsg}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <%-- ══ TRỐNG ══ --%>
  <c:if test="${empty myClasses}">
    <div class="card">
      <div class="card-body text-center py-5 text-muted">
        <i class="bi bi-journals fs-1 d-block mb-2"></i>
        <p class="mb-3">Bạn chưa đăng ký lớp học nào.</p>
        <a href="${pageContext.request.contextPath}/student/courses"
           class="btn btn-primary btn-sm">
          <i class="bi bi-search me-1"></i>Xem khóa học đang mở
        </a>
      </div>
    </div>
  </c:if>

  <%-- ══ DANH SÁCH LỚP ══ --%>
  <div class="row g-3">
    <c:forEach var="cl" items="${myClasses}">
      <div class="col-12 col-md-6">
        <div class="card h-100"
             style="border-left: 4px solid
               ${cl.classStatus == 'ongoing'  ? '#198754' :
                 cl.classStatus == 'upcoming' ? '#0d6efd' : '#6c757d'};">

          <%-- Card Header --%>
          <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-start py-3">
            <div>
              <div class="fw-bold" style="font-size:15px">${cl.courseName}</div>
              <span class="badge rounded-pill mt-1"
                    style="background:#e8f0fe;color:#1a73e8;font-size:11px">
                ${cl.levelName}
              </span>
            </div>
            <c:choose>
              <c:when test="${cl.classStatus == 'ongoing'}">
                <span class="badge bg-success ms-2">Đang học</span>
              </c:when>
              <c:when test="${cl.classStatus == 'upcoming'}">
                <span class="badge bg-primary ms-2">Sắp khai giảng</span>
              </c:when>
              <c:otherwise>
                <span class="badge bg-secondary ms-2">Đã kết thúc</span>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="card-body d-flex flex-column gap-2" style="font-size:13px">

            <div>
              <i class="bi bi-door-open text-muted me-1"></i>
              <span class="fw-semibold">${cl.className}</span>
            </div>

            <div class="text-muted">
              <i class="bi bi-calendar3 me-1"></i>
              <c:choose>
                <c:when test="${not empty cl.scheduleInfo}">${cl.scheduleInfo}</c:when>
                <c:otherwise>Chưa có lịch học</c:otherwise>
              </c:choose>
            </div>

            <div class="text-muted">
              <i class="bi bi-clock me-1"></i>
              ${cl.startDate} → ${cl.endDate}
            </div>

            <%-- Học phí + Thanh toán --%>
            <div class="d-flex justify-content-between align-items-center mt-1 pt-2 border-top">
              <div>
                <div class="text-muted" style="font-size:11px">Học phí</div>
                <div class="fw-bold text-primary" style="font-size:14px">
                  <fmt:formatNumber value="${cl.tuitionFee}" type="number"
                                    groupingUsed="true" maxFractionDigits="0"/>đ
                </div>
              </div>
              <c:choose>
                <c:when test="${cl.paymentStatus == 'paid'}">
                  <span class="badge bg-success">
                    <i class="bi bi-check2-circle me-1"></i>Đã thanh toán
                  </span>
                </c:when>
                <c:when test="${cl.paymentStatus == 'pending'}">
                  <span class="badge bg-warning text-dark">
                    <i class="bi bi-hourglass-split me-1"></i>Chờ thanh toán
                  </span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary">${cl.paymentStatus}</span>
                </c:otherwise>
              </c:choose>
            </div>

          </div>

          <%-- Card Footer — nút xem điểm --%>
          <c:if test="${cl.classStatus == 'ongoing' || cl.classStatus == 'finished'}">
            <div class="card-footer bg-white border-top py-2">
              <a href="${pageContext.request.contextPath}/student/grades?classId=${cl.classId}"
                 class="btn btn-sm btn-outline-primary w-100">
                <i class="bi bi-bar-chart me-1"></i>Xem điểm số
              </a>
            </div>
          </c:if>

        </div>
      </div>
    </c:forEach>
  </div><!-- End row -->

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
