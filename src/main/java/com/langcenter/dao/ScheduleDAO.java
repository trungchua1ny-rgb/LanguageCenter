package com.langcenter.dao;

import com.langcenter.model.Schedule;
import com.langcenter.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO: ScheduleDAO — Thao tác DB với bảng schedules
 * Chỉ chứa SQL, không có business logic.
 */
public class ScheduleDAO {

    // ─── BASE SQL ─────────────────────────────────────────
    private static final String BASE_SELECT =
        "SELECT s.id, s.class_id, s.room_id, " +
        "       cl.class_name, co.name AS course_name, r.room_name, " +
        "       s.day_of_week, s.start_time, s.end_time " +
        "FROM schedules s " +
        "JOIN classes cl ON s.class_id = cl.id " +
        "JOIN courses co ON cl.course_id = co.id " +
        "JOIN rooms   r  ON s.room_id   = r.id ";

    // ─── MAP ROW → Schedule ───────────────────────────────
    private Schedule mapRow(ResultSet rs) throws SQLException {
        Schedule sc = new Schedule();
        sc.setId(rs.getInt("id"));
        sc.setClassId(rs.getInt("class_id"));
        sc.setRoomId(rs.getInt("room_id"));
        sc.setClassName(rs.getString("class_name"));
        sc.setCourseName(rs.getString("course_name"));
        sc.setRoomName(rs.getString("room_name"));
        sc.setDayOfWeek(rs.getString("day_of_week"));
        sc.setStartTime(rs.getString("start_time").substring(0, 5));  // HH:mm
        sc.setEndTime(rs.getString("end_time").substring(0, 5));
        return sc;
    }

    // ─── READ ─────────────────────────────────────────────

    /**
     * Lấy toàn bộ TKB của 1 lớp (Admin xem, xếp TKB).
     * Sắp xếp theo thứ tự ngày trong tuần, sau đó giờ bắt đầu.
     */
    public List<Schedule> getByClassId(int classId) {
        List<Schedule> list = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE s.class_id = ? " +
                     "ORDER BY FIELD(s.day_of_week,'Mon','Tue','Wed','Thu','Fri','Sat','Sun'), s.start_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.getByClassId] " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy TKB cá nhân của Student đang login.
     * Truy vấn qua: enrollments → classes → schedules
     * Chỉ lấy các lớp có payment_status = 'paid' để đảm bảo chính xác.
     */
    public List<Schedule> getByStudentId(int studentId) {
        List<Schedule> list = new ArrayList<>();
        String sql =
            "SELECT s.id, s.class_id, s.room_id, " +
            "       cl.class_name, co.name AS course_name, r.room_name, " +
            "       s.day_of_week, s.start_time, s.end_time " +
            "FROM schedules s " +
            "JOIN classes     cl ON s.class_id     = cl.id " +
            "JOIN courses     co ON cl.course_id   = co.id " +
            "JOIN rooms       r  ON s.room_id      = r.id " +
            "JOIN enrollments en ON en.class_id    = cl.id " +
            "WHERE en.student_id     = ? " +
            "  AND en.payment_status = 'paid' " +
            "  AND cl.status        IN ('ongoing', 'upcoming') " +
            "ORDER BY FIELD(s.day_of_week,'Mon','Tue','Wed','Thu','Fri','Sat','Sun'), s.start_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.getByStudentId] " + e.getMessage());
        }
        return list;
    }

    // ─── CREATE ───────────────────────────────────────────

    /**
     * Thêm 1 buổi học vào thời khóa biểu.
     * Caller nên gọi hasConflict() trước để kiểm tra trùng phòng.
     */
    public boolean insert(Schedule s) {
        String sql = "INSERT INTO schedules (class_id, room_id, day_of_week, start_time, end_time) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getClassId());
            ps.setInt(2, s.getRoomId());
            ps.setString(3, s.getDayOfWeek());
            ps.setString(4, s.getStartTime());
            ps.setString(5, s.getEndTime());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.insert] " + e.getMessage());
            return false;
        }
    }

    // ─── DELETE ───────────────────────────────────────────

    /**
     * Xóa 1 buổi học theo id.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM schedules WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.delete] " + e.getMessage());
            return false;
        }
    }

    // ─── CONFLICT CHECK ───────────────────────────────────

    /**
     * Kiểm tra phòng đã bị đặt trong khung giờ đó chưa.
     * Logic: cùng phòng, cùng ngày, và khoảng giờ bị OVERLAP.
     *
     * Overlap xảy ra khi:
     *   newStart < existEnd  AND  newEnd > existStart
     *
     * @param excludeScheduleId  Truyền 0 khi thêm mới.
     *                           Truyền id hiện tại khi cần kiểm tra khi sửa (nếu sau này mở rộng).
     */
    public boolean hasConflict(int roomId, String day,
                               String start, String end,
                               int excludeScheduleId) {
        String sql =
            "SELECT COUNT(*) FROM schedules " +
            "WHERE room_id    = ? " +
            "  AND day_of_week = ? " +
            "  AND start_time  < ? " +   // existStart < newEnd
            "  AND end_time    > ? " +   // existEnd   > newStart
            "  AND id         != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setString(2, day);
            ps.setString(3, end);
            ps.setString(4, start);
            ps.setInt(5, excludeScheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.hasConflict] " + e.getMessage());
        }
        return false;
    }

    // ─── UTILITY ──────────────────────────────────────────

    /**
     * Lấy danh sách phòng học (dùng để populate dropdown trong form).
     */
    public List<String[]> getAllRooms() {
        List<String[]> rooms = new ArrayList<>();
        String sql = "SELECT id, room_name FROM rooms ORDER BY room_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rooms.add(new String[]{ rs.getString("id"), rs.getString("room_name") });
            }
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO.getAllRooms] " + e.getMessage());
        }
        return rooms;
    }
}
