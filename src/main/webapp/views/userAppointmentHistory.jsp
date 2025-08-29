<%--
Author: Chia Yu Xin
Consultation Module
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Appointment History</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script defer src="<%= request.getContextPath() %>/static/malaysian-date-utils.js"></script>
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
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Your Appointment History</h3>
        <div class="flex gap-4 items-end">
          <!-- Status Filter -->
          <div class="form-control">
            <label class="label">
              <span class="label-text">Filter by Status</span>
            </label>
            <select id="statusFilter" class="select select-bordered select-sm">
              <option value="">All Status</option>
              <option value="scheduled">Scheduled</option>
              <option value="confirmed">Confirmed</option>
              <option value="cancelled">Cancelled</option>
              <option value="completed">Completed</option>
              <option value="check in">Checked In</option>
              <option value="noshow">No Show</option>
            </select>
          </div>
          
          <!-- Date Range Filter -->
          <div class="form-control">
            <label class="label">
              <span class="label-text">From Date</span>
            </label>
            <input type="date" id="fromDateFilter" class="input input-bordered input-sm">
          </div>
          
          <div class="form-control">
            <label class="label">
              <span class="label-text">To Date</span>
            </label>
            <input type="date" id="toDateFilter" class="input input-bordered input-sm">
          </div>
          
          <!-- Clear Filters Button -->
          <button id="clearFilters" class="btn btn-outline btn-sm">
            <span class="icon-[tabler--filter-off] size-4"></span>
            Clear Filters
          </button>
        </div>
      </div>
      
      <div class="overflow-x-auto">
        <table class="table table-zebra w-full">
          <thead>
            <tr>
              <th>Date</th>
              <th>Time</th>
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
  let allAppointments = []; // Store all appointments for filtering

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
      
      // Handle custom List structure and store all appointments
      if (appointments && appointments.elements) {
        allAppointments = appointments.elements;
      } else if (Array.isArray(appointments)) {
        allAppointments = appointments;
      } else {
        allAppointments = [];
      }
      
      // Sort appointments by date in descending order (newest first)
      allAppointments.sort((a, b) => {
        const dateA = new Date(a.appointmentTime);
        const dateB = new Date(b.appointmentTime);
        return dateB - dateA;
      });
      
      populateAppointmentHistoryTable(allAppointments);
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

    // Apply filters
    const filteredAppointments = applyFilters(appointments);

    if (!filteredAppointments || filteredAppointments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="text-center text-gray-500">No appointment history found</td></tr>';
      return;
    }

    filteredAppointments.forEach((appointment) => {
      const row = document.createElement('tr');

      // Format appointment date and time with better error handling
      let date = 'N/A';
      let time = 'N/A';
      
      if (appointment.appointmentTime) {
        try {
          const appointmentDateTime = new Date(appointment.appointmentTime);
          if (!isNaN(appointmentDateTime.getTime())) {
            date = formatDateDDMMYYYY(appointmentDateTime);
            time = formatMalaysianTime(appointmentDateTime);
          }
        } catch (error) {
          console.error('Error parsing appointment date:', appointment.appointmentTime, error);
        }
      }

      // Get status badge
      const statusBadge = getStatusBadge(appointment.status);

      row.innerHTML =
        '<td>' + date + '</td>' +
        '<td>' + time + '</td>' +
        '<td>' + statusBadge + '</td>' +
        '<td>' + (appointment.description || '-') + '</td>';

      tbody.appendChild(row);
    });
  }

  // Apply filters to appointments
  function applyFilters(appointments) {
    const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
    const fromDateFilter = document.getElementById('fromDateFilter').value;
    const toDateFilter = document.getElementById('toDateFilter').value;

    return appointments.filter(appointment => {
      // Status filter
      if (statusFilter && appointment.status && appointment.status.toLowerCase() !== statusFilter) {
        return false;
      }

      // Date range filter
      if (appointment.appointmentTime) {
        const appointmentDate = new Date(appointment.appointmentTime);
        const appointmentDateStr = appointmentDate.toISOString().split('T')[0];

        if (fromDateFilter && appointmentDateStr < fromDateFilter) {
          return false;
        }
        if (toDateFilter && appointmentDateStr > toDateFilter) {
          return false;
        }
      }

      return true;
    });
  }

  // Format date as dd/mm/yyyy
  function formatDateDDMMYYYY(date) {
    // Check if date is valid
    if (!date || isNaN(date.getTime())) {
      return 'N/A';
    }
    
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return day + '/' + month + '/' + year;
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
    
    // Add event listeners for filters
    document.getElementById('statusFilter').addEventListener('change', function() {
      populateAppointmentHistoryTable(allAppointments);
    });
    
    document.getElementById('fromDateFilter').addEventListener('change', function() {
      populateAppointmentHistoryTable(allAppointments);
    });
    
    document.getElementById('toDateFilter').addEventListener('change', function() {
      populateAppointmentHistoryTable(allAppointments);
    });
    
    // Clear filters button
    document.getElementById('clearFilters').addEventListener('click', function() {
      document.getElementById('statusFilter').value = '';
      document.getElementById('fromDateFilter').value = '';
      document.getElementById('toDateFilter').value = '';
      populateAppointmentHistoryTable(allAppointments);
    });
  });
</script>
</body>
</html>
