<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 31/07/2025
  Time: 10:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>User Dashboard</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/userSidebar.jsp" %>

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Welcome and Summary -->
  <div id="welcomeSection" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <h2 class="text-2xl font-bold mb-2">Welcome back, <span id="patientName">User</span>!</h2>
    <p class="text-sm text-base-content/70">Today is <%= java.time.LocalDate.now() %>.</p>
  </div>

  <!-- Next Appointment -->
  <div id="appointmentSection" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <div class="flex justify-between items-center mb-4 cursor-pointer" onclick="toggleAppointments()">
      <h3 class="text-xl font-semibold">Your Upcoming Appointments</h3>
      <span id="toggleIcon" class="icon-[tabler--chevron-left] accordion-item-active:-rotate-90 size-5 shrink-0 transition-transform duration-300 rtl:-rotate-180" ></span>
    </div>
    <div id="appointmentsContent" class="overflow-x-auto">
      <table class="table table-zebra w-full">
        <thead>
          <tr>
            <th>Date</th>
            <th>Time</th>
            <th>Type</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody id="appointmentsTableBody">
          <!-- Data will be populated by JavaScript -->
        </tbody>
      </table>
    </div>
  </div>

  <!-- Clinic Rules -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h3 class="text-xl font-semibold mb-4">Clinic Rules & Regulations</h3>
    <ul class="list-disc list-inside text-base-content/80 space-y-1">
      <li>Arrive at least 10 minutes before your appointment.</li>
      <li>Notify 24 hours in advance for cancellations.</li>
      <li>Masks must be worn at all times in the clinic.</li>
      <li>Maintain silence in waiting areas.</li>
    </ul>
  </div>

  <!-- Operating Hours -->
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h3 class="text-xl font-semibold mb-4">Clinic Operating Hours</h3>
    <ul class="text-base-content/80 space-y-1">
      <li>Monday – Friday: 9:00 AM – 6:00 PM</li>
      <li>Saturday: 9:00 AM – 1:00 PM</li>
      <li>Sunday & Public Holidays: Closed</li>
    </ul>
  </div>

  <!-- Quick Links -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <a href="<%= request.getContextPath() %>/user/medicalHistory" class="btn btn-outline btn-primary w-full">View Medical History</a>
    <a href="<%= request.getContextPath() %>/user/invoice" class="btn btn-outline btn-secondary w-full">View Invoices</a>
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

  // Load dashboard data
  async function loadDashboardData() {
    patientId = getPatientId();
    
    try {
      const response = await fetch(API_BASE + '/patients/' + patientId + '/dashboard');
      if (!response.ok) {
        throw new Error('Failed to load dashboard data');
      }
      
      const dashboardData = await response.json();
      populateDashboard(dashboardData);
      hideLoading();
    } catch (error) {
      console.error('Error loading dashboard data:', error);
      showError('Failed to load dashboard data: ' + error.message);
      hideLoading();
    }
  }

  // Populate dashboard with data
  function populateDashboard(data) {
    // Populate patient name from MultiMap structure
    let patient = null;
    
    // Check if data has the MultiMap structure
    if (data.map && data.map.elements) {
      // Find the patient element in the MultiMap
      for (const element of data.map.elements) {
        if (element.key === 'patient' && element.value && element.value.elements && element.value.elements.length > 0) {
          patient = element.value.elements[0];
          break;
        }
      }
    } else if (data.patient) {
      // Fallback to direct structure
      patient = data.patient;
    }

    if (patient) {
      const patientName = (patient.firstName || '') + ' ' + (patient.lastName || '');
      document.getElementById('patientName').textContent = patientName.trim() || 'User';
    }

    // Populate appointments table
    populateAppointmentsTable(data);

    // Show sections
    document.getElementById('welcomeSection').classList.remove('hidden');
    document.getElementById('appointmentSection').classList.remove('hidden');
  }

  // Populate appointments table
  function populateAppointmentsTable(data) {
    const tbody = document.getElementById('appointmentsTableBody');
    tbody.innerHTML = '';

    console.log('Raw dashboard data:', data);

    // Handle MultiMap structure from the API
    let appointments = [];
    
    // Check if data has the MultiMap structure
    if (data.map && data.map.elements) {
      console.log('Found MultiMap structure');
      // Find the appointment elements in the MultiMap
      for (const element of data.map.elements) {
        console.log('Processing element:', element.key, element.value);
        if (element.key === 'appointment' && element.value && element.value.elements) {
          appointments = element.value.elements;
          console.log('Found appointments:', appointments);
          break;
        }
      }
    } else if (data.appointment) {
      console.log('Using direct appointment structure');
      appointments = data.appointment;
    }

    console.log('Final appointments array:', appointments);

    if (!appointments || appointments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="text-center text-gray-500">No upcoming appointments</td></tr>';
      return;
    }

    appointments.forEach((appointment, index) => {
      console.log('Processing appointment ' + index + ':', appointment);
      
      const row = document.createElement('tr');
      
      // Format appointment date and time
      const appointmentDateTime = appointment.appointmentTime ? new Date(appointment.appointmentTime) : null;
      const date = appointmentDateTime ? appointmentDateTime.toLocaleDateString() : 'N/A';
      const time = appointmentDateTime ? appointmentDateTime.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit'
      }) : 'N/A';

      console.log('Appointment ' + index + ' - Date: ' + date + ', Time: ' + time + ', Status: ' + appointment.status);

      // Get status badge
      const statusBadge = getStatusBadge(appointment.status);

      row.innerHTML = 
        '<td>' + date + '</td>' +
        '<td>' + time + '</td>' +
        '<td>' + (appointment.appointmentType || 'Consultation') + '</td>' +
        '<td>' + statusBadge + '</td>' +
        '<td>' +
          '<button class="btn btn-xs btn-warning" onclick="rescheduleAppointment(\'' + appointment.appointmentID + '\')">Reschedule</button>' +
          ' <button class="btn btn-xs btn-error" onclick="cancelAppointment(\'' + appointment.appointmentID + '\')">Cancel</button>' +
        '</td>';
      
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
      default:
        return '<span class="badge badge-soft badge-neutral">' + status + '</span>';
    }
  }

  // Reschedule appointment
  function rescheduleAppointment(appointmentId) {
    // TODO: Implement reschedule functionality
    alert('Reschedule functionality will be implemented here');
  }

  // Cancel appointment
  function cancelAppointment(appointmentId) {
    if (confirm('Are you sure you want to cancel this appointment?')) {
      // TODO: Implement cancel functionality
      alert('Cancel functionality will be implemented here');
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
  }

  // Simple toggle for appointments
  function toggleAppointments() {
    const content = document.getElementById('appointmentsContent');
    const icon = document.getElementById('toggleIcon');
    
    if (content.style.display === 'none') {
      content.style.display = 'block';
      icon.style.transform = 'rotate(-90deg)';
    } else {
      content.style.display = 'none';
      icon.style.transform = 'rotate(0deg)';
    }
  }

  // Initialize dashboard
  document.addEventListener('DOMContentLoaded', function() {
    loadDashboardData();
  });
</script>
</body>
</html>
