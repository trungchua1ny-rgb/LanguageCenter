<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="container-fluid py-4" style="max-width:680px">
  <div class="d-flex align-items-center gap-2 mb-4">
    <a href="${pageContext.request.contextPath}/admin/classes"
       class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left"></i>
    </a>
    <h4 class="mb-0">
      ${empty classObj ? 'Thêm lớp học mới' : 'Sửa lớp: '.concat(classObj.className)}
    </h4>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <form method="post"
            action="${pageContext.request.contextPath}/admin/classes">
        <input type="hidden" name="action"
               value="${empty classObj ? 'insert' : 'update'}">
        <c:if test="${not empty classObj}">
          <input type="hidden" name="id" value="${classObj.id}">
        </c:if>

        <div class="mb-3">
          <label class="form-label fw-semibold">
            Tên lớp <span class="text-danger">*</span>
          </label>
          <input type="text" name="className" class="form-control" required
                 value="${classObj.className}"
                 placeholder="VD: IELTS Cấp tốc K01">
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">
            Khóa học <span class="text-danger">*</span>
          </label>
          <select name="courseId" class="form-select" required>
            <option value="">-- Chọn khóa học --</option>
            <c:forEach var="co" items="${courses}">
              <option value="${co.id}"
                      ${classObj.courseId == co.id ? 'selected' : ''}>
                ${co.name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="row g-3 mb-3">
          <div class="col-md-6">
            <label class="form-label fw-semibold">Ngày khai giảng</label>
            <input type="date" name="startDate" class="form-control"
                   value="${classObj.startDate}">
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Ngày kết thúc</label>
            <input type="date" name="endDate" class="form-control"
                   value="${classObj.endDate}">
          </div>
        </div>

        <div class="mb-4">
          <label class="form-label fw-semibold">Trạng thái</label>
          <select name="status" class="form-select">
            <option value="upcoming" ${classObj.status == 'upcoming' ? 'selected':''}>
              Sắp khai giảng
            </option>
            <option value="ongoing"  ${classObj.status == 'ongoing'  ? 'selected':''}>
              Đang học
            </option>
            <option value="finished" ${classObj.status == 'finished' ? 'selected':''}>
              Đã kết thúc
            </option>
            <option value="cancelled" ${classObj.status == 'cancelled' ? 'selected':''}>
              Đã hủy
            </option>
          </select>
        </div>

        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary">
            <i class="bi bi-check-lg"></i>
            ${empty classObj ? 'Thêm lớp' : 'Lưu thay đổi'}
          </button>
          <a href="${pageContext.request.contextPath}/admin/classes"
             class="btn btn-outline-secondary">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>