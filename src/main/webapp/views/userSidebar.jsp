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
        <li><a href="<%= request.getContextPath() %>/views/userDashboard.jsp"><span class="icon-[tabler--home] size-5"></span>Dashboard</a></li>
        <li><a href="<%= request.getContextPath() %>/views/userCreateAppointment.jsp"><span class="icon-[tabler--calendar-plus] size-5"></span>Create Appointment</a></li>
        <li><a href="<%= request.getContextPath() %>/views/userAppointmentHistory.jsp"><span class="icon-[tabler--history] size-5"></span>Appointment History</a></li>
        <li><a href="<%= request.getContextPath() %>/views/userInvoiceList.jsp"><span class="icon-[tabler--receipt-2] size-5"></span>Invoice</a></li>
        <li><a href="<%= request.getContextPath() %>/views/userMedicalHistory.jsp"><span class="icon-[tabler--notes] size-5"></span>Medical History</a></li>
        <li><a href="<%= request.getContextPath() %>/views/userQueue.jsp"><span class="icon-[tabler--clock-hour-5] size-5"></span>Your Queue</a></li>
      </div>
      <div class="mt-6">
        <li>
          <a href="<%= request.getContextPath() %>/views/userProfile.jsp">
            <div class="flex items-center gap-3">
              <div class="avatar"><div class="w-8 rounded-full"><img src="https://cdn.flyonui.com/fy-assets/avatar/avatar-1.png" alt="profile"/></div></div>
              <div>
                <div class="text-sm font-semibold">User</div>
                <div class="text-xs text-base-content/50">Profile</div>
              </div>
            </div>
          </a>
        </li>
      </div>
    </ul>
  </div>
</aside>
</body>
</html>
