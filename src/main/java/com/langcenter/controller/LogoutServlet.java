package com.langcenter.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter; // Dành cho AuthFilter
import javax.servlet.annotation.WebServlet; // Dành cho LogoutServlet
import javax.servlet.http.*;
import java.io.IOException;
import com.langcenter.model.User; // Dành cho AuthFilter
/**
 * GET hoặc POST /logout → huỷ session và redirect về trang login.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        logout(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        logout(req, resp);
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();   // xoá toàn bộ session
        }
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}