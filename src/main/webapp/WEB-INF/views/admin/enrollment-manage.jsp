<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Duyệt Đăng ký</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Đăng ký / Duyệt</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">
  <div class="row">
    <div class="col-lg-12">

      <div class="card">
        <div class="card-body">

          <div class="pt-3 mb-3">
            <h5 class="card-title mb-1">Quản lý đăng ký khóa học</h5>
            <p class="text-muted mb-0" style="font-size:13px">
              Duyệt thanh toán và quản lý trạng thái đăng ký của học viên.
            </p>
          </div>

          <%-- ══ THÔNG BÁO ══ --%>
          <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show py-2">
              <i class="bi bi-check-circle me-1"></i>${successMsg}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>
          <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show py-2">
              <i class="bi bi-exclamation-circle me-1"></i>${errorMsg}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <%-- ══ TAB LỌC TRẠNG THÁI ══ --%>
          <div class="d-flex gap-2 mb-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/admin/enrollments"
               class="btn btn-sm ${empty activeStatus ? 'btn-dark' : 'btn-outline-secondary'}">
              Tất cả
            </a>
            <a href="${pageContext.request.contextPath}/admin/enrollments?status=pending"
               class="btn btn-sm ${activeStatus == 'pending' ? 'btn-warning' : 'btn-outline-warning'} position-relative">
              Chờ thanh toán
              <c:if test="${countPending > 0}">
                <span class="position-absolute top-0 start-100 translate-middle
                             badge rounded-pill bg-danger" style="font-size:9px">
                  ${countPending}
                </span>
              </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/admin/enrollments?status=paid"
               class="btn btn-sm ${activeStatus == 'paid' ? 'btn-success' : 'btn-outline-success'}">
              Đã thanh toán
              <c:if test="${countPaid > 0}">
                <span class="badge bg-success bg-opacity-75 ms-1" style="font-size:10px">${countPaid}</span>
              </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/admin/enrollments?status=refunded"
               class="btn btn-sm ${activeStatus == 'refunded' ? 'btn-secondary' : 'btn-outline-secondary'}">
              Đã hoàn tiền
            </a>
          </div>

          <%-- ══ BẢNG ══ --%>
          <c:choose>
            <c:when test="${empty enrollments}">
              <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                Không có đăng ký nào<c:if test="${not empty activeStatus}"> với trạng thái này</c:if>.
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle" style="font-size:14px">
                  <thead class="table-light">
                    <tr>
                      <th style="width:40px">#</th>
                      <th>Học viên</th>
                      <th>Lớp học</th>
                      <th>Khóa / Cấp độ</th>
                      <th>Học phí</th>
                      <th>Ngày đăng ký</th>
                      <th>Trạng thái</th>
                      <th style="width:130px">Thao tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="en" items="${enrollments}" varStatus="s">
                      <tr>
                        <td class="text-muted">${s.count}</td>
                        <td class="fw-semibold">${en.studentName}</td>
                        <td>
                          <span class="badge bg-light text-dark border"
                                style="font-size:12px">${en.className}</span>
                        </td>
                        <td>
                          <div style="font-size:13px">${en.courseName}</div>
                          <span class="badge rounded-pill mt-1 bg-primary bg-opacity-10 text-primary"
                                style="font-size:10px">${en.levelName}</span>
                        </td>
                        <td class="fw-semibold text-primary">
                          <fmt:formatNumber value="${en.tuitionFee}" type="number"
                                            groupingUsed="true" maxFractionDigits="0"/>đ
                        </td>
                        <td style="font-size:12px" class="text-muted">${en.enrolledDate}</td>
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
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${en.paymentStatus == 'pending'}">
                              <button class="btn btn-sm btn-success py-0 px-2 me-1"
                                      title="Xác nhận đã thu tiền"
                                      onclick="confirmAction(${en.id}, 'approve',
                                        'Xác nhận thanh toán cho học viên ${en.studentName}?')">
                                <i class="bi bi-check-lg"></i>
                              </button>
                              <button class="btn btn-sm btn-outline-danger py-0 px-2"
                                      title="Hủy đăng ký"
                                      onclick="confirmAction(${en.id}, 'cancel',
                                        'Hủy đăng ký của học viên ${en.studentName}?')">
                                <i class="bi bi-x-lg"></i>
                              </button>
                            </c:when>
                            <c:when test="${en.paymentStatus == 'paid'}">
                              <button class="btn btn-sm btn-outline-secondary py-0 px-2"
                                      title="Hoàn tiền"
                                      onclick="confirmAction(${en.id}, 'refund',
                                        'Xác nhận hoàn tiền cho học viên ${en.studentName}?')">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Hoàn tiền
                              </button>
                            </c:when>
                            <c:otherwise>
                              <span class="text-muted" style="font-size:12px">—</span>
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
      </div><!-- End Card -->

    </div>
  </div>
</section>

<%-- ══ FORM ẨN XỬ LÝ ACTION ══ --%>
<form id="actionForm" method="POST"
      action="${pageContext.request.contextPath}/admin/enrollments"
      style="display:none">
  <input type="hidden" name="action" id="form-action">
  <input type="hidden" name="id"     id="form-id">
</form>

<script>
function confirmAction(id, action, message) {
  if (!confirm(message)) return;
  document.getElementById('form-id').value     = id;
  document.getElementById('form-action').value = action;
  document.getElementById('actionForm').submit();
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
