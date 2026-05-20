package com.langcenter.dao;

import com.langcenter.model.SchoolClass;
import com.langcenter.model.Course;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * DAO quản lý lớp học.
 * Sửa lỗi:
 *   1. Đổi model Class → SchoolClass (tránh trùng java.lang.Class)
 *   2. Bỏ throws Exception — bắt lỗi trong try-catch bên trong, trả giá trị an toàn
 */
public class ClassDAO {

    private static final String SELECT =
        "SELECT cl.id, cl.course_id, cl.class_name, cl.start_date, cl.end_date, cl.status, " +
        "       co.name AS course_name, " +
        "       IFNULL(u.full_name,'Chưa phân công') AS teacher_name " +
        "FROM classes cl " +
        "JOIN courses co ON cl.course_id = co.id " +
        "LEFT JOIN users u ON co.teacher_id = u.id ";

    // ═══════════════════════════════════════════════════════════
    // 1. LẤY TẤT CẢ LỚP HỌC
    // ═══════════════════════════════════════════════════════════
    public List<SchoolClass> getAll() {
        List<SchoolClass> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "ORDER BY cl.id DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception ex) {
            System.err.println("[ClassDAO] getAll lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 2. LỌC THEO TRẠNG THÁI
    // ═══════════════════════════════════════════════════════════
    public List<SchoolClass> getByStatus(String status) {
        List<SchoolClass> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 SELECT + "WHERE cl.status=? ORDER BY cl.id DESC")) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception ex) {
            System.err.println("[ClassDAO] getByStatus lỗi: " + ex.getMessage());
        }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 3. LẤY 1 LỚP THEO ID
    // ═══════════════════════════════════════════════════════════
    public SchoolClass getById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE cl.id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception ex) {
            System.err.println("[ClassDAO] getById lỗi: " + ex.getMessage());
        }
        return null;
    }

    // ═══════════════════════════════════════════════════════════
    // 4. THÊM LỚP HỌC MỚI
    // ═══════════════════════════════════════════════════════════
    public boolean insert(SchoolClass cl) {
        String sql = "INSERT INTO classes (course_id, class_name, start_date, end_date, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,    cl.getCourseId());
            ps.setString(2, cl.getClassName());
            ps.setString(3, cl.getStartDate());
            ps.setString(4, cl.getEndDate());
            ps.setString(5, cl.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("[ClassDAO] insert lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 5. CẬP NHẬT LỚP HỌC
    // ═══════════════════════════════════════════════════════════
    public boolean update(SchoolClass cl) {
        String sql = "UPDATE classes SET course_id=?, class_name=?, start_date=?, " +
                     "end_date=?, status=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,    cl.getCourseId());
            ps.setString(2, cl.getClassName());
            ps.setString(3, cl.getStartDate());
            ps.setString(4, cl.getEndDate());
            ps.setString(5, cl.getStatus());
            ps.setInt(6,    cl.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("[ClassDAO] update lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 6. XÓA LỚP HỌC (chỉ xóa nếu chưa có enrollment)
    // ═══════════════════════════════════════════════════════════
    public boolean delete(int id) {
        String checkSql  = "SELECT COUNT(*) FROM enrollments WHERE class_id=?";
        String deleteSql = "DELETE FROM classes WHERE id=?";
        try (Connection c = DBConnection.getConnection()) {
            // Kiểm tra còn học viên đăng ký không
            try (PreparedStatement ps = c.prepareStatement(checkSql)) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    System.err.println("[ClassDAO] Không xóa được: lớp " + id + " còn enrollment.");
                    return false;
                }
            }
            // Xóa hẳn
            try (PreparedStatement ps = c.prepareStatement(deleteSql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception ex) {
            System.err.println("[ClassDAO] delete lỗi: " + ex.getMessage());
        }
        return false;
    }

    // ═══════════════════════════════════════════════════════════
    // 7. LẤY DANH SÁCH KHÓA HỌC (cho dropdown form)
    // ═══════════════════════════════════════════════════════════
    public List<Course> getCourses() {
        return new CourseDAO().getAllActive();
    }

    // ═══════════════════════════════════════════════════════════
    // HELPER — map ResultSet → SchoolClass
    // ═══════════════════════════════════════════════════════════
    private SchoolClass map(ResultSet rs) throws SQLException {
        SchoolClass cl = new SchoolClass();
        cl.setId(rs.getInt("id"));
        cl.setCourseId(rs.getInt("course_id"));
        cl.setClassName(rs.getString("class_name"));
        cl.setStartDate(rs.getString("start_date"));
        cl.setEndDate(rs.getString("end_date"));
        cl.setStatus(rs.getString("status"));
        cl.setCourseName(rs.getString("course_name"));
        cl.setTeacherName(rs.getString("teacher_name"));
        return cl;
    }
}