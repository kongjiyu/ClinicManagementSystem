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

<button type="button" class="btn btn-text max-sm:btn-square sm:hidden" aria-haspopup="dialog" aria-expanded="false" aria-controls="logo-sidebar" data-overlay="#logo-sidebar" >
  <span class="icon-[tabler--menu-2] size-5"></span>
</button>

<aside id="logo-sidebar" class="overlay [--auto-close:sm] sm:shadow-none overlay-open:translate-x-0 drawer drawer-start hidden max-w-64 sm:absolute sm:z-0 sm:flex sm:translate-x-0" role="dialog" tabindex="-1" >
  <div class="drawer-header">
    <div class="flex items-center gap-3">
      <h3 class="drawer-title text-xl font-semibold">Admin</h3>
    </div>
  </div>
  <div class="drawer-body px-2">
    <ul class="menu p-0 flex flex-col justify-between h-full">
      <div>
        <li>
          <a href="#">
            <span class="icon-[tabler--home] size-5"></span>
            Dashboard
          </a>
        </li>
        <li>
          <a href="#">
            <span class="icon-[tabler--activity-heartbeat] size-5"></span>
            Queue
          </a>
        </li>
        <li>
          <a href="#">
            <span class="icon-[tabler--user] size-5"></span>
            Patient
          </a>
        </li>
        <li>
          <a href="#">
            <span class="icon-[tabler--stethoscope] size-5"></span>
            Consultation
          </a>
        </li>
        <li class="space-y-0.5">
          <a class="collapse-toggle collapse-open:bg-base-content/10" id="menu-pharmacy" data-collapse="#menu-pharmacy-collapse">
            <span class="icon-[tabler--medical-cross] size-5"></span>
            Pharmacy
            <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 transition-all duration-300"></span>
          </a>
          <ul id="menu-pharmacy-collapse" class="collapse hidden w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="menu-pharmacy">
            <li>
              <a href="#">
                <span class="icon-[tabler--pill] size-5"></span>
                List of Medicine
              </a>
            </li>
            <li>
              <a href="#">
                <span class="icon-[tabler--syringe] size-5"></span>
                Medicine Dispensing
              </a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#">
            <span class="icon-[tabler--user-star] size-5"></span>
            Doctor
          </a>
        </li>
      </div>
      <div class="mt-6">
        <li>
          <a href="#">
            <div class="flex items-center gap-3">
              <div class="avatar">
                <div class="w-8 rounded-full">
                  <img src="https://cdn.flyonui.com/fy-assets/avatar/avatar-1.png" alt="profile"/>
                </div>
              </div>
              <div>
                <div class="text-sm font-semibold">Admin</div>
                <div class="text-xs text-base-content/50">Profile</div>
              </div>
            </div>
          </a>
        </li>
      </div>
    </ul>
  </div>
</aside>

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
