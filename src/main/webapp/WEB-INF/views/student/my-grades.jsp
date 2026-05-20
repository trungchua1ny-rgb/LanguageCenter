<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="main-content">
  <div class="container-fluid py-4">

    <%-- ── PAGE HEADER ─────────────────────────────────── --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h4 class="fw-bold mb-1">
          <i class="bi bi-award text-warning me-2"></i>Điểm số của tôi
        </h4>
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb mb-0 small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Trang chủ</a></li>
            <li class="breadcrumb-item active">Điểm số</li>
          </ol>
        </nav>
      </div>
    </div>

    <%-- ── STATS CARDS ──────────────────────────────────── --%>
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="card border-0 shadow-sm text-center py-3">
          <div class="h3 fw-bold text-primary mb-0">${totalExams}</div>
          <div class="small text-muted">Bài kiểm tra</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card border-0 shadow-sm text-center py-3">
          <div class="h3 fw-bold
                       ${avgScore >= 80 ? 'text-success' : avgScore >= 65 ? 'text-primary' : avgScore >= 50 ? 'text-warning' : 'text-danger'}
                       mb-0">
            ${avgScore}%
          </div>
          <div class="small text-muted">Điểm trung bình</div>
        </div>
      </div>
      <c:if test="${not empty filterClassId}">
        <div class="col-12 col-md-6">
          <div class="alert alert-info mb-0 py-2 d-flex align-items-center">
            <i class="bi bi-funnel-fill me-2"></i>
            Đang lọc theo lớp #${filterClassId}.
            <a href="${pageContext.request.contextPath}/student/grades"
               class="ms-2 alert-link">Xem tất cả</a>
          </div>
        </div>
      </c:if>
    </div>

    <%-- ── BẢNG ĐIỂM ───────────────────────────────────── --%>
    <div class="card border-0 shadow-sm">
      <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
        <h6 class="fw-bold mb-0">
          <i class="bi bi-table me-2 text-warning"></i>Bảng điểm chi tiết
        </h6>
        <span class="badge bg-secondary rounded-pill">${totalExams} bài</span>
      </div>
      <div class="card-body p-0">
        <c:choose>
          <c:when test="${empty grades}">
            <div class="text-center py-5 text-muted">
              <i class="bi bi-inbox" style="font-size:3rem;"></i>
              <h5 class="mt-3">Chưa có điểm nào</h5>
              <p>Điểm sẽ hiển thị tại đây sau khi giáo viên nhập điểm cho các bài kiểm tra.</p>
              <a href="${pageContext.request.contextPath}/student/my-classes"
                 class="btn btn-outline-primary btn-sm mt-1">
                <i class="bi bi-collection me-1"></i>Xem lớp của tôi
              </a>
            </div>
          </c:when>

          <c:otherwise>
            <%-- Desktop table --%>
            <div class="table-responsive d-none d-md-block">
              <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                  <tr>
                    <th>#</th>
                    <th>Lớp học</th>
                    <th>Khóa học</th>
                    <th>Bài thi</th>
                    <th class="text-center">Điểm</th>
                    <th class="text-center" style="width:130px;">Tiến độ</th>
                    <th>Xếp loại</th>
                    <th>Ngày thi</th>
                    <th>Ghi chú</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="g" items="${grades}" varStatus="st">
                    <tr>
                      <td class="text-muted small">${st.count}</td>
                      <td>
                        <a href="${pageContext.request.contextPath}/student/grades?classId=${g.enrollmentId}"
                           class="fw-semibold text-decoration-none text-dark">
                          ${g.className}
                        </a>
                      </td>
                      <td class="text-muted small">${g.courseName}</td>
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
                                 style="width:${g.scorePercent}%"
                                 role="progressbar"
                                 aria-valuenow="${g.scorePercent}"
                                 aria-valuemin="0" aria-valuemax="100">
                            </div>
                          </div>
                          <span class="text-muted small" style="min-width:32px;">${g.scorePercent}%</span>
                        </div>
                      </td>
                      <td>
                        <span class="badge ${g.rankBadgeClass} rounded-pill">${g.rank}</span>
                      </td>
                      <td class="text-muted small">
                        ${g.formattedExamDate}
                      </td>
                      <td class="text-muted small">${g.note}</td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <%-- Mobile card list --%>
            <div class="d-md-none p-3">
              <c:forEach var="g" items="${grades}">
                <div class="card border mb-3">
                  <div class="card-body pb-2">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                      <div>
                        <div class="fw-bold">${g.examName}</div>
                        <div class="text-muted small">${g.className} &middot; ${g.courseName}</div>
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
                        <i class="bi bi-calendar3 me-1"></i>
                        ${g.formattedExamDate}
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
    </div>

    <%-- ── LEGEND XẾP LOẠI ─────────────────────────────── --%>
    <c:if test="${not empty grades}">
      <div class="card border-0 shadow-sm mt-4">
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

  </div><%-- end container --%>
</div><%-- end main-content --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>