<%--
Author: Yap Yu Xin
Consultation Module
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

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-2">Appointment History</h1>
    <p class="text-sm text-base-content/70">View all your past and current appointments</p>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <div id="appointmentHistoryContent" class="hidden">
    <div class="bg-base-100 p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold mb-4">Your Appointment History</h3>
      <div class="overflow-x-auto">
        <table class="table table-zebra w-full">
          <thead>
            <tr>
              <th>Date</th>
              <th>Time</th>
              <th>Type</th>
              <th>Status</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody id="appointmentHistoryTableBody">
            <!-- Data will be populated by JavaScript -->
          </tbody>
        </table>
      </div>
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

  // Get patient ID from session
  async function getPatientId() {
    try {
      const response = await fetch(API_BASE + '/auth/session');
      if (response.ok) {
        const session = await response.json();
        if (session.authenticated && session.userType === 'patient' && session.userId) {
          return session.userId;
        }
      }
    } catch (error) {
      console.error('Error getting patient ID from session:', error);
    }
    return null;
  }

  // Load appointment history data
  async function loadAppointmentHistory() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
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
      tbody.innerHTML = '<tr><td colspan="5" class="text-center text-gray-500">No appointment history found</td></tr>';
      return;
    }

    appointmentArray.forEach((appointment) => {
      const row = document.createElement('tr');
      
      // Format appointment date and time
      const appointmentDateTime = appointment.appointmentTime ? new Date(appointment.appointmentTime) : null;
      const date = appointmentDateTime ? appointmentDateTime.toLocaleDateString() : 'N/A';
      const time = appointmentDateTime ? appointmentDateTime.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit'
      }) : 'N/A';

      // Get status badge
      const statusBadge = getStatusBadge(appointment.status);

      row.innerHTML = 
        '<td>' + date + '</td>' +
        '<td>' + time + '</td>' +
        '<td>' + (appointment.appointmentType || 'Consultation') + '</td>' +
        '<td>' + statusBadge + '</td>' +
        '<td>' + (appointment.description || '-') + '</td>';
      
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
