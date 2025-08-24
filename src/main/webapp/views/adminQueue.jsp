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
    <div class="flex gap-2">
      <button id="create-consultation-btn" class="btn btn-success" onclick="openCreateConsultationModal()">
        <span class="icon-[tabler--plus] size-4 mr-2"></span>
        Create Consultation
      </button>
      <button id="refresh-btn" class="btn btn-primary" onclick="loadQueueData()">
        <span class="icon-[tabler--refresh] size-4 mr-2"></span>
        Refresh Queue
      </button>
    </div>
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
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Treatment</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="treatment-table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Name</th>
          <th>Treatment Count</th>
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
          <th>Name</th>
          <th>Invoice ID</th>
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

    <h2 class="text-xl font-semibold mb-2">Cancelled</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table" id="cancelled-table">
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

  <!-- Create Consultation Modal -->
  <div id="create-consultation-modal" class="custom-modal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">Create Consultation for Walk-in Patient</h3>
        <button type="button" class="modal-close" onclick="closeCreateConsultationModal()">&times;</button>
      </div>
      <div class="modal-body">
        <form id="patient-search-form">
          <div class="form-group">
            <label class="form-label">ID Type</label>
            <select id="id-type" name="idType" class="form-select" required>
              <option value="">Select ID Type</option>
              <option value="IC">IC</option>
              <option value="Passport">Passport</option>
              <option value="Student ID">Student ID</option>
              <option value="Driver License">Driver License</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">ID Number</label>
            <input type="text" id="id-number" name="idNumber" class="form-select" placeholder="Enter ID number" required>
          </div>
        </form>
        
        <!-- Patient Search Results -->
        <div id="patient-search-results" style="display: none;">
          <div class="form-group">
            <label class="form-label">Found Patient</label>
            <div id="patient-info" class="p-3 bg-gray-50 rounded border">
              <!-- Patient info will be populated here -->
            </div>
          </div>
        </div>
        
        <!-- No Patient Found Message -->
        <div id="no-patient-found" style="display: none;">
          <div class="alert alert-warning">
            <span class="icon-[tabler--alert-triangle] size-4 mr-2"></span>
            No patient found with the provided ID. Please check the ID type and number.
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeCreateConsultationModal()">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="searchPatient()">Search Patient</button>
        <button type="button" class="btn btn-success" id="create-consultation-confirm-btn" onclick="createConsultation()" style="display: none;">
          Create Consultation
        </button>
      </div>
    </div>
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
    renderTable('treatment-table', queueData.treatment?.elements || []);
    renderTable('billing-table', queueData.billing?.elements || []);
    renderTable('completed-table', queueData.completed?.elements || []);
    renderTable('cancelled-table', queueData.cancelled?.elements || []);

    // Generate modals for all consultations
    generateModals();
  }

  // Render individual table
  function renderTable(tableId, data) {
    const table = document.getElementById(tableId);
    const tbody = table.querySelector('tbody');
    tbody.innerHTML = '';

    if (!data || !Array.isArray(data) || data.length === 0) {
      let colspan = '4'; // Default for most tables
      if (tableId === 'completed-table') {
        colspan = '3'; // Completed table has no actions
      } else if (tableId === 'cancelled-table') {
        colspan = '3'; // Cancelled table has no actions
      } else if (tableId === 'waiting-table') {
        colspan = '5'; // Waiting table has waiting time column
      } else if (tableId === 'treatment-table') {
        colspan = '5'; // Treatment table has treatment count column
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
      } else if (tableId === 'waiting-table') {
        // Waiting table: Start Consult button
        actionButton =
          '<button type="button" class="btn btn-primary btn-soft start-consult-btn" ' +
                  'data-consultation-id="' + consultationId + '">' +
            'Start Consult' +
          '</button>';
      } else if (tableId === 'in-progress-table') {
        // In Progress table: Move to Treatment button
        actionButton =
          '<button type="button" class="btn btn-primary btn-soft move-to-treatment-btn" ' +
                  'data-consultation-id="' + consultationId + '">' +
            'Move to Treatment' +
          '</button>';
      } else if (tableId === 'treatment-table') {
        // Treatment table: Manage Treatments and Move to Billing buttons
        actionButton =
          '<div class="flex gap-2">' +
            '<button type="button" class="btn btn-info btn-soft manage-treatments-btn" ' +
                    'data-consultation-id="' + consultationId + '">' +
              'Manage Treatments' +
            '</button>' +
            '<button type="button" class="btn btn-success btn-soft move-to-billing-btn" ' +
                    'data-consultation-id="' + consultationId + '">' +
              'Move to Billing' +
            '</button>' +
          '</div>';
      } else if (tableId === 'billing-table') {
        // Billing table: Paid button
        actionButton =
          '<button type="button" class="btn btn-success btn-soft paid-btn" ' +
                  'data-consultation-id="' + consultationId + '">' +
            'Paid' +
          '</button>';
      } else {
        // Other tables: generic update status button
        actionButton =
          '<button type="button" class="btn btn-circle btn-text btn-sm update-status-btn" ' +
                  'data-consultation-id="' + consultationId + '" ' +
                  'data-status="' + status + '">' +
            '<span class="icon-[tabler--pencil] size-5"></span>' +
          '</button>';
      }

      // Different row structure based on table type
      if (tableId === 'completed-table') {
        // Completed table: no actions
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>';
      } else       if (tableId === 'cancelled-table') {
        // Cancelled table: no actions
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>';
      } else if (tableId === 'waiting-table') {
        // Waiting table: includes waiting time
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td class="waiting-time" data-checkin="' + (checkInTime || '') + '"><span class="time-text">' + calculateWaitingTime(checkInTime) + '</span></td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td>' + actionButton + '</td>';
      } else if (tableId === 'treatment-table') {
        // Treatment table: includes treatment count
        const treatmentCount = item.treatmentCount || 0;
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td><span class="badge badge-soft badge-info">' + treatmentCount + ' treatments</span></td>' +
          '<td>' + actionButton + '</td>';
      } else if (tableId === 'billing-table') {
        // Billing table: includes invoice ID
        const invoiceId = item.invoiceID || 'N/A';
        const invoiceLink = invoiceId !== 'N/A' ? 
          '<a href="<%= request.getContextPath() %>/views/invoiceDetail.jsp?id=' + invoiceId + '" class="link link-primary hover:underline">' + invoiceId + '</a>' : 
          'N/A';
        
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td>' + invoiceLink + '</td>' +
          '<td>' + actionButton + '</td>';
      } else if (status === 'Appointment') {
        // Appointments table: link to appointment detail
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/appointmentDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
          '<td>' + (patientName || 'Unknown') + '</td>' +
          '<td>' + actionButton + '</td>';
      } else {
        // All other tables: link to consultation detail
        row.innerHTML =
          '<td><a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId + '" class="link link-primary hover:underline">' + consultationId + '</a></td>' +
          '<td>' + (formatTime(checkInTime) || 'N/A') + '</td>' +
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
    if (queueData.cancelled?.elements && Array.isArray(queueData.cancelled.elements)) {
      allConsultations.push(...queueData.cancelled.elements);
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
      // Also close payment method modal if it exists
      const paymentModal = document.getElementById('payment-method-modal');
      if (paymentModal) {
        paymentModal.remove();
      }
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

  // Handle start consult (move from waiting to in progress)
  async function handleStartConsult(consultationId) {
    if (!confirm('Are you sure you want to start consultation for this patient? This will move them to In Progress.')) {
      return;
    }

    try {
      const response = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'In Progress' })
      });

      if (response.ok) {
        alert('Consultation started successfully! Patient moved to In Progress.');
        // Reload queue data
        await loadQueueData();
      } else {
        const error = await response.json();
        alert('Error starting consultation: ' + error.error);
      }
    } catch (error) {
      alert('Error starting consultation: ' + error.message);
    }
  }

  // Handle paid button (mark consultation as completed)
  async function handlePaid(consultationId) {
    // Find the consultation to get the bill ID
    const consultation = findConsultationById(consultationId);
    if (!consultation || !consultation.billID) {
      alert('No bill found for this consultation');
      return;
    }

    // Show payment method selection modal
    openPaymentMethodModal(consultation.billID, consultationId);
  }

  // Find consultation by ID from queue data
  function findConsultationById(consultationId) {
    const allConsultations = [
      ...(queueData.appointments?.elements || []),
      ...(queueData.waiting?.elements || []),
      ...(queueData.inProgress?.elements || []),
      ...(queueData.billing?.elements || []),
      ...(queueData.completed?.elements || []),
      ...(queueData.cancelled?.elements || [])
    ];
    
    return allConsultations.find(c => c.consultationId === consultationId);
  }

  // Open payment method selection modal
  function openPaymentMethodModal(billId, consultationId) {
    const modalHtml = 
      '<div id="payment-method-modal" class="custom-modal show">' +
        '<div class="modal-content">' +
          '<div class="modal-header">' +
            '<h3 class="modal-title">Select Payment Method</h3>' +
            '<button type="button" class="modal-close" onclick="closePaymentMethodModal()">&times;</button>' +
          '</div>' +
          '<div class="modal-body">' +
            '<div class="form-group">' +
              '<label class="form-label">Payment Method</label>' +
              '<select id="payment-method-select" class="form-select">' +
                '<option value="">Select Payment Method</option>' +
                '<option value="Cash">Cash</option>' +
                '<option value="Credit Card">Credit Card</option>' +
                '<option value="Debit Card">Debit Card</option>' +
                '<option value="Online Banking">Online Banking</option>' +
                '<option value="E-Wallet">E-Wallet</option>' +
              '</select>' +
            '</div>' +
          '</div>' +
          '<div class="modal-footer">' +
            '<button type="button" class="btn btn-secondary" onclick="closePaymentMethodModal()">Cancel</button>' +
            '<button type="button" class="btn btn-primary" onclick="confirmPayment(\'' + billId + '\', \'' + consultationId + '\')">Confirm Payment</button>' +
          '</div>' +
        '</div>' +
      '</div>';

    // Remove existing modal if any
    const existingModal = document.getElementById('payment-method-modal');
    if (existingModal) {
      existingModal.remove();
    }

    // Add new modal to body
    document.body.insertAdjacentHTML('beforeend', modalHtml);
  }

  // Close payment method modal
  function closePaymentMethodModal() {
    const modal = document.getElementById('payment-method-modal');
    if (modal) {
      modal.remove();
    }
  }

  // Confirm payment with selected method
  async function confirmPayment(billId, consultationId) {
    const paymentMethod = document.getElementById('payment-method-select').value;
    
    if (!paymentMethod) {
      alert('Please select a payment method');
      return;
    }

    try {
      // First, update the payment method
      const paymentResponse = await fetch(API_BASE + '/bills/' + billId + '/payment-method', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ paymentMethod: paymentMethod })
      });

      if (!paymentResponse.ok) {
        const error = await paymentResponse.json();
        throw new Error('Error updating payment method: ' + error.error);
      }

      // Then, update consultation status to completed
      const statusResponse = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Completed' })
      });

      if (statusResponse.ok) {
        alert('Payment confirmed with ' + paymentMethod + '! Patient moved to Completed.');
        closePaymentMethodModal();
        // Reload queue data
        await loadQueueData();
      } else {
        const error = await statusResponse.json();
        alert('Error confirming payment: ' + error.error);
      }
    } catch (error) {
      alert('Error confirming payment: ' + error.message);
    }
  }

  // Handle move to treatment stage
  async function handleMoveToTreatment(consultationId) {
    if (!confirm('Move this consultation to the Treatment stage?')) {
      return;
    }

    try {
      const response = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Treatment' })
      });

      if (response.ok) {
        alert('Consultation moved to Treatment stage successfully!');
        await loadQueueData();
      } else {
        const error = await response.json();
        alert('Error moving to treatment stage: ' + error.error);
      }
    } catch (error) {
      alert('Error moving to treatment stage: ' + error.message);
    }
  }

  // Handle manage treatments (navigate to consultation detail page)
  function handleManageTreatments(consultationId) {
    // Navigate to consultation detail page where treatment can be managed
    window.location.href = '<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + consultationId;
  }

  // Handle move to billing stage
  async function handleMoveToBilling(consultationId) {
    if (!confirm('Move this consultation to the Billing stage? This will create an invoice.')) {
      return;
    }

    try {
      // First, update consultation status to Billing
      const statusResponse = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Billing' })
      });

      if (!statusResponse.ok) {
        const error = await statusResponse.json();
        throw new Error('Error updating consultation status: ' + error.error);
      }

      // Then, create an invoice for the consultation
      const invoiceResponse = await fetch(API_BASE + '/bills/from-consultation/' + consultationId, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        }
      });

      if (invoiceResponse.ok) {
        const invoiceData = await invoiceResponse.json();
        alert('Consultation moved to Billing stage successfully! Invoice created with ID: ' + invoiceData.billID);
        await loadQueueData();
      } else {
        const error = await invoiceResponse.json();
        alert('Consultation status updated but failed to create invoice: ' + error.error);
        await loadQueueData();
      }
    } catch (error) {
      alert('Error moving to billing stage: ' + error.message);
    }
  }

  // Handle done consult (move from in progress to billing and create invoice)
  async function handleDoneConsult(consultationId) {
    if (!confirm('Are you sure you want to mark this consultation as done? This will move the patient to Billing and create an invoice.')) {
      return;
    }

    try {
      // First, update consultation status to Billing
      const statusResponse = await fetch(API_BASE + '/queue/' + consultationId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Billing' })
      });

      if (!statusResponse.ok) {
        const error = await statusResponse.json();
        throw new Error('Error updating consultation status: ' + error.error);
      }

      // Then, create an invoice for the consultation
      const invoiceResponse = await fetch(API_BASE + '/bills/from-consultation/' + consultationId, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        }
      });

      if (invoiceResponse.ok) {
        const invoiceData = await invoiceResponse.json();
        alert('Consultation completed successfully! Patient moved to Billing. Invoice created with ID: ' + invoiceData.billID);
        // Reload queue data
        await loadQueueData();
      } else {
        const error = await invoiceResponse.json();
        alert('Consultation status updated but failed to create invoice: ' + error.error);
        // Still reload to show updated status
        await loadQueueData();
      }
    } catch (error) {
      alert('Error completing consultation: ' + error.message);
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

  // Create Consultation Modal Functions
  function openCreateConsultationModal() {
    const modal = document.getElementById('create-consultation-modal');
    if (modal) {
      modal.classList.add('show');
      // Reset form and hide results
      document.getElementById('patient-search-form').reset();
      document.getElementById('patient-search-results').style.display = 'none';
      document.getElementById('no-patient-found').style.display = 'none';
      document.getElementById('create-consultation-confirm-btn').style.display = 'none';
    }
  }

  function closeCreateConsultationModal() {
    const modal = document.getElementById('create-consultation-modal');
    if (modal) {
      modal.classList.remove('show');
    }
  }

  // Search patient by ID type and number
  async function searchPatient() {
    const idType = document.getElementById('id-type').value;
    const idNumber = document.getElementById('id-number').value;

    if (!idType || !idNumber) {
      alert('Please select ID type and enter ID number');
      return;
    }

    try {
      // First, get all patients and search locally
      const response = await fetch(API_BASE + '/patients');
      if (!response.ok) {
        throw new Error('Failed to fetch patients');
      }

      const data = await response.json();
      const patients = data.elements || data || [];

      // Find patient by ID type and number
      const patient = patients.find(p => 
        p.idType === idType && p.idNumber === idNumber
      );

      if (patient) {
        // Show patient info
        document.getElementById('patient-info').innerHTML = 
          '<div class="grid grid-cols-2 gap-2 text-sm">' +
            '<div><strong>Name:</strong> ' + patient.firstName + ' ' + patient.lastName + '</div>' +
            '<div><strong>Age:</strong> ' + patient.age + '</div>' +
            '<div><strong>Gender:</strong> ' + patient.gender + '</div>' +
            '<div><strong>Contact:</strong> ' + patient.contactNumber + '</div>' +
            '<div><strong>Email:</strong> ' + patient.email + '</div>' +
            '<div><strong>Blood Type:</strong> ' + patient.bloodType + '</div>' +
          '</div>';

        document.getElementById('patient-search-results').style.display = 'block';
        document.getElementById('no-patient-found').style.display = 'none';
        document.getElementById('create-consultation-confirm-btn').style.display = 'inline-block';
        
        // Store patient data for consultation creation
        window.selectedPatientForConsultation = patient;
      } else {
        // Show no patient found message
        document.getElementById('patient-search-results').style.display = 'none';
        document.getElementById('no-patient-found').style.display = 'block';
        document.getElementById('create-consultation-confirm-btn').style.display = 'none';
        window.selectedPatientForConsultation = null;
      }
    } catch (error) {
      console.error('Error searching patient:', error);
      alert('Error searching patient: ' + error.message);
    }
  }

  // Create consultation for the found patient
  async function createConsultation() {
    if (!window.selectedPatientForConsultation) {
      alert('No patient selected');
      return;
    }

    try {
      const consultationData = {
        patientID: window.selectedPatientForConsultation.patientID,
        consultationDate: new Date().toISOString().split('T')[0], // Today's date
        consultationTime: new Date().toISOString(),
        status: 'Waiting',
        reason: 'Walk-in consultation'
      };

      const response = await fetch(API_BASE + '/consultations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(consultationData)
      });

      if (response.ok) {
        const result = await response.json();
        alert('Consultation created successfully! Consultation ID: ' + result.consultationID);
        closeCreateConsultationModal();
        // Reload queue data to show the new consultation
        await loadQueueData();
      } else {
        const error = await response.json();
        alert('Error creating consultation: ' + error.error);
      }
    } catch (error) {
      console.error('Error creating consultation:', error);
      alert('Error creating consultation: ' + error.message);
    }
  }

  // Auto-refresh every 30 seconds
  setInterval(loadQueueData, 15000);

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', function() {
    loadQueueData();
    startRealTimeUpdates();
    
    // Add event delegation for all buttons (only once)
    document.addEventListener('click', function(e) {
      // Update status buttons
      if (e.target.closest('.update-status-btn')) {
        console.log('Update status button clicked');
        const btn = e.target.closest('.update-status-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        const status = btn.getAttribute('data-status');
        console.log('Button data:', { consultationId, status });
        openUpdateModal(consultationId, status);
      }
      
      // Checkin appointment buttons
      if (e.target.closest('.checkin-appointment-btn')) {
        console.log('Checkin appointment button clicked');
        const btn = e.target.closest('.checkin-appointment-btn');
        const appointmentId = btn.getAttribute('data-appointment-id');
        console.log('Button data:', { appointmentId });
        openCheckinModal(appointmentId);
      }
      
      // Start consult buttons
      if (e.target.closest('.start-consult-btn')) {
        console.log('Start consult button clicked');
        const btn = e.target.closest('.start-consult-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handleStartConsult(consultationId);
      }
      
      // Done consult buttons
      if (e.target.closest('.done-consult-btn')) {
        console.log('Done consult button clicked');
        const btn = e.target.closest('.done-consult-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handleDoneConsult(consultationId);
      }
      
      // Move to treatment buttons
      if (e.target.closest('.move-to-treatment-btn')) {
        console.log('Move to treatment button clicked');
        const btn = e.target.closest('.move-to-treatment-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handleMoveToTreatment(consultationId);
      }
      
      // Manage treatments buttons
      if (e.target.closest('.manage-treatments-btn')) {
        console.log('Manage treatments button clicked');
        const btn = e.target.closest('.manage-treatments-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handleManageTreatments(consultationId);
      }
      
      // Move to billing buttons
      if (e.target.closest('.move-to-billing-btn')) {
        console.log('Move to billing button clicked');
        const btn = e.target.closest('.move-to-billing-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handleMoveToBilling(consultationId);
      }
      
      // Paid buttons
      if (e.target.closest('.paid-btn')) {
        console.log('Paid button clicked');
        const btn = e.target.closest('.paid-btn');
        const consultationId = btn.getAttribute('data-consultation-id');
        console.log('Button data:', { consultationId });
        handlePaid(consultationId);
      }
    });
  });
</script>
</body>
</html>

