package com.langcenter.controller;

import com.langcenter.dao.EnrollmentDAO;
import com.langcenter.model.Enrollment;
import com.langcenter.model.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/student/dashboard")
public class DashboardStudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User me = (User) req.getSession().getAttribute("loggedUser");
        try {
            List<Enrollment> myClasses =
                new EnrollmentDAO().getAvailableClasses(me.getId());
            req.setAttribute("myClasses", myClasses);
        } catch (Exception e) {
            req.setAttribute("myClasses", Collections.emptyList());
        }

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard-student.jsp")
           .forward(req, resp);
    }
}