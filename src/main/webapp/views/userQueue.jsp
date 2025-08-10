<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:48 PM
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
  <h1 class="text-3xl font-bold mb-6">Your Queue</h1>

  <div class="bg-white shadow-md rounded-lg p-6">
    <p class="text-lg mb-4">There are currently <span class="font-semibold text-blue-600">5</span> patient(s) in queue before you.</p>
    <p class="text-lg mb-4">Estimated waiting time: <span class="font-semibold text-blue-600">50</span> minutes.</p>

    <div class="mt-6">
      <button class="btn btn-primary">Refresh</button>
    </div>
  </div>
</div>


</body>
</html>
