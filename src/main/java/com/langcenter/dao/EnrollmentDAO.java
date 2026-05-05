package com.langcenter.dao;

import com.langcenter.model.Enrollment;
import com.langcenter.util.DBConnection; 

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {
    
    // ═══════════════════════════════════════════════════════════
    // 1. LẤY DANH SÁCH LỚP HỌC ĐANG MỞ (Để sinh viên đăng ký)
    // ═══════════════════════════════════════════════════════════
    public List<Enrollment> getAvailableClasses(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT cl.id AS class_id, cl.class_name, cl.start_date, cl.status AS class_status, " +
                     "co.name AS course_name, co.description AS course_description, co.tuition_fee, co.max_students, " +
                     "lv.name AS level_name, " +
                     "(SELECT COUNT(*) FROM enrollments e2 WHERE e2.class_id = cl.id AND e2.payment_status != 'cancelled') AS current_students, " +
                     "(SELECT COUNT(*) FROM enrollments e3 WHERE e3.class_id = cl.id AND e3.student_id = ? AND e3.payment_status != 'cancelled') AS already_enrolled, " +
                     "GROUP_CONCAT(CONCAT(s.day_of_week,' ',s.start_time,'-',s.end_time) ORDER BY s.day_of_week SEPARATOR ', ') AS schedule_info " +
                     "FROM classes cl JOIN courses co ON co.id = cl.course_id JOIN levels lv ON lv.id = co.level_id " +
                     "LEFT JOIN schedules s ON s.class_id = cl.id WHERE cl.status IN ('upcoming','ongoing') " +
                     "GROUP BY cl.id ORDER BY cl.start_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Enrollment e = new Enrollment();
                e.setClassId(rs.getInt("class_id"));
                e.setClassName(rs.getString("class_name"));
                e.setStartDate(rs.getString("start_date"));
                e.setClassStatus(rs.getString("class_status"));
                e.setCourseName(rs.getString("course_name"));
                e.setCourseDescription(rs.getString("course_description"));
                e.setTuitionFee(rs.getDouble("tuition_fee"));
                e.setMaxStudents(rs.getInt("max_students"));
                e.setLevelName(rs.getString("level_name"));
                e.setCurrentStudents(rs.getInt("current_students"));
                e.setScheduleInfo(rs.getString("schedule_info"));
                e.setNote(rs.getInt("already_enrolled") > 0 ? "enrolled" : "");
                list.add(e);
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
        return list;
    }

    // ═══════════════════════════════════════════════════════════
    // 2. SINH VIÊN ĐĂNG KÝ LỚP
    // ═══════════════════════════════════════════════════════════
    public boolean enroll(int studentId, int classId) {
        String sql = "INSERT INTO enrollments (student_id, class_id, enrolled_date, payment_status) VALUES (?, ?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) { ex.printStackTrace(); return false; }
    }

    // ═══════════════════════════════════════════════════════════
    // 3. LẤY DANH SÁCH LỚP HỌC "CỦA TÔI" (Sinh viên xem lớp đã đăng ký)
    // ═══════════════════════════════════════════════════════════
    public List<Enrollment> getMyEnrollments(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql =
            "SELECT e.id, e.enrolled_date, e.payment_status, " +
            "  cl.id AS class_id, cl.class_name, cl.status AS class_status, " +
            "  cl.start_date, cl.end_date, " +
            "  co.name AS course_name, co.tuition_fee, " +
            "  lv.name AS level_name, " +
            "  GROUP_CONCAT(CONCAT(s.day_of_week,' ',s.start_time,'-',s.end_time) ORDER BY s.day_of_week SEPARATOR ', ') AS schedule_info " +
            "FROM enrollments e " +
            "JOIN classes cl ON cl.id = e.class_id " +
            "JOIN courses co ON co.id = cl.course_id " +
            "JOIN levels lv ON lv.id = co.level_id " +
            "LEFT JOIN schedules s ON s.class_id = cl.id " +
            "WHERE e.student_id = ? AND e.payment_status != 'cancelled' " +
            "GROUP BY e.id " +
            "ORDER BY e.enrolled_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Enrollment e = new Enrollment();
                    e.setId(rs.getInt("id"));
                    e.setClassId(rs.getInt("class_id"));
                    e.setClassName(rs.getString("class_name"));
                    e.setCourseName(rs.getString("course_name"));
                    e.setLevelName(rs.getString("level_name"));
                    e.setClassStatus(rs.getString("class_status"));
                    e.setPaymentStatus(rs.getString("payment_status"));
                    e.setTuitionFee(rs.getDouble("tuition_fee"));
                    e.setStartDate(rs.getString("start_date"));
                    e.setEndDate(rs.getString("end_date")); 
                    e.setScheduleInfo(rs.getString("schedule_info"));
                    e.setEnrolledDate(rs.getDate("enrolled_date").toLocalDate());
                    
                    list.add(e);
                }
            }
        } catch (Exception ex) {
            System.err.println("[EnrollmentDAO] getMyEnrollments lỗi: " + ex.getMessage());
        }
        return list;
    }
}