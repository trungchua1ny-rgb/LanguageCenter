<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.langcenter.model.User" %>
<%
    User homeUser = (User) session.getAttribute("loggedUser");
    String homeCtx = request.getContextPath();
    String firstName = homeUser != null ? homeUser.getFullName().split(" ")[0] : "bạn";
%>

<%-- Include header --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%-- Include sidebar --%>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<%-- ========== PAGE STYLES ========== --%>
<style>
  /* ── Promo Banner ── */
  .lc-promo-banner {
    background: linear-gradient(135deg, #0056d2 0%, #1a3a6b 100%);
    border-radius: 12px;
    padding: 24px 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 28px;
    overflow: hidden;
    position: relative;
    color: #fff;
  }
  .lc-promo-banner::after {
    content: '';
    position: absolute; right: -40px; top: -40px;
    width: 200px; height: 200px;
    border-radius: 50%;
    background: rgba(255,255,255,.06);
  }
  .lc-promo-title {
    font-size: 22px; font-weight: 700; line-height: 1.3;
    margin-bottom: 6px;
  }
  .lc-promo-sub {
    font-size: 14px; opacity: .8; margin-bottom: 16px;
    max-width: 420px;
  }
  .lc-promo-badge {
    display: inline-flex; align-items: center; gap: 6px;
    background: #ffcc02; color: #1a3a6b;
    padding: 4px 12px; border-radius: 20px;
    font-size: 12px; font-weight: 700; margin-bottom: 12px;
  }
  .lc-promo-btn {
    background: #fff; color: var(--lc-blue);
    border: none; border-radius: 6px;
    padding: 10px 22px; font-size: 14px; font-weight: 700;
    cursor: pointer; text-decoration: none;
    transition: transform .15s, box-shadow .15s;
    display: inline-block;
  }
  .lc-promo-btn:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,.2); color: var(--lc-blue); }
  .lc-promo-discount {
    font-size: 64px; font-weight: 900; line-height: 1;
    color: rgba(255,255,255,.15);
    position: absolute; right: 28px; top: 50%; transform: translateY(-50%);
    letter-spacing: -4px;
    user-select: none;
  }

  /* ── Section title ── */
  .lc-section-title {
    font-size: 18px; font-weight: 700; color: var(--lc-gray-800);
    margin-bottom: 16px; display: flex; align-items: center; justify-content: space-between;
  }
  .lc-section-title a {
    font-size: 13px; font-weight: 600; color: var(--lc-blue); text-decoration: none;
  }
  .lc-section-title a:hover { text-decoration: underline; }

  /* ── Course card ── */
  .lc-course-row {
    display: grid;
    gap: 16px;
    margin-bottom: 32px;
  }
  .lc-course-row.cols-4 { grid-template-columns: repeat(4, 1fr); }
  .lc-course-row.cols-3 { grid-template-columns: repeat(3, 1fr); }
  @media (max-width: 1200px) { .lc-course-row.cols-4 { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width: 900px)  { .lc-course-row.cols-4, .lc-course-row.cols-3 { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 600px)  { .lc-course-row.cols-4, .lc-course-row.cols-3 { grid-template-columns: 1fr; } }

  .lc-course-card {
    background: var(--lc-white);
    border: 1px solid var(--lc-gray-200);
    border-radius: 8px;
    overflow: hidden;
    cursor: pointer;
    transition: box-shadow .2s, transform .2s;
    text-decoration: none;
    display: flex; flex-direction: column;
  }
  .lc-course-card:hover {
    box-shadow: var(--lc-shadow-md);
    transform: translateY(-2px);
    border-color: transparent;
  }
  .lc-course-thumb {
    width: 100%; aspect-ratio: 16/9;
    object-fit: cover;
    background: var(--lc-gray-100);
    display: flex; align-items: center; justify-content: center;
    font-size: 36px;
    flex-shrink: 0;
  }
  .lc-course-body {
    padding: 14px 16px 16px;
    display: flex; flex-direction: column; flex: 1;
  }
  .lc-course-provider {
    font-size: 11px; font-weight: 600;
    text-transform: uppercase; letter-spacing: .5px;
    color: var(--lc-gray-400); margin-bottom: 5px;
  }
  .lc-course-name {
    font-size: 14px; font-weight: 700; color: var(--lc-gray-800);
    line-height: 1.4; margin-bottom: 8px;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
    overflow: hidden;
  }
  .lc-course-meta {
    display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
    margin-top: auto;
  }
  .lc-course-rating {
    display: flex; align-items: center; gap: 3px;
    font-size: 12px; font-weight: 600; color: #d97706;
  }
  .lc-course-rating i { font-size: 12px; }
  .lc-course-tag {
    font-size: 11px; font-weight: 500;
    padding: 2px 8px; border-radius: 20px;
    background: var(--lc-blue-light); color: var(--lc-blue);
  }
  .lc-course-tag.new { background: #ecfdf5; color: var(--lc-green); }
  .lc-course-tag.hot { background: #fef3c7; color: #d97706; }

  /* Course thumb colored backgrounds */
  .lc-thumb-1 { background: linear-gradient(135deg,#1a56db,#3b82f6); }
  .lc-thumb-2 { background: linear-gradient(135deg,#d97706,#f59e0b); }
  .lc-thumb-3 { background: linear-gradient(135deg,#059669,#34d399); }
  .lc-thumb-4 { background: linear-gradient(135deg,#7c3aed,#a78bfa); }
  .lc-thumb-5 { background: linear-gradient(135deg,#dc2626,#f87171); }
  .lc-thumb-6 { background: linear-gradient(135deg,#0891b2,#22d3ee); }

  /* ── Enroll Progress card ── */
  .lc-progress-card {
    background: var(--lc-white);
    border: 1px solid var(--lc-gray-200);
    border-radius: 8px;
    padding: 16px;
    display: flex; gap: 14px; align-items: flex-start;
    transition: box-shadow .2s;
    text-decoration: none;
  }
  .lc-progress-card:hover { box-shadow: var(--lc-shadow-md); border-color: var(--lc-blue-light); }
  .lc-progress-thumb {
    width: 72px; height: 52px; border-radius: 6px;
    display: flex; align-items: center; justify-content: center;
    font-size: 22px; flex-shrink: 0;
  }
  .lc-progress-info { flex: 1; min-width: 0; }
  .lc-progress-name {
    font-size: 14px; font-weight: 600; color: var(--lc-gray-800);
    margin-bottom: 3px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .lc-progress-class {
    font-size: 12px; color: var(--lc-gray-400); margin-bottom: 8px;
  }
  .lc-progress-bar-wrap {
    height: 6px; background: var(--lc-gray-100); border-radius: 3px; overflow: hidden;
  }
  .lc-progress-bar-fill {
    height: 100%; background: var(--lc-blue); border-radius: 3px;
    transition: width .6s ease;
  }
  .lc-progress-pct {
    font-size: 11px; font-weight: 600; color: var(--lc-blue); margin-top: 4px;
  }

  /* ── Category chips ── */
  .lc-cat-grid {
    display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 32px;
  }
  .lc-cat-chip {
    display: flex; align-items: center; gap: 7px;
    padding: 9px 16px; border-radius: 6px;
    border: 1.5px solid var(--lc-gray-200);
    background: var(--lc-white);
    font-size: 13.5px; font-weight: 600; color: var(--lc-gray-700);
    cursor: pointer; text-decoration: none;
    transition: border-color .15s, background .15s, color .15s;
  }
  .lc-cat-chip:hover {
    border-color: var(--lc-blue);
    background: var(--lc-blue-light);
    color: var(--lc-blue);
  }
  .lc-cat-chip span.icon { font-size: 16px; }

  /* ── Stats row ── */
  .lc-stats-row {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px; margin-bottom: 32px;
  }
  @media (max-width: 900px) { .lc-stats-row { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 500px) { .lc-stats-row { grid-template-columns: 1fr 1fr; } }

  .lc-stat-card {
    background: var(--lc-white);
    border: 1px solid var(--lc-gray-200);
    border-radius: 8px;
    padding: 18px 20px;
    display: flex; align-items: center; gap: 14px;
  }
  .lc-stat-icon {
    width: 44px; height: 44px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; flex-shrink: 0;
  }
  .lc-stat-icon.blue   { background: var(--lc-blue-light); color: var(--lc-blue); }
  .lc-stat-icon.green  { background: #ecfdf5; color: var(--lc-green); }
  .lc-stat-icon.orange { background: #fef3c7; color: #d97706; }
  .lc-stat-icon.purple { background: #f5f3ff; color: #7c3aed; }

  .lc-stat-num {
    font-size: 22px; font-weight: 800; color: var(--lc-gray-800);
    line-height: 1;
  }
  .lc-stat-label { font-size: 12px; color: var(--lc-gray-400); margin-top: 3px; font-weight: 500; }

  /* ── Welcome greeting ── */
  .lc-greeting {
    font-size: 24px; font-weight: 800;
    color: var(--lc-gray-800); margin-bottom: 6px;
  }
  .lc-greeting-sub {
    font-size: 14px; color: var(--lc-gray-400); margin-bottom: 24px;
  }
</style>

<%-- ========== PAGE CONTENT ========== --%>

<!-- Greeting -->
<div class="lc-greeting">Chào mừng trở lại, <%= firstName %>! 👋</div>
<div class="lc-greeting-sub">Hôm nay bạn muốn học gì?</div>

<!-- Promo Banner -->
<div class="lc-promo-banner">
  <div style="position:relative;z-index:1;">
    <div class="lc-promo-badge">🔥 Ưu đãi đặc biệt</div>
    <div class="lc-promo-title">Đăng ký thêm khóa học,<br>tiết kiệm đến 40%!</div>
    <div class="lc-promo-sub">Xây dựng kỹ năng toàn diện với hàng chục khóa học ngoại ngữ chất lượng cao tại Language Center.</div>
    <a href="<%= homeCtx %>/student/courses" class="lc-promo-btn">Khám phá ngay</a>
  </div>
  <div class="lc-promo-discount">40%</div>
</div>

<!-- Quick stats -->
<div class="lc-stats-row">
  <div class="lc-stat-card">
    <div class="lc-stat-icon blue"><i class="bi bi-journal-bookmark-fill"></i></div>
    <div>
      <div class="lc-stat-num">3</div>
      <div class="lc-stat-label">Khóa đang học</div>
    </div>
  </div>
  <div class="lc-stat-card">
    <div class="lc-stat-icon green"><i class="bi bi-patch-check-fill"></i></div>
    <div>
      <div class="lc-stat-num">1</div>
      <div class="lc-stat-label">Khóa hoàn thành</div>
    </div>
  </div>
  <div class="lc-stat-card">
    <div class="lc-stat-icon orange"><i class="bi bi-calendar-check-fill"></i></div>
    <div>
      <div class="lc-stat-num">12</div>
      <div class="lc-stat-label">Buổi học trong tháng</div>
    </div>
  </div>
  <div class="lc-stat-card">
    <div class="lc-stat-icon purple"><i class="bi bi-award-fill"></i></div>
    <div>
      <div class="lc-stat-num">8.5</div>
      <div class="lc-stat-label">Điểm TB hiện tại</div>
    </div>
  </div>
</div>

<!-- Continue learning -->
<div class="lc-section-title">
  Tiếp tục học
  <a href="<%= homeCtx %>/student/my-classes">Xem tất cả →</a>
</div>
<div class="lc-course-row cols-3" style="margin-bottom:32px;">
  <a href="<%= homeCtx %>/student/my-classes" class="lc-progress-card">
    <div class="lc-progress-thumb lc-thumb-1">🇬🇧</div>
    <div class="lc-progress-info">
      <div class="lc-progress-name">Tiếng Anh Giao Tiếp B1</div>
      <div class="lc-progress-class">Lớp ANH-B1-01 · GV: Nguyễn Hữu A</div>
      <div class="lc-progress-bar-wrap"><div class="lc-progress-bar-fill" style="width:65%"></div></div>
      <div class="lc-progress-pct">65% hoàn thành</div>
    </div>
  </a>
  <a href="<%= homeCtx %>/student/my-classes" class="lc-progress-card">
    <div class="lc-progress-thumb lc-thumb-2">🇯🇵</div>
    <div class="lc-progress-info">
      <div class="lc-progress-name">Tiếng Nhật N4 – Ngữ pháp</div>
      <div class="lc-progress-class">Lớp NHT-N4-02 · GV: Trần Thị B</div>
      <div class="lc-progress-bar-wrap"><div class="lc-progress-bar-fill" style="width:40%;background:#d97706;"></div></div>
      <div class="lc-progress-pct" style="color:#d97706;">40% hoàn thành</div>
    </div>
  </a>
  <a href="<%= homeCtx %>/student/my-classes" class="lc-progress-card">
    <div class="lc-progress-thumb lc-thumb-3">🇰🇷</div>
    <div class="lc-progress-info">
      <div class="lc-progress-name">Tiếng Hàn Sơ Cấp – TOPIK I</div>
      <div class="lc-progress-class">Lớp HAN-SC-03 · GV: Lê Văn C</div>
      <div class="lc-progress-bar-wrap"><div class="lc-progress-bar-fill" style="width:20%;background:#059669;"></div></div>
      <div class="lc-progress-pct" style="color:#059669;">20% hoàn thành</div>
    </div>
  </a>
</div>

<!-- Explore categories -->
<div class="lc-section-title">Khám phá theo ngôn ngữ</div>
<div class="lc-cat-grid">
  <a href="<%= homeCtx %>/student/courses?lang=en" class="lc-cat-chip">
    <span class="icon">🇬🇧</span> Tiếng Anh
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=jp" class="lc-cat-chip">
    <span class="icon">🇯🇵</span> Tiếng Nhật
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=kr" class="lc-cat-chip">
    <span class="icon">🇰🇷</span> Tiếng Hàn
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=cn" class="lc-cat-chip">
    <span class="icon">🇨🇳</span> Tiếng Trung
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=fr" class="lc-cat-chip">
    <span class="icon">🇫🇷</span> Tiếng Pháp
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=de" class="lc-cat-chip">
    <span class="icon">🇩🇪</span> Tiếng Đức
  </a>
  <a href="<%= homeCtx %>/student/courses?lang=es" class="lc-cat-chip">
    <span class="icon">🇪🇸</span> Tiếng Tây Ban Nha
  </a>
  <a href="<%= homeCtx %>/student/courses" class="lc-cat-chip">
    <span class="icon">🌐</span> Tất cả khóa học
  </a>
</div>

<!-- Featured courses -->
<div class="lc-section-title">
  Khóa học nổi bật
  <a href="<%= homeCtx %>/student/courses">Xem tất cả →</a>
</div>
<div class="lc-course-row cols-4">

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-1" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇬🇧</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Anh Giao Tiếp Tổng Hợp A1–C1</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.9</span>
        <span class="lc-course-tag hot">Phổ biến</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-2" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇯🇵</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Nhật JLPT N5–N1 Toàn Diện</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.8</span>
        <span class="lc-course-tag">Chứng chỉ</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-3" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇰🇷</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Hàn TOPIK I & II Luyện Thi</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.7</span>
        <span class="lc-course-tag new">Mới</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-4" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇨🇳</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Trung HSK 1–6 Học Nhanh</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.6</span>
        <span class="lc-course-tag">Chứng chỉ</span>
      </div>
    </div>
  </a>

</div>

<!-- Recently added -->
<div class="lc-section-title">
  Mới khai giảng
  <a href="<%= homeCtx %>/student/courses">Xem tất cả →</a>
</div>
<div class="lc-course-row cols-4">

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-5" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇫🇷</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Pháp DELF A1–B2</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.8</span>
        <span class="lc-course-tag new">Mới</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-6" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇩🇪</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Đức Goethe A1–B1</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.7</span>
        <span class="lc-course-tag new">Mới</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-1" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇬🇧</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">IELTS Luyện Thi Cấp Tốc 6.5–8.0</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.9</span>
        <span class="lc-course-tag hot">Phổ biến</span>
      </div>
    </div>
  </a>

  <a href="<%= homeCtx %>/student/courses" class="lc-course-card">
    <div class="lc-course-thumb lc-thumb-2" style="display:flex;align-items:center;justify-content:center;aspect-ratio:16/9;font-size:40px;">🇯🇵</div>
    <div class="lc-course-body">
      <div class="lc-course-provider">Language Center</div>
      <div class="lc-course-name">Tiếng Nhật Business – Giao Tiếp Công Sở</div>
      <div class="lc-course-meta">
        <span class="lc-course-rating"><i class="bi bi-star-fill"></i> 4.6</span>
        <span class="lc-course-tag new">Mới</span>
      </div>
    </div>
  </a>

</div>

<!-- AI Consult CTA -->
<div style="background:linear-gradient(135deg,#f0f7ff 0%,#e8f1fd 100%);border:1.5px solid var(--lc-blue-light);border-radius:12px;padding:24px 28px;display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap;margin-bottom:32px;">
  <div>
    <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">
      <span style="font-size:28px;">🤖</span>
      <span style="font-size:17px;font-weight:700;color:var(--lc-gray-800);">Không biết chọn lộ trình nào?</span>
    </div>
    <p style="font-size:14px;color:var(--lc-gray-600);margin:0;max-width:480px;">
      Hỏi AI tư vấn ngay — AI sẽ phân tích mục tiêu của bạn và đề xuất lộ trình học phù hợp nhất.
    </p>
  </div>
  <a href="<%= homeCtx %>/student/ai-consult"
     style="background:var(--lc-blue);color:#fff;border-radius:6px;padding:11px 24px;font-size:14px;font-weight:700;text-decoration:none;white-space:nowrap;transition:background .15s;"
     onmouseover="this.style.background='var(--lc-blue-dark)'"
     onmouseout="this.style.background='var(--lc-blue)'">
    Tư vấn AI ngay →
  </a>
</div>

<%-- Include footer --%>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
