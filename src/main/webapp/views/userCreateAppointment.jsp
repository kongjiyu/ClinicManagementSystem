<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>New Appointment</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="p-8 bg-gray-50 text-sm">
<%@ include file="/views/userSidebar.jsp" %>

  <div class="max-w-3xl mx-auto bg-white shadow-md p-8 rounded-md">
    <form method="post" action="${pageContext.request.contextPath}/appointment" class="space-y-6 max-w-xl mx-auto">
        <h2 class="text-2xl font-semibold">Create New Appointment</h2>

        <!-- Select Date -->
        <div>
            <label class="label">Appointment Date</label>
            <input type="date" name="appointmentDate" class="input input-bordered w-full"
                   min="<%= java.time.LocalDate.now() %>"
                   max="<%= java.time.LocalDate.now().plusMonths(1) %>"
                   required />
        </div>

        <!-- Select Time -->
        <div>
            <label class="label">Appointment Time</label>
            <select name="appointmentTime" class="select select-bordered w-full" required>
                <option value="" disabled selected>Select a time slot</option>
                <option value="09:00">09:00 AM</option>
                <option value="09:30">09:30 AM</option>
                <option value="10:00">10:00 AM</option>
                <option value="10:30">10:30 AM</option>
                <option value="11:00">11:00 AM</option>
                <option value="11:30">11:30 AM</option>
                <option value="14:00">02:00 PM</option>
                <option value="14:30">02:30 PM</option>
                <option value="15:00">03:00 PM</option>
                <option value="15:30">03:30 PM</option>
                <option value="16:00">04:00 PM</option>
            </select>
        </div>

        <!-- Notes (Optional) -->
        <div>
            <label class="label">Notes / Reason</label>
            <textarea name="note" class="textarea textarea-bordered w-full" placeholder="Describe your reason (optional)"></textarea>
        </div>

        <!-- Submit -->
        <div class="text-right">
            <input type="hidden" name="action" value="create" />
            <button type="submit" class="btn btn-primary">Submit Appointment</button>
        </div>
    </form>
  </div>
</body>
</html>
