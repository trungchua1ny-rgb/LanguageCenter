package com.langcenter.controller;

import com.langcenter.dao.ScheduleDAO;
import com.langcenter.model.Schedule;
import com.langcenter.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * Servlet: MyScheduleServlet
 * URL: /student/schedule
 *
 * GET → Hiển thị TKB cá nhân của student đang login.
 *       Dữ liệu được group theo ngày trong tuần để hiển thị dạng lịch tuần.
 *
 * AuthFilter đã đảm bảo chỉ role='student' vào được /student/*
 */
@WebServlet("/student/schedule")
public class MyScheduleServlet extends HttpServlet {

    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

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

        // Query TKB cá nhân
        List<Schedule> allSchedules = scheduleDAO.getByStudentId(me.getId());

        // Group theo ngày trong tuần (LinkedHashMap để giữ thứ tự Mon → Sun)
        Map<String, List<Schedule>> scheduleByDay = new LinkedHashMap<>();
        String[] dayOrder = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
        for (String d : dayOrder) {
            scheduleByDay.put(d, new ArrayList<>());
        }
        for (Schedule sc : allSchedules) {
            String day = sc.getDayOfWeek();
            if (scheduleByDay.containsKey(day)) {
                scheduleByDay.get(day).add(sc);
            }
        }

        req.setAttribute("scheduleByDay", scheduleByDay);
        req.setAttribute("allSchedules", allSchedules);
        req.setAttribute("totalSessions", allSchedules.size());

        req.getRequestDispatcher("/WEB-INF/views/student/my-schedule.jsp")
           .forward(req, resp);
    }
}
