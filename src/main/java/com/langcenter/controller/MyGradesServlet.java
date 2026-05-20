package com.langcenter.controller;

import com.langcenter.dao.GradeDAO;
import com.langcenter.model.Grade;
import com.langcenter.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet: MyGradesServlet
 * URL: /student/grades
 *
 * GET /student/grades             → Toàn bộ điểm của student (tất cả lớp)
 * GET /student/grades?classId=X   → Điểm theo lớp cụ thể
 *     (nút "Xem điểm số" trong my-classes.jsp trỏ vào đây với classId)
 *
 * AuthFilter đã đảm bảo chỉ role='student' vào được /student/*
 */
@WebServlet("/student/grades")
public class MyGradesServlet extends HttpServlet {

    private final GradeDAO gradeDAO = new GradeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Lấy student đang login từ session
        User me = (User) req.getSession().getAttribute("loggedUser");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String classIdParam = req.getParameter("classId");
        List<Grade> grades;

        if (classIdParam != null && !classIdParam.isEmpty()) {
            // Xem điểm 1 lớp cụ thể
            try {
                int classId = Integer.parseInt(classIdParam);
                grades = gradeDAO.getByStudentAndClass(me.getId(), classId);
                req.setAttribute("filterClassId", classId);
            } catch (NumberFormatException e) {
                // classId lỗi → fallback xem toàn bộ
                grades = gradeDAO.getByStudentId(me.getId());
            }
        } else {
            // Xem toàn bộ điểm
            grades = gradeDAO.getByStudentId(me.getId());
        }

        // Tính điểm trung bình (nếu có dữ liệu)
        double avgScore = 0;
        if (!grades.isEmpty()) {
            double total    = grades.stream().mapToDouble(Grade::getScore).sum();
            double maxTotal = grades.stream().mapToDouble(Grade::getMaxScore).sum();
            if (maxTotal > 0) avgScore = Math.round((total / maxTotal) * 100.0 * 10.0) / 10.0;
        }

        req.setAttribute("grades",    grades);
        req.setAttribute("avgScore",  avgScore);
        req.setAttribute("totalExams", grades.size());

        req.getRequestDispatcher("/WEB-INF/views/student/my-grades.jsp")
           .forward(req, resp);
    }
}
