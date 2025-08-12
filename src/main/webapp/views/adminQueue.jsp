<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Queue Management</title>
  <link href="<% out.print(request.getContextPath()); %>/static/output.css" rel="stylesheet">
  <script defer src="<% out.print(request.getContextPath()); %>/static/flyonui.js"></script>
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
  </div>

  <!-- Dynamic Modals Container -->
  <div id="modals-container">
    <!-- Modals will be generated dynamically -->
  </div>
</main>

<script>
  const API_BASE = '<% out.print(request.getContextPath()); %>/api';
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
    renderTable('appointments-table', queueData.appointments || []);
    renderTable('waiting-table', queueData.waiting || []);
    renderTable('in-progress-table', queueData.inProgress || []);
    renderTable('billing-table', queueData.billing || []);
    renderTable('completed-table', queueData.completed || []);

    // Generate modals for all consultations
    generateModals();
  }

  // Render individual table
  function renderTable(tableId, data) {
    const table = document.getElementById(tableId);
    const tbody = table.querySelector('tbody');
    tbody.innerHTML = '';

    if (!data || !Array.isArray(data) || data.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="text-center text-gray-500">No items in this queue</td></tr>';
      return;
    }

         data.forEach(item => {
       const row = document.createElement('tr');
       const consultationId = item.consultationId || 'N/A';
       const status = item.status || 'Waiting';

       // Different button for appointments vs consultations
       let actionButton;
       if (status === 'Appointment') {
         actionButton =
           '<button type="button" class="btn btn-circle btn-text btn-sm" ' +
                   'aria-haspopup="dialog" ' +
                   'aria-expanded="false" ' +
                   'aria-controls="checkin-appointment-modal-' + consultationId + '" ' +
                   'data-overlay="#checkin-appointment-modal-' + consultationId + '">' +
             '<span class="icon-[tabler--check] size-5"></span>' +
           '</button>';
       } else {
         actionButton =
           '<button type="button" class="btn btn-circle btn-text btn-sm" ' +
                   'aria-haspopup="dialog" ' +
                   'aria-expanded="false" ' +
                   'aria-controls="update-status-modal-' + consultationId + '" ' +
                   'data-overlay="#update-status-modal-' + consultationId + '"' +
                   'onclick="openUpdateModal(\'' + consultationId + '\', \'' + status + '\')">' +
             '<span class="icon-[tabler--pencil] size-5"></span>' +
           '</button>';
       }

       row.innerHTML =
         '<td>' + consultationId + '</td>' +
         '<td>' + (formatTime(item.checkInTime) || 'N/A') + '</td>' +
         '<td>' + (item.waitingTime || '00:00') + '</td>' +
         '<td>' + (item.patientName || 'Unknown') + '</td>' +
         '<td>' + actionButton + '</td>';
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

  // Generate modals for all consultations
  function generateModals() {
    const container = document.getElementById('modals-container');
    container.innerHTML = '';

    // Collect all consultation IDs from all tables
    const allConsultations = [];

    // Add consultations from each category
    if (queueData.appointments && Array.isArray(queueData.appointments)) {
      allConsultations.push(...queueData.appointments);
    }
    if (queueData.waiting && Array.isArray(queueData.waiting)) {
      allConsultations.push(...queueData.waiting);
    }
    if (queueData.inProgress && Array.isArray(queueData.inProgress)) {
      allConsultations.push(...queueData.inProgress);
    }
    if (queueData.billing && Array.isArray(queueData.billing)) {
      allConsultations.push(...queueData.billing);
    }
    if (queueData.completed && Array.isArray(queueData.completed)) {
      allConsultations.push(...queueData.completed);
    }

    allConsultations.forEach(item => {
      const consultationId = item.consultationId;
      const currentStatus = item.status || 'Waiting';

      // Different modal for appointments vs consultations
      if (currentStatus === 'Appointment') {
        // Modal for checking in appointments
        const modalHtml =
          '<div id="checkin-appointment-modal-' + consultationId + '" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">' +
            '<div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">' +
              '<div class="modal-content max-w-xl break-words whitespace-normal">' +
                '<div class="modal-header">' +
                  '<h3 class="modal-title">Check In Appointment</h3>' +
                  '<button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#checkin-appointment-modal-' + consultationId + '">' +
                    '<span class="icon-[tabler--x] size-4"></span>' +
                  '</button>' +
                '</div>' +
                '<div class="modal-body">' +
                  '<p>Are you sure you want to check in this appointment? This will create a consultation and move the patient to the waiting queue.</p>' +
                '</div>' +
                '<div class="modal-footer p-6">' +
                  '<button type="button" class="btn btn-soft btn-secondary" data-overlay="#checkin-appointment-modal-' + consultationId + '">Cancel</button>' +
                  '<button type="button" class="btn btn-primary checkin-appointment-btn" data-appointment-id="' + consultationId + '">Check In</button>' +
                '</div>' +
              '</div>' +
            '</div>' +
          '</div>';

        container.insertAdjacentHTML('beforeend', modalHtml);
      } else {
        // Modal for updating consultation status
        const modalHtml =
          '<div id="update-status-modal-' + consultationId + '" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">' +
            '<div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">' +
              '<div class="modal-content max-w-xl break-words whitespace-normal">' +
                '<div class="modal-header">' +
                  '<h3 class="modal-title">Update Status</h3>' +
                  '<button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#update-status-modal-' + consultationId + '">' +
                    '<span class="icon-[tabler--x] size-4"></span>' +
                  '</button>' +
                '</div>' +
                '<form class="status-update-form" data-consultation-id="' + consultationId + '">' +
                  '<div class="modal-body">' +
                    '<label for="modal-status-' + consultationId + '" class="block text-sm font-medium text-gray-700">Status</label>' +
                    '<select name="status" id="modal-status-' + consultationId + '" class="form-select w-full">' +
                      '<option value="Waiting"' + (currentStatus === 'Waiting' ? ' selected' : '') + '>Waiting</option>' +
                      '<option value="In Progress"' + (currentStatus === 'In Progress' ? ' selected' : '') + '>In Progress</option>' +
                      '<option value="Billing"' + (currentStatus === 'Billing' ? ' selected' : '') + '>Billing</option>' +
                      '<option value="Completed"' + (currentStatus === 'Completed' ? ' selected' : '') + '>Completed</option>' +
                      '<option value="Cancelled"' + (currentStatus === 'Cancelled' ? ' selected' : '') + '>Cancelled</option>' +
                    '</select>' +
                  '</div>' +
                  '<div class="modal-footer p-6">' +
                    '<button type="button" class="btn btn-soft btn-secondary" data-overlay="#update-status-modal-' + consultationId + '">Cancel</button>' +
                    '<button type="submit" class="btn btn-primary">Save changes</button>' +
                  '</div>' +
                '</form>' +
              '</div>' +
            '</div>' +
          '</div>';

        container.insertAdjacentHTML('beforeend', modalHtml);
      }
    });

    // Add event listeners to all forms
    document.querySelectorAll('.status-update-form').forEach(form => {
      form.addEventListener('submit', handleStatusUpdate);
    });

    // Add event listeners to check-in buttons
    document.querySelectorAll('.checkin-appointment-btn').forEach(btn => {
      btn.addEventListener('click', handleAppointmentCheckIn);
    });
  }

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
  async function handleAppointmentCheckIn(e) {
    const appointmentId = e.target.getAttribute('data-appointment-id');

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
        const modal = document.getElementById('checkin-appointment-modal-' + appointmentId);
        if (modal) {
          modal.classList.add('hidden');
        }
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

  // Open update modal (now just sets the form data)
  function openUpdateModal(consultationId, currentStatus) {
    // The modal will be opened by FlyonUI via data-overlay attribute
    // Form data is already set in the generated modal
  }



  // Auto-refresh every 30 seconds
  setInterval(loadQueueData, 30000);

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', loadQueueData);
</script>
</body>
</html>

