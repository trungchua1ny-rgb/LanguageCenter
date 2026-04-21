package com.langcenter.dao;

import com.langcenter.util.DBConnection;
import com.langcenter.model.User;
import java.sql.*;

/**
 * Data Access Object cho bảng `users`.
 * Tuần 1-2: chỉ cần findByUsername() để login.
 * Tuần sau: thêm findById(), create(), update(), ... khi cần.
 */
public class UserDAO {

    /**
     * Tìm user theo username.
     * Dùng trong LoginServlet để xác thực đăng nhập.
     *
     * @param username  username cần tìm
     * @return User object nếu tìm thấy, null nếu không
     */
    public User findByUsername(String username) {
        String sql = "SELECT id, username, password_hash, full_name, email, phone, role, is_active "
                   + "FROM users WHERE username = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[UserDAO] Lỗi findByUsername: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tìm user theo ID (dùng khi load lại thông tin từ session).
     */
    public User findById(int id) {
        String sql = "SELECT id, username, password_hash, full_name, email, phone, role, is_active "
                   + "FROM users WHERE id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[UserDAO] Lỗi findById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ── Private helper ────────────────────────────────────────────────────────

    /** Ánh xạ 1 dòng ResultSet → User object */
    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("username"),
            rs.getString("password_hash"),
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("role"),
            rs.getBoolean("is_active")
        );
    }
}