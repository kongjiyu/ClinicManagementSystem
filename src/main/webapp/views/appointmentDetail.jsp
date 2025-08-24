<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Appointment Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Appointment Detail</h1>
    <button class="btn btn-secondary" onclick="window.history.back()">
      <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
      Back to List
    </button>
  </div>

  <!-- Appointment Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Appointment Information</h2>
    <form id="appointment-form">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label" for="appointmentId">Appointment ID</label>
          <input type="text" id="appointmentId" name="appointmentId" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="status">Status</label>
          <input type="text" id="status" name="status" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="appointmentDate">Appointment Date</label>
          <input type="text" id="appointmentDate" name="appointmentDate" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="appointmentTime">Appointment Time</label>
          <input type="text" id="appointmentTime" name="appointmentTime" class="input input-bordered w-full" disabled />
        </div>
        <div class="md:col-span-2">
          <label class="label" for="reason">Description</label>
          <textarea id="reason" name="reason" class="textarea textarea-bordered w-full" rows="3" disabled></textarea>
        </div>
      </div>
      <!-- Form is read-only now -->
    </form>
  </section>

  <!-- Patient Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Patient Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label class="label">Patient Name</label>
        <input type="text" id="patientName" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" id="patientAge" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Gender</label>
        <input type="text" id="patientGender" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Contact Number</label>
        <input type="text" id="patientContact" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" id="patientEmail" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Blood Type</label>
        <input type="text" id="patientBloodType" class="input input-bordered w-full" disabled />
      </div>
    </div>
  </section>



</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let appointmentId = '';
  let appointmentData = {};
  let patientData = {};

  // Get appointment ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  appointmentId = urlParams.get('id');

  if (!appointmentId) {
    alert('No appointment ID provided');
    window.location.href = '<%= request.getContextPath() %>/views/appointmentList.jsp';
  }

  // Load appointment data
  async function loadAppointmentData() {
    try {
      const response = await fetch(API_BASE + '/appointments/' + appointmentId);
      if (!response.ok) {
        throw new Error('Failed to load appointment data');
      }

      appointmentData = await response.json();
      
      // Load patient data
      await loadPatientData();

      // Populate appointment form
      populateAppointmentForm();

      // Form is now read-only, no action buttons needed

    } catch (error) {
      console.error('Error loading appointment data:', error);
      alert('Error loading appointment data: ' + error.message);
    }
  }

  // Load patient data
  async function loadPatientData() {
    try {
      const response = await fetch(API_BASE + '/patients/' + appointmentData.patientID);
      if (!response.ok) {
        throw new Error('Failed to load patient data');
      }

      patientData = await response.json();
      populatePatientForm();

    } catch (error) {
      console.error('Error loading patient data:', error);
    }
  }



  // Populate appointment form
  function populateAppointmentForm() {
    if (!appointmentData) return;

    document.getElementById('appointmentId').value = appointmentData.appointmentID || '';
    document.getElementById('status').value = appointmentData.status || 'Scheduled';
    
    // Format appointment date and time
    if (appointmentData.appointmentTime) {
      const dateTime = new Date(appointmentData.appointmentTime);
      document.getElementById('appointmentDate').value = dateTime.toLocaleDateString();
      document.getElementById('appointmentTime').value = dateTime.toLocaleTimeString();
    }
    
    document.getElementById('reason').value = appointmentData.description || '';
  }

  // Populate patient form
  function populatePatientForm() {
    if (!patientData) return;

    document.getElementById('patientName').value = (patientData.firstName || '') + ' ' + (patientData.lastName || '');
    document.getElementById('patientAge').value = patientData.age || '';
    document.getElementById('patientGender').value = patientData.gender || '';
    document.getElementById('patientContact').value = patientData.contactNumber || '';
    document.getElementById('patientEmail').value = patientData.email || '';
    document.getElementById('patientBloodType').value = patientData.bloodType || '';
  }









  // Load data when page loads
  document.addEventListener('DOMContentLoaded', loadAppointmentData);
</script>
</body>
</html>
