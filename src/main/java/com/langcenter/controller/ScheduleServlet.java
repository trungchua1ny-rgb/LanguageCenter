package com.langcenter.controller;

import com.langcenter.dao.ClassDAO;
import com.langcenter.dao.ScheduleDAO;
import com.langcenter.model.Schedule;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet: ScheduleServlet
 * URL: /admin/schedules
 *
 * GET  /admin/schedules?classId=X              → Xem TKB của lớp đó
 * GET  /admin/schedules                        → Yêu cầu chọn lớp (nếu chưa có classId)
 * POST /admin/schedules?action=add             → Thêm buổi học mới
 * POST /admin/schedules?action=delete          → Xóa 1 buổi học
 *
 * AuthFilter đã đảm bảo chỉ role='admin' vào được /admin/*
 */
@WebServlet("/admin/schedules")
public class ScheduleServlet extends HttpServlet {

    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final ClassDAO classDAO = new ClassDAO(); // Khởi tạo ClassDAO để lấy danh sách lớp

    // ─── GET ──────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String classIdParam = req.getParameter("classId");

        // 1. Luôn load danh sách lớp học cho dropdown lọc (Phần ông bị thiếu)
        req.setAttribute("allClasses", classDAO.getAll());

        // 2. Luôn load danh sách phòng học cho dropdown form thêm
        req.setAttribute("rooms", scheduleDAO.getAllRooms());

        if (classIdParam != null && !classIdParam.isEmpty()) {
            try {
                int classId = Integer.parseInt(classIdParam);
                List<Schedule> schedules = scheduleDAO.getByClassId(classId);
                req.setAttribute("schedules", schedules);
                req.setAttribute("selectedClassId", classId);
            } catch (NumberFormatException e) {
                req.setAttribute("errorMsg", "classId không hợp lệ.");
            }
        }
        // else: không có classId → JSP sẽ hiển thị hướng dẫn chọn lớp

        req.getRequestDispatcher("/WEB-INF/views/admin/schedule-manage.jsp")
           .forward(req, resp);
    }

    // ─── POST ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            handleAdd(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/schedules");
        }
    }

    // ─── ADD ──────────────────────────────────────────────
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String classIdStr = req.getParameter("classId");
        String roomIdStr  = req.getParameter("roomId");
        String day        = req.getParameter("dayOfWeek");
        String start      = req.getParameter("startTime");
        String end        = req.getParameter("endTime");

        // Validate cơ bản
        if (isBlank(classIdStr) || isBlank(roomIdStr) || isBlank(day)
                || isBlank(start) || isBlank(end)) {
            redirect(resp, req, classIdStr, "error=missing_fields");
            return;
        }

        int classId, roomId;
        try {
            classId = Integer.parseInt(classIdStr);
            roomId  = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            redirect(resp, req, classIdStr, "error=invalid_id");
            return;
        }

        // Validate giờ: start phải trước end
        if (start.compareTo(end) >= 0) {
            redirect(resp, req, classIdStr, "error=invalid_time");
            return;
        }

        // Kiểm tra conflict phòng học
        if (scheduleDAO.hasConflict(roomId, day, start, end, 0)) {
            redirect(resp, req, classIdStr, "error=room_conflict");
            return;
        }

        Schedule sc = new Schedule(classId, roomId, day, start, end);
        boolean ok = scheduleDAO.insert(sc);

        redirect(resp, req, classIdStr, ok ? "success=added" : "error=db_fail");
    }

    // ─── DELETE ───────────────────────────────────────────
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String idStr      = req.getParameter("id");
        String classIdStr = req.getParameter("classId");

        if (isBlank(idStr)) {
            redirect(resp, req, classIdStr, "error=missing_id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean ok = scheduleDAO.delete(id);
            redirect(resp, req, classIdStr, ok ? "success=deleted" : "error=db_fail");
        } catch (NumberFormatException e) {
            redirect(resp, req, classIdStr, "error=invalid_id");
        }
    }

    // ─── HELPER ───────────────────────────────────────────
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** Redirect về trang TKB của lớp (kèm classId nếu có) */
    private void redirect(HttpServletResponse resp, HttpServletRequest req,
                          String classId, String query) throws IOException {
        StringBuilder url = new StringBuilder(req.getContextPath() + "/admin/schedules");
        if (classId != null && !classId.isEmpty()) {
            url.append("?classId=").append(classId).append("&").append(query);
        } else {
            url.append("?").append(query);
        }
        resp.sendRedirect(url.toString());
    }
}