<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
    String f_ctx  = request.getContextPath();
    String f_role = (String) session.getAttribute("role");
%>

</main><!-- /#lc-main -->
</div><!-- /#lc-layout -->

<!-- ═══════════════════════════════════ FOOTER ═══════════════════════════════════ -->
<footer style="margin-left:var(--sidebar-w);padding:16px 20px;
               border-top:1px solid var(--border);background:var(--bg-white);
               font-size:12px;color:var(--text-muted);text-align:center;">
  © 2026 Language Center · Đồ án môn học · Java MVC
</footer>

<!-- ═══════════════════════════════════ CHATBOT (Student only) ═══════════════════════════════════ -->
<% if ("student".equals(f_role)) { %>
<style>
  #lcChatBtn {
    position: fixed; bottom: 24px; right: 24px;
    width: 52px; height: 52px; border-radius: 50%;
    background: var(--primary); color: #fff; border: none;
    box-shadow: 0 4px 16px rgba(30,136,229,.45);
    cursor: pointer; z-index: 9999;
    display: flex; align-items: center; justify-content: center;
    font-size: 22px; transition: transform .2s, background .2s;
  }
  #lcChatBtn:hover { background: var(--primary-dark); transform: scale(1.08); }
  #lcChatBtn .dot {
    position: absolute; top: 5px; right: 5px;
    width: 12px; height: 12px; background: #f44336;
    border-radius: 50%; border: 2px solid #fff;
  }
  #lcChatBox {
    position: fixed; bottom: 88px; right: 24px;
    width: 360px; max-height: 500px;
    background: #fff; border-radius: 14px;
    box-shadow: 0 8px 32px rgba(0,0,0,.15);
    z-index: 9998; display: none; flex-direction: column;
    overflow: hidden; border: 1px solid var(--border);
    font-family: var(--font);
  }
  #lcChatBox.open { display: flex; }
  #lcChatBox .cb-head {
    background: var(--primary); color: #fff;
    padding: 12px 16px;
    display: flex; align-items: center;
    justify-content: space-between; flex-shrink: 0;
  }
  #lcChatBox .cb-head .title {
    font-size: 14px; font-weight: 600;
    display: flex; align-items: center; gap: 8px;
  }
  #lcChatBox .cb-head .close {
    background: none; border: none;
    color: rgba(255,255,255,.8); font-size: 18px;
    cursor: pointer; line-height: 1;
  }
  #lcChatMsgs {
    flex: 1; overflow-y: auto; padding: 12px;
    background: #f8f9fa; display: flex;
    flex-direction: column; gap: 8px;
  }
  .cb-msg {
    max-width: 82%; padding: 8px 12px;
    border-radius: 12px; font-size: 13px;
    line-height: 1.5; white-space: pre-wrap;
  }
  .cb-msg.user {
    align-self: flex-end;
    background: var(--primary); color: #fff;
    border-bottom-right-radius: 3px;
  }
  .cb-msg.bot {
    align-self: flex-start;
    background: #fff; border: 1px solid var(--border);
    border-bottom-left-radius: 3px;
  }
  #lcChatBox .cb-input {
    display: flex; border-top: 1px solid var(--border); flex-shrink: 0;
  }
  #lcChatBox .cb-input textarea {
    flex: 1; border: none; resize: none; padding: 10px 12px;
    font-size: 13px; outline: none; font-family: var(--font);
  }
  #lcChatBox .cb-input .send {
    width: 46px; background: var(--primary); color: #fff;
    border: none; cursor: pointer; font-size: 16px;
    transition: background .2s;
  }
  #lcChatBox .cb-input .send:hover { background: var(--primary-dark); }
  #lcChatBox .cb-input .send:disabled { background: #9ca3af; }
</style>

<button id="lcChatBtn" onclick="lcToggleChat()" title="Tư vấn AI">
  <i class="bi bi-robot"></i>
  <span class="dot"></span>
</button>

<div id="lcChatBox">
  <div class="cb-head">
    <div class="title"><i class="bi bi-robot"></i> Tư vấn AI lộ trình học</div>
    <button class="close" onclick="lcToggleChat()">✕</button>
  </div>
  <div id="lcChatMsgs">
    <div class="cb-msg bot">Xin chào! 👋 Tôi có thể tư vấn lộ trình học cho bạn. Hãy đặt câu hỏi nhé!</div>
  </div>
  <div class="cb-input">
    <textarea id="lcChatInput" rows="2"
              placeholder="Nhập câu hỏi... (Enter gửi)"
              onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();lcSend();}"></textarea>
    <button class="send" id="lcSendBtn" onclick="lcSend()">
      <i class="bi bi-send-fill"></i>
    </button>
  </div>
</div>

<script>
(function(){
  const box  = document.getElementById('lcChatBox');
  const msgs = document.getElementById('lcChatMsgs');
  const inp  = document.getElementById('lcChatInput');
  const btn  = document.getElementById('lcSendBtn');
  const dot  = document.querySelector('#lcChatBtn .dot');
  const ctx  = '<%= f_ctx %>';

  window.lcToggleChat = function() {
    box.classList.toggle('open');
    if (box.classList.contains('open')) {
      if (dot) dot.style.display = 'none';
      inp.focus();
      msgs.scrollTop = msgs.scrollHeight;
    }
  };

  function addMsg(text, isUser) {
    const d = document.createElement('div');
    d.className = 'cb-msg ' + (isUser ? 'user' : 'bot');
    d.textContent = text;
    msgs.appendChild(d);
    msgs.scrollTop = msgs.scrollHeight;
  }

  window.lcSend = async function() {
    const q = inp.value.trim();
    if (!q) return;
    addMsg(q, true);
    inp.value = '';
    btn.disabled = true;

    const typing = document.createElement('div');
    typing.className = 'cb-msg bot';
    typing.id = 'lc-typing';
    typing.innerHTML = '<span style="opacity:.6">Đang soạn...</span>';
    msgs.appendChild(typing);
    msgs.scrollTop = msgs.scrollHeight;

    try {
      const p = new URLSearchParams();
      p.append('question', q);
      const r = await fetch(ctx + '/student/ai-consult',
        { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:p });
      const data = await r.json();
      document.getElementById('lc-typing')?.remove();
      addMsg(data.answer || ('⚠ ' + (data.error || 'Lỗi không xác định')), false);
    } catch(e) {
      document.getElementById('lc-typing')?.remove();
      addMsg('⚠ Lỗi kết nối: ' + e.message, false);
    } finally {
      btn.disabled = false;
      inp.focus();
    }
  };
})();
</script>
<% } %>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ── Dropdown user ── */
function toggleDropdown(el) {
  const dd = el.querySelector('.lc-dropdown');
  if (!dd) return;
  dd.classList.toggle('open');
  document.addEventListener('click', function handler(e) {
    if (!el.contains(e.target)) {
      dd.classList.remove('open');
      document.removeEventListener('click', handler);
    }
  });
}

/* ── Sidebar submenu ── */
function toggleSubmenu(el, id) {
  const sub = document.getElementById(id);
  if (!sub) return;
  const isOpen = sub.classList.contains('open');
  // Đóng tất cả submenu khác
  document.querySelectorAll('.lc-submenu').forEach(s => s.classList.remove('open'));
  document.querySelectorAll('.lc-nav-item').forEach(n => n.classList.remove('expanded'));
  // Toggle cái được click
  if (!isOpen) {
    sub.classList.add('open');
    el.classList.add('expanded');
  }
}
</script>

</body>
</html>
