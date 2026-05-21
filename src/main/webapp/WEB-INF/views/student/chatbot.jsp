<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<div class="pagetitle">
  <h1>Tư vấn AI lộ trình học</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
      <li class="breadcrumb-item active">Tư vấn AI</li>
    </ol>
  </nav>
</div><!-- End Page Title -->

<section class="section">
  <div class="row">
    <div class="col-lg-8 col-xl-7 mx-auto">

      <div class="card">
        <div class="card-body d-flex flex-column" style="height:620px; padding:0;">

          <%-- ══ HEADER CHAT ══ --%>
          <div class="d-flex align-items-center gap-3 px-4 py-3 border-bottom"
               style="background:#f8f9fa; border-radius: .375rem .375rem 0 0; flex-shrink:0;">
            <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary text-white"
                 style="width:40px;height:40px;font-size:18px;flex-shrink:0;">
              <i class="bi bi-robot"></i>
            </div>
            <div>
              <div class="fw-bold" style="font-size:15px">AI Tư vấn lộ trình học</div>
              <div class="text-muted" style="font-size:12px">
                <i class="bi bi-circle-fill text-success me-1" style="font-size:8px"></i>
                Dựa trên danh sách khóa học thực tế của trung tâm
              </div>
            </div>
          </div>

          <%-- ══ KHUNG CHAT ══ --%>
          <div id="chatBox"
               style="flex:1; overflow-y:auto; padding:1rem;
                      background:#f8f9fa; display:flex;
                      flex-direction:column; gap:.75rem;">
            <c:if test="${empty history}">
              <div class="text-center text-muted my-auto">
                <i class="bi bi-chat-dots fs-1 d-block mb-2"></i>
                <p class="mb-1 fw-semibold">Hãy đặt câu hỏi để được tư vấn!</p>
                <small class="text-muted d-block">
                  Ví dụ: "Tôi muốn thi IELTS 6.5 trong 4 tháng, nên học khóa nào?"
                </small>
              </div>
            </c:if>
          </div>

          <%-- ══ INPUT ══ --%>
          <div class="border-top d-flex" style="flex-shrink:0;">
            <textarea id="questionInput" class="form-control border-0 rounded-0"
                      rows="2" placeholder="Nhập câu hỏi... (Ctrl+Enter để gửi)"
                      style="resize:none; outline:none; box-shadow:none;"></textarea>
            <button class="btn btn-primary rounded-0 px-4" id="sendBtn" onclick="sendQuestion()">
              <span id="btnText"><i class="bi bi-send-fill"></i></span>
              <span id="btnSpinner" class="spinner-border spinner-border-sm d-none"></span>
            </button>
          </div>

        </div>
      </div><!-- End Card -->

      <p class="text-muted text-center mt-2" style="font-size:12px">
        <i class="bi bi-shield-check me-1"></i>
        AI tư vấn có thể mắc lỗi. Hãy xác nhận thông tin với nhân viên trung tâm.
      </p>

    </div>
  </div>
</section>

<%--
  Data lịch sử từ server — xuất ra hidden div, đọc bằng JS để tránh lỗi EL với ký tự đặc biệt
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

// ── Đọc lịch sử từ DOM (server → DESC → reverse để hiện cũ→mới) ─────────────
window.addEventListener('load', function () {
  const items = document.querySelectorAll('#historyData .hist-item');
  if (items.length > 0) {
    chatBox.innerHTML = '';
    Array.from(items).reverse().forEach(item => {
      appendBubble(item.querySelector('.hist-q').textContent, true);
      appendBubble(item.querySelector('.hist-a').textContent, false,
                   item.querySelector('.hist-m').textContent);
    });
  }
  chatBox.scrollTop = chatBox.scrollHeight;
});

// ── Ctrl+Enter gửi ───────────────────────────────────────────────────────────
input.addEventListener('keydown', e => {
  if (e.ctrlKey && e.key === 'Enter') sendQuestion();
});

// ── Tạo bubble chat ──────────────────────────────────────────────────────────
function appendBubble(text, isUser, model) {
  const wrap   = document.createElement('div');
  wrap.className = 'd-flex ' + (isUser ? 'justify-content-end' : 'justify-content-start');

  const bubble = document.createElement('div');
  bubble.style.cssText = 'max-width:78%; white-space:pre-wrap; word-break:break-word; font-size:14px;';
  bubble.className = 'px-3 py-2 rounded-3 '
    + (isUser ? 'bg-primary text-white' : 'bg-white border shadow-sm');
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

  const typing = document.createElement('div');
  typing.id = 'typing';
  typing.className = 'd-flex justify-content-start';
  typing.innerHTML =
    '<div class="px-3 py-2 rounded-3 bg-white border shadow-sm text-muted fst-italic" style="font-size:13px">' +
    '<span class="spinner-grow spinner-grow-sm me-2"></span>AI đang soạn câu trả lời...</div>';
  chatBox.appendChild(typing);
  chatBox.scrollTop = chatBox.scrollHeight;

  try {
	  const res = await fetch(
		      '${pageContext.request.contextPath}/student/ai-consult',
		      {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		        body: 'question=' + encodeURIComponent(q)
		      }
		    );
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
