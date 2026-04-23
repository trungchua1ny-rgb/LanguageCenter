<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<%-- ══ HEADER TRANG ══ --%>
<div class="d-flex align-items-center gap-2 mb-4">
  <a href="${pageContext.request.contextPath}/admin/students"
     class="btn btn-sm btn-outline-secondary">
    <i class="bi bi-arrow-left"></i>
  </a>
  <h5 class="fw-bold mb-0">Chi tiết học viên</h5>
</div>

<div class="row g-3">

  <%-- ══ CỘT TRÁI — thông tin cá nhân ══ --%>
  <div class="col-12 col-md-4">
    <div class="card border-0 shadow-sm h-100">
      <div class="card-body text-center pt-4">

        <%-- Avatar chữ cái đầu --%>
        <div style="width:64px;height:64px;border-radius:50%;
                    background:#e8f0fe;color:#1a73e8;
                    display:flex;align-items:center;justify-content:center;
                    font-size:24px;font-weight:600;margin:0 auto 12px">
          ${student.fullName.substring(0,1).toUpperCase()}
        </div>

        <div class="fw-bold fs-5">${student.fullName}</div>
        <div class="text-muted mb-3" style="font-size:13px">@${student.username}</div>

        <%-- Badge trạng thái --%>
        <c:choose>
          <c:when test="${student.active}">
            <span class="badge bg-success mb-3">Hoạt động</span>
          </c:when>
          <c:otherwise>
            <span class="badge bg-danger mb-3">Đã khóa</span>
          </c:otherwise>
        </c:choose>

        <hr class="my-3">

        <%-- Thông tin liên hệ --%>
        <div class="text-start" style="font-size:13px">
          <div class="mb-2">
            <span class="text-muted">Email</span><br>
            <span>${student.email}</span>
          </div>
          <div class="mb-2">
            <span class="text-muted">Số điện thoại</span><br>
            <c:choose>
              <c:when test="${not empty student.phone}">${student.phone}</c:when>
              <c:otherwise><span class="text-muted">Chưa cập nhật</span></c:otherwise>
            </c:choose>
          </div>
          <div>
            <span class="text-muted">Ngày tạo tài khoản</span><br>
            <fmt:formatDate value="${student.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
          </div>
        </div>

        <hr class="my-3">

        <%-- Nút khóa / mở tài khoản --%>
        <form method="POST"
              action="${pageContext.request.contextPath}/admin/students"
              onsubmit="return confirm('${student.active ? 'Khóa tài khoản học viên này?' : 'Mở lại tài khoản học viên này?'}')">
          <input type="hidden" name="action" value="toggle">
          <input type="hidden" name="id"     value="${student.id}">
          <button type="submit"
                  class="btn btn-sm w-100 ${student.active ? 'btn-outline-danger' : 'btn-outline-success'}">
            <i class="bi bi-${student.active ? 'lock' : 'unlock'} me-1"></i>
            ${student.active ? 'Khóa tài khoản' : 'Mở tài khoản'}
          </button>
        </form>

      </div>
    </div>
  </div>

  <%-- ══ CỘT PHẢI — danh sách lớp học ══ --%>
  <div class="col-12 col-md-8">
    <div class="card border-0 shadow-sm">
      <div class="card-header bg-white border-bottom py-3">
        <h6 class="fw-bold mb-0">
          <i class="bi bi-journal-bookmark me-2"></i>
          Lớp học đã đăng ký
          <span class="badge bg-primary rounded-pill ms-1"
                style="font-size:11px">${enrollments.size()}</span>
        </h6>
      </div>
      <div class="card-body p-0">
        <c:choose>
          <c:when test="${empty enrollments}">
            <div class="text-center py-4 text-muted">
              <i class="bi bi-inbox fs-2 d-block mb-1"></i>
              Học viên chưa đăng ký lớp nào.
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-responsive">
              <table class="table table-hover align-middle mb-0" style="font-size:13px">
                <thead class="table-light">
                  <tr>
                    <th>Tên lớp</th>
                    <th>Khóa học</th>
                    <th>Ngày đăng ký</th>
                    <th>Trạng thái lớp</th>
                    <th>Thanh toán</th>
                  </tr>
                </thead>
                <tbody>
                  <%-- enrollments là List<String[]>:
                       [0]=class_name [1]=course_name
                       [2]=payment_status [3]=class_status [4]=enrolled_date --%>
                  <c:forEach var="en" items="${enrollments}">
                    <tr>
                      <td class="fw-semibold">${en[0]}</td>
                      <td>${en[1]}</td>
                      <td>${en[4]}</td>
                      <td>
                        <c:choose>
                          <c:when test="${en[3] == 'ongoing'}">
                            <span class="badge bg-success">Đang học</span>
                          </c:when>
                          <c:when test="${en[3] == 'upcoming'}">
                            <span class="badge bg-primary">Sắp khai giảng</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary">Đã kết thúc</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${en[2] == 'paid'}">
                            <span class="badge bg-success">Đã thanh toán</span>
                          </c:when>
                          <c:when test="${en[2] == 'pending'}">
                            <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary">${en[2]}</span>
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
    </div>
  </div>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
