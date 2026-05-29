package com.langcenter.controller;

import com.langcenter.model.User;
import com.langcenter.service.GeminiService;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/student/ai-consult")
public class AiConsultServlet extends HttpServlet {

    private final GeminiService geminiService = new GeminiService();
    private final Gson gson = new Gson();

    /** GET: hiển thị trang chatbot + lịch sử */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User me = (User) req.getSession().getAttribute("loggedUser");
        try {
            req.setAttribute("history", geminiService.getHistory(me.getId()));
        } catch (Exception e) {
            req.setAttribute("history", Collections.emptyList());
        }
        req.getRequestDispatcher("/WEB-INF/views/student/chatbot.jsp")
           .forward(req, resp);
    }

    /** POST: nhận câu hỏi → gọi GeminiService → trả JSON */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        User me       = (User) req.getSession().getAttribute("loggedUser");
        String userMsg = req.getParameter("question");
        Map<String, String> result = new HashMap<>();

        if (userMsg == null || userMsg.trim().isEmpty()) {
            result.put("error", "Câu hỏi không được để trống.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            String answer = geminiService.consult(me.getId(), userMsg.trim());
            result.put("answer", answer);
        } catch (Exception e) {
            result.put("error", "Lỗi AI: " + e.getMessage());
        }

        resp.getWriter().write(gson.toJson(result));
    }
}