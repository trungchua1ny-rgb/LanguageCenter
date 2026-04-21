package com.langcenter.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("appName", "Trung tâm Ngoại ngữ");
        req.getRequestDispatcher(
            "/views/common/home.jsp").forward(req, resp);
    }
}