package com.langcenter.service;

import com.langcenter.dao.CourseDAO;
import com.langcenter.model.Course;
import com.google.gson.*;
import com.langcenter.util.DBConnection;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.*;

public class GeminiService {

	private static final String MODEL_NAME = "gemini-2.5-flash";
	private static final String API_KEY    = loadApiKey();
	private static final String API_URL    =
	    "https://generativelanguage.googleapis.com/v1beta/models/"
	    + MODEL_NAME + ":generateContent?key=";

    // ─────────────────────────────────────────────────────────────────────────
    // PUBLIC API
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Gọi Gemini tư vấn lộ trình học, lưu lịch sử vào ai_consults.
     * @param studentId  ID của student đang login
     * @param userMsg    Câu hỏi của student
     * @return           Câu trả lời từ Gemini
     */
    public String consult(int studentId, String userMsg) throws Exception {
        // 1. Lấy danh sách khóa học đang mở từ DB
        List<Course> courses = new CourseDAO().getAllActive();

        // 2. Ghép prompt
        String prompt = buildPrompt(courses, userMsg);

        // 3. Gọi Gemini API → nhận câu trả lời
        String aiResponse = callGeminiApi(prompt);

        // 4. Lưu lịch sử vào bảng ai_consults (đúng theo schema của bạn)
        saveHistory(studentId, userMsg, aiResponse);

        return aiResponse;
    }

    /**
     * Lấy lịch sử tư vấn của 1 student — mới nhất trước, tối đa 20 dòng.
     * Dùng đúng tên cột: user_message, ai_response, model_used, created_at
     */
    public List<Map<String, Object>> getHistory(int studentId) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT user_message, ai_response, model_used, created_at " +
                     "FROM ai_consults " +
                     "WHERE student_id = ? " +
                     "ORDER BY created_at DESC LIMIT 20";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("user_message", rs.getString("user_message"));
                row.put("ai_response",  rs.getString("ai_response"));
                row.put("model_used",   rs.getString("model_used"));
                row.put("created_at",   rs.getTimestamp("created_at").toString());
                list.add(row);
            }
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────────

    /** Ghép danh sách khóa học + câu hỏi thành 1 prompt đầy đủ */
    private String buildPrompt(List<Course> courses, String userMsg) {
        StringBuilder sb = new StringBuilder();
        sb.append("Bạn là tư vấn viên học thuật của trung tâm ngoại ngữ.\n");
        sb.append("Dưới đây là danh sách các khóa học hiện đang mở:\n\n");

        for (Course c : courses) {
            sb.append("• ").append(c.getName())
              .append(" | Cấp độ: ").append(c.getLevelName())
              .append(" | Thời lượng: ").append(c.getDurationWeeks()).append(" tuần")
              .append(" | Học phí: ").append(String.format("%,.0f", c.getTuitionFee()))
              .append(" VNĐ\n");
        }

        sb.append("\nHọc viên hỏi: ").append(userMsg).append("\n\n");
        sb.append("Hãy tư vấn lộ trình học phù hợp nhất dựa trên danh sách trên. ")
          .append("Trả lời bằng tiếng Việt, rõ ràng và thực tế.");

        return sb.toString();
    }

    /** Gọi Gemini REST API, trả về chuỗi text trả lời */
    private String callGeminiApi(String prompt) throws Exception {
        URL url = new URL(API_URL + API_KEY);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(30_000);

        // Build request body JSON
        JsonObject part    = new JsonObject();
        part.addProperty("text", prompt);

        JsonArray parts    = new JsonArray();
        parts.add(part);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject body    = new JsonObject();
        body.add("contents", contents);

        // Gửi request
        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes("UTF-8"));
        }

        // Đọc response
        int status = conn.getResponseCode();
        InputStream is = (status >= 400)
            ? conn.getErrorStream()
            : conn.getInputStream();

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br =
                new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }

        if (status != 200) {
            throw new RuntimeException("Gemini API lỗi HTTP " + status + ": " + sb);
        }

        // Parse JSON: candidates[0].content.parts[0].text
        JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();
        return json.getAsJsonArray("candidates")
                   .get(0).getAsJsonObject()
                   .getAsJsonObject("content")
                   .getAsJsonArray("parts")
                   .get(0).getAsJsonObject()
                   .get("text").getAsString();
    }

    /**
     * Lưu lịch sử — đúng tên cột theo schema thực tế:
     * user_message, ai_response, model_used
     */
    private void saveHistory(int studentId, String userMsg, String aiResponse) {
        String sql = "INSERT INTO ai_consults " +
                     "(student_id, user_message, ai_response, model_used) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1,    studentId);
            ps.setString(2, userMsg);
            ps.setString(3, aiResponse);
            ps.setString(4, MODEL_NAME);   // lưu "gemini-pro" vào model_used
            ps.executeUpdate();
        } catch (Exception e) {
            // Lỗi lưu DB không được làm hỏng luồng chat
            System.err.println("[GeminiService] Lỗi lưu ai_consults: " + e.getMessage());
        }
    }

    /** Đọc API key từ db.properties — không bao giờ hardcode */
    private static String loadApiKey() {
        try (InputStream is = GeminiService.class
                .getClassLoader().getResourceAsStream("db.properties")) {
            if (is == null)
                throw new RuntimeException("Không tìm thấy db.properties");
            Properties props = new Properties();
            props.load(is);
            String key = props.getProperty("gemini.api.key", "").trim();
            if (key.isEmpty())
                throw new RuntimeException("Thiếu gemini.api.key trong db.properties");
            return key;
        } catch (IOException e) {
            throw new RuntimeException("Lỗi đọc API key: " + e.getMessage());
        }
    }
}