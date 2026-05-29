<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
  /* ══ MY-GRADES PAGE ══ */

  /* Filter card */
  .lc-filter-card {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    padding: 20px 24px;
    margin-bottom: 24px;
  }
  .lc-filter-card label { font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
  .lc-filter-card .form-select {
    border: 1.5px solid #e5e7eb; border-radius: 6px;
    font-size: 13.5px; color: #374151;
    padding: 8px 12px;
  }
  .lc-filter-card .form-select:focus {
    border-color: #0056d2;
    box-shadow: 0 0 0 3px rgba(0,86,210,.10);
  }

  /* Score stat cards */
  .lc-score-stat {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    padding: 16px 20px;
    text-align: center;
    height: 100%;
  }
  .lc-score-stat .num {
    font-size: 28px; font-weight: 800; line-height: 1; margin-bottom: 4px;
  }
  .lc-score-stat .lbl { font-size: 12px; color: #9ca3af; font-weight: 500; }

  /* Grade table */
  .lc-grade-table {
    font-size: 14px;
    border-collapse: separate;
    border-spacing: 0;
    width: 100%;
  }
  .lc-grade-table thead th {
    background: #f9fafb;
    border-bottom: 2px solid #e5e7eb;
    padding: 10px 14px;
    font-size: 12px; font-weight: 700;
    text-transform: uppercase; letter-spacing: .5px;
    color: #6b7280;
    white-space: nowrap;
  }
  .lc-grade-table tbody tr {
    border-bottom: 1px solid #f3f4f6;
    transition: background .1s;
  }
  .lc-grade-table tbody tr:hover { background: #f9fafb; }
  .lc-grade-table tbody td { padding: 12px 14px; vertical-align: middle; }

  /* Score cell */
  .lc-score-cell { display: flex; align-items: baseline; gap: 2px; }
  .lc-score-main { font-size: 16px; font-weight: 800; color: #0056d2; }
  .lc-score-max  { font-size: 12px; color: #9ca3af; }

  /* Progress bar */
  .lc-grade-bar {
    display: flex; align-items: center; gap: 8px;
  }
  .lc-grade-bar-track {
    flex: 1; height: 7px; background: #f3f4f6; border-radius: 4px; overflow: hidden;
  }
  .lc-grade-bar-fill {
    height: 100%; border-radius: 4px;
    transition: width .6s ease;
  }
  .lc-grade-bar-pct { font-size: 12px; color: #6b7280; min-width: 36px; text-align: right; }

  /* Mobile grade card */
  .lc-grade-mob-card {
    background: #fff; border: 1px solid #e5e7eb;
    border-radius: 10px; padding: 14px 16px;
    margin-bottom: 10px;
  }
  .lc-grade-mob-card .top {
    display: flex; justify-content: space-between; align-items: flex-start;
    margin-bottom: 8px;
  }
  .lc-grade-mob-card .exam-name { font-size: 14px; font-weight: 700; color: #1f2937; }
  .lc-grade-mob-card .class-name { font-size: 12px; color: #6b7280; margin-top: 2px; }

  /* Legend */
  .lc-legend {
    display: flex; flex-wrap: wrap; gap: 12px 20px; align-items: center;
    padding: 14px 20px;
    background: #fff; border: 1px solid #e5e7eb; border-radius: 10px;
    margin-top: 16px;
  }
  .lc-legend-item { display: flex; align-items: center; gap: 6px; font-size: 12.5px; color: #6b7280; }

  /* Empty */
  .lc-empty { text-align: center; padding: 48px 20px; color: #9ca3af; }
  .lc-empty i { font-size: 44px; margin-bottom: 10px; display: block; }
</style>

<div class="pagetitle">
  <h1>Điểm số của tôi</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item">
        <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      </li>
      <li class="breadcrumb-item active">Điểm số</li>
    </ol>
  </nav>
</div>

<section class="section">

  <%-- ══ FILTER ══ --%>
  <div class="lc-filter-card">
    <form method="get" action="${pageContext.request.contextPath}/student/grades">
      <div class="row g-3 align-items-end">
        <div class="col-md-5">
          <label>Xem điểm theo lớp</label>
          <select name="classId" class="form-select" onchange="this.form.submit()">
            <option value="">-- Tất cả lớp của tôi --</option>
            <c:forEach var="cl" items="${myEnrolledClasses}">
              <option value="${cl[0]}" ${cl[0] == filterClassId ? 'selected' : ''}>
                ${cl[1]} — ${cl[2]}
              </option>
            </c:forEach>
          </select>
          <div class="form-text" style="font-size:12px;">Chọn lớp để lọc điểm riêng.</div>
        </div>
        <div class="col-auto">
          <c:if test="${not empty filterClassId}">
            <a href="${pageContext.request.contextPath}/student/grades"
               style="display:inline-flex;align-items:center;gap:5px;background:#f3f4f6;
                      color:#374151;border:1px solid #e5e7eb;border-radius:6px;
                      padding:8px 14px;font-size:13px;text-decoration:none;">
              <i class="bi bi-x-circle"></i>Xóa lọc
            </a>
          </c:if>
        </div>
      </div>
    </form>
  </div>

  <%-- ══ STATS ══ --%>
  <c:if test="${not empty grades}">
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="lc-score-stat">
          <div class="num text-primary">${totalExams}</div>
          <div class="lbl">Bài kiểm tra</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="lc-score-stat">
          <div class="num
            ${avgScore >= 80 ? 'text-success' :
              avgScore >= 65 ? 'text-primary' :
              avgScore >= 50 ? 'text-warning' : 'text-danger'}">
            ${avgScore}%
          </div>
          <div class="lbl">Điểm trung bình</div>
        </div>
      </div>
      <c:if test="${not empty filterClassId}">
        <div class="col-12 col-md-6 d-flex align-items-center">
          <div class="alert alert-info py-2 mb-0 w-100" style="font-size:13px; border-radius:8px;">
            <i class="bi bi-funnel-fill me-1"></i>
            Đang xem điểm lớp: <strong>${filterClassName}</strong>
          </div>
        </div>
      </c:if>
    </div>
  </c:if>

  <%-- ══ BẢNG ĐIỂM ══ --%>
  <div class="card" style="border-radius:10px; border:1px solid #e5e7eb; box-shadow:none; overflow:hidden;">
    <div class="card-body" style="padding:0;">

      <%-- Header --%>
      <div style="padding:16px 20px; border-bottom:1px solid #f3f4f6;
                  display:flex; align-items:center; justify-content:space-between;">
        <div style="font-size:15px; font-weight:700; color:#1f2937;">Bảng điểm chi tiết</div>
        <span class="badge bg-secondary rounded-pill">${totalExams} bài</span>
      </div>

      <c:choose>
        <c:when test="${empty grades}">
          <div class="lc-empty">
            <i class="bi bi-inbox"></i>
            <c:choose>
              <c:when test="${not empty filterClassId}">
                <p>Lớp này chưa có điểm nào. Giáo viên sẽ nhập sau mỗi bài kiểm tra.</p>
              </c:when>
              <c:otherwise>
                <p>Chọn lớp học ở trên hoặc chờ giáo viên nhập điểm.</p>
              </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/student/my-classes"
               style="background:#0056d2;color:#fff;border-radius:6px;padding:9px 18px;
                      font-size:13px;font-weight:600;text-decoration:none;
                      display:inline-flex;align-items:center;gap:5px;">
              <i class="bi bi-collection"></i>Xem lớp của tôi
            </a>
          </div>
        </c:when>

        <c:otherwise>
          <%-- Desktop table --%>
          <div class="table-responsive d-none d-md-block">
            <table class="lc-grade-table">
              <thead>
                <tr>
                  <th>#</th>
                  <c:if test="${empty filterClassId}">
                    <th>Lớp học</th>
                    <th>Khóa học</th>
                  </c:if>
                  <th>Bài thi</th>
                  <th class="text-center">Điểm</th>
                  <th style="min-width:160px;">Tiến độ</th>
                  <th>Xếp loại</th>
                  <th>Ngày thi</th>
                  <th>Ghi chú</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="g" items="${grades}" varStatus="st">
                  <tr>
                    <td style="color:#9ca3af; font-size:13px;">${st.count}</td>

                    <c:if test="${empty filterClassId}">
                      <td>
                        <a href="${pageContext.request.contextPath}/student/grades?classId=${g.enrollmentId}"
                           style="font-weight:600; text-decoration:none; color:#1f2937;">
                          ${g.className}
                        </a>
                      </td>
                      <td style="font-size:13px; color:#6b7280;">${g.courseName}</td>
                    </c:if>

                    <td style="font-weight:500;">${g.examName}</td>

                    <td class="text-center">
                      <div class="lc-score-cell justify-content-center">
                        <span class="lc-score-main">
                          <fmt:formatNumber value="${g.score}" maxFractionDigits="1"/>
                        </span>
                        <span class="lc-score-max">
                          /<fmt:formatNumber value="${g.maxScore}" maxFractionDigits="1"/>
                        </span>
                      </div>
                    </td>

                    <td>
                      <div class="lc-grade-bar">
                        <div class="lc-grade-bar-track">
                          <div class="lc-grade-bar-fill ${g.rankBadgeClass}"
                               style="width:${g.scorePercent}%"></div>
                        </div>
                        <span class="lc-grade-bar-pct">${g.scorePercent}%</span>
                      </div>
                    </td>

                    <td>
                      <span class="badge ${g.rankBadgeClass} rounded-pill">${g.rank}</span>
                    </td>
                    <td style="font-size:13px; color:#6b7280;">${g.formattedExamDate}</td>
                    <td style="font-size:13px; color:#9ca3af;">${g.note}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <%-- Mobile cards --%>
          <div class="d-md-none" style="padding:12px;">
            <c:forEach var="g" items="${grades}">
              <div class="lc-grade-mob-card">
                <div class="top">
                  <div>
                    <div class="exam-name">${g.examName}</div>
                    <div class="class-name">${g.className} · ${g.courseName}</div>
                  </div>
                  <span class="badge ${g.rankBadgeClass} rounded-pill ms-2">${g.rank}</span>
                </div>

                <div style="display:flex; align-items:center; gap:10px; margin-bottom:6px;">
                  <div class="lc-score-cell">
                    <span class="lc-score-main">
                      <fmt:formatNumber value="${g.score}" maxFractionDigits="1"/>
                    </span>
                    <span class="lc-score-max">
                      /<fmt:formatNumber value="${g.maxScore}" maxFractionDigits="1"/>
                    </span>
                  </div>
                  <div class="lc-grade-bar" style="flex:1;">
                    <div class="lc-grade-bar-track">
                      <div class="lc-grade-bar-fill ${g.rankBadgeClass}"
                           style="width:${g.scorePercent}%"></div>
                    </div>
                    <span class="lc-grade-bar-pct">${g.scorePercent}%</span>
                  </div>
                </div>

                <c:if test="${not empty g.formattedExamDate}">
                  <div style="font-size:12px; color:#9ca3af;">
                    <i class="bi bi-calendar3 me-1"></i>${g.formattedExamDate}
                  </div>
                </c:if>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </div><!-- End grade card -->

  <%-- ══ LEGEND ══ --%>
  <c:if test="${not empty grades}">
    <div class="lc-legend">
      <span style="font-size:12px; font-weight:700; color:#374151;">Xếp loại:</span>
      <span class="lc-legend-item"><span class="badge bg-success rounded-pill">Xuất sắc</span> ≥ 90%</span>
      <span class="lc-legend-item"><span class="badge bg-primary rounded-pill">Giỏi</span> 80–89%</span>
      <span class="lc-legend-item"><span class="badge bg-info text-dark rounded-pill">Khá</span> 65–79%</span>
      <span class="lc-legend-item"><span class="badge bg-warning text-dark rounded-pill">Trung bình</span> 50–64%</span>
      <span class="lc-legend-item"><span class="badge bg-danger rounded-pill">Yếu</span> &lt; 50%</span>
    </div>
  </c:if>

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
