package com.langcenter.model;

import java.time.LocalDate;
import java.sql.Timestamp;

public class Enrollment {
    
    // 1. CÁC TRƯỜNG GỐC TRONG BẢNG ENROLLMENTS
    private int id;
    private int studentId;
    private int classId;
    private LocalDate enrolledDate;
    private String paymentStatus;
    private Timestamp paidAt;
    private String note;

    // 2. CÁC TRƯỜNG MỞ RỘNG (Dùng cho JOIN hiển thị trên JSP)
    private String studentName;      // Dành cho Admin xem ai đăng ký
    private String className;
    private String courseName;
    private String courseDescription;
    private double tuitionFee;
    private int maxStudents;
    private int currentStudents;
    private String levelName;
    private String scheduleInfo;
    private String startDate;
    private String classStatus;

    public Enrollment() {}

    // ═══════════════════════════════════════════════════════════
    // GETTERS & SETTERS CHO CÁC TRƯỜNG GỐC VÀ ADMIN
    // ═══════════════════════════════════════════════════════════
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public LocalDate getEnrolledDate() { return enrolledDate; }
    public void setEnrolledDate(LocalDate enrolledDate) { this.enrolledDate = enrolledDate; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    // ═══════════════════════════════════════════════════════════
    // GETTERS & SETTERS (Giữ nguyên của ông cho Sinh viên)
    // ═══════════════════════════════════════════════════════════

    public int getClassId() { return classId; }
    public void setClassId(int classId) { this.classId = classId; }
    
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public String getCourseDescription() { return courseDescription; }
    public void setCourseDescription(String courseDescription) { this.courseDescription = courseDescription; }
    
    public double getTuitionFee() { return tuitionFee; }
    public void setTuitionFee(double tuitionFee) { this.tuitionFee = tuitionFee; }
    
    public int getMaxStudents() { return maxStudents; }
    public void setMaxStudents(int maxStudents) { this.maxStudents = maxStudents; }
    
    public int getCurrentStudents() { return currentStudents; }
    public void setCurrentStudents(int currentStudents) { this.currentStudents = currentStudents; }
    
    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
    
    public String getScheduleInfo() { return scheduleInfo; }
    public void setScheduleInfo(String scheduleInfo) { this.scheduleInfo = scheduleInfo; }
    
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    
    public String getClassStatus() { return classStatus; }
    public void setClassStatus(String classStatus) { this.classStatus = classStatus; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    
    private String endDate;
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    // ═══════════════════════════════════════════════════════════
    // LOGIC QUAN TRỌNG CHO JSP CỦA SINH VIÊN
    // ═══════════════════════════════════════════════════════════
    public boolean isAvailable() {
        return currentStudents < maxStudents;
    }

    public int getRemainingSlots() {
        return maxStudents - currentStudents;
    }
}