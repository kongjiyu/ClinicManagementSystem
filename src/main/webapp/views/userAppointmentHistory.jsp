<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Appointment History</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>

<%@ include file="/views/userSidebar.jsp" %>


<div class="p-8 ml-64">
  <h1 class="text-3xl font-bold mb-6">Appointment History</h1>

  <div class="overflow-x-auto bg-white rounded-lg shadow-md">
    <table class="table table-zebra w-full text-left">
      <thead class="bg-gray-100">
        <tr>
          <th class="px-6 py-3">Appointment ID</th>
          <th class="px-6 py-3">Date &amp; Time</th>
          <th class="px-6 py-3">Status</th>
          <th class="px-6 py-3">Doctor</th>
          <th class="px-6 py-3">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="px-6 py-4">APT001</td>
          <td class="px-6 py-4">2025-08-01 10:00 AM</td>
          <td class="px-6 py-4 text-green-600 font-semibold">Completed</td>
          <td class="px-6 py-4">Dr. Lim Jun Kai</td>
          <td class="px-6 py-4">
            <button class="btn btn-sm btn-outline-primary">View</button>
          </td>
        </tr>
        <tr>
          <td class="px-6 py-4">APT002</td>
          <td class="px-6 py-4">2025-08-03 2:30 PM</td>
          <td class="px-6 py-4 text-red-500 font-semibold">Cancelled</td>
          <td class="px-6 py-4">Dr. Wong Siew Mei</td>
          <td class="px-6 py-4">
            <button class="btn btn-sm btn-outline-primary">View</button>
          </td>
        </tr>
        <tr>
          <td class="px-6 py-4">APT003</td>
          <td class="px-6 py-4">2025-08-10 11:15 AM</td>
          <td class="px-6 py-4 text-yellow-500 font-semibold">Upcoming</td>
          <td class="px-6 py-4">Dr. Tan Wei Jie</td>
          <td class="px-6 py-4">
            <button class="btn btn-sm btn-outline-primary">View</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

</body>
</html>
