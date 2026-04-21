package com.langcenter.model;

import java.time.LocalDate;

public class Enrollment {
    private int id;
    private int studentId;
    private int classId;
    private LocalDate enrolledDate;
    private String paymentStatus;
    private String note;

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

    // Getters và Setters (giữ nguyên các field bạn đã có)
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

    // Logic quan trọng cho JSP
    public boolean isAvailable() {
        return currentStudents < maxStudents;
    }

    public int getRemainingSlots() {
        return maxStudents - currentStudents;
    }
}