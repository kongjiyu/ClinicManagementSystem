<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:21 PM
  To change this template use File | Settings | File Templates.
--%>
<!--
  Author: Oh Wan Ting
  Treatment Module
-->
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
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Your Treatment History</h3>
        <div class="flex gap-4 items-end">
          <!-- Status Filter -->
          <div class="form-control">
            <label class="label">
              <span class="label-text">Filter by Status</span>
            </label>
            <select id="statusFilter" class="select select-bordered select-sm">
              <option value="">All Status</option>
              <option value="in progress">In Progress</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
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
              <th>Treatment Name</th>
              <th>Type</th>
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
  let allTreatments = []; // Store all treatments for filtering

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

  // Get doctor names for treatments
  async function getDoctorNamesForTreatments(treatments) {
    try {
      // Get all staff members to map doctor IDs to names
      const staffResponse = await fetch(API_BASE + '/staff');
      if (!staffResponse.ok) {
        throw new Error('Failed to load staff data');
      }
      
      const staffData = await staffResponse.json();
      const staffList = staffData.elements || staffData || [];
      
      // Create a map of doctor ID to doctor name
      const doctorMap = {};
      staffList.forEach(staff => {
        if (staff.staffID && staff.position && staff.position.toLowerCase().includes('doctor')) {
          doctorMap[staff.staffID] = staff.firstName + ' ' + staff.lastName;
        }
      });
      
      // Add doctor names to treatments
      return treatments.map(treatment => ({
        ...treatment,
        doctorName: treatment.doctorID ? (doctorMap[treatment.doctorID] || 'Unknown Doctor') : 'N/A'
      }));
      
    } catch (error) {
      console.error('Error getting doctor names:', error);
      // Return treatments with default doctor names if there's an error
      return treatments.map(treatment => ({
        ...treatment,
        doctorName: treatment.doctorID ? 'Unknown Doctor' : 'N/A'
      }));
    }
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
      
      const allTreatmentsResponse = await response.json();
      const treatments = allTreatmentsResponse.elements || allTreatmentsResponse || [];
      // Filter out null treatments and treatments without patientID, then filter by patient
      const validTreatments = treatments.filter(treatment => 
        treatment && 
        treatment.patientID && 
        treatment.patientID !== null && 
        treatment.patientID !== undefined
      );
      const patientTreatments = validTreatments.filter(treatment => treatment.patientID === patientId);
      
      // Store all treatments for filtering
      allTreatments = patientTreatments;
      
      // Get doctor names for all treatments
      const treatmentsWithDoctorNames = await getDoctorNamesForTreatments(patientTreatments);
      
      populateTreatmentHistoryTable(treatmentsWithDoctorNames);
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

    // Apply filters
    const filteredTreatments = applyFilters(treatments);

    if (!filteredTreatments || filteredTreatments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" class="text-center text-gray-500">No treatment history found</td></tr>';
      return;
    }

    // Sort treatments by date (most recent first), handling null dates
    // Note: Frontend sorting is used as treatments may not have backend sorting
    const sortedTreatments = filteredTreatments.sort((a, b) => {
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
      const date = treatmentDate ? formatDateToMalaysian(treatmentDate) : 'N/A';

      // Get status and outcome badges
      const statusBadge = getTreatmentStatusBadge(treatment.status);
      const outcomeBadge = getTreatmentOutcomeBadge(treatment.outcome);

      row.innerHTML = 
        '<td>' + date + '</td>' +
        '<td>' + (treatment.treatmentName || 'Unknown') + '</td>' +
        '<td>' + (treatment.treatmentType || 'N/A') + '</td>' +
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

  // Apply filters to treatments
  function applyFilters(treatments) {
    const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
    const fromDateFilter = document.getElementById('fromDateFilter').value;
    const toDateFilter = document.getElementById('toDateFilter').value;

    return treatments.filter(treatment => {
      // Status filter
      if (statusFilter && treatment.status && treatment.status.toLowerCase() !== statusFilter) {
        return false;
      }

      // Date range filter
      if (treatment.treatmentDate) {
        const treatmentDate = new Date(treatment.treatmentDate);
        const treatmentDateStr = treatmentDate.toISOString().split('T')[0];

        if (fromDateFilter && treatmentDateStr < fromDateFilter) {
          return false;
        }
        if (toDateFilter && treatmentDateStr > toDateFilter) {
          return false;
        }
      }

      return true;
    });
  }

  // Format date to Malaysian format (dd/mm/yyyy)
  function formatDateToMalaysian(date) {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return day + '/' + month + '/' + year;
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
    
    // Add event listeners for filters
    document.getElementById('statusFilter').addEventListener('change', function() {
      populateTreatmentHistoryTable(allTreatments);
    });
    
    document.getElementById('fromDateFilter').addEventListener('change', function() {
      populateTreatmentHistoryTable(allTreatments);
    });
    
    document.getElementById('toDateFilter').addEventListener('change', function() {
      populateTreatmentHistoryTable(allTreatments);
    });
    
    // Clear filters button
    document.getElementById('clearFilters').addEventListener('click', function() {
      document.getElementById('statusFilter').value = '';
      document.getElementById('fromDateFilter').value = '';
      document.getElementById('toDateFilter').value = '';
      populateTreatmentHistoryTable(allTreatments);
    });
  });
</script>
</body>
</html>
