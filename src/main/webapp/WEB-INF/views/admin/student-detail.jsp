<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Chi tiết Học viên</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/students">Học viên</a></li>
      <li class="breadcrumb-item active">${student.fullName}</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">
  <div class="row">

    <%-- ══ CỘT TRÁI: THÔNG TIN HỌC VIÊN ══ --%>
    <div class="col-lg-4">
      <div class="card">
        <div class="card-body pt-4">
          <div class="text-center mb-3">
            <div class="mx-auto d-flex align-items-center justify-content-center rounded-circle text-white fw-bold mb-3"
                 style="width:72px;height:72px;background:#0d6efd;font-size:28px;">
              ${student.fullName.substring(0,1).toUpperCase()}
            </div>
            <h5 class="fw-bold mb-1">${student.fullName}</h5>
            <p class="text-muted mb-0" style="font-size:13px">@${student.username}</p>
            <c:choose>
              <c:when test="${student.active}">
                <span class="badge bg-success mt-2">Hoạt động</span>
              </c:when>
              <c:otherwise>
                <span class="badge bg-danger mt-2">Đã khóa</span>
              </c:otherwise>
            </c:choose>
          </div>

          <hr>

          <ul class="list-unstyled mb-0" style="font-size:14px">
            <li class="d-flex align-items-center gap-2 py-2 border-bottom">
              <i class="bi bi-envelope text-muted"></i>
              <span>${student.email}</span>
            </li>
            <li class="d-flex align-items-center gap-2 py-2 border-bottom">
              <i class="bi bi-telephone text-muted"></i>
              <span>
                <c:choose>
                  <c:when test="${not empty student.phone}">${student.phone}</c:when>
                  <c:otherwise class="text-muted">Chưa cập nhật</c:otherwise>
                </c:choose>
              </span>
            </li>
            <li class="d-flex align-items-center gap-2 py-2 border-bottom">
              <i class="bi bi-calendar text-muted"></i>
              <span>Tham gia: <fmt:formatDate value="${student.createdAt}" pattern="dd/MM/yyyy"/></span>
            </li>
            <li class="d-flex align-items-center gap-2 py-2">
              <i class="bi bi-journals text-muted"></i>
              <span>Đang học <strong>${student.enrollmentCount}</strong> lớp</span>
            </li>
          </ul>

          <div class="mt-3 d-flex gap-2">
            <form method="POST"
                  action="${pageContext.request.contextPath}/admin/students"
                  class="flex-grow-1">
              <input type="hidden" name="action" value="toggle">
              <input type="hidden" name="id" value="${student.id}">
              <button type="submit"
                      class="btn btn-sm w-100 ${student.active ? 'btn-outline-danger' : 'btn-outline-success'}"
                      onclick="return confirm('${student.active ? 'Khóa' : 'Mở'} tài khoản của ${student.fullName}?')">
                <i class="bi bi-${student.active ? 'lock' : 'unlock'} me-1"></i>
                ${student.active ? 'Khóa tài khoản' : 'Mở tài khoản'}
              </button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/students"
               class="btn btn-sm btn-outline-secondary">
              <i class="bi bi-arrow-left"></i>
            </a>
          </div>

        </div>
      </div><!-- End Info Card -->
    </div>

    <%-- ══ CỘT PHẢI: LỊCH SỬ ĐĂNG KÝ ══ --%>
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title pt-3">Lịch sử đăng ký khóa học</h5>

          <c:choose>
            <c:when test="${empty enrollments}">
              <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                Học viên chưa đăng ký lớp nào.
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle" style="font-size:14px">
                  <thead class="table-light">
                    <tr>
                      <th>#</th>
                      <th>Lớp học</th>
                      <th>Khóa học</th>
                      <th>Ngày đăng ký</th>
                      <th>Học phí</th>
                      <th>Trạng thái</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="en" items="${enrollments}" varStatus="s">
                      <tr>
                        <td class="text-muted">${s.count}</td>
                        <td>
                          <span class="badge bg-light text-dark border">${en.className}</span>
                        </td>
                        <td>
                          <div style="font-size:13px">${en.courseName}</div>
                          <span class="badge rounded-pill bg-primary bg-opacity-10 text-primary"
                                style="font-size:10px">${en.levelName}</span>
                        </td>
                        <td style="font-size:12px" class="text-muted">${en.enrolledDate}</td>
                        <td class="fw-semibold text-primary" style="font-size:13px">
                          <fmt:formatNumber value="${en.tuitionFee}" type="number"
                                            groupingUsed="true" maxFractionDigits="0"/>đ
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${en.paymentStatus == 'pending'}">
                              <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                            </c:when>
                            <c:when test="${en.paymentStatus == 'paid'}">
                              <span class="badge bg-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${en.paymentStatus == 'refunded'}">
                              <span class="badge bg-secondary">Đã hoàn tiền</span>
                            </c:when>
                            <c:when test="${en.paymentStatus == 'cancelled'}">
                              <span class="badge bg-danger">Đã hủy</span>
                            </c:when>
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
      </div><!-- End Enrollment Card -->
    </div>

  </div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
