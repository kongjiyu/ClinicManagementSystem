<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 31/07/2025
  Time: 10:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Title</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/userSidebar.jsp" %>

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <!-- Welcome and Summary -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h2 class="text-2xl font-bold mb-2">Welcome back, <%= session.getAttribute("username") %>!</h2>
    <p class="text-sm text-base-content/70">Today is <%= java.time.LocalDate.now() %>.</p>
  </div>

  <!-- Next Appointment -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h3 class="text-xl font-semibold mb-4">Your Upcoming Appointment</h3>
    <div class="overflow-x-auto">
      <table class="table table-zebra w-full">
        <thead>
          <tr>
            <th>Date</th>
            <th>Time</th>
            <th>Doctor</th>
            <th>Type</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Example Row -->
          <tr>
            <td>2025-08-01</td>
            <td>10:30 AM</td>
            <td>Dr. Lee</td>
            <td>Consultation</td>
            <td><span class="badge badge-success">Confirmed</span></td>
            <td>
              <button class="btn btn-xs btn-warning">Reschedule</button>
              <button class="btn btn-xs btn-error">Cancel</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Clinic Rules -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h3 class="text-xl font-semibold mb-4">Clinic Rules & Regulations</h3>
    <ul class="list-disc list-inside text-base-content/80 space-y-1">
      <li>Arrive at least 10 minutes before your appointment.</li>
      <li>Notify 24 hours in advance for cancellations.</li>
      <li>Masks must be worn at all times in the clinic.</li>
      <li>Maintain silence in waiting areas.</li>
    </ul>
  </div>

  <!-- Operating Hours -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h3 class="text-xl font-semibold mb-4">Clinic Operating Hours</h3>
    <ul class="text-base-content/80 space-y-1">
      <li>Monday – Friday: 9:00 AM – 6:00 PM</li>
      <li>Saturday: 9:00 AM – 1:00 PM</li>
      <li>Sunday & Public Holidays: Closed</li>
    </ul>
  </div>

  <!-- Quick Links -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <a href="<%= request.getContextPath() %>/user/medicalHistory" class="btn btn-outline btn-primary w-full">View Medical History</a>
    <a href="<%= request.getContextPath() %>/user/invoice" class="btn btn-outline btn-secondary w-full">View Invoices</a>
  </div>
</div>

</body>
</html>
