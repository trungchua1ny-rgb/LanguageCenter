<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
  /* ── Page ── */
  .lc-page-bar {
    display:flex; align-items:center; justify-content:space-between;
    flex-wrap:wrap; gap:10px; margin-bottom:16px;
  }
  .lc-page-title { font-size:20px; font-weight:800; color:var(--text-main); }

  .lc-back-link {
    font-size:13px; color:var(--primary); text-decoration:none; font-weight:600;
    display:inline-flex; align-items:center; gap:5px;
  }
  .lc-back-link:hover { text-decoration:underline; }

  /* ── Grid: 5 cols compact ── */
  .lc-enroll-grid {
    display:grid;
    grid-template-columns:repeat(auto-fill, minmax(300px, 1fr));
    gap:12px;
  }

  /* ── Card ── */
  .lc-enroll-card {
    border:1.5px solid var(--border);
    border-radius:10px;
    overflow:hidden;
    display:flex; flex-direction:column;
    background:#fff;
    transition:box-shadow .2s, transform .2s, border-color .2s;
  }
  .lc-enroll-card:hover:not(.disabled) {
    box-shadow:0 6px 20px rgba(30,136,229,.13);
    transform:translateY(-3px);
    border-color:var(--primary);
  }
  .lc-enroll-card.disabled { opacity:.65; }
  .lc-enroll-card.enrolled { border-color:#22c55e; }

  /* ── Thumbnail (compact) ── */
  .lc-enroll-thumb {
    position:relative;
    width:100%; aspect-ratio:21/9;
    overflow:hidden; flex-shrink:0;
    background:#f3f4f6;
  }
  .lc-enroll-thumb img {
    width:100%; height:100%; object-fit:cover;
    transition:transform .35s ease;
  }
  .lc-enroll-card:hover:not(.disabled) .lc-enroll-thumb img { transform:scale(1.05); }

  .lc-status-ribbon {
    position:absolute; top:7px; left:7px;
    font-size:10px; font-weight:700;
    padding:2px 8px; border-radius:20px;
  }
  .lc-slots-pill {
    position:absolute; bottom:6px; right:6px;
    font-size:10px; font-weight:600;
    background:rgba(0,0,0,.5); color:white;
    padding:2px 8px; border-radius:10px;
  }

  /* ── Body ── */
  .lc-enroll-body {
    padding:10px 12px 8px;
    display:flex; flex-direction:column; flex:1; gap:4px;
  }
  .lc-enroll-course-name {
    font-size:13px; font-weight:700; color:var(--text-main); line-height:1.3;
    display:-webkit-box; -webkit-line-clamp:2;
    -webkit-box-orient:vertical; overflow:hidden;
  }
  .lc-enroll-meta {
    font-size:11px; color:var(--text-muted);
    display:flex; align-items:flex-start; gap:5px; line-height:1.35;
  }
  .lc-enroll-meta i { flex-shrink:0; margin-top:1px; font-size:11px; }

  /* Slot progress */
  .lc-enroll-slots { margin-top:3px; }
  .slot-label {
    font-size:11px; color:var(--text-muted); margin-bottom:3px;
    display:flex; justify-content:space-between; align-items:center;
  }

  /* ── Footer ── */
  .lc-enroll-footer {
    padding:8px 12px 10px;
    border-top:1px solid var(--border);
    display:flex; align-items:center;
    justify-content:space-between; gap:6px;
    margin-top:auto;
  }
  .lc-enroll-price-label { font-size:10px; color:var(--text-light); }
  .lc-enroll-price       { font-size:15px; font-weight:800; color:var(--primary); }

  /* Buttons */
  .lc-btn-enroll {
    background:var(--primary); color:#fff; border:none;
    border-radius:6px; padding:6px 12px; font-size:11px; font-weight:700;
    cursor:pointer; transition:background .15s;
    display:inline-flex; align-items:center; gap:4px;
    white-space:nowrap; font-family:var(--font);
  }
  .lc-btn-enroll:hover { background:var(--primary-dark); }
  .lc-btn-enrolled {
    background:#dcfce7; color:#15803d;
    border:1px solid #86efac; border-radius:6px;
    padding:6px 10px; font-size:11px; font-weight:600;
    cursor:default; display:inline-flex; align-items:center; gap:4px;
  }
  .lc-btn-full {
    background:#f3f4f6; color:#9ca3af;
    border:1px solid var(--border); border-radius:6px;
    padding:6px 10px; font-size:11px;
    cursor:not-allowed; display:inline-flex; align-items:center; gap:4px;
  }

  /* ── Empty ── */
  .lc-empty {
    text-align:center; padding:48px 20px; color:var(--text-muted);
  }
  .lc-empty i { font-size:3rem; display:block; margin-bottom:12px; color:var(--primary-mid); }
</style>

<!-- Page bar -->
<div class="lc-page-bar fade-in-up">
  <div class="lc-page-title">Đăng ký Khóa học</div>
  <a href="${pageContext.request.contextPath}/student/my-classes" class="lc-back-link">
    <i class="bi bi-arrow-left"></i>Khóa học của tôi
  </a>
</div>

<!-- Alerts -->
<c:if test="${not empty successMsg}">
  <div style="background:#dcfce7;border:1px solid #bbf7d0;border-radius:8px;
              padding:10px 14px;font-size:13px;color:#15803d;margin-bottom:14px;
              display:flex;align-items:center;gap:8px;" class="fade-in-up">
    <i class="bi bi-check-circle-fill"></i>${successMsg}
  </div>
</c:if>
<c:if test="${not empty errorMsg}">
  <div style="background:#fee2e2;border:1px solid #fecaca;border-radius:8px;
              padding:10px 14px;font-size:13px;color:#dc2626;margin-bottom:14px;
              display:flex;align-items:center;gap:8px;" class="fade-in-up">
    <i class="bi bi-exclamation-circle-fill"></i>${errorMsg}
  </div>
</c:if>

<!-- Grid -->
<c:choose>
  <c:when test="${empty availableClasses}">
    <div class="lc-card fade-in-up">
      <div class="lc-empty">
        <i class="bi bi-inbox"></i>
        <p>Hiện chưa có lớp học nào đang mở đăng ký.</p>
      </div>
    </div>
  </c:when>

  <c:otherwise>
    <div class="lc-enroll-grid fade-in-up">
      <c:forEach var="cls" items="${availableClasses}" varStatus="st">

        <%-- Ảnh xoay vòng theo index --%>
        <c:set var="imgIndex" value="${st.index % 8}"/>
        <c:choose>
          <c:when test="${imgIndex == 0}"><c:set var="thumbImg" value="news-1.jpg"/></c:when>
          <c:when test="${imgIndex == 1}"><c:set var="thumbImg" value="news-2.jpg"/></c:when>
          <c:when test="${imgIndex == 2}"><c:set var="thumbImg" value="news-3.jpg"/></c:when>
          <c:when test="${imgIndex == 3}"><c:set var="thumbImg" value="news-4.jpg"/></c:when>
          <c:when test="${imgIndex == 4}"><c:set var="thumbImg" value="news-5.jpg"/></c:when>
          <c:when test="${imgIndex == 5}"><c:set var="thumbImg" value="slides-1.jpg"/></c:when>
          <c:when test="${imgIndex == 6}"><c:set var="thumbImg" value="slides-2.jpg"/></c:when>
          <c:otherwise>                  <c:set var="thumbImg" value="slides-3.jpg"/></c:otherwise>
        </c:choose>

        <c:set var="isEnrolled" value="${cls.note == 'enrolled'}"/>
        <c:set var="isFull"     value="${!cls.available}"/>

        <div class="lc-enroll-card ${isFull ? 'disabled' : ''} ${isEnrolled ? 'enrolled' : ''}">

          <%-- Thumbnail --%>
          <div class="lc-enroll-thumb">
            <img src="${pageContext.request.contextPath}/assets/img/${thumbImg}"
                 alt="${cls.courseName}" loading="lazy">
            <c:choose>
              <c:when test="${cls.classStatus == 'ongoing'}">
                <span class="lc-status-ribbon bg-success text-white">🟢 Đang học</span>
              </c:when>
              <c:otherwise>
                <span class="lc-status-ribbon" style="background:var(--primary);color:white;">🔵 Sắp KG</span>
              </c:otherwise>
            </c:choose>
            <c:if test="${!isEnrolled && !isFull}">
              <span class="lc-slots-pill">${cls.currentStudents}/${cls.maxStudents} chỗ</span>
            </c:if>
          </div>

          <%-- Body --%>
          <div class="lc-enroll-body">
            <div class="lc-enroll-course-name">${cls.courseName}</div>

            <div class="lc-enroll-meta">
              <i class="bi bi-door-open-fill" style="color:var(--primary)"></i>
              <span style="font-weight:600;color:var(--text-main)">${cls.className}</span>
            </div>

            <div class="lc-enroll-meta">
              <i class="bi bi-calendar3"></i>
              <span>${cls.scheduleInfo}</span>
            </div>

            <%-- Slot progress --%>
            <div class="lc-enroll-slots">
              <div class="slot-label">
                <span style="display:flex;align-items:center;gap:4px;">
                  <i class="bi bi-people-fill" style="font-size:11px;color:var(--text-muted)"></i>
                  <span style="font-weight:600;color:${cls.available ? '#16a34a' : '#dc2626'};">
                    ${cls.currentStudents}/${cls.maxStudents}
                  </span>
                </span>
                <c:if test="${cls.remainingSlots <= 3 && cls.available}">
                  <span style="background:#fee2e2;color:#dc2626;border-radius:20px;
                               padding:1px 6px;font-size:10px;font-weight:700;">Sắp đầy!</span>
                </c:if>
              </div>
              <div style="height:4px;background:#e5e7eb;border-radius:3px;overflow:hidden;">
                <div style="height:100%;border-radius:3px;
                            background:${cls.remainingSlots <= 3 ? '#dc2626' : '#16a34a'};
                            width:${(cls.currentStudents / cls.maxStudents) * 100}%"></div>
              </div>
            </div>
          </div>

          <%-- Footer --%>
          <div class="lc-enroll-footer">
            <div>
              <div class="lc-enroll-price-label">Học phí</div>
              <div class="lc-enroll-price">
                <fmt:formatNumber value="${cls.tuitionFee}" type="number"
                                  groupingUsed="true" maxFractionDigits="0"/>đ
              </div>
            </div>
            <c:choose>
              <c:when test="${isEnrolled}">
                <span class="lc-btn-enrolled">
                  <i class="bi bi-check-circle-fill"></i>Đã đăng ký
                </span>
              </c:when>
              <c:when test="${isFull}">
                <span class="lc-btn-full">
                  <i class="bi bi-x-circle"></i>Hết chỗ
                </span>
              </c:when>
              <c:otherwise>
                <button class="lc-btn-enroll"
                        onclick="confirmEnroll(${cls.classId}, '${cls.courseName}', '${cls.className}')">
                  <i class="bi bi-plus-circle-fill"></i>Đăng ký
                </button>
              </c:otherwise>
            </c:choose>
          </div>

        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>

<%-- Modal xác nhận --%>
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:14px;border:none;box-shadow:0 8px 32px rgba(0,0,0,.16);">
      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold">
          <i class="bi bi-clipboard-check me-2" style="color:var(--primary)"></i>Xác nhận đăng ký
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/student/courses" method="POST">
        <div class="modal-body">
          <p class="mb-1 text-muted" style="font-size:12px">Bạn chọn đăng ký khóa học:</p>
          <p id="modal-course-name" style="font-weight:700;color:var(--primary);font-size:15px;margin-bottom:3px;"></p>
          <p id="modal-class-name"  style="font-size:12px;color:var(--text-muted);margin-bottom:0;"></p>
          <div style="background:var(--primary-light);border-radius:8px;padding:10px 14px;
                      margin-top:14px;font-size:12px;color:var(--text-main);">
            <i class="bi bi-info-circle me-1" style="color:var(--primary)"></i>
            Sau khi đăng ký, Admin sẽ xác nhận và hướng dẫn thanh toán học phí cho bạn.
          </div>
          <input type="hidden" name="action"  value="enroll">
          <input type="hidden" name="classId" id="modal-class-id">
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="lc-btn-enroll">
            <i class="bi bi-check-lg"></i>Xác nhận đăng ký
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function confirmEnroll(id, course, cls) {
  document.getElementById('modal-class-id').value          = id;
  document.getElementById('modal-course-name').textContent = course;
  document.getElementById('modal-class-name').textContent  = 'Lớp: ' + cls;
  new bootstrap.Modal(document.getElementById('confirmModal')).show();
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
