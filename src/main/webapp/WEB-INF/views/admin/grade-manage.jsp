<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Quản lý Điểm số</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Điểm số</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">

  <%-- ══ THÔNG BÁO ══ --%>
  <c:if test="${param.success == 'inserted'}">
    <div class="alert alert-success alert-dismissible fade show">
      <i class="bi bi-check-circle-fill me-2"></i>Nhập điểm thành công!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.success == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
      <i class="bi bi-pencil-fill me-2"></i>Cập nhật điểm thành công!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.success == 'deleted'}">
    <div class="alert alert-info alert-dismissible fade show">
      <i class="bi bi-trash-fill me-2"></i>Đã xóa điểm.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.error == 'invalid_score'}">
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-triangle-fill me-2"></i>
      Điểm không hợp lệ. Điểm phải &ge; 0 và không vượt quá điểm tối đa.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.error == 'missing_fields'}">
    <div class="alert alert-warning alert-dismissible fade show">
      <i class="bi bi-exclamation-circle-fill me-2"></i>Vui lòng điền đầy đủ thông tin.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.error == 'db_fail'}">
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-x-circle-fill me-2"></i>Thao tác thất bại. Vui lòng thử lại.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <%-- ══ FILTER: CHỌN LỚP ══ --%>
  <div class="card mb-4">
    <div class="card-body">
      <h5 class="card-title">Lọc theo lớp học</h5>
      <form method="get" action="${pageContext.request.contextPath}/admin/grades"
            class="row g-3 align-items-end">
        <div class="col-md-6">
          <label class="form-label fw-semibold">Chọn lớp</label>
          <select name="classId" class="form-select" onchange="this.form.submit()">
            <option value="">-- Tất cả lớp đang hoạt động --</option>
            <c:forEach var="cls" items="${allClasses}">
              <option value="${cls[0]}" <c:if test="${cls[0] == selectedClassId}">selected</c:if>>
                ${cls[1]}
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="col-md-2">
          <a href="${pageContext.request.contextPath}/admin/grades"
             class="btn btn-outline-secondary w-100">
            <i class="bi bi-x-circle me-1"></i>Xóa lọc
          </a>
        </div>
      </form>
    </div>
  </div>

  <c:choose>

    <%-- ══ CHƯA CHỌN LỚP ══ --%>
    <c:when test="${empty selectedClassId}">
      <div class="text-center py-5 text-muted">
        <i class="bi bi-award" style="font-size:3rem;"></i>
        <p class="mt-3 fs-5">Chọn lớp học phía trên để xem và nhập điểm.</p>
      </div>
    </c:when>

    <c:otherwise>
      <div class="row g-4">

        <%-- ══ CỘT TRÁI: BẢNG ĐIỂM ══ --%>
        <div class="col-lg-8">
          <div class="card">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-center pt-3 mb-3">
                <h5 class="card-title mb-0">
                  Bảng điểm — Lớp #<strong>${selectedClassId}</strong>
                </h5>
                <span class="badge bg-secondary rounded-pill">${fn:length(grades)} bài</span>
              </div>

              <c:choose>
                <c:when test="${empty grades}">
                  <div class="text-center py-5 text-muted">
                    <i class="bi bi-inbox" style="font-size:2rem;"></i>
                    <p class="mt-2">Chưa có điểm nào cho lớp này.</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="table-responsive">
                    <table class="table table-hover align-middle" style="font-size:14px">
                      <thead class="table-light">
                        <tr>
                          <th>Học viên</th>
                          <th>Bài thi</th>
                          <th class="text-center">Điểm</th>
                          <th class="text-center">%</th>
                          <th>Xếp loại</th>
                          <th>Ngày thi</th>
                          <th>Ghi chú</th>
                          <th class="text-center" style="width:90px">Thao tác</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="g" items="${grades}">
                          <tr>
                            <td class="fw-semibold">${g.studentName}</td>
                            <td>${g.examName}</td>
                            <td class="text-center">
                              <strong class="text-primary">
                                <fmt:formatNumber value="${g.score}" maxFractionDigits="1"/>
                              </strong>
                              <span class="text-muted small">
                                /<fmt:formatNumber value="${g.maxScore}" maxFractionDigits="1"/>
                              </span>
                            </td>
                            <td class="text-center">
                              <div class="progress" style="height:6px;min-width:60px;">
                                <div class="progress-bar ${g.rankBadgeClass}"
                                     style="width:${g.scorePercent}%"></div>
                              </div>
                              <small class="text-muted">${g.scorePercent}%</small>
                            </td>
                            <td>
                              <span class="badge ${g.rankBadgeClass} rounded-pill">${g.rank}</span>
                            </td>
                            <td class="text-muted small">${g.formattedExamDate}</td>
                            <td class="text-muted small">${g.note}</td>
                            <td class="text-center">
                              <a href="${pageContext.request.contextPath}/admin/grades?classId=${selectedClassId}&editId=${g.id}"
                                 class="btn btn-sm btn-outline-primary py-0 px-2 me-1" title="Sửa điểm">
                                <i class="bi bi-pencil"></i>
                              </a>
                              <button type="button" class="btn btn-sm btn-outline-danger py-0 px-2"
                                      data-bs-toggle="modal" data-bs-target="#deleteModal"
                                      data-grade-id="${g.id}"
                                      data-grade-info="${g.studentName} — ${g.examName}">
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

        <%-- ══ CỘT PHẢI: FORM NHẬP / SỬA ĐIỂM ══ --%>
        <div class="col-lg-4">

          <%-- Form sửa điểm (nếu có editGrade) --%>
          <c:if test="${not empty editGrade}">
            <div class="card border-warning border-2 mb-3">
              <div class="card-body">
                <h5 class="card-title text-warning pt-3">
                  <i class="bi bi-pencil-square me-2"></i>Sửa điểm
                </h5>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/grades?action=update"
                      class="needs-validation" novalidate>
                  <input type="hidden" name="classId" value="${selectedClassId}">
                  <input type="hidden" name="id" value="${editGrade.id}">

                  <div class="mb-2">
                    <label class="form-label fw-semibold small">Học viên</label>
                    <input type="text" class="form-control form-control-sm"
                           value="${editGrade.studentName}" disabled>
                  </div>
                  <div class="mb-2">
                    <label class="form-label fw-semibold small">
                      Tên bài thi <span class="text-danger">*</span>
                    </label>
                    <input type="text" name="examName" class="form-control form-control-sm"
                           value="${editGrade.examName}" required maxlength="100">
                  </div>
                  <div class="row g-2 mb-2">
                    <div class="col-6">
                      <label class="form-label fw-semibold small">
                        Điểm đạt <span class="text-danger">*</span>
                      </label>
                      <input type="number" name="score" class="form-control form-control-sm"
                             value="${editGrade.score}" step="0.1" min="0" required>
                    </div>
                    <div class="col-6">
                      <label class="form-label fw-semibold small">
                        Điểm tối đa <span class="text-danger">*</span>
                      </label>
                      <input type="number" name="maxScore" class="form-control form-control-sm"
                             value="${editGrade.maxScore}" step="0.1" min="0.1" required>
                    </div>
                  </div>
                  <div class="mb-2">
                    <label class="form-label fw-semibold small">Ngày thi</label>
                    <input type="date" name="examDate" class="form-control form-control-sm"
                           value="${editGrade.examDate}">
                  </div>
                  <div class="mb-3">
                    <label class="form-label fw-semibold small">Ghi chú</label>
                    <input type="text" name="note" class="form-control form-control-sm"
                           value="${editGrade.note}" maxlength="255">
                  </div>
                  <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning btn-sm flex-grow-1">
                      <i class="bi bi-save me-1"></i>Lưu thay đổi
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/grades?classId=${selectedClassId}"
                       class="btn btn-outline-secondary btn-sm">
                      <i class="bi bi-x"></i>
                    </a>
                  </div>
                </form>
              </div>
            </div>
          </c:if>

          <%-- Form nhập điểm mới --%>
          <div class="card">
            <div class="card-body">
              <h5 class="card-title pt-3">
                <i class="bi bi-plus-circle me-2 text-success"></i>Nhập điểm mới
              </h5>
              <form method="post"
                    action="${pageContext.request.contextPath}/admin/grades?action=insert"
                    class="needs-validation" novalidate>
                <input type="hidden" name="classId" value="${selectedClassId}">

                <div class="mb-3">
                  <label class="form-label fw-semibold small">
                    Chọn học viên <span class="text-danger">*</span>
                  </label>
                  <select name="enrollmentId" class="form-select form-select-sm" required>
                    <option value="" disabled selected>-- Chọn học viên --</option>
                    <c:forEach var="stu" items="${students}">
                      <option value="${stu[0]}">${stu[1]}</option>
                    </c:forEach>
                  </select>
                  <div class="invalid-feedback">Vui lòng chọn học viên.</div>
                  <div class="form-text">Chỉ hiển thị học viên đã thanh toán.</div>
                </div>

                <div class="mb-3">
                  <label class="form-label fw-semibold small">
                    Tên bài thi <span class="text-danger">*</span>
                  </label>
                  <input type="text" name="examName" class="form-control form-control-sm"
                         placeholder="VD: Kiểm tra giữa kỳ" required maxlength="100">
                  <div class="invalid-feedback">Bắt buộc.</div>
                </div>

                <div class="row g-2 mb-3">
                  <div class="col-6">
                    <label class="form-label fw-semibold small">
                      Điểm đạt <span class="text-danger">*</span>
                    </label>
                    <input type="number" name="score" class="form-control form-control-sm"
                           placeholder="VD: 8.5" step="0.1" min="0" required>
                    <div class="invalid-feedback">Bắt buộc.</div>
                  </div>
                  <div class="col-6">
                    <label class="form-label fw-semibold small">
                      Thang điểm <span class="text-danger">*</span>
                    </label>
                    <input type="number" name="maxScore" class="form-control form-control-sm"
                           placeholder="VD: 10" step="0.1" min="0.1" value="10" required>
                    <div class="invalid-feedback">Bắt buộc.</div>
                  </div>
                </div>

                <div class="mb-3">
                  <label class="form-label fw-semibold small">Ngày thi</label>
                  <input type="date" name="examDate" class="form-control form-control-sm">
                </div>

                <div class="mb-4">
                  <label class="form-label fw-semibold small">Ghi chú</label>
                  <input type="text" name="note" class="form-control form-control-sm"
                         placeholder="Tùy chọn" maxlength="255">
                </div>

                <div class="d-grid">
                  <button type="submit" class="btn btn-success btn-sm">
                    <i class="bi bi-plus-circle me-2"></i>Nhập điểm
                  </button>
                </div>
              </form>
            </div>
          </div>

        </div><!-- End col right -->
      </div><!-- End row -->
    </c:otherwise>
  </c:choose>

</section>

<%-- ══ MODAL XÁC NHẬN XÓA ══ --%>
<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h6 class="modal-title fw-bold">
          <i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Xác nhận xóa điểm
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="deleteModalBody">Xóa bản ghi điểm này?</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
        <form id="deleteForm" method="post"
              action="${pageContext.request.contextPath}/admin/grades?action=delete">
          <input type="hidden" name="classId" value="${selectedClassId}">
          <input type="hidden" name="id" id="deleteGradeId">
          <button type="submit" class="btn btn-danger btn-sm">
            <i class="bi bi-trash me-1"></i>Xóa
          </button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
(() => {
  'use strict';
  document.querySelectorAll('.needs-validation').forEach(form => {
    form.addEventListener('submit', e => {
      if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
      form.classList.add('was-validated');
    }, false);
  });
})();

const deleteModal = document.getElementById('deleteModal');
if (deleteModal) {
  deleteModal.addEventListener('show.bs.modal', event => {
    const btn  = event.relatedTarget;
    const id   = btn.getAttribute('data-grade-id');
    const info = btn.getAttribute('data-grade-info');
    document.getElementById('deleteGradeId').value = id;
    document.getElementById('deleteModalBody').textContent = `Xóa điểm: ${info}?`;
  });
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
