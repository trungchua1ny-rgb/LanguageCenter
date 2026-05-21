<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<c:set var="isEdit"     value="${course != null}" />
<c:set var="formTitle"  value="${isEdit ? 'Sửa khóa học' : 'Thêm khóa học mới'}" />
<c:set var="formAction" value="${isEdit ? 'update' : 'insert'}" />

<div class="pagetitle">
  <h1>${formTitle}</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/courses">Khóa học</a></li>
      <li class="breadcrumb-item active">${formTitle}</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">
  <div class="row">
    <div class="col-lg-8">

      <div class="card">
        <div class="card-body pt-4">
          <h5 class="card-title">${formTitle}</h5>

          <form method="POST"
                action="${pageContext.request.contextPath}/admin/courses"
                novalidate id="courseForm">

            <input type="hidden" name="action" value="${formAction}">
            <c:if test="${isEdit}">
              <input type="hidden" name="id" value="${course.id}">
            </c:if>

            <%-- Tên khóa học --%>
            <div class="mb-3">
              <label class="form-label fw-semibold">
                Tên khóa học <span class="text-danger">*</span>
              </label>
              <input type="text" name="name" class="form-control"
                     placeholder="Ví dụ: IELTS Target 6.5"
                     value="${isEdit ? course.name : ''}"
                     required maxlength="150">
            </div>

            <%-- Mô tả --%>
            <div class="mb-3">
              <label class="form-label fw-semibold">Mô tả</label>
              <textarea name="description" class="form-control" rows="3"
                        placeholder="Mô tả ngắn về khóa học...">${isEdit ? course.description : ''}</textarea>
            </div>

            <%-- Cấp độ + Giáo viên --%>
            <div class="row g-3 mb-3">
              <div class="col-md-6">
                <label class="form-label fw-semibold">
                  Cấp độ <span class="text-danger">*</span>
                </label>
                <select name="levelId" class="form-select" required>
                  <option value="">-- Chọn cấp độ --</option>
                  <c:forEach var="lv" items="${levels}">
                    <option value="${lv.id}"
                      ${isEdit && course.levelId == lv.id ? 'selected' : ''}>
                      ${lv.name}
                    </option>
                  </c:forEach>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Giáo viên phụ trách</label>
                <select name="teacherId" class="form-select">
                  <option value="">-- Chưa phân công --</option>
                  <c:forEach var="t" items="${teachers}">
                    <option value="${t.id}"
                      ${isEdit && course.teacherId == t.id ? 'selected' : ''}>
                      ${t.fullName}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <%-- Số tuần + Học phí + Sĩ số --%>
            <div class="row g-3 mb-3">
              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  Số tuần học <span class="text-danger">*</span>
                </label>
                <input type="number" name="durationWeeks" class="form-control"
                       min="1" max="52" required
                       value="${isEdit ? course.durationWeeks : 12}">
              </div>
              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  Học phí (đ) <span class="text-danger">*</span>
                </label>
                <input type="number" name="tuitionFee" class="form-control"
                       min="0" step="100000" required
                       value="${isEdit ? course.tuitionFee : 0}">
              </div>
              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  Sĩ số tối đa <span class="text-danger">*</span>
                </label>
                <input type="number" name="maxStudents" class="form-control"
                       min="1" max="100" required
                       value="${isEdit ? course.maxStudents : 20}">
              </div>
            </div>

            <%-- Trạng thái --%>
            <div class="mb-4">
              <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox"
                       name="isActive" id="isActive"
                       ${!isEdit || course.active ? 'checked' : ''}>
                <label class="form-check-label fw-semibold" for="isActive">
                  Hiển thị cho học viên đăng ký
                </label>
              </div>
            </div>

            <%-- Nút submit --%>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-save me-1"></i>
                ${isEdit ? 'Lưu thay đổi' : 'Thêm khóa học'}
              </button>
              <a href="${pageContext.request.contextPath}/admin/courses"
                 class="btn btn-secondary">Hủy</a>
            </div>

          </form>
        </div>
      </div><!-- End Card -->

    </div>
  </div>
</section>

<script>
document.getElementById('courseForm').addEventListener('submit', function(e) {
  const name  = this.querySelector('[name=name]').value.trim();
  const level = this.querySelector('[name=levelId]').value;
  if (!name || !level) {
    e.preventDefault();
    alert('Vui lòng điền đầy đủ các trường bắt buộc (*)');
  }
});
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
