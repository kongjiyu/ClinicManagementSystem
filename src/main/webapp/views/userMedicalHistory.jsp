<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Medical History</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>

<%@ include file="/views/userSidebar.jsp" %>

<main class="p-6 md:ml-64">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 mt-6">
    <h1 class="text-2xl font-semibold mb-6">Your Medicine History</h1>

    <div class="overflow-x-auto bg-white rounded-lg shadow-md">
      <table class="table table-zebra w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3">Prescription ID</th>
            <th class="px-6 py-3">Date Issued</th>
            <th class="px-6 py-3">Doctor</th>
            <th class="px-6 py-3">Medicine Name(s)</th>
            <th class="px-6 py-3">Dosage & Duration</th>
            <th class="px-6 py-3">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="px-6 py-4">RX001</td>
            <td class="px-6 py-4">2025-07-01</td>
            <td class="px-6 py-4">Dr. Lim Wei Jun</td>
            <td class="px-6 py-4">Paracetamol</td>
            <td class="px-6 py-4">500mg, 3 times daily, 5 days</td>
            <td class="px-6 py-4 text-green-600 font-semibold">Completed</td>
          </tr>
          <tr>
            <td class="px-6 py-4">RX002</td>
            <td class="px-6 py-4">2025-07-15</td>
            <td class="px-6 py-4">Dr. Jane Tan</td>
            <td class="px-6 py-4">Amoxicillin</td>
            <td class="px-6 py-4">250mg, 2 times daily, 7 days</td>
            <td class="px-6 py-4 text-yellow-500 font-semibold">Ongoing</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</main>

</body>
</html>
