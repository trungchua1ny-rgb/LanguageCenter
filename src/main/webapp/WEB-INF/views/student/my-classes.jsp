<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
  /* ── Page bar ── */
  .lc-page-bar {
    display:flex; align-items:center; justify-content:space-between;
    flex-wrap:wrap; gap:10px; margin-bottom:16px;
  }
  .lc-page-title { font-size:20px; font-weight:800; color:var(--text-main); }
  .lc-page-info  { font-size:13px; color:var(--text-muted); }
  .lc-page-info strong { color:var(--text-main); }

  /* ── Add btn ── */
  .lc-btn-add {
    background:var(--primary); color:#fff; border:none;
    border-radius:7px; padding:8px 16px; font-size:13px; font-weight:600;
    text-decoration:none; display:inline-flex; align-items:center; gap:6px;
    font-family:var(--font); transition:background .15s;
  }
  .lc-btn-add:hover { background:var(--primary-dark); color:#fff; }

  /* ── Section heading ── */
  .lc-sec-head {
    font-size:14px; font-weight:700; color:var(--text-main);
    margin:18px 0 10px; padding-bottom:7px;
    border-bottom:2px solid var(--primary-mid);
  }

  /* ── Grid: 4 cols ── */
  .lc-class-grid {
    display:grid;
    grid-template-columns:repeat(auto-fill, minmax(315px, 1fr));
    gap:12px;
  }

  /* ── Card ── */
  .lc-class-card {
    background:#fff;
    border:1.5px solid var(--border);
    border-radius:10px;
    overflow:hidden;
    display:flex; flex-direction:column;
    transition:box-shadow .2s, transform .15s;
  }
  .lc-class-card:hover {
    box-shadow:0 6px 20px rgba(30,136,229,.13);
    transform:translateY(-3px);
  }
  .lc-class-card.status-ongoing  { border-left:3px solid #22c55e; }
  .lc-class-card.status-upcoming { border-left:3px solid var(--primary); }
  .lc-class-card.status-finished { border-left:3px solid #9ca3af; }

  /* ── Thumbnail (compact 16/9 → ~118px) ── */
  .lc-class-thumb {
    width:100%; aspect-ratio:21/9;
    overflow:hidden; flex-shrink:0; position:relative;
    background:#f3f4f6;
  }
  .lc-class-thumb img {
    width:100%; height:100%; object-fit:cover;
    transition:transform .35s ease;
  }
  .lc-class-card:hover .lc-class-thumb img { transform:scale(1.05); }

  /* Status pill trên ảnh */
  .lc-class-pill {
    position:absolute; top:7px; right:7px;
    font-size:10px; font-weight:700;
    padding:2px 8px; border-radius:20px;
  }

  /* ── Body ── */
  .lc-class-body {
    padding:10px 12px;
    display:flex; flex-direction:column; gap:4px; flex:1;
  }
  .lc-class-name {
    font-size:13px; font-weight:700; color:var(--text-main);
    line-height:1.3;
    display:-webkit-box; -webkit-line-clamp:2;
    -webkit-box-orient:vertical; overflow:hidden;
  }
  .lc-level-badge {
    display:inline-block;
    background:var(--primary-light); color:var(--primary);
    font-size:10px; font-weight:600;
    padding:2px 8px; border-radius:20px; width:fit-content;
  }
  .lc-class-meta {
    font-size:11px; color:var(--text-muted);
    display:flex; align-items:flex-start; gap:5px; line-height:1.35;
  }
  .lc-class-meta i { flex-shrink:0; margin-top:1px; font-size:11px; }

  /* ── Footer ── */
  .lc-class-footer {
    padding:8px 12px 10px;
    border-top:1px solid var(--border);
    display:flex; align-items:center;
    justify-content:space-between; gap:6px;
  }
  .lc-tuition-label { font-size:10px; color:var(--text-light); }
  .lc-tuition-price { font-size:14px; font-weight:800; color:var(--primary); }

  .lc-btn-grade {
    display:inline-flex; align-items:center; gap:4px;
    background:var(--primary-light); color:var(--primary);
    border:none; border-radius:6px;
    padding:5px 10px; font-size:11px; font-weight:600;
    text-decoration:none; white-space:nowrap;
    font-family:var(--font); transition:background .15s;
  }
  .lc-btn-grade:hover { background:var(--primary); color:#fff; }

  /* ── Empty ── */
  .lc-empty {
    text-align:center; padding:48px 20px; color:var(--text-muted);
  }
  .lc-empty i { font-size:3rem; display:block; margin-bottom:12px; color:var(--primary-mid); }
</style>

<!-- Page bar -->
<div class="lc-page-bar fade-in-up">
  <div>
    <div class="lc-page-title">Khóa học của tôi</div>
    <div class="lc-page-info mt-1">
      <strong>${activeCount}</strong> lớp đang học &nbsp;·&nbsp;
      <strong>${totalCount}</strong> tổng cộng
    </div>
  </div>
  <a href="${pageContext.request.contextPath}/student/courses" class="lc-btn-add">
    <i class="bi bi-plus-circle-fill"></i>Đăng ký thêm
  </a>
</div>

<!-- Alert -->
<c:if test="${not empty successMsg}">
  <div style="background:#dcfce7;border:1px solid #bbf7d0;border-radius:8px;
              padding:10px 14px;font-size:13px;color:#15803d;margin-bottom:14px;
              display:flex;align-items:center;gap:8px;" class="fade-in-up">
    <i class="bi bi-check-circle-fill"></i>${successMsg}
  </div>
</c:if>

<!-- Empty state -->
<c:if test="${empty myClasses}">
  <div class="lc-card fade-in-up">
    <div class="lc-empty">
      <i class="bi bi-journals"></i>
      <p>Bạn chưa đăng ký lớp học nào.</p>
      <a href="${pageContext.request.contextPath}/student/courses" class="lc-btn-add" style="margin-top:4px;">
        <i class="bi bi-search"></i>Xem khóa học đang mở
      </a>
    </div>
  </div>
</c:if>

<!-- Lớp đang học -->
<c:set var="hasOngoing" value="false"/>
<c:forEach var="cl" items="${myClasses}">
  <c:if test="${cl.classStatus == 'ongoing'}"><c:set var="hasOngoing" value="true"/></c:if>
</c:forEach>
<c:if test="${hasOngoing}">
  <div class="lc-sec-head fade-in-up">Khoá học thường</div>
  <div class="lc-class-grid fade-in-up">
    <c:forEach var="cl" items="${myClasses}" varStatus="st">
      <c:if test="${cl.classStatus == 'ongoing'}">

        <c:set var="ci" value="${st.index % 8}"/>
        <c:choose>
          <c:when test="${ci == 0}"><c:set var="cThumb" value="news-1.jpg"/></c:when>
          <c:when test="${ci == 1}"><c:set var="cThumb" value="slides-1.jpg"/></c:when>
          <c:when test="${ci == 2}"><c:set var="cThumb" value="news-3.jpg"/></c:when>
          <c:when test="${ci == 3}"><c:set var="cThumb" value="slides-2.jpg"/></c:when>
          <c:when test="${ci == 4}"><c:set var="cThumb" value="news-2.jpg"/></c:when>
          <c:when test="${ci == 5}"><c:set var="cThumb" value="slides-3.jpg"/></c:when>
          <c:when test="${ci == 6}"><c:set var="cThumb" value="news-4.jpg"/></c:when>
          <c:otherwise>            <c:set var="cThumb" value="news-5.jpg"/></c:otherwise>
        </c:choose>

        <div class="lc-class-card status-ongoing">
          <div class="lc-class-thumb">
            <img src="${pageContext.request.contextPath}/assets/img/${cThumb}"
                 alt="${cl.courseName}" loading="lazy">
            <span class="lc-class-pill bg-success text-white">Đang học</span>
          </div>
          <div class="lc-class-body">
            <div class="lc-class-name">${cl.courseName}</div>
            <span class="lc-level-badge">${cl.levelName}</span>
            <div class="lc-class-meta">
              <i class="bi bi-door-open-fill" style="color:var(--primary)"></i>
              <span style="font-weight:600;color:var(--text-main)">${cl.className}</span>
            </div>
            <div class="lc-class-meta">
              <i class="bi bi-calendar3"></i>
              <c:choose>
                <c:when test="${not empty cl.scheduleInfo}">${cl.scheduleInfo}</c:when>
                <c:otherwise><span style="font-style:italic">Chưa có lịch học</span></c:otherwise>
              </c:choose>
            </div>
            <div class="lc-class-meta">
              <i class="bi bi-clock"></i>
              <span>${cl.startDate} → ${cl.endDate}</span>
            </div>
          </div>
          <div class="lc-class-footer">
            <div>
              <div class="lc-tuition-label">Học phí</div>
              <div class="lc-tuition-price">
                <fmt:formatNumber value="${cl.tuitionFee}" type="number"
                                  groupingUsed="true" maxFractionDigits="0"/>đ
              </div>
            </div>
            <c:choose>
              <c:when test="${cl.paymentStatus == 'paid'}">
                <span style="background:#dcfce7;color:#15803d;border-radius:20px;
                             padding:3px 9px;font-size:11px;font-weight:600;">
                  <i class="bi bi-check2-circle me-1"></i>Đã TT
                </span>
              </c:when>
              <c:otherwise>
                <span style="background:#fef3c7;color:#92400e;border-radius:20px;
                             padding:3px 9px;font-size:11px;font-weight:600;">
                  <i class="bi bi-hourglass-split me-1"></i>Chờ TT
                </span>
              </c:otherwise>
            </c:choose>
          </div>
          <div style="padding:0 12px 10px;">
            <a href="${pageContext.request.contextPath}/student/grades?classId=${cl.classId}"
               class="lc-btn-grade" style="width:100%;justify-content:center;">
              <i class="bi bi-bar-chart-fill"></i>Xem điểm số
            </a>
          </div>
        </div>

      </c:if>
    </c:forEach>
  </div>
</c:if>

<!-- Lớp khác (upcoming / finished) -->
<c:set var="hasOther" value="false"/>
<c:forEach var="cl" items="${myClasses}">
  <c:if test="${cl.classStatus != 'ongoing'}"><c:set var="hasOther" value="true"/></c:if>
</c:forEach>
<c:if test="${hasOther}">
  <div class="lc-sec-head fade-in-up" style="margin-top:22px;">Khoá học sắp khai giảng / đã kết thúc</div>
  <div class="lc-class-grid fade-in-up">
    <c:forEach var="cl" items="${myClasses}" varStatus="st">
      <c:if test="${cl.classStatus != 'ongoing'}">

        <c:set var="ci" value="${st.index % 8}"/>
        <c:choose>
          <c:when test="${ci == 0}"><c:set var="cThumb" value="news-2.jpg"/></c:when>
          <c:when test="${ci == 1}"><c:set var="cThumb" value="news-4.jpg"/></c:when>
          <c:when test="${ci == 2}"><c:set var="cThumb" value="slides-3.jpg"/></c:when>
          <c:when test="${ci == 3}"><c:set var="cThumb" value="news-5.jpg"/></c:when>
          <c:when test="${ci == 4}"><c:set var="cThumb" value="slides-1.jpg"/></c:when>
          <c:when test="${ci == 5}"><c:set var="cThumb" value="news-1.jpg"/></c:when>
          <c:when test="${ci == 6}"><c:set var="cThumb" value="slides-2.jpg"/></c:when>
          <c:otherwise>            <c:set var="cThumb" value="news-3.jpg"/></c:otherwise>
        </c:choose>

        <c:set var="cardStatus" value="status-finished"/>
        <c:if test="${cl.classStatus == 'upcoming'}"><c:set var="cardStatus" value="status-upcoming"/></c:if>

        <div class="lc-class-card ${cardStatus}">
          <div class="lc-class-thumb">
            <img src="${pageContext.request.contextPath}/assets/img/${cThumb}"
                 alt="${cl.courseName}" loading="lazy"
                 style="${cl.classStatus == 'finished' ? 'filter:grayscale(40%)' : ''}">
            <c:choose>
              <c:when test="${cl.classStatus == 'upcoming'}">
                <span class="lc-class-pill" style="background:var(--primary);color:white;">Sắp KG</span>
              </c:when>
              <c:otherwise>
                <span class="lc-class-pill bg-secondary text-white">Đã KT</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="lc-class-body">
            <div class="lc-class-name">${cl.courseName}</div>
            <span class="lc-level-badge">${cl.levelName}</span>
            <div class="lc-class-meta">
              <i class="bi bi-door-open-fill" style="color:var(--primary)"></i>
              <span style="font-weight:600;color:var(--text-main)">${cl.className}</span>
            </div>
            <div class="lc-class-meta">
              <i class="bi bi-calendar3"></i>
              <c:choose>
                <c:when test="${not empty cl.scheduleInfo}">${cl.scheduleInfo}</c:when>
                <c:otherwise><span style="font-style:italic">Chưa có lịch học</span></c:otherwise>
              </c:choose>
            </div>
            <div class="lc-class-meta">
              <i class="bi bi-clock"></i>
              <span>${cl.startDate} → ${cl.endDate}</span>
            </div>
          </div>
          <div class="lc-class-footer">
            <div>
              <div class="lc-tuition-label">Học phí</div>
              <div class="lc-tuition-price">
                <fmt:formatNumber value="${cl.tuitionFee}" type="number"
                                  groupingUsed="true" maxFractionDigits="0"/>đ
              </div>
            </div>
            <c:choose>
              <c:when test="${cl.paymentStatus == 'paid'}">
                <span style="background:#dcfce7;color:#15803d;border-radius:20px;
                             padding:3px 9px;font-size:11px;font-weight:600;">
                  <i class="bi bi-check2-circle me-1"></i>Đã TT
                </span>
              </c:when>
              <c:otherwise>
                <span style="background:#fef3c7;color:#92400e;border-radius:20px;
                             padding:3px 9px;font-size:11px;font-weight:600;">
                  <i class="bi bi-hourglass-split me-1"></i>Chờ TT
                </span>
              </c:otherwise>
            </c:choose>
          </div>
          <c:if test="${cl.classStatus == 'finished'}">
            <div style="padding:0 12px 10px;">
              <a href="${pageContext.request.contextPath}/student/grades?classId=${cl.classId}"
                 class="lc-btn-grade" style="width:100%;justify-content:center;">
                <i class="bi bi-bar-chart-fill"></i>Xem điểm số
              </a>
            </div>
          </c:if>
        </div>

      </c:if>
    </c:forEach>
  </div>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
