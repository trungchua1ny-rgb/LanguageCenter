<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ══ HEADER (Khai báo biến nằm ở trong này) ══ --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%-- ══ SIDEBAR (Menu trái) ══ --%>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h5 class="fw-bold mb-1">Xin chào, <%= loggedUser != null ? loggedUser.getFullName() : "Admin" %> 👋</h5>
    <p class="text-muted mb-0" style="font-size:14px">Chào mừng bạn quay trở lại hệ thống.</p>
  </div>
</div>

<div class="row g-3 mb-4">
  <div class="col-6 col-md-3">
    <div class="card border-0 shadow-sm h-100">
      <div class="card-body d-flex align-items-center gap-3">
        <div style="width:44px;height:44px;border-radius:12px;background:#e8f0fe; display:flex;align-items:center;justify-content:center;font-size:22px;">📚</div>
        <div>
          <div class="fw-bold fs-5">4</div>
          <div class="text-muted" style="font-size:12px">Khóa học</div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-6 col-md-3">
    <div class="card border-0 shadow-sm h-100">
      <div class="card-body d-flex align-items-center gap-3">
        <div style="width:44px;height:44px;border-radius:12px;background:#e8f5e9; display:flex;align-items:center;justify-content:center;font-size:22px;">🎯</div>
        <div>
          <div class="fw-bold fs-5">2</div>
          <div class="text-muted" style="font-size:12px">Lớp đang học</div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-6 col-md-3">
    <div class="card border-0 shadow-sm h-100">
      <div class="card-body d-flex align-items-center gap-3">
        <div style="width:44px;height:44px;border-radius:12px;background:#fff8e1; display:flex;align-items:center;justify-content:center;font-size:22px;">📝</div>
        <div>
          <div class="fw-bold fs-5">3</div>
          <div class="text-muted" style="font-size:12px">Bài kiểm tra</div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-6 col-md-3">
    <div class="card border-0 shadow-sm h-100">
      <div class="card-body d-flex align-items-center gap-3">
        <div style="width:44px;height:44px;border-radius:12px;background:#fce4ec; display:flex;align-items:center;justify-content:center;font-size:22px;">⭐</div>
        <div>
          <div class="fw-bold fs-5">7.2</div>
          <div class="text-muted" style="font-size:12px">Điểm TB</div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="card border-0 shadow-sm">
  <div class="card-header bg-white border-bottom py-3">
    <span class="fw-semibold">📅 Thông báo nội bộ</span>
  </div>
  <div class="card-body text-muted text-center py-5" style="font-size:14px">
    Chưa có thông báo nào hôm nay. Dữ liệu sẽ được kết nối sau.
  </div>
</div>

<%-- ══ FOOTER ══ --%>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>