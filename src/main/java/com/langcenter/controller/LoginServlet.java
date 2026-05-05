package com.langcenter.controller;

import com.langcenter.dao.UserDAO;
import com.langcenter.model.User;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Xử lý đăng nhập.
 *
 * GET  /login  → hiển thị form login.jsp
 * POST /login  → xác thực username/password, tạo session, redirect theo role
 *
 * Dependency cần thêm vào pom.xml:
 *   <dependency>
 *     <groupId>org.mindrot</groupId>
 *     <artifactId>jbcrypt</artifactId>
 *     <version>0.4</version>
 *   </dependency>
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /** GET /login → show form */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu đã login rồi thì redirect thẳng về dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    /** POST /login → xác thực */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // ── 1. Validate đầu vào ──────────────────────────────────────────────
        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            setErrorAndForward(req, resp, "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
            return;
        }

        // ── 2. Tìm user trong DB ─────────────────────────────────────────────
        User user = userDAO.findByUsername(username.trim());

        if (user == null) {
            setErrorAndForward(req, resp, "Tài khoản không tồn tại.");
            return;
        }

        // ── 3. Kiểm tra tài khoản bị khoá ───────────────────────────────────
        if (!user.isActive()) {
            setErrorAndForward(req, resp, "Tài khoản đã bị khoá. Vui lòng liên hệ admin.");
            return;
        }

        // ── 4. Verify password bằng BCrypt ───────────────────────────────────
        boolean passwordMatch = BCrypt.checkpw(password, user.getPasswordHash());
        if (!passwordMatch) {
            setErrorAndForward(req, resp, "Mật khẩu không đúng.");
            return;
        }

        // ── 5. Tạo session ───────────────────────────────────────────────────
        HttpSession session = req.getSession(true);   // tạo session mới
        session.setAttribute("loggedUser", user);
        session.setMaxInactiveInterval(30 * 60);// hết hạn sau 30 phút
        
        session.setAttribute("role", user.getRole()); //add session role

        // ── 6. Redirect theo role ────────────────────────────────────────────
        String contextPath = req.getContextPath();
        switch (user.getRole()) {
            case "admin":
                resp.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case "teacher":
                resp.sendRedirect(contextPath + "/teacher/dashboard");
                break;
            default: // student
                resp.sendRedirect(contextPath + "/student/dashboard");
                break;
        }
    }

    /** Gắn lỗi vào request rồi forward về login.jsp */
    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", msg);
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }
}