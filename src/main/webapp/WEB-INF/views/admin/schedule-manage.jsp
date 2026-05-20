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
          <i class="bi bi-calendar3 text-primary me-2"></i>Quản lý Thời khóa biểu
        </h4>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb mb-0 small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Trang chủ</a></li>
            <li class="breadcrumb-item active">Thời khóa biểu</li>
          </ol>
        </nav>
      </div>
    </div>

    <%-- ── ALERT MESSAGES ──────────────────────────────── --%>
    <c:if test="${param.success == 'added'}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>Thêm buổi học thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="alert alert-info alert-dismissible fade show" role="alert">
        <i class="bi bi-trash-fill me-2"></i>Đã xóa buổi học.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${param.error == 'room_conflict'}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <strong>Trùng lịch!</strong> Phòng đã được đặt trong khung giờ đó. Vui lòng chọn phòng hoặc giờ khác.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${param.error == 'invalid_time'}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Giờ kết thúc phải sau giờ bắt đầu.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${param.error == 'missing_fields'}">
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-circle-fill me-2"></i>Vui lòng điền đầy đủ thông tin.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${param.error == 'db_fail'}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-x-circle-fill me-2"></i>Thao tác thất bại. Vui lòng thử lại.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <%-- ── BƯỚC 1: CHỌN LỚP (form filter) ────────────── --%>
    <div class="card border-0 shadow-sm mb-4">
      <div class="card-body">
        <form method="get" action="${pageContext.request.contextPath}/admin/schedules"
              class="row g-3 align-items-end">
          <div class="col-md-6">
            <label class="form-label fw-semibold">
              <i class="bi bi-search me-1"></i>Chọn lớp để xem / xếp TKB
            </label>
            <select name="classId" class="form-select" required onchange="this.form.submit()">
              <option value="" disabled <c:if test="${empty selectedClassId}">selected</c:if>>
                -- Bấm để chọn lớp học --
              </option>
              <c:forEach var="cls" items="${allClasses}">
                <option value="${cls.id}" <c:if test="${cls.id == selectedClassId}">selected</c:if>>
                  ${cls.className} (Mã: ${cls.id})
                </option>
              </c:forEach>
            </select>
            <div class="form-text">Chọn lớp học từ danh sách để xem thời khóa biểu tương ứng.</div>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-primary w-100">
              <i class="bi bi-search me-1"></i>Xem TKB
            </button>
          </div>
        </form>
      </div>
    </div>

    <%-- ── NỘI DUNG CHÍNH (chỉ hiển thị khi đã chọn lớp) ─ --%>
    <c:choose>

      <c:when test="${empty selectedClassId}">
        <%-- Chưa chọn lớp --%>
        <div class="text-center py-5 text-muted">
          <i class="bi bi-calendar3" style="font-size:3rem;"></i>
          <p class="mt-3 fs-5">Hãy chọn lớp học bên trên để xem thời khóa biểu của lớp đó.</p>
        </div>
      </c:when>

      <c:otherwise>
        <div class="row g-4">

          <%-- ── CỘT TRÁI: DANH SÁCH TKB ─────────────────── --%>
          <div class="col-lg-7">
            <div class="card border-0 shadow-sm">
              <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                <h6 class="fw-bold mb-0">
                  <i class="bi bi-list-ul me-2 text-primary"></i>
                  Thời khóa biểu — Lớp #<strong>${selectedClassId}</strong>
                </h6>
                <span class="badge bg-primary rounded-pill">${fn:length(schedules)} buổi</span>
              </div>
              <div class="card-body p-0">
                <c:choose>
                  <c:when test="${empty schedules}">
                    <div class="text-center py-5 text-muted">
                      <i class="bi bi-calendar-x" style="font-size:2rem;"></i>
                      <p class="mt-2">Lớp này chưa có buổi học nào.</p>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="table-responsive">
                      <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                          <tr>
                            <th>Thứ</th>
                            <th>Giờ học</th>
                            <th>Phòng</th>
                            <th>Khóa học</th>
                            <th class="text-center">Thao tác</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="sc" items="${schedules}">
                            <tr>
                              <td>
                                <span class="badge bg-primary bg-opacity-10 text-primary fw-semibold px-2 py-1">
                                  ${sc.dayOfWeekVi}
                                </span>
                              </td>
                              <td>
                                <i class="bi bi-clock me-1 text-muted"></i>
                                <strong>${sc.startTime}</strong>
                                <span class="text-muted mx-1">–</span>
                                <strong>${sc.endTime}</strong>
                              </td>
                              <td>
                                <i class="bi bi-geo-alt me-1 text-muted"></i>${sc.roomName}
                              </td>
                              <td class="text-muted small">${sc.courseName}</td>
                              <td class="text-center">
                                <%-- Confirm xóa bằng modal Bootstrap --%>
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        data-schedule-id="${sc.id}"
                                        data-schedule-info="${sc.dayOfWeekVi} ${sc.startTime}–${sc.endTime} (${sc.roomName})">
                                  <i class="bi bi-trash"></i>
                                </button>
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
          </div>

          <%-- ── CỘT PHẢI: FORM THÊM BUỔI HỌC ──────────── --%>
          <div class="col-lg-5">
            <div class="card border-0 shadow-sm">
              <div class="card-header bg-white border-bottom py-3">
                <h6 class="fw-bold mb-0">
                  <i class="bi bi-plus-circle me-2 text-success"></i>Thêm buổi học mới
                </h6>
              </div>
              <div class="card-body">
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/schedules?action=add"
                      class="needs-validation" novalidate>

                  <%-- classId ẩn --%>
                  <input type="hidden" name="classId" value="${selectedClassId}">

                  <%-- Thứ trong tuần --%>
                  <div class="mb-3">
                    <label class="form-label fw-semibold">Thứ trong tuần <span class="text-danger">*</span></label>
                    <select name="dayOfWeek" class="form-select" required>
                      <option value="" disabled selected>-- Chọn thứ --</option>
                      <option value="Mon">Thứ Hai</option>
                      <option value="Tue">Thứ Ba</option>
                      <option value="Wed">Thứ Tư</option>
                      <option value="Thu">Thứ Năm</option>
                      <option value="Fri">Thứ Sáu</option>
                      <option value="Sat">Thứ Bảy</option>
                      <option value="Sun">Chủ Nhật</option>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn thứ.</div>
                  </div>

                  <%-- Giờ bắt đầu & kết thúc --%>
                  <div class="row g-2 mb-3">
                    <div class="col-6">
                      <label class="form-label fw-semibold">Giờ bắt đầu <span class="text-danger">*</span></label>
                      <input type="time" name="startTime" class="form-control" required>
                      <div class="invalid-feedback">Bắt buộc.</div>
                    </div>
                    <div class="col-6">
                      <label class="form-label fw-semibold">Giờ kết thúc <span class="text-danger">*</span></label>
                      <input type="time" name="endTime" class="form-control" required>
                      <div class="invalid-feedback">Bắt buộc.</div>
                    </div>
                  </div>

                  <%-- Phòng học --%>
                  <div class="mb-4">
                    <label class="form-label fw-semibold">Phòng học <span class="text-danger">*</span></label>
                    <select name="roomId" class="form-select" required>
                      <option value="" disabled selected>-- Chọn phòng --</option>
                      <c:forEach var="room" items="${rooms}">
                        <option value="${room[0]}">${room[1]}</option>
                      </c:forEach>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn phòng.</div>
                    <div class="form-text text-warning">
                      <i class="bi bi-info-circle me-1"></i>
                      Hệ thống sẽ tự kiểm tra nếu phòng đã bị đặt trùng giờ.
                    </div>
                  </div>

                  <div class="d-grid">
                    <button type="submit" class="btn btn-success">
                      <i class="bi bi-plus-circle me-2"></i>Thêm buổi học
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>

        </div><%-- end row --%>
      </c:otherwise>
    </c:choose>

  </div><%-- end container --%>
</div><%-- end main-content --%>

<%-- ── MODAL XÁC NHẬN XÓA ─────────────────────────────── --%>
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h6 class="modal-title fw-bold" id="deleteModalLabel">
          <i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Xác nhận xóa
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="deleteModalBody">
        Bạn có chắc muốn xóa buổi học này không?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
        <form id="deleteForm" method="post"
              action="${pageContext.request.contextPath}/admin/schedules?action=delete">
          <input type="hidden" name="classId" value="${selectedClassId}">
          <input type="hidden" name="id" id="deleteScheduleId">
          <button type="submit" class="btn btn-danger btn-sm">
            <i class="bi bi-trash me-1"></i>Xóa
          </button>
        </form>
      </div>
    </div>
  </div>
</div>

<%-- ── SCRIPTS ──────────────────────────────────────────── --%>
<script>
  // Bootstrap form validation
  (() => {
    'use strict';
    document.querySelectorAll('.needs-validation').forEach(form => {
      form.addEventListener('submit', e => {
        if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
        form.classList.add('was-validated');
      }, false);
    });
  })();

  // Populate modal với thông tin buổi học sẽ xóa
  const deleteModal = document.getElementById('deleteModal');
  if (deleteModal) {
    deleteModal.addEventListener('show.bs.modal', event => {
      const btn  = event.relatedTarget;
      const id   = btn.getAttribute('data-schedule-id');
      const info = btn.getAttribute('data-schedule-info');
      document.getElementById('deleteScheduleId').value = id;
      document.getElementById('deleteModalBody').textContent =
        `Xóa buổi học: ${info}?`;
    });
  }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>