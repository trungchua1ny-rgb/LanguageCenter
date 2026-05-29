package com.langcenter.controller;

import com.langcenter.dao.CourseDAO;
import com.langcenter.model.Course;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
/**
 * Servlet quản lý CRUD Khóa học — chỉ Admin truy cập.
 *
 * GET  /admin/courses              → danh sách
 * GET  /admin/courses?action=add   → form thêm mới
 * GET  /admin/courses?action=edit&id=X → form sửa
 * POST /admin/courses (action=insert)  → lưu mới
 * POST /admin/courses (action=update)  → lưu sửa
 * POST /admin/courses (action=delete)  → xóa / ẩn
 */
@WebServlet("/admin/courses")
public class CourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();

    // ═══════════════════════════════════════════════════════════
    // GET
    // ═══════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            showForm(req, resp, null);          // form trống → thêm mới

        } else if ("edit".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/admin/courses"); return; }
            Course course = courseDAO.getById(Integer.parseInt(idStr));
            if (course == null) { resp.sendRedirect(req.getContextPath() + "/admin/courses?error=Không tìm thấy khóa học."); return; }
            showForm(req, resp, course);        // form điền sẵn → sửa

        } else {
            // Mặc định: danh sách
            req.setAttribute("courses",  courseDAO.getAll());
            req.setAttribute("successMsg", req.getParameter("success"));
            req.setAttribute("errorMsg",   req.getParameter("error"));
            forward(req, resp, "/WEB-INF/views/admin/course-list.jsp");
        }
    }

 // ═══════════════════════════════════════════════════════════
    // POST
    // ═══════════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String base   = req.getContextPath() + "/admin/courses";

        try {
            switch (action == null ? "" : action) {

                case "insert" -> {
                    Course c = buildFromRequest(req);
                    boolean ok = courseDAO.insert(c);
                    if (ok) {
                        resp.sendRedirect(base + "?success=" + URLEncoder.encode("Thêm khóa học thành công!", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?error=" + URLEncoder.encode("Thêm thất bại, kiểm tra lại dữ liệu.", "UTF-8"));
                    }
                }

                case "update" -> {
                    Course c = buildFromRequest(req);
                    String idStr = req.getParameter("id");
                    
                    if (idStr == null || idStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("Không tìm thấy ID khóa học để cập nhật.");
                    }
                    
                    c.setId(Integer.parseInt(idStr));
                    boolean ok = courseDAO.update(c);
                    if (ok) {
                        resp.sendRedirect(base + "?success=" + URLEncoder.encode("Cập nhật khóa học thành công!", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?error=" + URLEncoder.encode("Cập nhật thất bại, vui lòng thử lại.", "UTF-8"));
                    }
                }

                case "delete" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = courseDAO.delete(id);
                    if (ok) {
                        resp.sendRedirect(base + "?success=" + URLEncoder.encode("Đã xóa khóa học.", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?error=" + URLEncoder.encode("Không thể xóa (đang có lớp học sử dụng, đã ẩn thay thế).", "UTF-8"));
                    }
                }

                default -> resp.sendRedirect(base);
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            // Mã hóa luôn cả lỗi hệ thống để không bị sập trang
            String errorDetails = URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8");
            resp.sendRedirect(base + "?error=" + errorDetails);
        }
    }

    // ═══════════════════════════════════════════════════════════
    // HELPER — hiển thị form thêm / sửa
    // ═══════════════════════════════════════════════════════════
    private void showForm(HttpServletRequest req, HttpServletResponse resp, Course course)
            throws ServletException, IOException {
        req.setAttribute("course",   course);           // null = thêm mới
        req.setAttribute("levels",   courseDAO.getLevels());
        req.setAttribute("teachers", courseDAO.getTeachers());
        forward(req, resp, "/WEB-INF/views/admin/course-form.jsp");
    }

    // ═══════════════════════════════════════════════════════════
    // HELPER — đọc form POST → Course object
    // ═══════════════════════════════════════════════════════════
    private Course buildFromRequest(HttpServletRequest req) {
        Course c = new Course();
        c.setName(req.getParameter("name").trim());
        c.setDescription(req.getParameter("description"));

        String levelId    = req.getParameter("levelId");
        String teacherId  = req.getParameter("teacherId");
        String duration   = req.getParameter("durationWeeks");
        String fee        = req.getParameter("tuitionFee");
        String maxStu     = req.getParameter("maxStudents");
        String isActive   = req.getParameter("isActive");

        c.setLevelId(levelId   != null && !levelId.isBlank()   ? Integer.parseInt(levelId)   : 0);
        c.setTeacherId(teacherId != null && !teacherId.isBlank() ? Integer.parseInt(teacherId) : 0);
        c.setDurationWeeks(duration != null && !duration.isBlank() ? Integer.parseInt(duration) : 12);
        c.setTuitionFee(fee    != null && !fee.isBlank()        ? Double.parseDouble(fee)     : 0);
        c.setMaxStudents(maxStu != null && !maxStu.isBlank()    ? Integer.parseInt(maxStu)    : 20);
        c.setActive("on".equals(isActive) || "true".equals(isActive));
        return c;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }
}