<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Trang chủ</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item active">Dashboard</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section dashboard">

  <%-- ══ LỜI CHÀO ══ --%>
  <div class="card mb-3">
    <div class="card-body py-3">
      <h5 class="card-title mb-0">
        Xin chào, <strong>${sessionScope.loggedUser.fullName}</strong>! 👋
      </h5>
      <p class="text-muted mb-0 mt-1" style="font-size:14px">
        Đây là tổng quan tình hình học tập của bạn.
      </p>
    </div>
  </div>

  <%-- ══ STATS CARDS ══ --%>
  <div class="row">
    <div class="col-xxl-4 col-md-4">
      <div class="card info-card sales-card">
        <div class="card-body">
          <h5 class="card-title">Lớp đang học</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
              <i class="bi bi-door-open"></i>
            </div>
            <div class="ps-3">
              <h6>${activeCount != null ? activeCount : 0}</h6>
              <span class="text-muted small pt-2 ps-1">lớp</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-xxl-4 col-md-4">
      <div class="card info-card revenue-card">
        <div class="card-body">
          <h5 class="card-title">Tổng đăng ký</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
              <i class="bi bi-journals"></i>
            </div>
            <div class="ps-3">
              <h6>${totalCount != null ? totalCount : 0}</h6>
              <span class="text-muted small pt-2 ps-1">khóa học</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-xxl-4 col-md-4">
      <div class="card info-card customers-card">
        <div class="card-body">
          <h5 class="card-title">Điểm TB</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
              <i class="bi bi-award"></i>
            </div>
            <div class="ps-3">
              <h6>${avgScore != null ? avgScore : '—'}%</h6>
              <span class="text-muted small pt-2 ps-1">trung bình</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div><!-- End Stats Row -->

  <%-- ══ LỚP HỌC CỦA TÔI ══ --%>
  <div class="row">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center pt-3 mb-3">
            <h5 class="card-title mb-0">Lớp của tôi</h5>
            <a href="${pageContext.request.contextPath}/student/my-classes"
               class="btn btn-sm btn-outline-primary">Xem tất cả</a>
          </div>

          <c:choose>
            <c:when test="${empty myClasses}">
              <div class="text-center py-4 text-muted">
                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                Bạn chưa đăng ký lớp nào.
                <div class="mt-2">
                  <a href="${pageContext.request.contextPath}/student/courses"
                     class="btn btn-sm btn-primary">Xem khóa học</a>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle" style="font-size:14px">
                  <thead class="table-light">
                    <tr>
                      <th>Khóa học</th>
                      <th>Lớp</th>
                      <th>Trạng thái lớp</th>
                      <th>Thanh toán</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="e" items="${myClasses}">
                      <tr>
                        <td class="fw-semibold">${e.courseName}</td>
                        <td>
                          <span class="badge bg-light text-dark border">${e.className}</span>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${e.classStatus == 'ongoing'}">
                              <span class="badge bg-success">Đang học</span>
                            </c:when>
                            <c:when test="${e.classStatus == 'upcoming'}">
                              <span class="badge bg-info text-dark">Sắp khai giảng</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-secondary">Đã kết thúc</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${e.paymentStatus == 'paid'}">
                              <span class="badge bg-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${e.paymentStatus == 'pending'}">
                              <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-secondary">${e.paymentStatus}</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div><!-- End col -->

    <%-- ══ QUICK LINKS ══ --%>
    <div class="col-lg-4">
      <div class="card">
        <div class="card-body pt-4">
          <h5 class="card-title">Truy cập nhanh</h5>
          <div class="d-flex flex-column gap-2">
            <a href="${pageContext.request.contextPath}/student/courses"
               class="btn btn-outline-primary text-start">
              <i class="bi bi-book me-2"></i>Đăng ký khóa học
            </a>
            <a href="${pageContext.request.contextPath}/student/schedule"
               class="btn btn-outline-primary text-start">
              <i class="bi bi-calendar-week me-2"></i>Thời khóa biểu
            </a>
            <a href="${pageContext.request.contextPath}/student/grades"
               class="btn btn-outline-primary text-start">
              <i class="bi bi-award me-2"></i>Xem điểm số
            </a>
            <a href="${pageContext.request.contextPath}/student/ai-consult"
               class="btn btn-outline-success text-start">
              <i class="bi bi-robot me-2"></i>Tư vấn AI lộ trình học
            </a>
          </div>
        </div>
      </div>
    </div><!-- End col -->

  </div><!-- End row -->

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
