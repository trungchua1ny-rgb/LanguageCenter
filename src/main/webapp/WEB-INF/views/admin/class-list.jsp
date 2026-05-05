<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="container-fluid py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="fw-bold mb-1">Quản lý lớp học</h5>
    <a href="${pageContext.request.contextPath}/admin/classes?action=add"
       class="btn btn-primary">
      <i class="bi bi-plus-lg"></i> Thêm lớp
    </a>
  </div>

  <c:if test="${param.insert_success == 1}">
    <div class="alert alert-success alert-dismissible fade show">
      ✅ Thêm lớp thành công!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.update_success == 1}">
    <div class="alert alert-success alert-dismissible fade show">
      ✅ Cập nhật thành công!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.delete_success == 1}">
    <div class="alert alert-success alert-dismissible fade show">
      ✅ Xóa lớp thành công!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.delete_failed == 1}">
    <div class="alert alert-danger alert-dismissible fade show">
      ❌ Không thể xóa — lớp này còn học viên đăng ký!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <%-- Filter buttons --%>
  <div class="mb-3 d-flex gap-2 flex-wrap">
    <a href="${pageContext.request.contextPath}/admin/classes"
       class="btn btn-sm ${empty filterStatus ? 'btn-secondary' : 'btn-outline-secondary'}">
      Tất cả
    </a>
    <a href="${pageContext.request.contextPath}/admin/classes?status=upcoming"
       class="btn btn-sm ${filterStatus == 'upcoming' ? 'btn-info' : 'btn-outline-info'}">
      Sắp khai giảng
    </a>
    <a href="${pageContext.request.contextPath}/admin/classes?status=ongoing"
       class="btn btn-sm ${filterStatus == 'ongoing' ? 'btn-success' : 'btn-outline-success'}">
      Đang học
    </a>
    <a href="${pageContext.request.contextPath}/admin/classes?status=finished"
       class="btn btn-sm ${filterStatus == 'finished' ? 'btn-secondary' : 'btn-outline-secondary'}">
      Đã kết thúc
    </a>
    <a href="${pageContext.request.contextPath}/admin/classes?status=cancelled"
       class="btn btn-sm ${filterStatus == 'cancelled' ? 'btn-danger' : 'btn-outline-danger'}">
      Đã hủy
    </a>
  </div>

  <div class="card shadow-sm">
    <div class="table-responsive">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>#</th>
            <th>Tên lớp</th>
            <th>Khóa học</th>
            <th>Giáo viên</th>
            <th>Khai giảng</th>
            <th>Kết thúc</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="cl" items="${classes}" varStatus="st">
            <tr>
              <td>${st.index + 1}</td>
              <td><strong>${cl.className}</strong></td>
              <td>${cl.courseName}</td>
              <td>${cl.teacherName}</td>
              <td>${cl.startDate}</td>
              <td>${cl.endDate}</td>
              <td>
                <span class="badge rounded-pill
                  ${cl.status == 'ongoing'   ? 'bg-success'  :
                    cl.status == 'upcoming'  ? 'bg-info text-dark' :
                    cl.status == 'finished'  ? 'bg-secondary' : 'bg-danger'}">
                  ${cl.status == 'ongoing'   ? 'Đang học' :
                    cl.status == 'upcoming'  ? 'Sắp khai giảng' :
                    cl.status == 'finished'  ? 'Đã kết thúc' : 'Đã hủy'}
                </span>
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/classes?action=edit&id=${cl.id}"
                   class="btn btn-sm btn-outline-primary me-1">
                  <i class="bi bi-pencil"></i>
                </a>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/classes"
                      class="d-inline"
                      onsubmit="return confirm('Xóa lớp «${cl.className}»?')">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id" value="${cl.id}">
                  <button type="submit" class="btn btn-sm btn-outline-danger">
                    <i class="bi bi-trash"></i>
                  </button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty classes}">
            <tr>
              <td colspan="8" class="text-center text-muted py-5">
                <i class="bi bi-inbox fs-2"></i>
                <p class="mt-2 mb-0">Không có lớp học nào.</p>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>