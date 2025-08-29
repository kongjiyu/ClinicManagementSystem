<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 01/08/2025
  Time: 4:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Medical History</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>

<%@ include file="/views/userSidebar.jsp" %>

<main class="p-6 md:ml-64">
  <div class="max-w-full mx-auto px-4 sm:px-6 lg:px-8 mt-6">
    <h1 class="text-2xl font-semibold mb-6">Your Medicine History</h1>

    <!-- Loading Spinner -->
    <div id="loadingSpinner" class="flex justify-center items-center py-8">
      <div class="loading loading-spinner loading-lg"></div>
    </div>

    <div id="medicalHistoryContent" class="hidden">
      <div class="overflow-x-auto bg-white rounded-lg shadow-md">
        <table class="table table-zebra w-full text-left min-w-full">
                      <thead class="bg-gray-100">
              <tr>
                <th class="px-6 py-3 w-40">Prescription ID</th>
                <th class="px-6 py-3 w-40">Date Issued</th>
                <th class="px-6 py-3 w-56">Doctor</th>
                <th class="px-6 py-3 w-56">Medicine Name(s)</th>
                <th class="px-6 py-3 w-80">Dosage & Duration</th>
                <th class="px-6 py-3 w-40">Status</th>
              </tr>
            </thead>
          <tbody id="medicalHistoryTableBody">
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
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let patientId = null;

  // Get patient ID from session or URL parameter
  function getPatientId() {
    // For now, we'll use a default patient ID
    // In a real application, this would come from the user's session
    return 'PT0001'; // Default patient ID for testing
  }

  // Load medical history data
  async function loadMedicalHistory() {
    patientId = getPatientId();
    
    try {
      const response = await fetch(API_BASE + '/patients/' + patientId + '/medical-history');
      if (!response.ok) {
        throw new Error('Failed to load medical history');
      }
      
      const prescriptions = await response.json();
      populateMedicalHistoryTable(prescriptions);
      hideLoading();
    } catch (error) {
      console.error('Error loading medical history:', error);
      showError('Failed to load medical history: ' + error.message);
      hideLoading();
    }
  }

  // Populate medical history table
  function populateMedicalHistoryTable(prescriptions) {
    const tbody = document.getElementById('medicalHistoryTableBody');
    tbody.innerHTML = '';

    // Handle custom List structure
    let prescriptionArray = [];
    if (prescriptions && prescriptions.elements) {
      prescriptionArray = prescriptions.elements;
    } else if (Array.isArray(prescriptions)) {
      prescriptionArray = prescriptions;
    }

    if (!prescriptionArray || prescriptionArray.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" class="text-center text-gray-500">No medical history found</td></tr>';
      return;
    }

    prescriptionArray.forEach((prescription) => {
      const row = document.createElement('tr');
      
      // Format prescription date
      const prescriptionDate = prescription.prescriptionDate ? new Date(prescription.prescriptionDate) : null;
      let dateIssued = 'N/A';
      if (prescriptionDate && !isNaN(prescriptionDate.getTime())) {
        const day = prescriptionDate.getDate().toString().padStart(2, '0');
        const month = (prescriptionDate.getMonth() + 1).toString().padStart(2, '0');
        const year = prescriptionDate.getFullYear();
        dateIssued = day + '/' + month + '/' + year;
      }

      // Get status badge
      const statusBadge = getStatusBadge(prescription.status);

      // Format dosage information
      const dosageInfo = prescription.dosage + ' ' + prescription.dosageUnit + ', ' + 
                        prescription.servingPerDay + ' times daily, ' + 
                        prescription.instruction;

      row.innerHTML = 
        '<td class="px-6 py-4 w-40">' + (prescription.prescriptionID || 'N/A') + '</td>' +
        '<td class="px-6 py-4 w-40">' + dateIssued + '</td>' +
        '<td class="px-6 py-4 w-56">' + (prescription.doctorName || 'To be assigned') + '</td>' +
        '<td class="px-6 py-4 w-56">' + (prescription.medicineName || 'N/A') + '</td>' +
        '<td class="px-6 py-4 w-80">' + dosageInfo + '</td>' +
        '<td class="px-6 py-4 w-40">' + statusBadge + '</td>';
      
      tbody.appendChild(row);
    });
  }

  // Get status badge HTML
  function getStatusBadge(status) {
    if (!status) return '<span class="badge badge-soft badge-neutral">Unknown</span>';
    
    const statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'completed':
      case 'finished':
        return '<span class="badge badge-soft badge-success">Completed</span>';
      case 'ongoing':
      case 'active':
        return '<span class="badge badge-soft badge-info">Ongoing</span>';
      case 'cancelled':
        return '<span class="badge badge-soft badge-error">Cancelled</span>';
      case 'pending':
        return '<span class="badge badge-soft badge-warning">Pending</span>';
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
    document.getElementById('medicalHistoryContent').classList.remove('hidden');
  }

  // Initialize medical history
  document.addEventListener('DOMContentLoaded', function() {
    loadMedicalHistory();
  });
</script>
</body>
</html>
