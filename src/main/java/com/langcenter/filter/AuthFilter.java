package com.langcenter.filter;



import javax.servlet.*;
import javax.servlet.annotation.WebFilter; // Dành cho AuthFilter
import javax.servlet.annotation.WebServlet; // Dành cho LogoutServlet
import javax.servlet.http.*;
import java.io.IOException;
import com.langcenter.model.User; // Dành cho AuthFilter

/**
 * Bộ lọc bảo vệ toàn bộ URL trừ /login, /assets.
 *
 * Cách hoạt động:
 *  - Nếu chưa login  → redirect /login
 *  - Nếu đã login    → tiếp tục, nhưng kiểm tra quyền theo role
 *
 * URL pattern:
 *  /admin/*   → chỉ role 'admin'
 *  /teacher/* → role 'admin' hoặc 'teacher'
 *  /student/* → tất cả role đã login
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    /** Các URL được truy cập mà KHÔNG cần đăng nhập */
    private static final String[] PUBLIC_URLS = {
        "/login", "/assets/", "/favicon.ico"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        // ── 1. Bỏ qua URL công khai ──────────────────────────────────────────
        for (String pub : PUBLIC_URLS) {
            if (uri.startsWith(ctx + pub)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // ── 2. Kiểm tra session ──────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            // Chưa đăng nhập → về trang login
            resp.sendRedirect(ctx + "/login");
            return;
        }

        // ── 3. Kiểm tra phân quyền theo URL ─────────────────────────────────
        String role = loggedUser.getRole();

        if (uri.startsWith(ctx + "/admin/") && !"admin".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Bạn không có quyền truy cập trang Admin.");
            return;
        }

        if (uri.startsWith(ctx + "/teacher/")
                && !"admin".equals(role) && !"teacher".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Bạn không có quyền truy cập trang Giáo viên.");
            return;
        }

        // ── 4. Cho phép đi tiếp ──────────────────────────────────────────────
        chain.doFilter(request, response);
    }
}