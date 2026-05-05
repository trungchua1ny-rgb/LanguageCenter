package com.langcenter.controller;

import com.langcenter.dao.EnrollmentDAO;
import com.langcenter.model.Enrollment;
import com.langcenter.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị danh sách lớp học của Student đang đăng nhập.
 *
 * GET /student/my-classes → danh sách lớp đã đăng ký + lịch + trạng thái
 */
@WebServlet("/student/my-classes")
public class MyClassesServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User student = (User) req.getSession().getAttribute("loggedUser");

        List<Enrollment> myClasses = enrollmentDAO.getMyEnrollments(student.getId());

        // Tách thành 2 nhóm để hiển thị rõ hơn trên JSP
        long activeCount = myClasses.stream()
            .filter(e -> "ongoing".equals(e.getClassStatus())
                      || "upcoming".equals(e.getClassStatus()))
            .count();

        req.setAttribute("myClasses",   myClasses);
        req.setAttribute("activeCount", activeCount);
        req.setAttribute("totalCount",  myClasses.size());
        req.setAttribute("successMsg",  req.getParameter("success"));

        req.getRequestDispatcher("/WEB-INF/views/student/my-classes.jsp")
           .forward(req, resp);
    }
}
