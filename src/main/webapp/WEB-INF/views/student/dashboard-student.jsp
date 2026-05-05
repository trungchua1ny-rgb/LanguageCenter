<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="container-fluid py-4">
  <h4 class="mb-4">
    Xin chào, <strong>${sessionScope.loggedUser.fullName}</strong>! 👋
  </h4>

  <%-- Lớp đang học --%>
  <div class="card shadow-sm">
    <div class="card-header fw-semibold">Lớp của tôi</div>
    <div class="card-body">
      <c:choose>
        <c:when test="${empty myClasses}">
          <p class="text-muted mb-0">Bạn chưa đăng ký lớp nào.
            <a href="${pageContext.request.contextPath}/student/courses">Xem khóa học</a>
          </p>
        </c:when>
        <c:otherwise>
          <ul class="list-group list-group-flush">
            <c:forEach var="e" items="${myClasses}">
              <li class="list-group-item d-flex justify-content-between">
                <span>${e.className} — ${e.courseName}</span>
                <span class="badge bg-secondary">${e.paymentStatus}</span>
              </li>
            </c:forEach>
          </ul>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>