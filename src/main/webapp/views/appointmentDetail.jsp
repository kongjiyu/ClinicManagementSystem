<%--
Author: Chia Yu Xin
Appointment Module
--%>

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
    <div class="flex gap-2">
      <button class="btn btn-secondary" onclick="goBack()">
        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
        <span id="backButtonText">Back to List</span>
      </button>
      <button id="editBtn" class="btn btn-primary" onclick="toggleEditMode()">
        <span class="icon-[tabler--edit] size-4 mr-2"></span>
        Edit
      </button>
    </div>
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
          <select id="status" name="status" class="select select-bordered w-full" disabled>
            <option value="Scheduled">Scheduled</option>
            <option value="Checked-in">Checked-in</option>
            <option value="Completed">Completed</option>
            <option value="Cancelled">Cancelled</option>
            <option value="No show">No show</option>
          </select>
        </div>
        <div>
          <label class="label" for="appointmentDate">Appointment Date</label>
          <input type="date" id="appointmentDate" name="appointmentDate" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="appointmentTime">Appointment Time</label>
          <input type="time" id="appointmentTime" name="appointmentTime" class="input input-bordered w-full" disabled />
        </div>
        <div class="md:col-span-2">
          <label class="label" for="reason">Description</label>
          <textarea id="reason" name="reason" class="textarea textarea-bordered w-full" rows="3" disabled></textarea>
        </div>
      </div>
      <div class="flex justify-end mt-6" id="saveButtonContainer" style="display: none;">
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </div>
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

      // Update edit button visibility based on appointment status
      updateEditButtonVisibility();

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
    
    // Format appointment date and time for form inputs
    if (appointmentData.appointmentTime) {
      const dateTime = new Date(appointmentData.appointmentTime);
      // Format date as YYYY-MM-DD for date input
      const dateStr = dateTime.toISOString().split('T')[0];
      document.getElementById('appointmentDate').value = dateStr;
      
      // Format time as HH:MM for time input
      const timeStr = dateTime.toTimeString().substring(0, 5);
      document.getElementById('appointmentTime').value = timeStr;
    }
    
    document.getElementById('reason').value = appointmentData.description || '';
  }

  // Toggle edit mode
  function toggleEditMode() {
    // Check if appointment is checked-in
    const currentStatus = appointmentData.status;
    if (currentStatus === 'Checked-in') {
      alert('Cannot edit appointment that is already checked-in.');
      return;
    }
    
    const editBtn = document.getElementById('editBtn');
    const saveContainer = document.getElementById('saveButtonContainer');
    const isEditing = editBtn.textContent.includes('Cancel');
    
    if (isEditing) {
      // Cancel edit mode
      editBtn.innerHTML = '<span class="icon-[tabler--edit] size-4 mr-2"></span>Edit';
      editBtn.className = 'btn btn-primary';
      saveContainer.style.display = 'none';
      
      // Disable all form fields
      document.getElementById('status').disabled = true;
      document.getElementById('appointmentDate').disabled = true;
      document.getElementById('appointmentTime').disabled = true;
      document.getElementById('reason').disabled = true;
      
      // Reload original data
      populateAppointmentForm();
    } else {
      // Enter edit mode
      editBtn.innerHTML = '<span class="icon-[tabler--x] size-4 mr-2"></span>Cancel';
      editBtn.className = 'btn btn-secondary';
      saveContainer.style.display = 'flex';
      
      // Enable all form fields
      document.getElementById('status').disabled = false;
      document.getElementById('appointmentDate').disabled = false;
      document.getElementById('appointmentTime').disabled = false;
      document.getElementById('reason').disabled = false;
    }
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

  // Update edit button visibility based on appointment status
  function updateEditButtonVisibility() {
    const editBtn = document.getElementById('editBtn');
    const currentStatus = appointmentData.status;
    
    if (currentStatus === 'Checked-in') {
      // Disable edit button for checked-in appointments
      editBtn.disabled = true;
      editBtn.title = 'Cannot edit appointment that is already checked-in';
      editBtn.classList.add('btn-disabled');
      editBtn.classList.remove('btn-primary');
      editBtn.innerHTML = '<span class="icon-[tabler--lock] size-4 mr-2"></span>Edit (Disabled)';
    } else {
      // Enable edit button for other statuses
      editBtn.disabled = false;
      editBtn.title = 'Edit appointment details';
      editBtn.classList.remove('btn-disabled');
      editBtn.classList.add('btn-primary');
      editBtn.innerHTML = '<span class="icon-[tabler--edit] size-4 mr-2"></span>Edit';
    }
  }









  // Smart back navigation function
  function goBack() {
    // Check if we came from a specific page via URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const fromPage = urlParams.get('from');
    
    if (fromPage === 'consultation') {
      // Go back to the consultation detail page
      window.close(); // Close this window and return to the consultation detail
    } else {
      // Default fallback to appointment list
      window.location.href = '<%= request.getContextPath() %>/views/appointmentList.jsp';
    }
  }

  // Set back button text based on where we came from
  function setBackButtonText() {
    const urlParams = new URLSearchParams(window.location.search);
    const fromPage = urlParams.get('from');
    
    if (fromPage === 'consultation') {
      document.getElementById('backButtonText').textContent = 'Back to Consultation';
    } else {
      document.getElementById('backButtonText').textContent = 'Back to List';
    }
  }

  // Handle form submission
  document.getElementById('appointment-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Check if appointment is checked-in
    const currentStatus = appointmentData.status;
    if (currentStatus === 'Checked-in') {
      alert('Cannot edit appointment that is already checked-in.');
      return;
    }
    
    const formData = new FormData(e.target);
    const appointmentDate = formData.get('appointmentDate');
    const appointmentTime = formData.get('appointmentTime');
    
    // Combine date and time into appointmentTime
    const combinedDateTime = appointmentDate + 'T' + appointmentTime + ':00';
    
    const updateData = {
      appointmentID: appointmentId,
      patientID: appointmentData.patientID,
      appointmentTime: combinedDateTime,
      status: formData.get('status'),
      description: formData.get('reason'),
      reason: formData.get('reason') // Keep reason field for compatibility
    };

    try {
      const response = await fetch(API_BASE + '/appointments/' + appointmentId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData)
      });

      if (response.ok) {
        alert('Appointment updated successfully!');
        // Reload appointment data
        await loadAppointmentData();
        // Exit edit mode
        toggleEditMode();
        // Update edit button visibility after status change
        updateEditButtonVisibility();
      } else {
        const error = await response.json();
        alert('Error updating appointment: ' + error.error);
      }
    } catch (error) {
      alert('Error updating appointment: ' + error.message);
    }
  });

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', function() {
    setBackButtonText();
    loadAppointmentData();
  });
</script>
</body>
</html>
