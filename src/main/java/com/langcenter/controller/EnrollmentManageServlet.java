package com.langcenter.controller;

import com.langcenter.dao.EnrollmentManageDAO;
import com.langcenter.model.Enrollment;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Servlet Admin quản lý danh sách đăng ký khóa học.
 */
@WebServlet("/admin/enrollments")
public class EnrollmentManageServlet extends HttpServlet {

    private final EnrollmentManageDAO dao = new EnrollmentManageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String status = req.getParameter("status"); // pending | paid | refunded | null

        List<Enrollment> list;
        if (status != null && !status.isBlank()) {
            list = dao.getByStatus(status);
        } else {
            list = dao.getAll();
        }

        // Badge đếm cho tab filter
        req.setAttribute("countPending",  dao.countByStatus("pending"));
        req.setAttribute("countPaid",     dao.countByStatus("paid"));
        req.setAttribute("countRefunded", dao.countByStatus("refunded"));

        req.setAttribute("enrollments",  list);
        req.setAttribute("activeStatus", status);
        req.setAttribute("successMsg",   req.getParameter("success"));
        req.setAttribute("errorMsg",     req.getParameter("error"));

        req.getRequestDispatcher("/WEB-INF/views/admin/enrollment-manage.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");
        String base   = req.getContextPath() + "/admin/enrollments";

        try {
            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(base + "?error=" + URLEncoder.encode("Thiếu thông tin đăng ký.", "UTF-8"));
                return;
            }

            int id = Integer.parseInt(idStr);

            switch (action == null ? "" : action) {

                case "approve" -> {
                    boolean ok = dao.updateStatus(id, "paid");
                    if (ok) {
                        resp.sendRedirect(base + "?status=pending&success=" + URLEncoder.encode("Đã xác nhận thanh toán thành công!", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?status=pending&error=" + URLEncoder.encode("Xác nhận thất bại, vui lòng thử lại.", "UTF-8"));
                    }
                }

                case "cancel" -> {
                    boolean ok = dao.updateStatus(id, "cancelled");
                    if (ok) {
                        resp.sendRedirect(base + "?success=" + URLEncoder.encode("Đã hủy đăng ký.", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?error=" + URLEncoder.encode("Hủy thất bại, vui lòng thử lại.", "UTF-8"));
                    }
                }

                case "refund" -> {
                    boolean ok = dao.updateStatus(id, "refunded");
                    if (ok) {
                        resp.sendRedirect(base + "?status=paid&success=" + URLEncoder.encode("Đã hoàn tiền cho học viên.", "UTF-8"));
                    } else {
                        resp.sendRedirect(base + "?status=paid&error=" + URLEncoder.encode("Hoàn tiền thất bại, vui lòng thử lại.", "UTF-8"));
                    }
                }

                default -> resp.sendRedirect(base);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(base + "?error=" + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        }
    }
}