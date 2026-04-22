<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<%-- ══ HEADER TRANG ══ --%>
<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h5 class="fw-bold mb-1">Quản lý khóa học</h5>
    <p class="text-muted mb-0" style="font-size:14px">
      Tổng cộng <strong>${courses.size()}</strong> khóa học
    </p>
  </div>
  <a href="${pageContext.request.contextPath}/admin/courses?action=add"
     class="btn btn-primary btn-sm">
    <i class="bi bi-plus-circle me-1"></i>Thêm khóa học
  </a>
</div>

<%-- ══ THÔNG BÁO ══ --%>
<c:if test="${not empty successMsg}">
  <div class="alert alert-success alert-dismissible fade show py-2">
    <i class="bi bi-check-circle me-1"></i>${successMsg}
    <button type="button" class="btn-close btn-sm" data-bs-dismiss="alert"></button>
  </div>
</c:if>
<c:if test="${not empty errorMsg}">
  <div class="alert alert-danger alert-dismissible fade show py-2">
    <i class="bi bi-exclamation-circle me-1"></i>${errorMsg}
    <button type="button" class="btn-close btn-sm" data-bs-dismiss="alert"></button>
  </div>
</c:if>

<%-- ══ BẢNG DANH SÁCH ══ --%>
<div class="card border-0 shadow-sm">
  <div class="card-body p-0">
    <c:choose>
      <c:when test="${empty courses}">
        <div class="text-center py-5 text-muted">
          <i class="bi bi-inbox fs-1"></i>
          <p class="mt-2">Chưa có khóa học nào.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0" style="font-size:14px">
            <thead class="table-light">
              <tr>
                <th style="width:40px">#</th>
                <th>Tên khóa học</th>
                <th>Cấp độ</th>
                <th>Giáo viên</th>
                <th>Số tuần</th>
                <th>Học phí</th>
                <th>Sĩ số</th>
                <th>Trạng thái</th>
                <th style="width:120px">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${courses}" varStatus="s">
                <tr>
                  <td class="text-muted">${s.count}</td>
                  <td>
                    <div class="fw-semibold">${c.name}</div>
                    <div class="text-muted" style="font-size:12px;
                         max-width:220px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">
                      ${c.description}
                    </div>
                  </td>
                  <td>
                    <span class="badge rounded-pill"
                          style="background:#e8f0fe;color:#1a73e8;font-size:11px">
                      ${c.levelName}
                    </span>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty c.teacherName}">${c.teacherName}</c:when>
                      <c:otherwise><span class="text-muted">Chưa phân công</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>${c.durationWeeks} tuần</td>
                  <td class="fw-semibold text-primary">
                    <fmt:formatNumber value="${c.tuitionFee}" type="number"
                                      groupingUsed="true" maxFractionDigits="0"/>đ
                  </td>
                  <td>${c.maxStudents}</td>
                  <td>
                    <c:choose>
                      <c:when test="${c.active}">
                        <span class="badge bg-success">Đang mở</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-secondary">Đã ẩn</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <%-- Nút Sửa --%>
                    <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=${c.id}"
                       class="btn btn-sm btn-outline-primary py-0 px-2 me-1">
                      <i class="bi bi-pencil"></i>
                    </a>
                    <%-- Nút Xóa --%>
                    <button class="btn btn-sm btn-outline-danger py-0 px-2"
                            onclick="confirmDelete(${c.id}, '${c.name}')">
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

<%-- ══ MODAL XÁC NHẬN XÓA ══ --%>
<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h6 class="modal-title fw-bold">Xác nhận xóa</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body pt-0">
        <p class="mb-1">Bạn muốn xóa khóa học:</p>
        <p class="fw-bold" id="delete-course-name"></p>
        <div class="alert alert-warning py-2 mb-0" style="font-size:13px">
          <i class="bi bi-exclamation-triangle me-1"></i>
          Nếu đã có lớp học sử dụng, khóa học sẽ bị <strong>ẩn</strong> thay vì xóa hẳn.
        </div>
      </div>
      <div class="modal-footer border-0 pt-0">
        <button class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
        <form id="deleteForm" method="POST"
              action="${pageContext.request.contextPath}/admin/courses">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" id="delete-id">
          <button type="submit" class="btn btn-danger btn-sm">Xác nhận xóa</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
function confirmDelete(id, name) {
  document.getElementById('delete-id').value = id;
  document.getElementById('delete-course-name').textContent = name;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
