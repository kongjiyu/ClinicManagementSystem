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
        <li><a href="<%= request.getContextPath() %>/views/consultationList.jsp"><span class="icon-[tabler--stethoscope] size-5"></span>Consultation</a></li>
        <li class="space-y-0.5">
          <a class="collapse-toggle collapse-open:bg-base-content/10" id="menu-pharmacy" data-collapse="#menu-pharmacy-collapse">
            <span class="icon-[tabler--medical-cross] size-5"></span>
            Pharmacy
            <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 transition-all duration-300"></span>
          </a>
          <ul id="menu-pharmacy-collapse" class="collapse hidden w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="menu-pharmacy">
            <li><a href="<%= request.getContextPath() %>/views/medicineList.jsp"><span class="icon-[tabler--pill] size-5"></span>List of Medicine</a></li>
            <li><a href="#"><span class="icon-[tabler--syringe] size-5"></span>Medicine Dispensing</a></li>
          </ul>
        </li>
        <li><a href="<%= request.getContextPath() %>/views/staffList.jsp"><span class="icon-[tabler--user-star] size-5"></span>Staff</a></li>
      </div>
      <div class="mt-6">
        <li>
          <a href="#">
            <div class="flex items-center gap-3">
              <div class="avatar"><div class="w-8 rounded-full"><img src="https://cdn.flyonui.com/fy-assets/avatar/avatar-1.png" alt="profile"/></div></div>
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
</body>
</html>
