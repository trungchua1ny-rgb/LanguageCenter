package com.langcenter.dao;

import com.langcenter.model.Class;
import com.langcenter.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ClassDAO {

    private static final String SELECT =
        "SELECT cl.id, cl.course_id, cl.class_name, cl.start_date, cl.end_date, cl.status, " +
        "       co.name AS course_name, " +
        "       IFNULL(u.full_name,'Chưa phân công') AS teacher_name " +
        "FROM classes cl " +
        "JOIN courses co ON cl.course_id = co.id " +
        "LEFT JOIN users u ON co.teacher_id = u.id ";

    public List<Class> getAll() throws Exception {
        List<Class> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "ORDER BY cl.id DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Class> getByStatus(String status) throws Exception {
        List<Class> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 SELECT + "WHERE cl.status=? ORDER BY cl.id DESC")) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Class getById(int id) throws Exception {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE cl.id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        }
    }

    public boolean insert(Class cl) throws Exception {
        String sql = "INSERT INTO classes (course_id,class_name,start_date,end_date,status) " +
                     "VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,    cl.getCourseId());
            ps.setString(2, cl.getClassName());
            ps.setString(3, cl.getStartDate());
            ps.setString(4, cl.getEndDate());
            ps.setString(5, cl.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Class cl) throws Exception {
        String sql = "UPDATE classes SET course_id=?,class_name=?,start_date=?," +
                     "end_date=?,status=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,    cl.getCourseId());
            ps.setString(2, cl.getClassName());
            ps.setString(3, cl.getStartDate());
            ps.setString(4, cl.getEndDate());
            ps.setString(5, cl.getStatus());
            ps.setInt(6,    cl.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws Exception {
        // Không xóa nếu còn enrollment
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT COUNT(*) FROM enrollments WHERE class_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) return false;
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "DELETE FROM classes WHERE id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<com.langcenter.model.Course> getCourses() throws Exception {
        return new CourseDAO().getAllActive();
    }

    private Class map(ResultSet rs) throws SQLException {
        Class cl = new Class();
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