package com.langcenter.model;

/**
 * Model ánh xạ bảng `classes`.
 * Đặt tên SchoolClass thay vì Class để tránh trùng java.lang.Class.
 */
public class SchoolClass {

    private int    id;
    private int    courseId;
    private String className;
    private String startDate;
    private String endDate;
    private String status;

    // Field join từ courses, users — dùng để hiển thị trên JSP
    private String courseName;
    private String teacherName;

    public SchoolClass() {}

    // ── Getters & Setters ─────────────────────────────────────
    public int    getId()          { return id; }
    public void   setId(int id)    { this.id = id; }

    public int    getCourseId()             { return courseId; }
    public void   setCourseId(int courseId) { this.courseId = courseId; }

    public String getClassName()                  { return className; }
    public void   setClassName(String className)  { this.className = className; }

    public String getStartDate()                  { return startDate; }
    public void   setStartDate(String startDate)  { this.startDate = startDate; }

    public String getEndDate()                    { return endDate; }
    public void   setEndDate(String endDate)      { this.endDate = endDate; }

    public String getStatus()                     { return status; }
    public void   setStatus(String status)        { this.status = status; }

    public String getCourseName()                     { return courseName; }
    public void   setCourseName(String courseName)    { this.courseName = courseName; }

    public String getTeacherName()                    { return teacherName; }
    public void   setTeacherName(String teacherName)  { this.teacherName = teacherName; }
}