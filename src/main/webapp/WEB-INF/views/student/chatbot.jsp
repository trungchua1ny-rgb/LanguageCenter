<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<style>
  /* ══ CHATBOT PAGE ══ */

  /* Wrapper */
  .lc-chat-wrap {
    max-width: 780px;
    margin: 0 auto;
  }

  /* Card */
  .lc-chat-card {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,.07);
    display: flex; flex-direction: column;
    height: 640px;
  }

  /* Chat header */
  .lc-chat-header {
    background: linear-gradient(135deg, #0056d2 0%, #1a3a6b 100%);
    padding: 16px 20px;
    display: flex; align-items: center; gap: 14px;
    flex-shrink: 0;
  }
  .lc-chat-avatar {
    width: 42px; height: 42px; border-radius: 50%;
    background: rgba(255,255,255,.2);
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; flex-shrink: 0;
    border: 2px solid rgba(255,255,255,.3);
  }
  .lc-chat-title  { font-size: 15px; font-weight: 700; color: #fff; }
  .lc-chat-status {
    font-size: 12px; color: rgba(255,255,255,.75);
    display: flex; align-items: center; gap: 5px; margin-top: 2px;
  }
  .lc-chat-status .dot {
    width: 7px; height: 7px; background: #4ade80;
    border-radius: 50%; flex-shrink: 0;
    animation: pulse 2s infinite;
  }
  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50%       { opacity: .4; }
  }

  /* Messages box */
  #chatBox {
    flex: 1;
    overflow-y: auto;
    padding: 16px 18px;
    background: #f9fafb;
    display: flex; flex-direction: column; gap: 10px;
  }
  #chatBox::-webkit-scrollbar { width: 4px; }
  #chatBox::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 2px; }

  /* Bubble */
  .lc-bubble-wrap { display: flex; }
  .lc-bubble-wrap.user { justify-content: flex-end; }
  .lc-bubble-wrap.bot  { justify-content: flex-start; }

  .lc-bubble {
    max-width: 76%;
    padding: 10px 14px;
    border-radius: 14px;
    font-size: 14px; line-height: 1.6;
    white-space: pre-wrap; word-break: break-word;
  }
  .lc-bubble.user {
    background: #0056d2; color: #fff;
    border-bottom-right-radius: 4px;
  }
  .lc-bubble.bot {
    background: #fff; color: #1f2937;
    border: 1px solid #e5e7eb;
    border-bottom-left-radius: 4px;
    box-shadow: 0 1px 4px rgba(0,0,0,.05);
  }
  .lc-bubble-model {
    font-size: 11px; color: #9ca3af; margin-top: 5px;
  }

  /* Typing bubble */
  .lc-typing {
    background: #fff; border: 1px solid #e5e7eb;
    border-radius: 14px; border-bottom-left-radius: 4px;
    padding: 10px 16px;
    display: inline-flex; align-items: center; gap: 4px;
  }
  .lc-typing span {
    width: 7px; height: 7px; background: #9ca3af;
    border-radius: 50%; display: inline-block;
    animation: bounce 1.2s infinite;
  }
  .lc-typing span:nth-child(2) { animation-delay: .2s; }
  .lc-typing span:nth-child(3) { animation-delay: .4s; }
  @keyframes bounce {
    0%, 60%, 100% { transform: translateY(0); }
    30%           { transform: translateY(-6px); }
  }

  /* Empty state */
  .lc-chat-empty {
    margin: auto; text-align: center; color: #9ca3af;
    padding: 20px;
  }
  .lc-chat-empty i { font-size: 44px; margin-bottom: 10px; display: block; }
  .lc-chat-empty h6 { font-size: 15px; font-weight: 700; color: #374151; margin-bottom: 6px; }

  /* Suggestion chips */
  .lc-chips {
    display: flex; flex-wrap: wrap; gap: 8px;
    justify-content: center; margin-top: 16px;
  }
  .lc-chip {
    padding: 6px 14px;
    background: #fff; border: 1.5px solid #e5e7eb; border-radius: 20px;
    font-size: 12.5px; font-weight: 500; color: #374151;
    cursor: pointer; transition: border-color .15s, background .15s, color .15s;
  }
  .lc-chip:hover {
    border-color: #0056d2; background: #e8f1fd; color: #0056d2;
  }

  /* Input area */
  .lc-chat-input-wrap {
    border-top: 1px solid #e5e7eb;
    display: flex; align-items: flex-end; gap: 0;
    background: #fff; flex-shrink: 0;
  }
  #questionInput {
    flex: 1; border: none; outline: none !important;
    box-shadow: none !important; resize: none;
    padding: 12px 16px; font-size: 14px;
    font-family: inherit; line-height: 1.55;
    background: transparent; color: #1f2937;
    border-radius: 0;
    max-height: 120px;
  }
  #questionInput::placeholder { color: #9ca3af; }
  .lc-send-btn {
    width: 52px; height: 52px;
    background: #0056d2; color: #fff;
    border: none; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: 18px; flex-shrink: 0;
    transition: background .15s;
    align-self: flex-end;
  }
  .lc-send-btn:hover  { background: #00399e; }
  .lc-send-btn:disabled { background: #9ca3af; cursor: not-allowed; }

  /* Disclaimer */
  .lc-disclaimer {
    text-align: center; font-size: 12px; color: #9ca3af;
    margin-top: 12px;
    display: flex; align-items: center; justify-content: center; gap: 5px;
  }
</style>

<div class="pagetitle">
  <h1>Tư vấn AI lộ trình học</h1>
  <nav>
    <ol class="breadcrumb">
      <li class="breadcrumb-item">
        <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      </li>
      <li class="breadcrumb-item active">Tư vấn AI</li>
    </ol>
  </nav>
</div>

<section class="section">
  <div class="lc-chat-wrap">

    <%-- ══ CHAT CARD ══ --%>
    <div class="lc-chat-card">

      <%-- Header --%>
      <div class="lc-chat-header">
        <div class="lc-chat-avatar">🤖</div>
        <div>
          <div class="lc-chat-title">AI Tư vấn Lộ trình Học</div>
          <div class="lc-chat-status">
            <span class="dot"></span>
            Dựa trên danh sách khóa học thực tế của trung tâm
          </div>
        </div>
      </div>

      <%-- Messages area --%>
      <div id="chatBox">
        <c:if test="${empty history}">
          <div class="lc-chat-empty">
            <i class="bi bi-chat-dots-fill"></i>
            <h6>Hãy đặt câu hỏi để được tư vấn!</h6>
            <p style="font-size:13px; margin-bottom:0; color:#6b7280;">
              AI sẽ gợi ý khóa học phù hợp dựa trên mục tiêu của bạn.
            </p>
            <div class="lc-chips" id="suggestChips">
              <span class="lc-chip" onclick="fillChip(this)">Tôi muốn học tiếng Anh giao tiếp</span>
              <span class="lc-chip" onclick="fillChip(this)">Nên thi IELTS hay TOEIC?</span>
              <span class="lc-chip" onclick="fillChip(this)">Học tiếng Nhật N4 mất bao lâu?</span>
              <span class="lc-chip" onclick="fillChip(this)">Lộ trình học Hàn cơ bản đến TOPIK II?</span>
            </div>
          </div>
        </c:if>
      </div>

      <%-- Input --%>
      <div class="lc-chat-input-wrap">
        <textarea id="questionInput" rows="2"
                  placeholder="Nhập câu hỏi... (Ctrl+Enter để gửi)"></textarea>
        <button class="lc-send-btn" id="sendBtn" onclick="sendQuestion()">
          <span id="btnIcon"><i class="bi bi-send-fill"></i></span>
          <span id="btnSpinner" class="spinner-border spinner-border-sm d-none"></span>
        </button>
      </div>

    </div><!-- End chat card -->

    <div class="lc-disclaimer">
      <i class="bi bi-shield-check"></i>
      AI có thể mắc lỗi — hãy xác nhận thông tin với nhân viên trung tâm.
    </div>

  </div>
</section>

<%-- Hidden history data --%>
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
(function () {
  const chatBox = document.getElementById('chatBox');
  const input   = document.getElementById('questionInput');
  const ctx     = '${pageContext.request.contextPath}';

  /* ── Tải lịch sử ── */
  window.addEventListener('load', function () {
    const items = document.querySelectorAll('#historyData .hist-item');
    if (items.length > 0) {
      chatBox.innerHTML = '';
      Array.from(items).reverse().forEach(item => {
        appendBubble(item.querySelector('.hist-q').textContent, true);
        appendBubble(item.querySelector('.hist-a').textContent, false,
                     item.querySelector('.hist-m').textContent);
      });
      chatBox.scrollTop = chatBox.scrollHeight;
    }
  });

  /* ── Ctrl+Enter ── */
  input.addEventListener('keydown', function (e) {
    if (e.ctrlKey && e.key === 'Enter') { e.preventDefault(); window.sendQuestion(); }
  });

  /* ── Auto-resize textarea ── */
  input.addEventListener('input', function () {
    this.style.height = 'auto';
    this.style.height = Math.min(this.scrollHeight, 120) + 'px';
  });

  /* ── Append bubble ── */
  function appendBubble(text, isUser, model) {
    const wrap   = document.createElement('div');
    wrap.className = 'lc-bubble-wrap ' + (isUser ? 'user' : 'bot');

    const bubble = document.createElement('div');
    bubble.className = 'lc-bubble ' + (isUser ? 'user' : 'bot');
    bubble.textContent = text;

    if (!isUser && model) {
      const badge = document.createElement('div');
      badge.className = 'lc-bubble-model';
      badge.textContent = '🤖 ' + model;
      bubble.appendChild(badge);
    }

    wrap.appendChild(bubble);
    chatBox.appendChild(wrap);
    chatBox.scrollTop = chatBox.scrollHeight;
  }

  /* ── Loading state ── */
  function setLoading(on) {
    document.getElementById('sendBtn').disabled = on;
    document.getElementById('btnIcon').classList.toggle('d-none', on);
    document.getElementById('btnSpinner').classList.toggle('d-none', !on);
  }

  /* ── Gửi câu hỏi ── */
  window.sendQuestion = async function () {
    const q = input.value.trim();
    if (!q) { input.focus(); return; }

    /* Ẩn suggestions khi đã gửi */
    const chips = document.getElementById('suggestChips');
    if (chips) chips.parentElement.remove();

    appendBubble(q, true);
    input.value = '';
    input.style.height = 'auto';
    setLoading(true);

    /* Typing indicator */
    const typingWrap = document.createElement('div');
    typingWrap.id = 'lc-typing-indicator';
    typingWrap.className = 'lc-bubble-wrap bot';
    typingWrap.innerHTML =
      '<div class="lc-typing"><span></span><span></span><span></span></div>';
    chatBox.appendChild(typingWrap);
    chatBox.scrollTop = chatBox.scrollHeight;

    try {
      const res = await fetch(ctx + '/student/ai-consult', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: 'question=' + encodeURIComponent(q)
      });
      const data = await res.json();
      document.getElementById('lc-typing-indicator')?.remove();

      if (data.answer && data.answer.trim()) {
        appendBubble(data.answer, false, 'gemini-pro');
      } else {
        appendBubble('⚠ ' + (data.error || 'Đã có lỗi xảy ra.'), false);
      }
    } catch (err) {
      document.getElementById('lc-typing-indicator')?.remove();
      appendBubble('⚠ Không thể kết nối tới server: ' + err.message, false);
    } finally {
      setLoading(false);
      input.focus();
    }
  };

  /* ── Fill chip vào input ── */
  window.fillChip = function (el) {
    input.value = el.textContent;
    input.focus();
  };

})();
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
