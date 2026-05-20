package com.langcenter.controller;

import com.langcenter.dao.GradeDAO;
import com.langcenter.model.Grade;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Servlet: GradeServlet
 * URL: /admin/grades
 *
 * GET  /admin/grades                     → Yêu cầu chọn lớp (nếu chưa có classId)
 * GET  /admin/grades?classId=X           → Xem danh sách điểm cả lớp X
 * POST /admin/grades?action=insert       → Nhập điểm mới
 * POST /admin/grades?action=update       → Sửa điểm
 * POST /admin/grades?action=delete       → Xóa điểm
 *
 * AuthFilter đã đảm bảo chỉ role='admin' vào được /admin/*
 */
@WebServlet("/admin/grades")
public class GradeServlet extends HttpServlet {

    private final GradeDAO gradeDAO = new GradeDAO();

    // ─── GET ──────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Luôn load danh sách lớp cho dropdown lọc
        req.setAttribute("allClasses", gradeDAO.getActiveClasses());

        String classIdParam = req.getParameter("classId");

        if (classIdParam != null && !classIdParam.isEmpty()) {
            try {
                int classId = Integer.parseInt(classIdParam);

                List<Grade> grades       = gradeDAO.getByClassId(classId);
                List<String[]> students  = gradeDAO.getEnrollmentsByClass(classId);

                req.setAttribute("grades",          grades);
                req.setAttribute("students",         students);
                req.setAttribute("selectedClassId",  classId);

                // Nếu có editId → load data vào form sửa
                String editIdParam = req.getParameter("editId");
                if (editIdParam != null) {
                    try {
                        int editId = Integer.parseInt(editIdParam);
                        Grade editGrade = gradeDAO.getById(editId);
                        if (editGrade != null) req.setAttribute("editGrade", editGrade);
                    } catch (NumberFormatException ignored) {}
                }

            } catch (NumberFormatException e) {
                req.setAttribute("errorMsg", "classId không hợp lệ.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/grade-manage.jsp")
           .forward(req, resp);
    }

    // ─── POST ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action    = req.getParameter("action");
        String classIdStr = req.getParameter("classId");

        switch (action == null ? "" : action) {
            case "insert": handleInsert(req, resp, classIdStr); break;
            case "update": handleUpdate(req, resp, classIdStr); break;
            case "delete": handleDelete(req, resp, classIdStr); break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/grades");
        }
    }

    // ─── INSERT ───────────────────────────────────────────
    private void handleInsert(HttpServletRequest req, HttpServletResponse resp,
                              String classIdStr) throws IOException {

        String enrollIdStr  = req.getParameter("enrollmentId");
        String examName     = req.getParameter("examName");
        String scoreStr     = req.getParameter("score");
        String maxScoreStr  = req.getParameter("maxScore");
        String examDateStr  = req.getParameter("examDate");
        String note         = req.getParameter("note");

        if (isBlank(enrollIdStr) || isBlank(examName) || isBlank(scoreStr) || isBlank(maxScoreStr)) {
            redirect(resp, req, classIdStr, "error=missing_fields");
            return;
        }

        try {
            int enrollId    = Integer.parseInt(enrollIdStr);
            double score    = Double.parseDouble(scoreStr);
            double maxScore = Double.parseDouble(maxScoreStr);

            if (score < 0 || maxScore <= 0 || score > maxScore) {
                redirect(resp, req, classIdStr, "error=invalid_score");
                return;
            }

            LocalDate examDate = parseDate(examDateStr);

            Grade g = new Grade(enrollId, examName.trim(), score, maxScore, examDate, note);
            boolean ok = gradeDAO.insert(g);
            redirect(resp, req, classIdStr, ok ? "success=inserted" : "error=db_fail");

        } catch (NumberFormatException e) {
            redirect(resp, req, classIdStr, "error=invalid_number");
        }
    }

    // ─── UPDATE ───────────────────────────────────────────
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp,
                              String classIdStr) throws IOException {

        String idStr        = req.getParameter("id");
        String examName     = req.getParameter("examName");
        String scoreStr     = req.getParameter("score");
        String maxScoreStr  = req.getParameter("maxScore");
        String examDateStr  = req.getParameter("examDate");
        String note         = req.getParameter("note");

        if (isBlank(idStr) || isBlank(examName) || isBlank(scoreStr) || isBlank(maxScoreStr)) {
            redirect(resp, req, classIdStr, "error=missing_fields");
            return;
        }

        try {
            int    id       = Integer.parseInt(idStr);
            double score    = Double.parseDouble(scoreStr);
            double maxScore = Double.parseDouble(maxScoreStr);

            if (score < 0 || maxScore <= 0 || score > maxScore) {
                redirect(resp, req, classIdStr, "error=invalid_score");
                return;
            }

            Grade g = new Grade();
            g.setId(id);
            g.setExamName(examName.trim());
            g.setScore(score);
            g.setMaxScore(maxScore);
            g.setExamDate(parseDate(examDateStr));
            g.setNote(note);

            boolean ok = gradeDAO.update(g);
            redirect(resp, req, classIdStr, ok ? "success=updated" : "error=db_fail");

        } catch (NumberFormatException e) {
            redirect(resp, req, classIdStr, "error=invalid_number");
        }
    }

    // ─── DELETE ───────────────────────────────────────────
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp,
                              String classIdStr) throws IOException {

        String idStr = req.getParameter("id");
        if (isBlank(idStr)) {
            redirect(resp, req, classIdStr, "error=missing_id");
            return;
        }
        try {
            int id     = Integer.parseInt(idStr);
            boolean ok = gradeDAO.delete(id);
            redirect(resp, req, classIdStr, ok ? "success=deleted" : "error=db_fail");
        } catch (NumberFormatException e) {
            redirect(resp, req, classIdStr, "error=invalid_id");
        }
    }

    // ─── HELPER ───────────────────────────────────────────
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private LocalDate parseDate(String s) {
        if (isBlank(s)) return LocalDate.now();
        try { return LocalDate.parse(s); }
        catch (DateTimeParseException e) { return LocalDate.now(); }
    }

    private void redirect(HttpServletResponse resp, HttpServletRequest req,
                          String classId, String query) throws IOException {
        StringBuilder url = new StringBuilder(req.getContextPath() + "/admin/grades");
        if (classId != null && !classId.isEmpty()) {
            url.append("?classId=").append(classId).append("&").append(query);
        } else {
            url.append("?").append(query);
        }
        resp.sendRedirect(url.toString());
    }
}
