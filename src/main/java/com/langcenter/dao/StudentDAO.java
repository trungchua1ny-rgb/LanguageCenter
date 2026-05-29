package com.langcenter.dao;

import com.langcenter.model.User;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO quản lý học viên (role = 'student') dành cho Admin.
 */
public class StudentDAO {

    // ═══════════════════════════════════════════════════════════
    // HELPER — map ResultSet → User
    // ═══════════════════════════════════════════════════════════
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        // Số lớp đang học (từ COUNT join)
        try { u.setEnrollmentCount(rs.getInt("enrollment_count")); }
        catch (SQLException ignored) {}
        return u;
    }

    // ═══════════════════════════════════════════════════════════
    // 1. LẤY TẤT CẢ HỌC VIÊN (kèm số lớp đang học)
    // ═══════════════════════════════════════════════════════════
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql =
            "SELECT u.*, " +
            "  (SELECT COUNT(*) FROM enrollments e " +
            "   WHERE e.student_id = u.id " +
            "   AND e.payment_status != 'cancelled') AS enrollment_count " +
            "FROM users u " +
            "WHERE u.role = 'student' " +
            "ORDER BY u.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception ex) {
            System.err.println("[StudentDAO] getAll lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 2. TÌM KIẾM HỌC VIÊN theo tên / email / username
    // ═══════════════════════════════════════════════════════════
    public List<User> search(String keyword) {
        List<User> list = new ArrayList<>();
        String sql =
            "SELECT u.*, " +
            "  (SELECT COUNT(*) FROM enrollments e " +
            "   WHERE e.student_id = u.id " +
            "   AND e.payment_status != 'cancelled') AS enrollment_count " +
            "FROM users u " +
            "WHERE u.role = 'student' " +
            "  AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ?) " +
            "ORDER BY u.full_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception ex) {
            System.err.println("[StudentDAO] search lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 3. LẤY 1 HỌC VIÊN THEO ID
    // ═══════════════════════════════════════════════════════════
    public User getById(int id) {
        String sql =
            "SELECT u.*, 0 AS enrollment_count " +
            "FROM users u WHERE u.id = ? AND u.role = 'student'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception ex) {
            System.err.println("[StudentDAO] getById lỗi: " + ex.getMessage());
        }
        return null;
    }

    // ═══════════════════════════════════════════════════════════
    // 4. KHÓA / MỞ TÀI KHOẢN (toggle is_active)
    // ═══════════════════════════════════════════════════════════
    public boolean toggleActive(int id) {
        String sql = "UPDATE users SET is_active = NOT is_active WHERE id = ? AND role = 'student'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("[StudentDAO] toggleActive lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 5. LẤY DANH SÁCH LỚP HỌC CỦA 1 HỌC VIÊN (cho trang detail)
    // ═══════════════════════════════════════════════════════════
    public List<String[]> getEnrollmentsByStudent(int studentId) {
        List<String[]> list = new ArrayList<>();
        String sql =
            "SELECT cl.class_name, co.name AS course_name, " +
            "       e.payment_status, cl.status AS class_status, " +
            "       e.enrolled_date " +
            "FROM enrollments e " +
            "JOIN classes cl ON cl.id = e.class_id " +
            "JOIN courses co ON co.id = cl.course_id " +
            "WHERE e.student_id = ? AND e.payment_status != 'cancelled' " +
            "ORDER BY e.enrolled_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("class_name"),
                        rs.getString("course_name"),
                        rs.getString("payment_status"),
                        rs.getString("class_status"),
                        rs.getString("enrolled_date")
                    });
                }
            }
        } catch (Exception ex) {
            System.err.println("[StudentDAO] getEnrollmentsByStudent lỗi: " + ex.getMessage());
        }
        return list;
    }
}
