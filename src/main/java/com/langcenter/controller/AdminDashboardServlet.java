package com.langcenter.controller;

import com.langcenter.dao.EnrollmentDAO;
// Nhớ import ClassDAO và Model tương ứng của ông (ví dụ SchoolClass hoặc Class)
// import com.langcenter.dao.ClassDAO;
// import com.langcenter.model.SchoolClass; 
import com.langcenter.model.Enrollment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    // Khai báo DAO ở cấp độ Class (ngoài hàm doGet)
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    // private final ClassDAO classDAO = new ClassDAO(); // Bỏ comment khi ông đã có ClassDAO

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // 1. Đăng ký mới nhất (5 gần nhất)
        List<Enrollment> recentEnrollments = enrollmentDAO.getRecent(5);
        req.setAttribute("recentEnrollments", recentEnrollments);

        // 2. Lớp đang hoạt động (Bỏ comment 2 dòng dưới nếu ông đã code ClassDAO và SchoolClass)
        // List<SchoolClass> ongoingClasses = classDAO.getByStatus("ongoing");
        // req.setAttribute("ongoingClasses", ongoingClasses);

        // (các attribute cũ giữ nguyên)
        // req.setAttribute("totalCourses", ...);
        // req.setAttribute("totalOngoingClasses", ...);
        // req.setAttribute("totalPending", ...);
        // req.setAttribute("totalStudents", ...);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}