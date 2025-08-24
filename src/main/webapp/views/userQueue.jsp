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

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-2">Your Queue Status</h1>
    <p class="text-sm text-base-content/70">Real-time queue information for today</p>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Queue Information -->
  <div id="queueContent" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Queue Position -->
      <div class="bg-primary/10 p-6 rounded-lg border border-primary/20">
        <div class="flex items-center gap-3 mb-4">
          <span class="icon-[tabler--users] size-6 text-primary"></span>
          <h3 class="text-lg font-semibold">Queue Position</h3>
        </div>
        <p class="text-3xl font-bold text-primary" id="queuePosition">-</p>
        <p class="text-sm text-base-content/70">patients ahead of you</p>
      </div>

      <!-- Estimated Wait Time -->
      <div class="bg-info/10 p-6 rounded-lg border border-info/20">
        <div class="flex items-center gap-3 mb-4">
          <span class="icon-[tabler--clock] size-6 text-info"></span>
          <h3 class="text-lg font-semibold">Estimated Wait</h3>
        </div>
        <p class="text-3xl font-bold text-info" id="estimatedWaitTime">-</p>
        <p class="text-sm text-base-content/70">minutes</p>
      </div>
    </div>

    <!-- Appointment/Consultation Details -->
    <div id="appointmentDetails" class="mt-6 p-4 bg-base-200 rounded-lg hidden">
      <h4 class="font-semibold mb-2">Your Schedule</h4>
      <div id="scheduleInfo"></div>
    </div>

    <!-- No Queue Message -->
    <div id="noQueueMessage" class="text-center py-8 hidden">
      <span class="icon-[tabler--calendar-off] size-16 text-base-content/30 mb-4 block"></span>
      <h3 class="text-lg font-semibold mb-2">No Queue Today</h3>
      <p class="text-base-content/70">You don't have any appointments or consultations scheduled for today.</p>
    </div>

    <!-- Refresh Button -->
    <div class="mt-6 flex justify-center">
      <button onclick="loadQueueData()" class="btn btn-primary flex items-center gap-2">
        <span class="icon-[tabler--refresh] size-4"></span>
        Refresh Queue
      </button>
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

  // Load queue data
  async function loadQueueData() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
    try {
      const response = await fetch(API_BASE + '/queue/patient/' + patientId);
      
      if (response.status === 404) {
        // No queue for today
        showNoQueueMessage();
        hideLoading();
        return;
      }
      
      if (!response.ok) {
        throw new Error('Failed to load queue data');
      }
      
      const queueData = await response.json();
      populateQueueData(queueData);
      hideLoading();
    } catch (error) {
      console.error('Error loading queue data:', error);
      showError('Failed to load queue data: ' + error.message);
      hideLoading();
    }
  }

  // Populate queue data
  function populateQueueData(data) {
    // Update queue position
    document.getElementById('queuePosition').textContent = data.queuePosition || 0;
    
    // Update estimated wait time
    document.getElementById('estimatedWaitTime').textContent = data.estimatedWaitTime || 0;
    
    // Show appointment/consultation details
    const appointmentDetails = document.getElementById('appointmentDetails');
    const scheduleInfo = document.getElementById('scheduleInfo');
    
    if (data.appointment || data.consultation) {
      let scheduleHtml = '';
      
      if (data.appointment) {
        const appointmentTime = new Date(data.appointment.appointmentTime);
        scheduleHtml += 
          '<div class="flex items-center gap-2 mb-2">' +
            '<span class="icon-[tabler--calendar] size-4 text-primary"></span>' +
            '<span><strong>Appointment:</strong> ' + appointmentTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }) + '</span>' +
          '</div>';
      }
      
      if (data.consultation) {
        scheduleHtml += 
          '<div class="flex items-center gap-2">' +
            '<span class="icon-[tabler--stethoscope] size-4 text-info"></span>' +
            '<span><strong>Consultation Status:</strong> ' + data.consultation.status + '</span>' +
          '</div>';
      }
      
      scheduleInfo.innerHTML = scheduleHtml;
      appointmentDetails.classList.remove('hidden');
    } else {
      appointmentDetails.classList.add('hidden');
    }
    
    // Show queue content
    document.getElementById('queueContent').classList.remove('hidden');
    document.getElementById('noQueueMessage').classList.add('hidden');
  }

  // Show no queue message
  function showNoQueueMessage() {
    document.getElementById('queueContent').classList.add('hidden');
    document.getElementById('noQueueMessage').classList.remove('hidden');
  }

  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
  }

  // Initialize queue
  document.addEventListener('DOMContentLoaded', function() {
    loadQueueData();
  });
</script>
</body>
</html>
