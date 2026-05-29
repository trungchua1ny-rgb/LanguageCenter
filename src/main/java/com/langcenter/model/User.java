package com.langcenter.model;

import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Model ánh xạ bảng `users` trong MariaDB.
 * role: 'admin' | 'teacher' | 'student'
 */
public class User {

    private int id;
    private String username;
    private String passwordHash;
    private String fullName;
    private String email;
    private String phone;
    private LocalDate dateOfBirth;
    private String avatarUrl;
    private String role;          // 'admin', 'teacher', 'student'
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // ══ TRƯỜNG BỔ SUNG CHO TRANG QUẢN LÝ HỌC VIÊN ══
    private int enrollmentCount;  // Đếm số lớp đang học

    public User() {}

    // ── Constructor tiện dùng khi lấy từ DB ──────────────────────────────────
    public User(int id, String username, String passwordHash,
                String fullName, String email, String phone,
                String role, boolean isActive) {
        this.id           = id;
        this.username     = username;
        this.passwordHash = passwordHash;
        this.fullName     = fullName;
        this.email        = email;
        this.phone        = phone;
        this.role         = role;
        this.isActive     = isActive;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public String getUsername()             { return username; }
    public void setUsername(String username)  { this.username = username; }

    public String getPasswordHash()         { return passwordHash; }
    public void setPasswordHash(String h)   { this.passwordHash = h; }

    public String getFullName()             { return fullName; }
    public void setFullName(String fullName)  { this.fullName = fullName; }

    public String getEmail()                { return email; }
    public void setEmail(String email)      { this.email = email; }

    public String getPhone()                { return phone; }
    public void setPhone(String phone)      { this.phone = phone; }

    public LocalDate getDateOfBirth()       { return dateOfBirth; }
    public void setDateOfBirth(LocalDate d) { this.dateOfBirth = d; }

    public String getAvatarUrl()            { return avatarUrl; }
    public void setAvatarUrl(String url)    { this.avatarUrl = url; }

    public String getRole()                 { return role; }
    public void setRole(String role)        { this.role = role; }

    public boolean isActive()               { return isActive; }
    public void setActive(boolean active)   { this.isActive = active; }

    public Timestamp getCreatedAt()         { return createdAt; }
    public void setCreatedAt(Timestamp t)   { this.createdAt = t; }

    public Timestamp getUpdatedAt()         { return updatedAt; }
    public void setUpdatedAt(Timestamp t)   { this.updatedAt = t; }

    // Getter & Setter cho enrollmentCount
    public int getEnrollmentCount()         { return enrollmentCount; }
    public void setEnrollmentCount(int e)   { this.enrollmentCount = e; }

    // ── Helper ────────────────────────────────────────────────────────────────
    public boolean isAdmin()   { return "admin".equals(role); }
    public boolean isTeacher() { return "teacher".equals(role); }
    public boolean isStudent() { return "student".equals(role); }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}