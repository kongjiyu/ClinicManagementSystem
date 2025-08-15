<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Queue Management</title>
  <link href="<% out.print(request.getContextPath()); %>/static/output.css" rel="stylesheet">
  <style>
    /* Custom Modal Styles */
    .custom-modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(4px);
    }

    .custom-modal.show {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .modal-content {
      background-color: white;
      margin: auto;
      padding: 0;
      border-radius: 8px;
      width: 90%;
      max-width: 500px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
      animation: modalSlideIn 0.3s ease-out;
    }

    @keyframes modalSlideIn {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .modal-header {
      padding: 20px 24px 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .modal-title {
      font-size: 1.25rem;
      font-weight: 600;
      color: #333;
      margin: 0;
    }

    .modal-close {
      background: none;
      border: none;
      font-size: 1.5rem;
      cursor: pointer;
      color: #666;
      padding: 4px;
      border-radius: 4px;
      transition: color 0.2s;
    }

    .modal-close:hover {
      color: #333;
    }

    .modal-body {
      padding: 20px 24px;
    }

    .modal-footer {
      padding: 0 24px 20px 24px;
      display: flex;
      justify-content: flex-end;
      gap: 12px;
    }

    .btn {
      padding: 8px 16px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      font-size: 0.875rem;
      font-weight: 500;
      transition: all 0.2s;
    }

    .btn-secondary {
      background-color: #f3f4f6;
      color: #374151;
    }

    .btn-secondary:hover {
      background-color: #e5e7eb;
    }

    .btn-primary {
      background-color: #3b82f6;
      color: white;
    }

    .btn-primary:hover {
      background-color: #2563eb;
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-label {
      display: block;
      margin-bottom: 6px;
      font-weight: 500;
      color: #374151;
    }

    .form-select {
      width: 100%;
      padding: 8px 12px;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 0.875rem;
      background-color: white;
    }

    .form-select:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
  </style>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6 pr-6">
  <div class="flex justify-between items-center">
    <h1 class="text-2xl font-bold">Today's Queue</h1>
    <button id="refresh-btn" class="btn btn-primary" onclick="loadQueueData()">
      <span class="icon-[tabler--refresh] size-4 mr-2"></span>
      Refresh Queue
    </button>
  </div>

  <div class="space-y-8">
    <h2 class="text-xl font-semibold mb-2">Appointments</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="appointments-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Appointment Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Waiting List</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="waiting-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">In Progress</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="in-progress-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Billing</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="billing-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Completed</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="completed-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Name</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>
  </div>

  <!-- Custom Modals Container -->
  <div id="modals-container">
    <!-- Modals will be generated dynamically -->
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let queueData = {};

  // Load queue data from API
  async function loadQueueData() {
    try {
      const response = await fetch(API_BASE + '/queue');

      if (!response.ok) {
        throw new Error('Failed to load queue data: ' + response.status);
      }

      queueData = await response.json();
      renderAllTables();
    } catch (error) {
      console.error('Error loading queue data:', error);
      alert('Error loading queue data: ' + error.message);
    }
  }

  // Render all tables
  function renderAllTables() {
    renderTable('appointments-table', queueData.appointments?.elements || []);
    renderTable('waiting-table', queueData.waiting?.elements || []);
    renderTable('in-progress-table', queueData.inProgress?.elements || []);
    renderTable('billing-table', queueData.billing?.elements || []);
    renderTable('completed-table', queueData.completed?.elements || []);

    // Generate modals for all consultations
    generateModals();
  }

  // Render individual table
  function renderTable(tableId, data) {
    const table = document.getElementById(tableId);
    const tbody = table.querySelector('tbody');
    tbody.innerHTML = '';

    if (!data || !Array.isArray(data) || data.length === 0) {
      let colspan = '5'; // Default for most tables
      if (tableId === 'completed-table') {
        colspan = '3'; // Completed table has no waiting time and no actions
      } else if (tableId === 'appointments-table') {
        colspan = '4'; // Appointments table has no waiting time column
      }
      tbody.innerHTML = '<tr><td colspan="' + colspan + '" class="text-center text-gray-500">No items in this queue</td></tr>';
      return;
    }

    data.forEach(item => {
      const row = document.createElement('tr');
      
      // Handle QueueItem DTO objects
      let consultationId = item.consultationId;
      let status = item.status || 'Waiting';
      let checkInTime = item.checkInTime;
      let patientName = item.patientName || 'Unknown';

      // Different button for appointments vs consultations
      let actionButton;
      if (status === 'Appointment') {
        actionButton =
          '<button type="button" class="btn btn-circle btn-text btn-sm checkin-appointment-btn" ' +
                  'data-appointment-id="' + consultationId + '">' +
            '<span class="icon-[tabler--check] size-5"></span>' +
          '</button>';
      } else {
        actionButton =
          '<button type="button" class="btn btn-circle btn-text btn-sm update-status-btn" ' +
                  'data-consultation-id="' + consultationId + '" ' +
                  'data-status="' + status + '">' +
            '<span class="icon-[tabler--pencil] size-5"></span>' +
          '</button>';
      }

      // Different row structure for completed table (no waiting time and no actions)
      if (tableId === 'completed-table') {
        row.innerHTML =
          '<td>' + consultationId + '</td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>';
      } else if (status === 'Appointment') {
        // Appointments don't show waiting time
        row.innerHTML =
          '<td>' + consultationId + '</td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td>' + actionButton + '</td>';
      } else {
        // Consultations show waiting time
        row.innerHTML =
          '<td>' + consultationId + '</td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td class="waiting-time" data-checkin="' + (checkInTime || '') + '"><span class="time-text">' + calculateWaitingTime(checkInTime) + '</span></td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td>' + actionButton + '</td>';
      }
      
      tbody.appendChild(row);
    });
  }

  // Format time for display
  function formatTime(dateTimeString) {
    if (!dateTimeString) return 'N/A';
    try {
      const date = new Date(dateTimeString);
      return date.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
      });
    } catch (error) {
      return 'N/A';
    }
  }

  // Calculate waiting time in real-time from check-in time
  function calculateWaitingTime(checkInTimeString) {
    if (!checkInTimeString) return '00:00:00';
    
    try {
      const checkInTime = new Date(checkInTimeString);
      const now = new Date();
      const diffMs = now - checkInTime;
      
      if (diffMs < 0) {
        return '00:00:00';
      }
      
      const diffMinutes = Math.floor(diffMs / (1000 * 60));
      const hours = Math.floor(diffMinutes / 60);
      const minutes = diffMinutes % 60;
      const seconds = Math.floor((diffMs / 1000) % 60);
      
      return String(hours).padStart(2, '0') + ':' + String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
    } catch (error) {
      return '00:00:00';
    }
  }

  // Update all waiting times in real-time
  function updateWaitingTimes() {
    const waitingTimeCells = document.querySelectorAll('.waiting-time');
    waitingTimeCells.forEach(cell => {  
      const checkInTime = cell.getAttribute('data-checkin');
      if (checkInTime) {
        // Only update the text content, not the entire cell
        const timeSpan = cell.querySelector('.time-text') || cell;
        timeSpan.textContent = calculateWaitingTime(checkInTime);
      }
    });
  }

  // Start real-time updates
  function startRealTimeUpdates() {
    // Update waiting times every second
    setInterval(updateWaitingTimes, 1000);
  }

  // Generate modals for all consultations
  function generateModals() {
    const container = document.getElementById('modals-container');
    container.innerHTML = '';

    // Collect all consultation IDs from all tables
    const allConsultations = [];

    // Add consultations from each category
    if (queueData.appointments?.elements && Array.isArray(queueData.appointments.elements)) {
      allConsultations.push(...queueData.appointments.elements);
    }
    if (queueData.waiting?.elements && Array.isArray(queueData.waiting.elements)) {
      allConsultations.push(...queueData.waiting.elements);
    }
    if (queueData.inProgress?.elements && Array.isArray(queueData.inProgress.elements)) {
      allConsultations.push(...queueData.inProgress.elements);
    }
    if (queueData.billing?.elements && Array.isArray(queueData.billing.elements)) {
      allConsultations.push(...queueData.billing.elements);
    }
    if (queueData.completed?.elements && Array.isArray(queueData.completed.elements)) {
      allConsultations.push(...queueData.completed.elements);
    }

    allConsultations.forEach(item => {
      let consultationId = item.consultationId;
      let currentStatus = item.status || 'Waiting';
      
      console.log('Generating modal for:', consultationId, currentStatus);

      // Different modal for appointments vs consultations
      if (currentStatus === 'Appointment') {
        // Modal for checking in appointments
        const modalHtml =
          '<div id="checkin-appointment-modal-' + consultationId + '" class="custom-modal">' +
            '<div class="modal-content">' +
              '<div class="modal-header">' +
                '<h3 class="modal-title">Check In Appointment</h3>' +
                '<button type="button" class="modal-close" onclick="closeModal(\'checkin-appointment-modal-' + consultationId + '\')">&times;</button>' +
              '</div>' +
              '<div class="modal-body">' +
                '<p>Are you sure you want to check in this appointment? This will create a consultation and move the patient to the waiting queue.</p>' +
              '</div>' +
              '<div class="modal-footer">' +
                '<button type="button" class="btn btn-secondary" onclick="closeModal(\'checkin-appointment-modal-' + consultationId + '\')">Cancel</button>' +
                '<button type="button" class="btn btn-primary" onclick="handleAppointmentCheckIn(\'' + consultationId + '\')">Check In</button>' +
              '</div>' +
            '</div>' +
          '</div>';

        container.insertAdjacentHTML('beforeend', modalHtml);
      } else {
        // Modal for updating consultation status
        const modalHtml =
          '<div id="update-status-modal-' + consultationId + '" class="custom-modal">' +
            '<div class="modal-content">' +
              '<div class="modal-header">' +
                '<h3 class="modal-title">Update Status</h3>' +
                '<button type="button" class="modal-close" onclick="closeModal(\'update-status-modal-' + consultationId + '\')">&times;</button>' +
              '</div>' +
              '<form class="status-update-form" data-consultation-id="' + consultationId + '">' +
                '<div class="modal-body">' +
                  '<div class="form-group">' +
                    '<label class="form-label">Status</label>' +
                    '<select name="status" id="modal-status-' + consultationId + '" class="form-select">' +
                      '<option value="Waiting"' + (currentStatus === 'Waiting' ? ' selected' : '') + '>Waiting</option>' +
                      '<option value="In Progress"' + (currentStatus === 'In Progress' ? ' selected' : '') + '>In Progress</option>' +
                      '<option value="Billing"' + (currentStatus === 'Billing' ? ' selected' : '') + '>Billing</option>' +
                      '<option value="Completed"' + (currentStatus === 'Completed' ? ' selected' : '') + '>Completed</option>' +
                      '<option value="Cancelled"' + (currentStatus === 'Cancelled' ? ' selected' : '') + '>Cancelled</option>' +
                    '</select>' +
                  '</div>' +
                '</div>' +
                '<div class="modal-footer">' +
                  '<button type="button" class="btn btn-secondary" onclick="closeModal(\'update-status-modal-' + consultationId + '\')">Cancel</button>' +
                  '<button type="submit" class="btn btn-primary">Save changes</button>' +
                '</div>' +
              '</form>' +
            '</div>' +
          '</div>';

        container.insertAdjacentHTML('beforeend', modalHtml);
      }
    });

    console.log('Generated modals for', allConsultations.length, 'items');

    // Add event listeners to all forms
    document.querySelectorAll('.status-update-form').forEach(form => {
      form.addEventListener('submit', handleStatusUpdate);
    });

    // Add event delegation for update status buttons
    document.addEventListener('click', function(e) {
      if (e.target.closest('.update-status-btn')) {
        console.log('Update status button clicked');
        const btn = e.target.closest('.update-status-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        const status = btn.getAttribute('data-status');
        console.log('Button data:', { consultationId, status });
        openUpdateModal(consultationId, status);
      }
    });

    // Add event delegation for checkin appointment buttons
    document.addEventListener('click', function(e) {
      if (e.target.closest('.checkin-appointment-btn')) {
        console.log('Checkin appointment button clicked');
        const btn = e.target.closest('.checkin-appointment-btn');
        const appointmentId = btn.getAttribute('data-appointment-id');
        console.log('Button data:', { appointmentId });
        openCheckinModal(appointmentId);
      }
    });
  }

  // Modal functions
  function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add('show');
    }
  }

  function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove('show');
    }
  }

  // Close modal when clicking outside
  document.addEventListener('click', function(e) {
    if (e.target.classList.contains('custom-modal')) {
      e.target.classList.remove('show');
    }
  });

  // Handle status update form submission
  async function handleStatusUpdate(e) {
    e.preventDefault();

    const form = e.target;
    const consultationId = form.getAttribute('data-consultation-id');
    const status = form.querySelector('select[name="status"]').value;

    try {
      const response = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: status })
      });

      if (response.ok) {
        alert('Status updated successfully!');
        closeModal('update-status-modal-' + consultationId);
        // Reload queue data
        await loadQueueData();
      } else {
        const error = await response.json();
        alert('Error updating status: ' + error.error);
      }
    } catch (error) {
      alert('Error updating status: ' + error.message);
    }
  }

  // Handle appointment check-in
  async function handleAppointmentCheckIn(appointmentId) {
    try {
      const response = await fetch(API_BASE + '/queue/checkin-appointment/' + appointmentId, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        }
      });

      if (response.ok) {
        alert('Appointment checked in successfully! A consultation has been created.');
        // Close the modal
        closeModal('checkin-appointment-modal-' + appointmentId);
        // Reload queue data
        await loadQueueData();
      } else {
        const error = await response.json();
        alert('Error checking in appointment: ' + error.error);
      }
    } catch (error) {
      alert('Error checking in appointment: ' + error.message);
    }
  }

  // Open update modal
  function openUpdateModal(consultationId, currentStatus) {
    console.log('Opening update modal for:', consultationId, currentStatus);
    openModal('update-status-modal-' + consultationId);
  }

  // Open checkin modal
  function openCheckinModal(appointmentId) {
    console.log('Opening checkin modal for:', appointmentId);
    openModal('checkin-appointment-modal-' + appointmentId);
  }

  // Auto-refresh every 30 seconds
  setInterval(loadQueueData, 15000);

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', function() {
    loadQueueData();
    startRealTimeUpdates();
  });
</script>
</body>
</html>

