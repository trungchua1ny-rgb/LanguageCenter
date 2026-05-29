<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Quản lý Lớp học</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Lớp học</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">
  <div class="row">
    <div class="col-lg-12">

      <div class="card">
        <div class="card-body">

          <%-- ══ TIÊU ĐỀ + NÚT THÊM ══ --%>
          <div class="d-flex justify-content-between align-items-center pt-3 mb-3">
            <h5 class="card-title mb-0">Danh sách lớp học</h5>
            <a href="${pageContext.request.contextPath}/admin/classes?action=add"
               class="btn btn-primary btn-sm">
              <i class="bi bi-plus-lg me-1"></i>Thêm lớp
            </a>
          </div>

          <%-- ══ THÔNG BÁO ══ --%>
          <c:if test="${param.insert_success == 1}">
            <div class="alert alert-success alert-dismissible fade show">
              <i class="bi bi-check-circle me-1"></i>Thêm lớp thành công!
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>
          <c:if test="${param.update_success == 1}">
            <div class="alert alert-success alert-dismissible fade show">
              <i class="bi bi-check-circle me-1"></i>Cập nhật thành công!
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>
          <c:if test="${param.delete_success == 1}">
            <div class="alert alert-success alert-dismissible fade show">
              <i class="bi bi-check-circle me-1"></i>Xóa lớp thành công!
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>
          <c:if test="${param.delete_failed == 1}">
            <div class="alert alert-danger alert-dismissible fade show">
              <i class="bi bi-exclamation-circle me-1"></i>Không thể xóa — lớp này còn học viên đăng ký!
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <%-- ══ BỘ LỌC TRẠNG THÁI ══ --%>
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

          <%-- ══ BẢNG ══ --%>
          <div class="table-responsive">
            <table class="table table-hover align-middle" style="font-size:14px">
              <thead class="table-light">
                <tr>
                  <th style="width:40px">#</th>
                  <th>Tên lớp</th>
                  <th>Khóa học</th>
                  <th>Giáo viên</th>
                  <th>Khai giảng</th>
                  <th>Kết thúc</th>
                  <th>Trạng thái</th>
                  <th style="width:100px">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty classes}">
                    <tr>
                      <td colspan="8" class="text-center text-muted py-5">
                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                        Không có lớp học nào.
                      </td>
                    </tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="cl" items="${classes}" varStatus="st">
                      <tr>
                        <td class="text-muted">${st.count}</td>
                        <td><strong>${cl.className}</strong></td>
                        <td>${cl.courseName}</td>
                        <td>${cl.teacherName}</td>
                        <td style="font-size:13px">${cl.startDate}</td>
                        <td style="font-size:13px">${cl.endDate}</td>
                        <td>
                          <span class="badge rounded-pill
                            ${cl.status == 'ongoing'  ? 'bg-success'  :
                              cl.status == 'upcoming' ? 'bg-info text-dark' :
                              cl.status == 'finished' ? 'bg-secondary' : 'bg-danger'}">
                            ${cl.status == 'ongoing'  ? 'Đang học' :
                              cl.status == 'upcoming' ? 'Sắp khai giảng' :
                              cl.status == 'finished' ? 'Đã kết thúc' : 'Đã hủy'}
                          </span>
                        </td>
                        <td>
                          <a href="${pageContext.request.contextPath}/admin/classes?action=edit&id=${cl.id}"
                             class="btn btn-sm btn-outline-primary py-0 px-2 me-1" title="Sửa">
                            <i class="bi bi-pencil"></i>
                          </a>
                          <form method="post"
                                action="${pageContext.request.contextPath}/admin/classes"
                                class="d-inline"
                                onsubmit="return confirm('Xóa lớp «${cl.className}»?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${cl.id}">
                            <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2" title="Xóa">
                              <i class="bi bi-trash"></i>
                            </button>
                          </form>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

        </div>
      </div><!-- End Card -->

    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
