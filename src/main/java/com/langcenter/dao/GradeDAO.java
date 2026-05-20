package com.langcenter.dao;

import com.langcenter.model.Grade;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO: GradeDAO — Thao tác DB với bảng grades
 * Chỉ chứa SQL, không có business logic.
 */
public class GradeDAO {

    // ─── MAP ROW → Grade ──────────────────────────────────
    private Grade mapRow(ResultSet rs) throws SQLException {
        Grade g = new Grade();
        g.setId(rs.getInt("id"));
        g.setEnrollmentId(rs.getInt("enrollment_id"));
        g.setStudentName(rs.getString("student_name"));
        g.setClassName(rs.getString("class_name"));
        g.setCourseName(rs.getString("course_name"));
        g.setExamName(rs.getString("exam_name"));
        g.setScore(rs.getDouble("score"));
        g.setMaxScore(rs.getDouble("max_score"));
        Date d = rs.getDate("exam_date");
        if (d != null) g.setExamDate(d.toLocalDate());
        g.setNote(rs.getString("note"));
        return g;
    }

    // ─── BASE SQL ─────────────────────────────────────────
    private static final String BASE_SELECT =
        "SELECT gr.id, gr.enrollment_id, " +
        "       u.full_name AS student_name, " +
        "       cl.class_name, co.name AS course_name, " +
        "       gr.exam_name, gr.score, gr.max_score, gr.exam_date, gr.note " +
        "FROM grades gr " +
        "JOIN enrollments en ON gr.enrollment_id = en.id " +
        "JOIN users       u  ON en.student_id    = u.id " +
        "JOIN classes     cl ON en.class_id      = cl.id " +
        "JOIN courses     co ON cl.course_id     = co.id ";

    // ─── READ ─────────────────────────────────────────────

    /**
     * Admin: Xem toàn bộ điểm của 1 lớp.
     * Sắp xếp theo tên học viên, sau đó ngày thi.
     */
    public List<Grade> getByClassId(int classId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE en.class_id = ? " +
                     "ORDER BY u.full_name, gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getByClassId] " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy điểm của 1 học viên trong 1 đăng ký cụ thể.
     * (Dùng khi admin xem chi tiết điểm theo enrollment)
     */
    public List<Grade> getByEnrollmentId(int enrollmentId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE gr.enrollment_id = ? " +
                     "ORDER BY gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getByEnrollmentId] " + e.getMessage());
        }
        return list;
    }

    /**
     * Student: Xem toàn bộ điểm của mình (tất cả lớp đã đăng ký).
     * Sắp xếp theo tên lớp rồi ngày thi.
     */
    public List<Grade> getByStudentId(int studentId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE en.student_id = ? " +
                     "ORDER BY cl.class_name, gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getByStudentId] " + e.getMessage());
        }
        return list;
    }

    /**
     * Student: Xem điểm của mình trong 1 lớp cụ thể.
     */
    public List<Grade> getByStudentAndClass(int studentId, int classId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE en.student_id = ? AND en.class_id = ? " +
                     "ORDER BY gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getByStudentAndClass] " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy Grade theo id (dùng khi cần load data vào form sửa điểm).
     */
    public Grade getById(int id) {
        String sql = BASE_SELECT + "WHERE gr.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getById] " + e.getMessage());
        }
        return null;
    }

    // ─── CREATE ───────────────────────────────────────────

    /**
     * Nhập điểm mới cho 1 học viên trong 1 enrollment.
     */
    public boolean insert(Grade g) {
        String sql = "INSERT INTO grades (enrollment_id, exam_name, score, max_score, exam_date, note) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, g.getEnrollmentId());
            ps.setString(2, g.getExamName());
            ps.setDouble(3, g.getScore());
            ps.setDouble(4, g.getMaxScore());
            ps.setDate(5, g.getExamDate() != null
                          ? Date.valueOf(g.getExamDate()) : Date.valueOf(LocalDate.now()));
            ps.setString(6, g.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[GradeDAO.insert] " + e.getMessage());
            return false;
        }
    }

    // ─── UPDATE ───────────────────────────────────────────

    /**
     * Sửa điểm (exam_name, score, max_score, exam_date, note).
     * enrollment_id không được sửa sau khi tạo.
     */
    public boolean update(Grade g) {
        String sql = "UPDATE grades SET exam_name=?, score=?, max_score=?, exam_date=?, note=? " +
                     "WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, g.getExamName());
            ps.setDouble(2, g.getScore());
            ps.setDouble(3, g.getMaxScore());
            ps.setDate(4, g.getExamDate() != null
                          ? Date.valueOf(g.getExamDate()) : Date.valueOf(LocalDate.now()));
            ps.setString(5, g.getNote());
            ps.setInt(6, g.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[GradeDAO.update] " + e.getMessage());
            return false;
        }
    }

    // ─── DELETE ───────────────────────────────────────────

    /**
     * Xóa 1 bản ghi điểm theo id.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM grades WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[GradeDAO.delete] " + e.getMessage());
            return false;
        }
    }

    // ─── UTILITY ──────────────────────────────────────────

    /**
     * Lấy danh sách enrollment của 1 lớp (populate dropdown "Chọn học viên").
     * Trả về mảng [enrollmentId, studentName].
     */
    public List<String[]> getEnrollmentsByClass(int classId) {
        List<String[]> result = new ArrayList<>();
        String sql =
            "SELECT en.id, u.full_name " +
            "FROM enrollments en " +
            "JOIN users u ON en.student_id = u.id " +
            "WHERE en.class_id = ? AND en.payment_status = 'paid' " +
            "ORDER BY u.full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new String[]{ rs.getString("id"), rs.getString("full_name") });
                }
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getEnrollmentsByClass] " + e.getMessage());
        }
        return result;
    }

    /**
     * Lấy danh sách lớp có học viên đã thanh toán (dropdown lọc lớp).
     * Trả về mảng [classId, className].
     */
    public List<String[]> getActiveClasses() {
        List<String[]> result = new ArrayList<>();
        String sql =
            "SELECT DISTINCT cl.id, cl.class_name " +
            "FROM classes cl " +
            "JOIN enrollments en ON en.class_id = cl.id " +
            "WHERE en.payment_status = 'paid' " +
            "ORDER BY cl.class_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(new String[]{ rs.getString("id"), rs.getString("class_name") });
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getActiveClasses] " + e.getMessage());
        }
        return result;
    }
}
