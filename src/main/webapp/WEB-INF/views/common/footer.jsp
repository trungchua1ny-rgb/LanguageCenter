<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <footer style="background:blue;; border-top:1px solid #e3e6f0;
                   text-align:center; padding:15px; margin-top:20px;
                   font-size:20px; color:#red; width: 100%;">
      © 2025 Language Center &nbsp;·&nbsp; Team 5 &nbsp;·&nbsp; Java MVC
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

</body>
</html>