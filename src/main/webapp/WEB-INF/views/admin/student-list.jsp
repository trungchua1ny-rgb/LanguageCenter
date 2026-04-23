<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<%-- ══ HEADER TRANG ══ --%>
<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h5 class="fw-bold mb-1">Quản lý học viên</h5>
    <p class="text-muted mb-0" style="font-size:14px">
      <c:choose>
        <c:when test="${not empty keyword}">
          Kết quả tìm kiếm "<strong>${keyword}</strong>":
          <strong>${totalCount}</strong> học viên
        </c:when>
        <c:otherwise>
          Tổng cộng <strong>${totalCount}</strong> học viên
        </c:otherwise>
      </c:choose>
    </p>
  </div>
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

<%-- ══ THANH TÌM KIẾM ══ --%>
<div class="card border-0 shadow-sm mb-3">
  <div class="card-body py-2 px-3">
    <form method="GET"
          action="${pageContext.request.contextPath}/admin/students"
          class="d-flex gap-2">
      <input type="text" name="q" class="form-control form-control-sm"
             placeholder="Tìm theo tên, email, username..."
             value="${keyword}" style="max-width:340px">
      <button type="submit" class="btn btn-sm btn-primary px-3">
        <i class="bi bi-search me-1"></i>Tìm
      </button>
      <c:if test="${not empty keyword}">
        <a href="${pageContext.request.contextPath}/admin/students"
           class="btn btn-sm btn-outline-secondary">Xóa bộ lọc</a>
      </c:if>
    </form>
  </div>
</div>

<%-- ══ BẢNG DANH SÁCH ══ --%>
<div class="card border-0 shadow-sm">
  <div class="card-body p-0">
    <c:choose>
      <c:when test="${empty students}">
        <div class="text-center py-5 text-muted">
          <i class="bi bi-people fs-1 d-block mb-2"></i>
          <c:choose>
            <c:when test="${not empty keyword}">Không tìm thấy học viên nào với từ khóa "<strong>${keyword}</strong>".</c:when>
            <c:otherwise>Chưa có học viên nào trong hệ thống.</c:otherwise>
          </c:choose>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0" style="font-size:14px">
            <thead class="table-light">
              <tr>
                <th style="width:40px">#</th>
                <th>Họ tên</th>
                <th>Tài khoản</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>Số lớp</th>
                <th>Ngày đăng ký</th>
                <th>Trạng thái</th>
                <th style="width:110px">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="sv" items="${students}" varStatus="s">
                <tr class="${sv.active ? '' : 'table-secondary opacity-75'}">
                  <td class="text-muted">${s.count}</td>

                  <%-- Họ tên + avatar chữ --%>
                  <td>
                    <div class="d-flex align-items-center gap-2">
                      <div style="width:32px;height:32px;border-radius:50%;
                                  background:#e8f0fe;color:#1a73e8;
                                  display:flex;align-items:center;justify-content:center;
                                  font-size:12px;font-weight:600;flex-shrink:0">
                        ${sv.fullName.substring(0,1).toUpperCase()}
                      </div>
                      <span class="fw-semibold">${sv.fullName}</span>
                    </div>
                  </td>

                  <td><code style="font-size:12px">${sv.username}</code></td>
                  <td style="font-size:13px">${sv.email}</td>
                  <td style="font-size:13px">
                    <c:choose>
                      <c:when test="${not empty sv.phone}">${sv.phone}</c:when>
                      <c:otherwise><span class="text-muted">—</span></c:otherwise>
                    </c:choose>
                  </td>

                  <%-- Số lớp đang học --%>
                  <td>
                    <span class="badge rounded-pill bg-primary bg-opacity-10
                                 text-primary fw-normal"
                          style="font-size:12px">
                      ${sv.enrollmentCount} lớp
                    </span>
                  </td>

                  <%-- Ngày tạo tài khoản --%>
                  <td style="font-size:12px;color:var(--bs-secondary-color)">
                    <fmt:formatDate value="${sv.createdAt}" pattern="dd/MM/yyyy"/>
                  </td>

                  <%-- Badge trạng thái --%>
                  <td>
                    <c:choose>
                      <c:when test="${sv.active}">
                        <span class="badge bg-success">Hoạt động</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-danger">Đã khóa</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <%-- Thao tác --%>
                  <td>
                    <%-- Nút xem chi tiết --%>
                    <a href="${pageContext.request.contextPath}/admin/students?action=detail&id=${sv.id}"
                       class="btn btn-sm btn-outline-primary py-0 px-2 me-1"
                       title="Xem chi tiết">
                      <i class="bi bi-eye"></i>
                    </a>
                    <%-- Nút khóa / mở --%>
                    <button class="btn btn-sm py-0 px-2
                                   ${sv.active ? 'btn-outline-danger' : 'btn-outline-success'}"
                            title="${sv.active ? 'Khóa tài khoản' : 'Mở tài khoản'}"
                            onclick="confirmToggle(${sv.id}, '${sv.fullName}', ${sv.active})">
                      <i class="bi bi-${sv.active ? 'lock' : 'unlock'}"></i>
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

<%-- ══ MODAL XÁC NHẬN KHÓA / MỞ ══ --%>
<div class="modal fade" id="toggleModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h6 class="modal-title fw-bold" id="modal-title">Xác nhận</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body pt-0">
        <p id="modal-body-text" class="mb-0"></p>
      </div>
      <div class="modal-footer border-0 pt-0">
        <button class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
        <form id="toggleForm" method="POST"
              action="${pageContext.request.contextPath}/admin/students">
          <input type="hidden" name="action" value="toggle">
          <input type="hidden" name="id"     id="toggle-id">
          <button type="submit" class="btn btn-sm" id="toggle-submit-btn">Xác nhận</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
function confirmToggle(id, name, isActive) {
  document.getElementById('toggle-id').value = id;

  const isLock = isActive;
  document.getElementById('modal-title').textContent = isLock ? 'Khóa tài khoản' : 'Mở tài khoản';
  document.getElementById('modal-body-text').textContent =
    isLock
      ? 'Bạn muốn khóa tài khoản của học viên: ' + name + '? Họ sẽ không thể đăng nhập.'
      : 'Bạn muốn mở lại tài khoản cho học viên: ' + name + '?';

  const btn = document.getElementById('toggle-submit-btn');
  btn.textContent = isLock ? 'Khóa tài khoản' : 'Mở tài khoản';
  btn.className   = 'btn btn-sm ' + (isLock ? 'btn-danger' : 'btn-success');

  new bootstrap.Modal(document.getElementById('toggleModal')).show();
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
