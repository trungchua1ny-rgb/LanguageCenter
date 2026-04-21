<%@ page contentType="text/html;charset=UTF-8" language="java" %>

</div><%-- đóng .page-content --%>
</div><%-- đóng .main-wrapper --%>

<!-- ══════════════ FOOTER ══════════════ -->
<footer style="background:#fff; border-top:1px solid #e3e6f0;
               text-align:center; padding:12px;
               font-size:12px; color:#adb5bd;">
  © 2025 Language Center &nbsp;·&nbsp; Team 5 &nbsp;·&nbsp; Java MVC
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Đóng sidebar khi click ra ngoài (mobile) -->
<script>
  document.addEventListener('click', function(e) {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('sidebarToggle');
    if (sidebar && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
      sidebar.classList.remove('show');
    }
  });
</script>

</body>
</html>
