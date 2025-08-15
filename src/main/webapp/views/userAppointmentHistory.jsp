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

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <div id="appointmentHistoryContent" class="hidden">
    <div class="overflow-x-auto bg-white rounded-lg shadow-md">
      <table class="table table-zebra w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3">Appointment ID</th>
            <th class="px-6 py-3">Date &amp; Time</th>
            <th class="px-6 py-3">Status</th>
          </tr>
        </thead>
        <tbody id="appointmentHistoryTableBody">
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>
</div>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let patientId = null;

  // Get patient ID from session or URL parameter
  function getPatientId() {
    // For now, we'll use a default patient ID
    // In a real application, this would come from the user's session
    return 'PT0001'; // Default patient ID for testing
  }

  // Load appointment history data
  async function loadAppointmentHistory() {
    patientId = getPatientId();
    
    try {
      const response = await fetch(API_BASE + '/patients/' + patientId + '/appointment-history');
      if (!response.ok) {
        throw new Error('Failed to load appointment history');
      }
      
      const appointments = await response.json();
      populateAppointmentHistoryTable(appointments);
      hideLoading();
    } catch (error) {
      console.error('Error loading appointment history:', error);
      showError('Failed to load appointment history: ' + error.message);
      hideLoading();
    }
  }

  // Populate appointment history table
  function populateAppointmentHistoryTable(appointments) {
    const tbody = document.getElementById('appointmentHistoryTableBody');
    tbody.innerHTML = '';

    // Handle custom List structure
    let appointmentArray = [];
    if (appointments && appointments.elements) {
      appointmentArray = appointments.elements;
    } else if (Array.isArray(appointments)) {
      appointmentArray = appointments;
    }

    if (!appointmentArray || appointmentArray.length === 0) {
      tbody.innerHTML = '<tr><td colspan="3" class="text-center text-gray-500">No appointment history found</td></tr>';
      return;
    }

    appointmentArray.forEach((appointment) => {
      const row = document.createElement('tr');
      
      // Format appointment date and time
      const appointmentDateTime = appointment.appointmentTime ? new Date(appointment.appointmentTime) : null;
      const dateTime = appointmentDateTime ? appointmentDateTime.toLocaleString('en-US', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      }) : 'N/A';

      // Get status badge
      const statusBadge = getStatusBadge(appointment.status);

      row.innerHTML = 
        '<td class="px-6 py-4">' + (appointment.appointmentID || 'N/A') + '</td>' +
        '<td class="px-6 py-4">' + dateTime + '</td>' +
        '<td class="px-6 py-4">' + statusBadge + '</td>';
      
      tbody.appendChild(row);
    });
  }

  // Get status badge HTML
  function getStatusBadge(status) {
    if (!status) return '<span class="badge badge-soft badge-neutral">Unknown</span>';
    
    const statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'scheduled':
      case 'confirmed':
        return '<span class="badge badge-soft badge-success">Confirmed</span>';
      case 'cancelled':
        return '<span class="badge badge-soft badge-error">Cancelled</span>';
      case 'noshow':
      case 'no shown':
        return '<span class="badge badge-soft badge-error">No Show</span>';
      case 'check in':
      case 'checked-in':
        return '<span class="badge badge-soft badge-info">Checked In</span>';
      case 'completed':
        return '<span class="badge badge-soft badge-success">Completed</span>';
      default:
        return '<span class="badge badge-soft badge-neutral">' + status + '</span>';
    }
  }



  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
    document.getElementById('appointmentHistoryContent').classList.remove('hidden');
  }

  // Initialize appointment history
  document.addEventListener('DOMContentLoaded', function() {
    loadAppointmentHistory();
  });
</script>
</body>
</html>
