<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Dashboard</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="<%= contextPath %>/admin/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Dashboard</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section dashboard">

  <%-- ══ LỜI CHÀO ══ --%>
  <div class="card mb-3">
    <div class="card-body py-3">
      <h5 class="card-title mb-0">
        Xin chào, <%= loggedUser != null ? loggedUser.getFullName() : "Admin" %> 👋
      </h5>
      <p class="text-muted mb-0 mt-1" style="font-size:14px">Chào mừng bạn quay trở lại hệ thống.</p>
    </div>
  </div>

  <%-- ══ 4 THẺ THỐNG KÊ ══ --%>
  <div class="row">

    <div class="col-xxl-3 col-md-6">
      <a href="<%= contextPath %>/admin/courses" class="text-decoration-none">
        <div class="card info-card sales-card">
          <div class="card-body">
            <h5 class="card-title">Khóa học <span>| Tổng</span></h5>
            <div class="d-flex align-items-center">
              <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                <i class="bi bi-book"></i>
              </div>
              <div class="ps-3">
                <h6>${totalCourses != null ? totalCourses : 4}</h6>
                <span class="text-muted small pt-2 ps-1">khóa học</span>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div><!-- End Khoa hoc Card -->

    <div class="col-xxl-3 col-md-6">
      <a href="<%= contextPath %>/admin/classes" class="text-decoration-none">
        <div class="card info-card revenue-card">
          <div class="card-body">
            <h5 class="card-title">Lớp đang học <span>| Ongoing</span></h5>
            <div class="d-flex align-items-center">
              <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                <i class="bi bi-door-open"></i>
              </div>
              <div class="ps-3">
                <h6>${totalOngoingClasses != null ? totalOngoingClasses : 2}</h6>
                <span class="text-muted small pt-2 ps-1">lớp</span>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div><!-- End Lop dang hoc Card -->

    <div class="col-xxl-3 col-md-6">
      <a href="<%= contextPath %>/admin/enrollments?status=pending" class="text-decoration-none">
        <div class="card info-card customers-card">
          <div class="card-body">
            <h5 class="card-title">Chờ duyệt <span>| Pending</span></h5>
            <div class="d-flex align-items-center">
              <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                <i class="bi bi-hourglass-split"></i>
              </div>
              <div class="ps-3">
                <h6>${totalPending != null ? totalPending : 3}</h6>
                <span class="text-success small pt-1 fw-bold">đơn đăng ký</span>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div><!-- End Don cho duyet Card -->

    <div class="col-xxl-3 col-md-6">
      <a href="<%= contextPath %>/admin/students" class="text-decoration-none">
        <div class="card info-card" style="border-left: 4px solid #f6c23e;">
          <div class="card-body">
            <h5 class="card-title">Học viên <span>| Tổng</span></h5>
            <div class="d-flex align-items-center">
              <div class="card-icon rounded-circle d-flex align-items-center justify-content-center"
                   style="background: #fff3cd; color:#f6c23e;">
                <i class="bi bi-people"></i>
              </div>
              <div class="ps-3">
                <h6>${totalStudents != null ? totalStudents : 10}</h6>
                <span class="text-muted small pt-2 ps-1">học viên</span>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div><!-- End Hoc vien Card -->

  </div><!-- End Stats Row -->

  <%-- ══ BẢNG ĐĂNG KÝ MỚI NHẤT ══ --%>
  <div class="row">
    <div class="col-12">
      <div class="card recent-sales overflow-auto">
        <div class="card-body">
          <h5 class="card-title">Đăng ký mới nhất <span>| 5 gần nhất</span></h5>
          <table class="table table-hover align-middle" style="font-size:14px">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Học viên</th>
                <th>Lớp học</th>
                <th>Ngày đăng ký</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <%-- Nếu đã có data từ Servlet thì dùng JSTL, tạm thời để placeholder --%>
              <tr>
                <td colspan="5" class="text-center text-muted py-4">
                  <i class="bi bi-inbox fs-4 d-block mb-1"></i>
                  Dữ liệu sẽ được hiển thị sau khi kết nối DB.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
