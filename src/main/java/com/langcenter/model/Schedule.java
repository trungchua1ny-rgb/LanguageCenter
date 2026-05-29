package com.langcenter.model;

/**
 * Model: Schedule — Thời khóa biểu của từng lớp học
 * Bảng: schedules (JOIN classes, courses, rooms)
 */
public class Schedule {

    private int    id;
    private int    classId;
    private int    roomId;

    // JOIN fields — lấy từ query
    private String className;
    private String courseName;
    private String roomName;

    // Thời gian
    private String dayOfWeek;   // 'Mon'|'Tue'|'Wed'|'Thu'|'Fri'|'Sat'|'Sun'
    private String startTime;   // HH:mm
    private String endTime;     // HH:mm

    // ─── Constructors ─────────────────────────────────────
    public Schedule() {}

    public Schedule(int classId, int roomId, String dayOfWeek,
                    String startTime, String endTime) {
        this.classId   = classId;
        this.roomId    = roomId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime   = endTime;
    }

    // ─── Helper ───────────────────────────────────────────
    /** Trả về tên thứ tiếng Việt để hiển thị trên JSP */
    public String getDayOfWeekVi() {
        if (dayOfWeek == null) return "";
        switch (dayOfWeek) {
            case "Mon": return "Thứ Hai";
            case "Tue": return "Thứ Ba";
            case "Wed": return "Thứ Tư";
            case "Thu": return "Thứ Năm";
            case "Fri": return "Thứ Sáu";
            case "Sat": return "Thứ Bảy";
            case "Sun": return "Chủ Nhật";
            default:    return dayOfWeek;
        }
    }

    /** Trả về thứ tự số để sort theo ngày trong tuần */
    public int getDayOrder() {
        if (dayOfWeek == null) return 99;
        switch (dayOfWeek) {
            case "Mon": return 1;
            case "Tue": return 2;
            case "Wed": return 3;
            case "Thu": return 4;
            case "Fri": return 5;
            case "Sat": return 6;
            case "Sun": return 7;
            default:    return 99;
        }
    }

    // ─── Getters & Setters ────────────────────────────────
    public int    getId()         { return id; }
    public void   setId(int id)   { this.id = id; }

    public int    getClassId()             { return classId; }
    public void   setClassId(int classId)  { this.classId = classId; }

    public int    getRoomId()              { return roomId; }
    public void   setRoomId(int roomId)    { this.roomId = roomId; }

    public String getClassName()                   { return className; }
    public void   setClassName(String className)   { this.className = className; }

    public String getCourseName()                  { return courseName; }
    public void   setCourseName(String courseName) { this.courseName = courseName; }

    public String getRoomName()                    { return roomName; }
    public void   setRoomName(String roomName)     { this.roomName = roomName; }

    public String getDayOfWeek()                   { return dayOfWeek; }
    public void   setDayOfWeek(String dayOfWeek)   { this.dayOfWeek = dayOfWeek; }

    public String getStartTime()                   { return startTime; }
    public void   setStartTime(String startTime)   { this.startTime = startTime; }

    public String getEndTime()                     { return endTime; }
    public void   setEndTime(String endTime)       { this.endTime = endTime; }
}
