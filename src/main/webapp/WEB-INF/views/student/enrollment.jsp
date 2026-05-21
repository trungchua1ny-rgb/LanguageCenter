<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Đăng ký Khóa học</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Khóa học đang mở</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">

  <%-- ══ THÔNG BÁO ══ --%>
  <c:if test="${not empty successMsg}">
    <div class="alert alert-success alert-dismissible fade show">
      <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-circle-fill me-2"></i>${errorMsg}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <%-- ══ DANH SÁCH KHÓA HỌC DẠNG CARD ══ --%>
  <c:choose>
    <c:when test="${empty availableClasses}">
      <div class="card">
        <div class="card-body text-center py-5 text-muted">
          <i class="bi bi-inbox fs-1 d-block mb-2"></i>
          <p>Hiện chưa có lớp học nào đang mở đăng ký.</p>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <div class="row g-3">
        <c:forEach var="cls" items="${availableClasses}">
          <div class="col-12 col-md-6 col-xl-4">
            <div class="card h-100" style="border-top: 3px solid ${cls.classStatus == 'ongoing' ? '#198754' : '#0d6efd'};">
              <div class="card-body d-flex flex-column">

                <%-- Header --%>
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <h6 class="fw-bold text-primary mb-0" style="font-size:15px">${cls.courseName}</h6>
                  <c:choose>
                    <c:when test="${cls.classStatus == 'ongoing'}">
                      <span class="badge bg-success ms-2 flex-shrink-0">Đang học</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-primary ms-2 flex-shrink-0">Sắp khai giảng</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <%-- Thông tin lớp --%>
                <ul class="list-unstyled mb-3" style="font-size:13px">
                  <li class="mb-1">
                    <i class="bi bi-door-open text-muted me-2"></i>
                    <span class="fw-semibold">${cls.className}</span>
                  </li>
                  <li class="mb-1">
                    <i class="bi bi-calendar3 text-muted me-2"></i>
                    <span class="text-muted">${cls.scheduleInfo}</span>
                  </li>
                  <li class="mb-1">
                    <i class="bi bi-people text-muted me-2"></i>
                    <span class="${cls.available ? 'text-success' : 'text-danger'} fw-semibold">
                      ${cls.currentStudents}/${cls.maxStudents} học viên
                    </span>
                    <c:if test="${cls.remainingSlots <= 3 && cls.available}">
                      <span class="badge bg-danger ms-1" style="font-size:10px">Sắp đầy!</span>
                    </c:if>
                  </li>
                </ul>

                <%-- Progress bar sĩ số --%>
                <div class="mb-3">
                  <div class="progress" style="height:5px;">
                    <div class="progress-bar ${cls.remainingSlots <= 3 ? 'bg-danger' : 'bg-success'}"
                         style="width:${(cls.currentStudents / cls.maxStudents) * 100}%"></div>
                  </div>
                </div>

                <%-- Footer: học phí + nút --%>
                <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top">
                  <div>
                    <div class="text-muted" style="font-size:11px">Học phí</div>
                    <div class="fw-bold text-primary" style="font-size:16px">
                      <fmt:formatNumber value="${cls.tuitionFee}" type="number"
                                        groupingUsed="true" maxFractionDigits="0"/>đ
                    </div>
                  </div>
                  <c:choose>
                    <c:when test="${cls.note == 'enrolled'}">
                      <button class="btn btn-sm btn-success" disabled>
                        <i class="bi bi-check-lg me-1"></i>Đã đăng ký
                      </button>
                    </c:when>
                    <c:when test="${!cls.available}">
                      <button class="btn btn-sm btn-secondary" disabled>
                        <i class="bi bi-x-circle me-1"></i>Hết chỗ
                      </button>
                    </c:when>
                    <c:otherwise>
                      <button class="btn btn-sm btn-primary"
                              onclick="confirmEnroll(${cls.classId}, '${cls.courseName}', '${cls.className}')">
                        <i class="bi bi-plus-circle me-1"></i>Đăng ký
                      </button>
                    </c:otherwise>
                  </c:choose>
                </div>

              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

</section>

<%-- ══ MODAL XÁC NHẬN ══ --%>
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold">
          <i class="bi bi-clipboard-check text-primary me-2"></i>Xác nhận đăng ký
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/student/courses" method="POST">
        <div class="modal-body">
          <p class="mb-1 text-muted small">Bạn chọn đăng ký khóa học:</p>
          <p id="modal-course-name" class="fw-bold text-primary fs-6 mb-1"></p>
          <p id="modal-class-name" class="text-muted small mb-0"></p>
          <div class="alert alert-info mt-3 py-2 mb-0" style="font-size:13px">
            <i class="bi bi-info-circle me-1"></i>
            Sau khi đăng ký, Admin sẽ xác nhận thanh toán học phí cho bạn.
          </div>
          <input type="hidden" name="action" value="enroll">
          <input type="hidden" name="classId" id="modal-class-id">
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary btn-sm px-4">
            <i class="bi bi-check-lg me-1"></i>Xác nhận đăng ký
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function confirmEnroll(id, course, cls) {
  document.getElementById('modal-class-id').value   = id;
  document.getElementById('modal-course-name').textContent = course;
  document.getElementById('modal-class-name').textContent  = 'Lớp: ' + cls;
  new bootstrap.Modal(document.getElementById('confirmModal')).show();
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
