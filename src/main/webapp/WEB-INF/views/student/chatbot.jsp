<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="container-fluid py-4">
  <h4 class="mb-4"><i class="bi bi-robot"></i> Tư vấn lộ trình học AI</h4>

  <div class="card shadow-sm mb-3">
    <div class="card-body p-0">
      <div id="chatBox"
           style="height:420px; overflow-y:auto; padding:1rem;
                  background:#f8f9fa; display:flex;
                  flex-direction:column; gap:.75rem;">
        <c:if test="${empty history}">
          <div class="text-center text-muted mt-auto mb-auto">
            <i class="bi bi-chat-dots fs-1"></i>
            <p class="mt-2">Hãy đặt câu hỏi để được tư vấn lộ trình học!</p>
            <small>Ví dụ: "Tôi muốn thi IELTS 6.5 trong 4 tháng, nên học khóa nào?"</small>
          </div>
        </c:if>
      </div>
    </div>
  </div>

  <div class="input-group shadow-sm">
    <textarea id="questionInput" class="form-control" rows="2"
              placeholder="Nhập câu hỏi... (Ctrl+Enter để gửi)"
              style="resize:none;"></textarea>
    <button class="btn btn-primary px-4" id="sendBtn" onclick="sendQuestion()">
      <span id="btnText"><i class="bi bi-send-fill"></i> Gửi</span>
      <span id="btnSpinner" class="spinner-border spinner-border-sm d-none"></span>
    </button>
  </div>
  <small class="text-muted mt-1 d-block">
    <i class="bi bi-info-circle"></i>
    AI tư vấn dựa trên danh sách khóa học thực tế của trung tâm.
  </small>
</div>

<%-- 
  ⚠️ KEY FIX: Dùng <c:out> để xuất data vào hidden div thay vì nhúng trực tiếp 
  vào JS template literal — tránh lỗi EL parser với ký tự đặc biệt 
--%>
<div id="historyData" style="display:none">
  <c:forEach var="h" items="${history}">
    <div class="hist-item">
      <span class="hist-q"><c:out value="${h.user_message}"/></span>
      <span class="hist-a"><c:out value="${h.ai_response}"/></span>
      <span class="hist-m"><c:out value="${h.model_used}"/></span>
    </div>
  </c:forEach>
</div>

<script>
const chatBox = document.getElementById('chatBox');
const input   = document.getElementById('questionInput');

// ── Đọc lịch sử từ DOM (không dùng EL trong JS) ──────────────────────────────
window.onload = function () {
  const items = document.querySelectorAll('#historyData .hist-item');
  if (items.length > 0) {
    chatBox.innerHTML = '';
    // Server trả DESC → reverse để hiện cũ → mới
    const arr = Array.from(items).reverse();
    arr.forEach(item => {
      const q = item.querySelector('.hist-q').textContent;
      const a = item.querySelector('.hist-a').textContent;
      const m = item.querySelector('.hist-m').textContent;
      appendBubble(q, true);
      appendBubble(a, false, m);
    });
  }
  chatBox.scrollTop = chatBox.scrollHeight;
};

// ── Ctrl+Enter gửi ───────────────────────────────────────────────────────────
input.addEventListener('keydown', function (e) {
  if (e.ctrlKey && e.key === 'Enter') sendQuestion();
});

// ── Tạo bubble chat ──────────────────────────────────────────────────────────
function appendBubble(text, isUser, model) {
  const wrap   = document.createElement('div');
  wrap.className = 'd-flex ' + (isUser ? 'justify-content-end' : 'justify-content-start');

  const bubble = document.createElement('div');
  bubble.style.cssText = 'max-width:75%; white-space:pre-wrap; word-break:break-word;';
  bubble.className = 'px-3 py-2 rounded-3 '
    + (isUser ? 'bg-primary text-white' : 'bg-white border');
  bubble.textContent = text;

  if (!isUser && model) {
    const badge = document.createElement('small');
    badge.className = 'd-block text-muted mt-1';
    badge.style.fontSize = '11px';
    badge.textContent = '🤖 ' + model;
    bubble.appendChild(badge);
  }

  wrap.appendChild(bubble);
  chatBox.appendChild(wrap);
  chatBox.scrollTop = chatBox.scrollHeight;
}

// ── Loading state ─────────────────────────────────────────────────────────────
function setLoading(on) {
  document.getElementById('sendBtn').disabled = on;
  document.getElementById('btnText').classList.toggle('d-none', on);
  document.getElementById('btnSpinner').classList.toggle('d-none', !on);
}

// ── Gửi câu hỏi qua AJAX ─────────────────────────────────────────────────────
async function sendQuestion() {
  const q = input.value.trim();
  if (!q) { input.focus(); return; }

  appendBubble(q, true);
  input.value = '';
  setLoading(true);

  // Typing indicator
  const typing = document.createElement('div');
  typing.id = 'typing';
  typing.className = 'd-flex justify-content-start';
  typing.innerHTML =
    '<div class="px-3 py-2 rounded-3 bg-white border text-muted fst-italic">' +
    '<span class="spinner-grow spinner-grow-sm me-1"></span>AI đang soạn câu trả lời...</div>';
  chatBox.appendChild(typing);
  chatBox.scrollTop = chatBox.scrollHeight;

  try {
    const fd = new FormData();
    fd.append('question', q);

    const contextPath = '${pageContext.request.contextPath}';
    const res  = await fetch(contextPath + '/student/ai-consult',
                             { method: 'POST', body: fd });
    const data = await res.json();

    document.getElementById('typing')?.remove();

    if (data.answer) {
      appendBubble(data.answer, false, 'gemini-pro');
    } else {
      appendBubble('⚠ ' + (data.error || 'Đã có lỗi xảy ra.'), false);
    }
  } catch (err) {
    document.getElementById('typing')?.remove();
    appendBubble('⚠ Không thể kết nối tới server: ' + err.message, false);
  } finally {
    setLoading(false);
    input.focus();
  }
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>