package com.langcenter.controller;

import com.langcenter.dao.GradeDAO;
import com.langcenter.model.Grade;
import com.langcenter.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/grades")
public class MyGradesServlet extends HttpServlet {

    private final GradeDAO gradeDAO = new GradeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // 1. Lấy user đang đăng nhập từ Session
        User me = (User) req.getSession().getAttribute("loggedUser");
        if (me == null || !"student".equals(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int studentId = me.getId();

        // 2. Lấy danh sách lớp mà student này ĐÃ ĐĂNG KÝ (truyền cho Dropdown)
        List<String[]> myClasses = gradeDAO.getEnrolledClassesByStudent(studentId);
        req.setAttribute("myEnrolledClasses", myClasses);

        // 3. Xử lý Lọc theo ClassId hoặc lấy Toàn bộ
        String classIdParam = req.getParameter("classId");
        List<Grade> grades;
        
        if (classIdParam != null && !classIdParam.isEmpty()) {
            try {
                int classId = Integer.parseInt(classIdParam);
                grades = gradeDAO.getByStudentAndClass(studentId, classId);
                req.setAttribute("filterClassId", classId);

                // Tìm tên lớp học để hiển thị lên dòng Alert màu xanh
                for (String[] c : myClasses) {
                    if (Integer.parseInt(c[0]) == classId) {
                        req.setAttribute("filterClassName", c[1] + " - " + c[2]);
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                grades = gradeDAO.getByStudentId(studentId);
            }
        } else {
            grades = gradeDAO.getByStudentId(studentId);
        }

        req.setAttribute("grades", grades);

        // 4. Tính toán số liệu thống kê hiển thị Card
        int totalExams = grades.size();
        double sumScore = 0;
        double sumMax = 0;
        for (Grade g : grades) {
            sumScore += g.getScore();
            sumMax += g.getMaxScore();
        }
        
        int avgScore = (sumMax > 0) ? (int) Math.round((sumScore / sumMax) * 100) : 0;

        req.setAttribute("totalExams", totalExams);
        req.setAttribute("avgScore", avgScore);

        req.getRequestDispatcher("/WEB-INF/views/student/my-grades.jsp").forward(req, resp);
    }
}