<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold mb-0">📚 Khóa học đang mở</h5>
    </div>

    <div class="row g-3">
        <c:forEach var="cls" items="${availableClasses}">
            <div class="col-12 col-md-6 col-xl-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-start">
                        <div class="fw-bold text-primary">${cls.courseName}</div>
                        <span class="badge ${cls.classStatus == 'ongoing' ? 'bg-success' : 'bg-primary'}">
                            ${cls.classStatus == 'ongoing' ? 'Đang học' : 'Sắp học'}
                        </span>
                    </div>

                    <div class="card-body small">
                        <div class="mb-1"><i class="bi bi-door-open me-2"></i>${cls.className}</div>
                        <div class="text-muted mb-2"><i class="bi bi-calendar3 me-2"></i>${cls.scheduleInfo}</div>
                        
                        <div class="mt-2">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Sĩ số</span>
                                <%-- FIX: Xóa dấu ngoặc () để tránh lỗi MethodNotFound [cite: 20-24] --%>
                                <span class="fw-bold ${cls.available ? 'text-success' : 'text-danger'}">
                                    ${cls.currentStudents}/${cls.maxStudents}
                                </span>
                            </div>
                            <div class="progress" style="height:6px">
                                <div class="progress-bar ${cls.remainingSlots <= 3 ? 'bg-danger' : 'bg-success'}" 
                                     style="width: ${(cls.currentStudents/cls.maxStudents)*100}%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer bg-white border-top d-flex justify-content-between align-items-center py-3">
                        <div class="fw-bold text-primary"><fmt:formatNumber value="${cls.tuitionFee}" type="number"/> đ</div>
                        
                        <c:choose>
                            <c:when test="${cls.note == 'enrolled'}">
                                <button class="btn btn-sm btn-success disabled">Đã đăng ký</button>
                            </c:when>
                            <c:when test="${!cls.available}">
                                <button class="btn btn-sm btn-secondary disabled">Hết chỗ</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-sm btn-primary" 
                                        onclick="confirmEnroll(${cls.classId}, '${cls.courseName}', '${cls.className}')">
                                    Đăng ký
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%-- Modal xác nhận (Bắt buộc phải có ID là confirmModal) [cite: 20-24] --%>
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold">Xác nhận đăng ký</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/student/courses" method="POST">
          <div class="modal-body">
            <p class="mb-1 small">Bạn chọn đăng ký khóa học:</p>
            <div id="modal-course-name" class="fw-bold text-primary"></div>
            <div id="modal-class-name" class="text-muted small"></div>
            <input type="hidden" name="action" value="enroll">
            <input type="hidden" name="classId" id="modal-class-id">
          </div>
          <div class="modal-footer border-0 pt-0">
            <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary btn-sm px-4">Xác nhận</button>
          </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<%-- Script điều khiển Modal (Phải nằm sau Footer để nhận thư viện Bootstrap)  --%>
<script>
function confirmEnroll(id, course, cls) {
    document.getElementById('modal-class-id').value = id;
    document.getElementById('modal-course-name').innerText = course;
    document.getElementById('modal-class-name').innerText = 'Lớp: ' + cls;
    
    // Sử dụng bộ khởi tạo của Bootstrap 5
    var myModal = new bootstrap.Modal(document.getElementById('confirmModal'));
    myModal.show();
}
</script>