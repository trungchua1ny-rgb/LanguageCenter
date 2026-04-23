package com.langcenter.controller;

import com.langcenter.dao.StudentDAO;
import com.langcenter.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Servlet quản lý học viên — chỉ Admin truy cập (đã có AuthFilter bảo vệ).
 */
@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    // ═══════════════════════════════════════════════════════════
    // GET
    // ═══════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action  = req.getParameter("action");
        String keyword = req.getParameter("q");

        if ("detail".equals(action)) {
            showDetail(req, resp);
            return;
        }

        // Danh sách — có hoặc không có tìm kiếm
        List<User> students;
        if (keyword != null && !keyword.isBlank()) {
            students = studentDAO.search(keyword);
            req.setAttribute("keyword", keyword);
        } else {
            students = studentDAO.getAll();
        }

        req.setAttribute("students",   students);
        req.setAttribute("totalCount", students.size());
        req.setAttribute("successMsg", req.getParameter("success"));
        req.setAttribute("errorMsg",   req.getParameter("error"));

        forward(req, resp, "/WEB-INF/views/admin/student-list.jsp");
    }

    // ═══════════════════════════════════════════════════════════
    // POST — khóa / mở tài khoản
    // ═══════════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String base   = req.getContextPath() + "/admin/students";

        try {
            if ("toggle".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr == null || idStr.isBlank()) {
                    resp.sendRedirect(base + "?error=" + URLEncoder.encode("Thiếu thông tin học viên.", "UTF-8"));
                    return;
                }
                int id = Integer.parseInt(idStr);
                boolean ok = studentDAO.toggleActive(id);
                
                if (ok) {
                    resp.sendRedirect(base + "?success=" + URLEncoder.encode("Đã cập nhật trạng thái tài khoản.", "UTF-8"));
                } else {
                    resp.sendRedirect(base + "?error=" + URLEncoder.encode("Cập nhật thất bại, vui lòng thử lại.", "UTF-8"));
                }
            } else {
                resp.sendRedirect(base);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(base + "?error=" + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        }
    }

    // ═══════════════════════════════════════════════════════════
    // HELPER — trang chi tiết học viên
    // ═══════════════════════════════════════════════════════════
    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        String base  = req.getContextPath() + "/admin/students";

        try {
            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(base + "?error=" + URLEncoder.encode("Thiếu ID học viên.", "UTF-8"));
                return;
            }

            User student = studentDAO.getById(Integer.parseInt(idStr));
            if (student == null) {
                resp.sendRedirect(base + "?error=" + URLEncoder.encode("Không tìm thấy học viên.", "UTF-8"));
                return;
            }

            req.setAttribute("student",     student);
            req.setAttribute("enrollments", studentDAO.getEnrollmentsByStudent(student.getId()));
            forward(req, resp, "/WEB-INF/views/admin/student-detail.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(base + "?error=" + URLEncoder.encode("Lỗi hệ thống khi tải chi tiết.", "UTF-8"));
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }
}