<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 23/07/2025
  Time: 10:59 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Admin Dashboard</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/sidebar.jsp" %>

<main class="p-6 sm:ml-64">
  <h1 class="text-2xl font-semibold text-base-content mb-4">Dashboard Overview</h1>

  <!-- FlyonUI Stats Block -->
  <div class="stats mb-6">
    <div class="stat">
      <div class="stat-figure text-base-content size-8">
        <span class="icon-[tabler--world] size-8"></span>
      </div>
      <div class="stat-title">Website Traffic</div>
      <div class="stat-value">32K</div>
      <div class="stat-desc">5% ↗︎ than last week</div>
    </div>

    <div class="stat">
      <div class="stat-figure text-base-content size-8">
        <span class="icon-[tabler--users-group] size-8"></span>
      </div>
      <div class="stat-title">New Signups</div>
      <div class="stat-value">1.2K</div>
      <div class="stat-desc">12% increase this month</div>
    </div>

    <div class="stat">
      <div class="stat-figure size-12">
        <div class="avatar">
          <div class="size-12 rounded-full">
            <img src="https://cdn.flyonui.com/fy-assets/avatar/avatar-2.png" alt="User Avatar"/>
          </div>
        </div>
      </div>
      <div class="stat-value text-success">95%</div>
      <div class="stat-title">Customer Retention</div>
      <div class="stat-desc">Steady over last quarter</div>
    </div>
  </div>

  <!-- Chart.js Container -->
  <div class="bg-white p-4 rounded-lg shadow-md">
    <canvas id="dashboardChart" width="400" height="200"></canvas>
  </div>
</main>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  const ctx = document.getElementById('dashboardChart').getContext('2d');
  const dashboardChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      datasets: [{
        label: 'Visits',
        data: [120, 190, 300, 500, 200, 300, 450],
        backgroundColor: 'rgba(94, 131, 242, 0.2)',
        borderColor: '#5E83F2',
        borderWidth: 2,
        fill: true,
        tension: 0.4
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          display: false
        }
      },
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
</script>
</body>
</html>
