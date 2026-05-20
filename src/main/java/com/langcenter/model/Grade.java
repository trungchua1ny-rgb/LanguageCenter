package com.langcenter.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Model: Grade — Điểm số học viên
 * Bảng: grades (JOIN enrollments, users, classes, courses)
 */
public class Grade {

    private int       id;
    private int       enrollmentId;

    // JOIN fields — lấy từ query
    private String    studentName;
    private String    className;
    private String    courseName;

    // Thông tin bài thi
    private String    examName;
    private double    score;
    private double    maxScore;
    private LocalDate examDate;
    private String    note;

    // ─── Constructors ─────────────────────────────────────
    public Grade() {
        this.maxScore = 10.0; // mặc định thang 10
    }

    public Grade(int enrollmentId, String examName,
                 double score, double maxScore,
                 LocalDate examDate, String note) {
        this.enrollmentId = enrollmentId;
        this.examName  = examName;
        this.score     = score;
        this.maxScore  = maxScore;
        this.examDate  = examDate;
        this.note      = note;
    }

    // ─── Helper Methods ───────────────────────────────────
    /**
     * Tính phần trăm điểm (dùng cho progress bar trong JSP)
     * Trả về giá trị 0–100
     */
    public int getScorePercent() {
        if (maxScore <= 0) return 0;
        return (int) Math.round((score / maxScore) * 100);
    }

    /**
     * Xếp loại học lực dựa trên phần trăm điểm
     * Dùng để hiển thị badge màu trong JSP
     */
    public String getRank() {
        double pct = getScorePercent();
        if (pct >= 90) return "Xuất sắc";
        if (pct >= 80) return "Giỏi";
        if (pct >= 65) return "Khá";
        if (pct >= 50) return "Trung bình";
        return "Yếu";
    }

    /**
     * CSS class Bootstrap tương ứng với xếp loại
     */
    public String getRankBadgeClass() {
        double pct = getScorePercent();
        if (pct >= 90) return "bg-success";
        if (pct >= 80) return "bg-primary";
        if (pct >= 65) return "bg-info text-dark";
        if (pct >= 50) return "bg-warning text-dark";
        return "bg-danger";
    }

    /**
     * Định dạng ngày thi thành chuỗi dd/MM/yyyy để hiển thị an toàn trên JSP
     */
    public String getFormattedExamDate() {
        if (this.examDate == null) return "";
        return this.examDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    // ─── Getters & Setters ────────────────────────────────
    public int    getId()               { return id; }
    public void   setId(int id)         { this.id = id; }

    public int    getEnrollmentId()                  { return enrollmentId; }
    public void   setEnrollmentId(int enrollmentId)  { this.enrollmentId = enrollmentId; }

    public String getStudentName()                   { return studentName; }
    public void   setStudentName(String studentName) { this.studentName = studentName; }

    public String getClassName()                     { return className; }
    public void   setClassName(String className)     { this.className = className; }

    public String getCourseName()                    { return courseName; }
    public void   setCourseName(String courseName)   { this.courseName = courseName; }

    public String getExamName()                      { return examName; }
    public void   setExamName(String examName)       { this.examName = examName; }

    public double getScore()                         { return score; }
    public void   setScore(double score)             { this.score = score; }

    public double getMaxScore()                      { return maxScore; }
    public void   setTargetMaxScore(double maxScore) { this.maxScore = maxScore; } // Hỗ trợ nếu gọi nhầm tên
    public void   setMaxScore(double maxScore)       { this.maxScore = maxScore; }

    public LocalDate getExamDate()                   { return examDate; }
    public void      setExamDate(LocalDate examDate) { this.examDate = examDate; }

    public String getNote()                          { return note; }
    public void   setNote(String note)               { this.note = note; }
}