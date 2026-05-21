<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Điểm số của tôi</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Điểm số</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">

  <%-- ══ BƯỚC 1: CHỌN LỚP ══ --%>
  <div class="card mb-4">
    <div class="card-body">
      <h5 class="card-title">Chọn lớp học</h5>
      <form method="get" action="${pageContext.request.contextPath}/student/grades"
            class="row g-3 align-items-end">
        <div class="col-md-6">
          <label class="form-label fw-semibold">Xem điểm theo lớp</label>
          <select name="classId" class="form-select" onchange="this.form.submit()">
            <option value="">-- Tất cả lớp của tôi --</option>
            <c:forEach var="cl" items="${myEnrolledClasses}">
              <option value="${cl[0]}"
                      ${cl[0] == filterClassId ? 'selected' : ''}>
                ${cl[1]} — ${cl[2]}
              </option>
            </c:forEach>
          </select>
          <div class="form-text">Chọn lớp để xem điểm riêng từng lớp.</div>
        </div>
        <div class="col-md-2">
          <c:if test="${not empty filterClassId}">
            <a href="${pageContext.request.contextPath}/student/grades"
               class="btn btn-outline-secondary w-100">
              <i class="bi bi-x-circle me-1"></i>Xem tất cả
            </a>
          </c:if>
        </div>
      </form>
    </div>
  </div>

  <%-- ══ STATS CARDS — chỉ hiện khi có dữ liệu ══ --%>
  <c:if test="${not empty grades}">
    <div class="row g-3 mb-3">
      <div class="col-6 col-md-3">
        <div class="card text-center">
          <div class="card-body py-3">
            <div class="h3 fw-bold text-primary mb-0">${totalExams}</div>
            <div class="small text-muted">Bài kiểm tra</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card text-center">
          <div class="card-body py-3">
            <div class="h3 fw-bold mb-0
                         ${avgScore >= 80 ? 'text-success' :
                           avgScore >= 65 ? 'text-primary' :
                           avgScore >= 50 ? 'text-warning' : 'text-danger'}">
              ${avgScore}%
            </div>
            <div class="small text-muted">Điểm trung bình</div>
          </div>
        </div>
      </div>
      <c:if test="${not empty filterClassId}">
        <div class="col-12 col-md-6 d-flex align-items-center">
          <div class="alert alert-info mb-0 py-2 w-100" style="font-size:13px">
            <i class="bi bi-funnel-fill me-1"></i>
            Đang xem điểm lớp: <strong>${filterClassName}</strong>
          </div>
        </div>
      </c:if>
    </div>
  </c:if>

  <%-- ══ BẢNG ĐIỂM ══ --%>
  <div class="card">
    <div class="card-body">
      <div class="d-flex justify-content-between align-items-center pt-3 mb-3">
        <h5 class="card-title mb-0">Bảng điểm chi tiết</h5>
        <span class="badge bg-secondary rounded-pill">${totalExams} bài</span>
      </div>

      <c:choose>
        <c:when test="${empty grades}">
          <div class="text-center py-5 text-muted">
            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
            <c:choose>
              <c:when test="${not empty filterClassId}">
                <p>Lớp này chưa có điểm nào. Giáo viên sẽ nhập điểm sau mỗi bài kiểm tra.</p>
              </c:when>
              <c:otherwise>
                <p>Chọn lớp học ở trên để xem điểm, hoặc chờ giáo viên nhập điểm.</p>
              </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/student/my-classes"
               class="btn btn-outline-primary btn-sm">
              <i class="bi bi-collection me-1"></i>Xem lớp của tôi
            </a>
          </div>
        </c:when>
        <c:otherwise>

          <%-- Desktop table --%>
          <div class="table-responsive d-none d-md-block">
            <table class="table table-hover align-middle" style="font-size:14px">
              <thead class="table-light">
                <tr>
                  <th>#</th>
                  <c:if test="${empty filterClassId}"><th>Lớp học</th><th>Khóa học</th></c:if>
                  <th>Bài thi</th>
                  <th class="text-center">Điểm</th>
                  <th class="text-center" style="width:140px">Tiến độ</th>
                  <th>Xếp loại</th>
                  <th>Ngày thi</th>
                  <th>Ghi chú</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="g" items="${grades}" varStatus="st">
                  <tr>
                    <td class="text-muted">${st.count}</td>
                    <c:if test="${empty filterClassId}">
                      <td>
                        <a href="${pageContext.request.contextPath}/student/grades?classId=${g.enrollmentId}"
                           class="fw-semibold text-decoration-none text-dark">
                          ${g.className}
                        </a>
                      </td>
                      <td class="text-muted small">${g.courseName}</td>
                    </c:if>
                    <td>${g.examName}</td>
                    <td class="text-center">
                      <span class="fw-bold text-primary fs-6">
                        <fmt:formatNumber value="${g.score}" maxFractionDigits="1"/>
                      </span>
                      <span class="text-muted small">
                        / <fmt:formatNumber value="${g.maxScore}" maxFractionDigits="1"/>
                      </span>
                    </td>
                    <td>
                      <div class="d-flex align-items-center gap-2">
                        <div class="progress flex-grow-1" style="height:8px;">
                          <div class="progress-bar ${g.rankBadgeClass}"
                               style="width:${g.scorePercent}%"></div>
                        </div>
                        <span class="text-muted small" style="min-width:36px">${g.scorePercent}%</span>
                      </div>
                    </td>
                    <td>
                      <span class="badge ${g.rankBadgeClass} rounded-pill">${g.rank}</span>
                    </td>
                    <td class="text-muted small">${g.formattedExamDate}</td>
                    <td class="text-muted small">${g.note}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <%-- Mobile card list --%>
          <div class="d-md-none">
            <c:forEach var="g" items="${grades}">
              <div class="card border mb-3">
                <div class="card-body pb-2">
                  <div class="d-flex justify-content-between align-items-start mb-2">
                    <div>
                      <div class="fw-bold">${g.examName}</div>
                      <div class="text-muted small">${g.className} · ${g.courseName}</div>
                    </div>
                    <span class="badge ${g.rankBadgeClass} rounded-pill ms-2">${g.rank}</span>
                  </div>
                  <div class="d-flex align-items-center gap-3 mb-2">
                    <div>
                      <span class="h5 fw-bold text-primary mb-0">
                        <fmt:formatNumber value="${g.score}" maxFractionDigits="1"/>
                      </span>
                      <span class="text-muted small">
                        / <fmt:formatNumber value="${g.maxScore}" maxFractionDigits="1"/>
                      </span>
                    </div>
                    <div class="progress flex-grow-1" style="height:8px;">
                      <div class="progress-bar ${g.rankBadgeClass}"
                           style="width:${g.scorePercent}%"></div>
                    </div>
                    <span class="text-muted small">${g.scorePercent}%</span>
                  </div>
                  <c:if test="${not empty g.formattedExamDate}">
                    <div class="text-muted small">
                      <i class="bi bi-calendar3 me-1"></i>${g.formattedExamDate}
                    </div>
                  </c:if>
                  <c:if test="${not empty g.note}">
                    <div class="text-muted small mt-1">
                      <i class="bi bi-chat-left-text me-1"></i>${g.note}
                    </div>
                  </c:if>
                </div>
              </div>
            </c:forEach>
          </div>

        </c:otherwise>
      </c:choose>

    </div>
  </div><!-- End Card -->

  <%-- ══ LEGEND XẾP LOẠI ══ --%>
  <c:if test="${not empty grades}">
    <div class="card mt-3">
      <div class="card-body py-3">
        <div class="d-flex flex-wrap gap-3 align-items-center">
          <span class="text-muted small fw-semibold">Xếp loại:</span>
          <span><span class="badge bg-success rounded-pill">Xuất sắc</span> <small class="text-muted ms-1">≥ 90%</small></span>
          <span><span class="badge bg-primary rounded-pill">Giỏi</span> <small class="text-muted ms-1">80–89%</small></span>
          <span><span class="badge bg-info text-dark rounded-pill">Khá</span> <small class="text-muted ms-1">65–79%</small></span>
          <span><span class="badge bg-warning text-dark rounded-pill">Trung bình</span> <small class="text-muted ms-1">50–64%</small></span>
          <span><span class="badge bg-danger rounded-pill">Yếu</span> <small class="text-muted ms-1">< 50%</small></span>
        </div>
      </div>
    </div>
  </c:if>

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
