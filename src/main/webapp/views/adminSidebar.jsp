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
  <title>Sidebar</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<aside id="logo-sidebar" class="fixed top-0 left-0 z-40 h-screen w-64 border-r sm:flex hidden flex-col" role="dialog" tabindex="-1">
  <div class="drawer-header">
    <div class="flex items-center gap-3">
      <h3 class="drawer-title text-xl font-semibold">Admin</h3>
    </div>
  </div>
  <div class="drawer-body px-2">
    <ul class="menu p-0 flex flex-col justify-between h-full">
      <div>
        <li><a href="<%= request.getContextPath() %>/views/adminDashboard.jsp"><span class="icon-[tabler--home] size-5"></span>Dashboard</a></li>
        <li><a href="<%= request.getContextPath() %>/views/adminQueue.jsp"><span class="icon-[tabler--activity-heartbeat] size-5"></span>Queue</a></li>
        <li><a href="<%= request.getContextPath() %>/views/patientList.jsp"><span class="icon-[tabler--user] size-5"></span>Patient</a></li>
        <li><a href="<%= request.getContextPath() %>/views/appointmentList.jsp"><span class="icon-[tabler--list] size-5"></span>Appointments</a></li>
        <li><a href="<%= request.getContextPath() %>/views/appointmentCalendar.jsp"><span class="icon-[tabler--calendar] size-5"></span>Calendar</a></li>
        <li><a href="<%= request.getContextPath() %>/views/adminDoctorSchedule.jsp"><span class="icon-[tabler--calendar-time] size-5"></span>Doctor Schedule</a></li>
        <li><a href="<%= request.getContextPath() %>/views/consultationList.jsp"><span class="icon-[tabler--stethoscope] size-5"></span>Consultation</a></li>
        <li><a href="<%= request.getContextPath() %>/views/treatmentList.jsp"><span class="icon-[tabler--medical-cross] size-5"></span>Treatment</a></li>
        <li><a href="<%= request.getContextPath() %>/views/invoiceList.jsp"><span class="icon-[tabler--receipt] size-5"></span>Invoices</a></li>
        <li><a href="<%= request.getContextPath() %>/views/medicineList.jsp"><span class="icon-[tabler--pill] size-5"></span>Medicine</a></li>
        <li><a href="<%= request.getContextPath() %>/views/orderList.jsp"><span class="icon-[tabler--package] size-5"></span>Orders</a></li>
        <li><a href="<%= request.getContextPath() %>/views/reportsDashboard.jsp"><span class="icon-[tabler--chart-bar] size-5"></span>Reports</a></li>
        <li><a href="<%= request.getContextPath() %>/views/staffList.jsp"><span class="icon-[tabler--user-star] size-5"></span>Staff</a></li>
      </div>
      <div class="mt-6">
        <li>
          <a href="<%= request.getContextPath() %>/views/adminProfile.jsp">
            <div class="flex items-center gap-3">
              <div class="avatar"><div class="w-8 rounded-full"><img src="https://cdn.flyonui.com/fy-assets/avatar/avatar-1.png" alt="profile"/></div></div>
              <div>
                <div class="text-sm font-semibold" id="adminName">Admin</div>
                <div class="text-xs text-base-content/50">Profile</div>
              </div>
            </div>
          </a>
        </li>
        <li>
          <a href="#" onclick="logout()" class="text-red-600 hover:bg-red-50">
            <span class="icon-[tabler--logout] size-5"></span>
            Logout
          </a>
        </li>
      </div>
    </ul>
  </div>
</aside>

<script>
  // Load user session info
  async function loadUserSession() {
    try {
      const response = await fetch('<%= request.getContextPath() %>/api/auth/session');
      if (response.ok) {
        const session = await response.json();
        if (session.authenticated && session.userName) {
          document.getElementById('adminName').textContent = session.userName;
        }
      }
    } catch (error) {
      console.error('Error loading session:', error);
    }
  }

  // Logout function
  async function logout() {
    if (confirm('Are you sure you want to logout?')) {
      try {
        const response = await fetch('<%= request.getContextPath() %>/api/auth/logout', {
          method: 'POST'
        });
        
        if (response.ok) {
          window.location.href = '<%= request.getContextPath() %>/login.jsp';
        } else {
          alert('Logout failed. Please try again.');
        }
      } catch (error) {
        console.error('Logout error:', error);
        alert('An error occurred during logout.');
      }
    }
  }

  // Load session when page loads
  document.addEventListener('DOMContentLoaded', loadUserSession);
</script>
</body>
</html>
