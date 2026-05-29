package com.langcenter.model;

/**
 * Model ánh xạ bảng `courses`.
 * Có thêm levelName, teacherName lấy từ JOIN để hiển thị trên JSP.
 */
public class Course {

    private int id;
    private String name;
    private String description;
    private int levelId;
    private String levelName;       // join từ bảng levels
    private int teacherId;
    private String teacherName;     // join từ bảng users
    private int durationWeeks;
    private double tuitionFee;
    private int maxStudents;
    private boolean active;

    public Course() {}

    // ── Getters & Setters ────────────────────────────────────
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getLevelId() { return levelId; }
    public void setLevelId(int levelId) { this.levelId = levelId; }

    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public int getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(int durationWeeks) { this.durationWeeks = durationWeeks; }

    public double getTuitionFee() { return tuitionFee; }
    public void setTuitionFee(double tuitionFee) { this.tuitionFee = tuitionFee; }

    public int getMaxStudents() { return maxStudents; }
    public void setMaxStudents(int maxStudents) { this.maxStudents = maxStudents; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}