package com.langcenter.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url, user, pass;

    static {
        try (InputStream in = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            props.load(in);
            url  = props.getProperty("db.url");
            user = props.getProperty("db.username");
            pass = props.getProperty("db.password");
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi load DB config", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }

    // Hàm main được thêm vào để Eclipse nhận diện và cho phép Run As Java Application
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                System.out.println("✅ Kết nối Database thành công!");
                System.out.println("Thông tin DB: " + conn.getMetaData().getDatabaseProductName());
            }
        } catch (SQLException e) {
            System.err.println("❌ Kết nối thất bại. Vui lòng kiểm tra lại db.properties hoặc xem MariaDB đã chạy chưa.");
            e.printStackTrace();
        }
    }
}