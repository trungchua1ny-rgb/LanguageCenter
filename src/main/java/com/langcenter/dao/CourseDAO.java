package com.langcenter.dao;

import com.langcenter.model.Course;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý toàn bộ truy vấn liên quan đến khóa học.
 * Admin: CRUD đầy đủ
 * Student: chỉ đọc (getAll, getById)
 */
public class CourseDAO {

    // ═══════════════════════════════════════════════════════════
    // DÙNG CHUNG — map ResultSet → Course object
    // ═══════════════════════════════════════════════════════════
    private Course mapRow(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setLevelId(rs.getInt("level_id"));
        c.setLevelName(rs.getString("level_name"));
        c.setTeacherId(rs.getInt("teacher_id"));
        c.setTeacherName(rs.getString("teacher_name"));
        c.setDurationWeeks(rs.getInt("duration_weeks"));
        c.setTuitionFee(rs.getDouble("tuition_fee"));
        c.setMaxStudents(rs.getInt("max_students"));
        c.setActive(rs.getBoolean("is_active"));
        return c;
    }

    // Query JOIN dùng lại nhiều chỗ
    private static final String BASE_SELECT =
        "SELECT c.*, " +
        "  l.name AS level_name, " +
        "  u.full_name AS teacher_name " +
        "FROM courses c " +
        "LEFT JOIN levels l ON l.id = c.level_id " +
        "LEFT JOIN users  u ON u.id = c.teacher_id ";

    // ═══════════════════════════════════════════════════════════
    // 1. LẤY TẤT CẢ KHÓA HỌC (Admin xem toàn bộ)
    // ═══════════════════════════════════════════════════════════
    public List<Course> getAll() {
        List<Course> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY c.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));

        } catch (Exception ex) {
            System.err.println("[CourseDAO] getAll lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 2. LẤY KHÓA HỌC ĐANG ACTIVE (Student xem để đăng ký)
    // ═══════════════════════════════════════════════════════════
    public List<Course> getAllActive() {
        List<Course> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE c.is_active = TRUE ORDER BY c.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));

        } catch (Exception ex) {
            System.err.println("[CourseDAO] getAllActive lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 3. LẤY 1 KHÓA HỌC THEO ID
    // ═══════════════════════════════════════════════════════════
    public Course getById(int id) {
        String sql = BASE_SELECT + "WHERE c.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }

        } catch (Exception ex) {
            System.err.println("[CourseDAO] getById lỗi: " + ex.getMessage());
        }
        return null;
    }

    // ═══════════════════════════════════════════════════════════
    // 4. THÊM MỚI KHÓA HỌC
    // ═══════════════════════════════════════════════════════════
    public boolean insert(Course c) {
        String sql =
            "INSERT INTO courses " +
            "(name, description, level_id, teacher_id, duration_weeks, tuition_fee, max_students, is_active) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getLevelId());
            // teacher_id có thể NULL
            if (c.getTeacherId() > 0) ps.setInt(4, c.getTeacherId());
            else ps.setNull(4, Types.INTEGER);
            ps.setInt(5, c.getDurationWeeks());
            ps.setDouble(6, c.getTuitionFee());
            ps.setInt(7, c.getMaxStudents());
            ps.setBoolean(8, c.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception ex) {
            System.err.println("[CourseDAO] insert lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 5. CẬP NHẬT KHÓA HỌC
    // ═══════════════════════════════════════════════════════════
    public boolean update(Course c) {
        String sql =
            "UPDATE courses SET " +
            "name=?, description=?, level_id=?, teacher_id=?, " +
            "duration_weeks=?, tuition_fee=?, max_students=?, is_active=? " +
            "WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getLevelId());
            if (c.getTeacherId() > 0) ps.setInt(4, c.getTeacherId());
            else ps.setNull(4, Types.INTEGER);
            ps.setInt(5, c.getDurationWeeks());
            ps.setDouble(6, c.getTuitionFee());
            ps.setInt(7, c.getMaxStudents());
            ps.setBoolean(8, c.isActive());
            ps.setInt(9, c.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception ex) {
            System.err.println("[CourseDAO] update lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 6. XÓA KHÓA HỌC (chỉ xóa được nếu chưa có lớp nào)
    // ═══════════════════════════════════════════════════════════
    public boolean delete(int id) {
        // Kiểm tra còn lớp học không trước khi xóa
        String checkSql = "SELECT COUNT(*) FROM classes WHERE course_id = ?";
        String deleteSql = "DELETE FROM courses WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {

            // Kiểm tra
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // Có lớp đang dùng → không xóa, chỉ ẩn đi
                    return deactivate(id);
                }
            }

            // Xóa hẳn
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }

        } catch (Exception ex) {
            System.err.println("[CourseDAO] delete lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 7. ẨN/HIỆN KHÓA HỌC (soft delete)
    // ═══════════════════════════════════════════════════════════
    public boolean deactivate(int id) {
        String sql = "UPDATE courses SET is_active = FALSE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("[CourseDAO] deactivate lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 8. LẤY DANH SÁCH LEVEL (cho dropdown form)
    // ═══════════════════════════════════════════════════════════
    public List<int[]> getAllLevels() {
        // Trả về list [id, name] đơn giản
        List<int[]> list = new ArrayList<>();
        String sql = "SELECT id, name FROM levels ORDER BY sort_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Dùng Map thay int[] cho dễ đọc hơn nếu muốn
                list.add(new int[]{rs.getInt("id")});
            }
        } catch (Exception ex) {
            System.err.println("[CourseDAO] getAllLevels lỗi: " + ex.getMessage());
        }
        return list;
    }

    // Phiên bản trả về List<Level> đúng hơn — dùng cái này
    public List<com.langcenter.model.Level> getLevels() {
        List<com.langcenter.model.Level> list = new ArrayList<>();
        String sql = "SELECT id, name FROM levels ORDER BY sort_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                com.langcenter.model.Level lv = new com.langcenter.model.Level();
                lv.setId(rs.getInt("id"));
                lv.setName(rs.getString("name"));
                list.add(lv);
            }
        } catch (Exception ex) {
            System.err.println("[CourseDAO] getLevels lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 9. LẤY DANH SÁCH GIÁO VIÊN (cho dropdown form)
    // ═══════════════════════════════════════════════════════════
    public List<com.langcenter.model.User> getTeachers() {
        List<com.langcenter.model.User> list = new ArrayList<>();
        String sql = "SELECT id, full_name FROM users WHERE role = 'teacher' AND is_active = TRUE ORDER BY full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                com.langcenter.model.User u = new com.langcenter.model.User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                list.add(u);
            }
        } catch (Exception ex) {
            System.err.println("[CourseDAO] getTeachers lỗi: " + ex.getMessage());
        }
        return list;
    }
}