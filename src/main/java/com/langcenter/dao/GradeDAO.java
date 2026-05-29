package com.langcenter.dao;

import com.langcenter.model.Grade;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class GradeDAO {

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

    public List<Grade> getByClassId(int classId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE en.class_id = ? ORDER BY u.full_name, gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return list;
    }

    public List<Grade> getByEnrollmentId(int enrollmentId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE gr.enrollment_id = ? ORDER BY gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return list;
    }

    public List<Grade> getByStudentId(int studentId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE en.student_id = ? ORDER BY cl.class_name, gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return list;
    }

    public List<Grade> getByStudentAndClass(int studentId, int classId) {
        List<Grade> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE en.student_id = ? AND en.class_id = ? ORDER BY gr.exam_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return list;
    }

    public Grade getById(int id) {
        String sql = BASE_SELECT + "WHERE gr.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return null;
    }

    public boolean insert(Grade g) {
        String sql = "INSERT INTO grades (enrollment_id, exam_name, score, max_score, exam_date, note) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, g.getEnrollmentId());
            ps.setString(2, g.getExamName());
            ps.setDouble(3, g.getScore());
            ps.setDouble(4, g.getMaxScore());
            ps.setDate(5, g.getExamDate() != null ? Date.valueOf(g.getExamDate()) : Date.valueOf(LocalDate.now()));
            ps.setString(6, g.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public boolean update(Grade g) {
        String sql = "UPDATE grades SET exam_name=?, score=?, max_score=?, exam_date=?, note=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, g.getExamName());
            ps.setDouble(2, g.getScore());
            ps.setDouble(3, g.getMaxScore());
            ps.setDate(4, g.getExamDate() != null ? Date.valueOf(g.getExamDate()) : Date.valueOf(LocalDate.now()));
            ps.setString(5, g.getNote());
            ps.setInt(6, g.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM grades WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public List<String[]> getEnrollmentsByClass(int classId) {
        List<String[]> result = new ArrayList<>();
        String sql = "SELECT en.id, u.full_name FROM enrollments en JOIN users u ON en.student_id = u.id WHERE en.class_id = ? AND en.payment_status = 'paid' ORDER BY u.full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(new String[]{ rs.getString("id"), rs.getString("full_name") });
            }
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return result;
    }

    public List<String[]> getActiveClasses() {
        List<String[]> result = new ArrayList<>();
        String sql = "SELECT DISTINCT cl.id, cl.class_name FROM classes cl JOIN enrollments en ON en.class_id = cl.id WHERE en.payment_status = 'paid' ORDER BY cl.class_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) result.add(new String[]{ rs.getString("id"), rs.getString("class_name") });
        } catch (SQLException e) { System.err.println(e.getMessage()); }
        return result;
    }

    // HÀM MỚI BỔ SUNG ĐỂ HIỂN THỊ TRONG DROPDOWN CỦA STUDENT
    public List<String[]> getEnrolledClassesByStudent(int studentId) {
        List<String[]> result = new ArrayList<>();
        String sql =
            "SELECT cl.id, cl.class_name, co.name AS course_name " +
            "FROM classes cl " +
            "JOIN courses co ON cl.course_id = co.id " +
            "JOIN enrollments en ON en.class_id = cl.id " +
            "WHERE en.student_id = ? AND en.payment_status = 'paid' " +
            "ORDER BY cl.class_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new String[]{
                        rs.getString("id"),
                        rs.getString("class_name"),
                        rs.getString("course_name")
                    });
                }
            }
        } catch (SQLException e) {
            System.err.println("[GradeDAO.getEnrolledClassesByStudent] " + e.getMessage());
        }
        return result;
    }
}