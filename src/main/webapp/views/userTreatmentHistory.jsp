<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Treatment History</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>

<%@ include file="/views/userSidebar.jsp" %>

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-2">Treatment History</h1>
    <p class="text-sm text-base-content/70">View all your past and current treatments</p>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <div id="treatmentHistoryContent" class="hidden">
    <div class="bg-base-100 p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold mb-4">Your Treatment History</h3>
      <div class="overflow-x-auto">
        <table class="table table-zebra w-full">
          <thead>
            <tr>
              <th>Date</th>
              <th>Treatment Name</th>
              <th>Type</th>
              <th>Doctor</th>
              <th>Status</th>
              <th>Outcome</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody id="treatmentHistoryTableBody">
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

  // Load treatment history data
  async function loadTreatmentHistory() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
    try {
      const response = await fetch(API_BASE + '/treatments');
      if (!response.ok) {
        throw new Error('Failed to load treatments');
      }
      
      const allTreatments = await response.json();
      const treatments = allTreatments.elements || allTreatments || [];
      // Filter out null treatments and treatments without patientID, then filter by patient
      const validTreatments = treatments.filter(treatment => 
        treatment && 
        treatment.patientID && 
        treatment.patientID !== null && 
        treatment.patientID !== undefined
      );
      const patientTreatments = validTreatments.filter(treatment => treatment.patientID === patientId);
      
      populateTreatmentHistoryTable(patientTreatments);
      hideLoading();
    } catch (error) {
      console.error('Error loading treatment history:', error);
      showError('Failed to load treatment history: ' + error.message);
      hideLoading();
    }
  }

  // Populate treatment history table
  function populateTreatmentHistoryTable(treatments) {
    const tbody = document.getElementById('treatmentHistoryTableBody');
    tbody.innerHTML = '';

    if (!treatments || treatments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="text-center text-gray-500">No treatment history found</td></tr>';
      return;
    }

    // Sort treatments by date (most recent first), handling null dates
    const sortedTreatments = treatments.sort((a, b) => {
      // Handle null or invalid treatments
      if (!a || !b) return 0;
      
      const dateA = a.treatmentDate ? new Date(a.treatmentDate) : new Date(0);
      const dateB = b.treatmentDate ? new Date(b.treatmentDate) : new Date(0);
      
      // Check if dates are valid
      if (isNaN(dateA.getTime()) && isNaN(dateB.getTime())) return 0;
      if (isNaN(dateA.getTime())) return 1;
      if (isNaN(dateB.getTime())) return -1;
      
      return dateB - dateA;
    });

    sortedTreatments.forEach((treatment) => {
      // Skip null treatments
      if (!treatment) {
        return;
      }
      
      const row = document.createElement('tr');
      
      // Format treatment date
      const treatmentDate = treatment.treatmentDate ? new Date(treatment.treatmentDate) : null;
      const date = treatmentDate ? treatmentDate.toLocaleDateString() : 'N/A';

      // Get status and outcome badges
      const statusBadge = getTreatmentStatusBadge(treatment.status);
      const outcomeBadge = getTreatmentOutcomeBadge(treatment.outcome);

      row.innerHTML = 
        '<td>' + date + '</td>' +
        '<td>' + (treatment.treatmentName || 'Unknown') + '</td>' +
        '<td>' + (treatment.treatmentType || 'N/A') + '</td>' +
        '<td>' + (treatment.doctorID || 'N/A') + '</td>' +
        '<td>' + statusBadge + '</td>' +
        '<td>' + outcomeBadge + '</td>' +
        '<td class="whitespace-normal">' + (treatment.notes || '-') + '</td>';
      
      tbody.appendChild(row);
    });
  }

  // Get treatment status badge HTML
  function getTreatmentStatusBadge(status) {
    if (!status) return '<span class="badge badge-soft badge-neutral">Unknown</span>';
    
    const statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'scheduled':
        return '<span class="badge badge-soft badge-info">Scheduled</span>';
      case 'in progress':
        return '<span class="badge badge-soft badge-warning">In Progress</span>';
      case 'completed':
        return '<span class="badge badge-soft badge-success">Completed</span>';
      case 'cancelled':
        return '<span class="badge badge-soft badge-error">Cancelled</span>';
      default:
        return '<span class="badge badge-soft badge-neutral">' + status + '</span>';
    }
  }

  // Get treatment outcome badge HTML
  function getTreatmentOutcomeBadge(outcome) {
    if (!outcome) return '<span class="badge badge-soft badge-neutral">N/A</span>';
    
    const outcomeLower = outcome.toLowerCase();
    switch (outcomeLower) {
      case 'successful':
        return '<span class="badge badge-soft badge-success">Successful</span>';
      case 'failed':
        return '<span class="badge badge-soft badge-error">Failed</span>';
      case 'partial success':
        return '<span class="badge badge-soft badge-warning">Partial Success</span>';
      default:
        return '<span class="badge badge-soft badge-neutral">' + outcome + '</span>';
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
    document.getElementById('treatmentHistoryContent').classList.remove('hidden');
  }

  // Initialize treatment history
  document.addEventListener('DOMContentLoaded', function() {
    loadTreatmentHistory();
  });
</script>
</body>
</html>
