package com.langcenter.dao;

import com.langcenter.model.Enrollment;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO quản lý đăng ký khóa học phía Admin.
 * (Tách riêng với EnrollmentDAO của Student để không rối)
 */
public class EnrollmentManageDAO {

    // ═══════════════════════════════════════════════════════════
    // HELPER — map ResultSet → Enrollment
    // ═══════════════════════════════════════════════════════════
    private Enrollment mapRow(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setId(rs.getInt("id"));
        e.setStudentName(rs.getString("student_name"));
        e.setClassName(rs.getString("class_name"));
        e.setCourseName(rs.getString("course_name"));
        e.setLevelName(rs.getString("level_name"));
        e.setTuitionFee(rs.getDouble("tuition_fee"));
        e.setPaymentStatus(rs.getString("payment_status"));
        e.setEnrolledDate(rs.getDate("enrolled_date").toLocalDate());
        return e;
    }

    // ═══════════════════════════════════════════════════════════
    // 1. LẤY TẤT CẢ ĐĂNG KÝ (Admin xem toàn bộ)
    // ═══════════════════════════════════════════════════════════
    public List<Enrollment> getAll() {
        List<Enrollment> list = new ArrayList<>();
        String sql =
            "SELECT e.id, e.enrolled_date, e.payment_status, " +
            "  u.full_name AS student_name, " +
            "  cl.class_name, co.name AS course_name, " +
            "  co.tuition_fee, lv.name AS level_name " +
            "FROM enrollments e " +
            "JOIN users   u  ON u.id  = e.student_id " +
            "JOIN classes cl ON cl.id = e.class_id " +
            "JOIN courses co ON co.id = cl.course_id " +
            "JOIN levels  lv ON lv.id = co.level_id " +
            "WHERE e.payment_status != 'cancelled' " +
            "ORDER BY e.enrolled_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception ex) {
            System.err.println("[EnrollmentManageDAO] getAll lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 2. LỌC THEO TRẠNG THÁI THANH TOÁN
    // ═══════════════════════════════════════════════════════════
    public List<Enrollment> getByStatus(String status) {
        List<Enrollment> list = new ArrayList<>();
        String sql =
            "SELECT e.id, e.enrolled_date, e.payment_status, " +
            "  u.full_name AS student_name, " +
            "  cl.class_name, co.name AS course_name, " +
            "  co.tuition_fee, lv.name AS level_name " +
            "FROM enrollments e " +
            "JOIN users   u  ON u.id  = e.student_id " +
            "JOIN classes cl ON cl.id = e.class_id " +
            "JOIN courses co ON co.id = cl.course_id " +
            "JOIN levels  lv ON lv.id = co.level_id " +
            "WHERE e.payment_status = ? " +
            "ORDER BY e.enrolled_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception ex) {
            System.err.println("[EnrollmentManageDAO] getByStatus lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 3. CẬP NHẬT TRẠNG THÁI THANH TOÁN
    //    'pending' → 'paid'     : Admin xác nhận đã thu tiền
    //    'paid'    → 'refunded' : Hoàn tiền
    //    any       → 'cancelled': Hủy đăng ký
    // ═══════════════════════════════════════════════════════════
    public boolean updateStatus(int enrollmentId, String newStatus) {
        String sql = "UPDATE enrollments SET payment_status = ?, " +
                     "paid_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            // Chỉ set paid_at khi xác nhận thanh toán
            if ("paid".equals(newStatus)) {
                ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(2, Types.TIMESTAMP);
            }
            ps.setInt(3, enrollmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("[EnrollmentManageDAO] updateStatus lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 4. ĐẾM SỐ ĐĂNG KÝ THEO TỪNG TRẠNG THÁI (cho badge header)
    // ═══════════════════════════════════════════════════════════
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE payment_status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception ex) {
            System.err.println("[EnrollmentManageDAO] countByStatus lỗi: " + ex.getMessage());
        }
        return 0;
    }
}
