package com.langcenter.controller;

import com.langcenter.dao.ClassDAO;
import com.langcenter.model.Class;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

@WebServlet("/admin/classes")
public class ClassServlet extends HttpServlet {

    private final ClassDAO dao = new ClassDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                req.setAttribute("courses", dao.getCourses());
                forward(req, resp, "class-form.jsp");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("classObj", dao.getById(id));
                req.setAttribute("courses",  dao.getCourses());
                forward(req, resp, "class-form.jsp");
            } else {
                String status = req.getParameter("status");
                req.setAttribute("classes",
                    (status != null && !status.isEmpty())
                        ? dao.getByStatus(status)
                        : dao.getAll());
                req.setAttribute("filterStatus", status);
                forward(req, resp, "class-list.jsp");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String msg = dao.delete(id) ? "delete_success=1" : "delete_failed=1";
                resp.sendRedirect(req.getContextPath() + "/admin/classes?" + msg);
                return;
            }
            Class cl = new Class();
            cl.setCourseId(Integer.parseInt(req.getParameter("courseId")));
            cl.setClassName(req.getParameter("className"));
            cl.setStartDate(req.getParameter("startDate"));
            cl.setEndDate(req.getParameter("endDate"));
            cl.setStatus(req.getParameter("status"));

            if ("insert".equals(action)) {
                dao.insert(cl);
                resp.sendRedirect(req.getContextPath() + "/admin/classes?insert_success=1");
            } else {
                cl.setId(Integer.parseInt(req.getParameter("id")));
                dao.update(cl);
                resp.sendRedirect(req.getContextPath() + "/admin/classes?update_success=1");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/admin/" + view).forward(req, resp);
    }
}