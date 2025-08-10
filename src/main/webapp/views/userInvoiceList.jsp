<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Queue</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>

<%@ include file="/views/userSidebar.jsp" %>
<div class="p-8 ml-64">
  <h1 class="text-3xl font-bold mb-6">Invoice List</h1>

  <div class="overflow-x-auto bg-white rounded-lg shadow-md">
    <table class="table table-zebra w-full text-left">
      <thead class="bg-gray-100">
        <tr>
          <th class="px-6 py-3">Invoice ID</th>
          <th class="px-6 py-3">Date</th>
          <th class="px-6 py-3">Amount</th>
          <th class="px-6 py-3">Status</th>
          <th class="px-6 py-3">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="px-6 py-4">INV001</td>
          <td class="px-6 py-4">2025-08-01</td>
          <td class="px-6 py-4">RM120.00</td>
          <td class="px-6 py-4 text-green-600 font-semibold">Paid</td>
          <td class="px-6 py-4">
            <button class="btn btn-sm btn-outline-primary">View</button>
          </td>
        </tr>
        <tr>
          <td class="px-6 py-4">INV002</td>
          <td class="px-6 py-4">2025-08-03</td>
          <td class="px-6 py-4">RM80.00</td>
          <td class="px-6 py-4 text-yellow-600 font-semibold">Pending</td>
          <td class="px-6 py-4">
            <button class="btn btn-sm btn-outline-primary">View</button>
          </td>
        </tr>
        <tr>
          <td class="px-6 py-4">INV003</td>
          <td class="px-6 py-4">2025-08-10</td>
          <td class="px-6 py-4">RM150.00</td>
          <td class="px-6 py-4 text-red-500 font-semibold">Overdue</td>
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
