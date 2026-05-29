package com.langcenter.controller;

import com.langcenter.dao.EnrollmentDAO;
import com.langcenter.model.Enrollment;
import com.langcenter.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/courses")
public class EnrollmentServlet extends HttpServlet {
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User student = (User) req.getSession().getAttribute("loggedUser");
        if (student == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<Enrollment> availableClasses = enrollmentDAO.getAvailableClasses(student.getId());
        req.setAttribute("availableClasses", availableClasses);
        req.getRequestDispatcher("/WEB-INF/views/student/enrollment.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User student = (User) req.getSession().getAttribute("loggedUser");
        int classId = Integer.parseInt(req.getParameter("classId"));
        
        if (enrollmentDAO.enroll(student.getId(), classId)) {
            resp.sendRedirect(req.getContextPath() + "/student/courses?success=Dang ky thanh cong!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/courses?error=Loi dang ky!");
        }
    }
}