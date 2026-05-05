<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer style="background:#0d6efd; border-top:1px solid #e3e6f0;
               text-align:center; padding:15px; margin-top:20px;
               font-size:14px; color:#fff; width:100%;">
  © 2025 Language Center · Team 5 · Java MVC
</footer>

</div><%-- đóng .page-content --%>
</div><%-- đóng .main-wrapper --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('click', function(e) {
  const sidebar = document.getElementById('sidebar');
  const toggleBtn = document.getElementById('sidebarToggle');
  if (sidebar && toggleBtn && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
    sidebar.classList.remove('show');
  }
});
</script>

<%-- FLOATING CHATBOT --%>
<% 
String userRole = (String) session.getAttribute("role");
if (userRole != null && userRole.equalsIgnoreCase("student")) { 
%>

<style>
#floatBubble {
  position: fixed; bottom: 28px; right: 28px;
  width: 56px; height: 56px; border-radius: 50%;
  background: #0d6efd; color: #fff; border: none;
  box-shadow: 0 4px 16px rgba(13,110,253,.45);
  cursor: pointer; z-index: 9999;
  display: flex; align-items: center; justify-content: center;
  font-size: 24px; transition: transform .2s, background .2s;
}
#floatBubble:hover { background:#0b5ed7; transform: scale(1.1); }
#floatBubble .badge-dot {
  position: absolute; top: 4px; right: 4px;
  width: 14px; height: 14px; background: #dc3545;
  border-radius: 50%; border: 2px solid #fff;
}
#floatChat {
  position: fixed; bottom: 96px; right: 28px;
  width: 370px; height: 500px; background: #fff;
  border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,.18);
  z-index: 9998; display: none; flex-direction: column; overflow: hidden;
}
#floatChat.open { display: flex; }
#floatChat .fc-header {
  background: #0d6efd; color: #fff; padding: 12px 16px;
  display: flex; align-items: center; justify-content: space-between;
  flex-shrink: 0;
}
#floatChat .fc-header .title {
  font-size: 14px; font-weight: 600;
  display: flex; align-items: center; gap: 8px;
}
#floatChat .fc-header .close-btn {
  background: none; border: none; color: #fff;
  font-size: 18px; cursor: pointer; line-height: 1; padding: 0;
}
#floatMessages {
  flex: 1; overflow-y: auto; padding: 12px; background: #f8f9fa;
  display: flex; flex-direction: column; gap: 8px;
}
.fc-msg {
  max-width: 82%; padding: 8px 12px; border-radius: 12px;
  font-size: 13px; line-height: 1.5; white-space: pre-wrap; word-break: break-word;
}
.fc-msg.user {
  align-self: flex-end; background: #0d6efd; color: #fff;
  border-bottom-right-radius: 4px;
}
.fc-msg.bot {
  align-self: flex-start; background: #fff; border: 1px solid #dee2e6;
  border-bottom-left-radius: 4px;
}
#floatChat .fc-input {
  display: flex; border-top: 1px solid #dee2e6; flex-shrink: 0;
}
#floatChat .fc-input textarea {
  flex: 1; border: none; resize: none; padding: 10px 12px;
  font-size: 13px; outline: none; font-family: inherit;
}
#floatChat .fc-input .send-btn {
  width: 48px; background: #0d6efd; color: #fff; border: none;
  cursor: pointer; font-size: 16px; transition: background .2s;
}
#floatChat .fc-input .send-btn:hover { background: #0b5ed7; }
#floatChat .fc-input .send-btn:disabled { background: #6c757d; }
</style>

<button id="floatBubble" onclick="toggleFloatChat()" title="Tư vấn AI">
  <i class="bi bi-robot"></i>
  <span class="badge-dot"></span>
</button>

<div id="floatChat">
  <div class="fc-header">
    <div class="title"><i class="bi bi-robot"></i> Tư vấn AI lộ trình học</div>
    <button class="close-btn" onclick="toggleFloatChat()">✕</button>
  </div>
  <div id="floatMessages">
    <div class="fc-msg bot">Xin chào! 👋 Tôi có thể tư vấn lộ trình học.<br>Hãy đặt câu hỏi nhé!</div>
  </div>
  <div class="fc-input">
    <textarea id="floatInput" rows="2" placeholder="Nhập câu hỏi... (Enter gửi)"
              onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendFloatMsg();}"></textarea>
    <button class="send-btn" id="floatSendBtn" onclick="sendFloatMsg()">
      <i class="bi bi-send-fill"></i>
    </button>
  </div>
</div>

<script>
(function() {
  var chat = document.getElementById('floatChat');
  var msgs = document.getElementById('floatMessages');
  var inp  = document.getElementById('floatInput');
  var btn  = document.getElementById('floatSendBtn');
  var bdg  = document.querySelector('#floatBubble .badge-dot');
  var ctx  = '<%= request.getContextPath() %>';

  window.toggleFloatChat = function() {
    chat.classList.toggle('open');
    if (chat.classList.contains('open')) {
      if (bdg) bdg.style.display = 'none';
      inp.focus();
      msgs.scrollTop = msgs.scrollHeight;
    }
  };

  function addMsg(text, isUser) {
    var div = document.createElement('div');
    div.className = 'fc-msg ' + (isUser ? 'user' : 'bot');
    div.textContent = text;
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
  }

  window.sendFloatMsg = async function() {
    var q = inp.value.trim();
    
    // Validation đầu vào
    if (!q || q.length === 0) {
      inp.focus();
      return;
    }

    // Hiện tin user ngay
    addMsg(q, true);
    inp.value = '';
    btn.disabled = true;

    // Typing indicator
    var typing = document.createElement('div');
    typing.className = 'fc-msg bot';
    typing.id = 'fc-typing';
    typing.innerHTML = '<span class="spinner-grow spinner-grow-sm me-1"></span>Đang soạn...';
    msgs.appendChild(typing);
    msgs.scrollTop = msgs.scrollHeight;

    try {
      // ✅ FIX: dùng URLSearchParams thay vì FormData
      var params = new URLSearchParams();
      params.append('question', q);

      var res = await fetch(ctx + '/student/ai-consult', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: params.toString()
      });

      if (!res.ok) throw new Error('HTTP ' + res.status);

      var data = await res.json();
      
      // Xóa typing
      var t = document.getElementById('fc-typing');
      if (t) t.remove();

      // Hiện câu trả lời
      if (data.answer && data.answer.trim()) {
        addMsg(data.answer, false);
      } else if (data.error) {
        addMsg('⚠ ' + data.error, false);
      } else {
        addMsg('⚠ Không nhận được câu trả lời từ AI.', false);
      }

    } catch (err) {
      var t = document.getElementById('fc-typing');
      if (t) t.remove();
      addMsg('⚠ Lỗi kết nối: ' + err.message, false);
      console.error('Chat error:', err);
    } finally {
      btn.disabled = false;
      inp.focus();
    }
  };

  // Enter để gửi, Shift+Enter xuống dòng
  inp.addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendFloatMsg();
    }
  });

})();
</script>

<% } %>

</body>
</html>