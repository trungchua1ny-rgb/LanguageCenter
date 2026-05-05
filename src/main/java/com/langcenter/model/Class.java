package com.langcenter.model;

public class Class {
    private int    id;
    private int    courseId;
    private String courseName;
    private String teacherName;
    private String className;
    private String startDate;
    private String endDate;
    private String status;

    public int    getId()                          { return id; }
    public void   setId(int id)                    { this.id = id; }
    public int    getCourseId()                    { return courseId; }
    public void   setCourseId(int courseId)        { this.courseId = courseId; }
    public String getCourseName()                  { return courseName; }
    public void   setCourseName(String courseName) { this.courseName = courseName; }
    public String getTeacherName()                 { return teacherName; }
    public void   setTeacherName(String t)         { this.teacherName = t; }
    public String getClassName()                   { return className; }
    public void   setClassName(String className)   { this.className = className; }
    public String getStartDate()                   { return startDate; }
    public void   setStartDate(String startDate)   { this.startDate = startDate; }
    public String getEndDate()                     { return endDate; }
    public void   setEndDate(String endDate)       { this.endDate = endDate; }
    public String getStatus()                      { return status; }
    public void   setStatus(String status)         { this.status = status; }
}