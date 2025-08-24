<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Appointment - Clinic Management System</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-6">
  <!-- Header -->
  <div class="flex justify-between items-center">
    <div>
      <h1 class="text-3xl font-bold">Create New Appointment</h1>
      <p class="text-base-content/70">Schedule a new appointment for a patient</p>
    </div>
    <a href="<%= request.getContextPath() %>/views/appointmentList.jsp" class="btn btn-outline">
      <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
      Back to Appointments
    </a>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Create Appointment Form -->
  <div id="formSection" class="hidden">
    <div class="bg-base-100 p-6 rounded-lg shadow-lg max-w-2xl mx-auto">
      <form id="createAppointmentForm" class="space-y-6">
        <!-- Patient Selection -->
        <div class="form-control">
          <label class="label">
            <span class="label-text font-semibold">Patient *</span>
          </label>
          <input type="text" id="patientInput" class="input input-bordered w-full" 
                 list="patientList" placeholder="Type patient name or ID to search..." required>
          <datalist id="patientList">
            <!-- Patient options will be populated by JavaScript -->
          </datalist>
          <label class="label">
            <span class="label-text-alt">Type to search for existing patients (name or ID)</span>
          </label>
        </div>
        
        <!-- Date and Time Selection -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Date *</span>
            </label>
            <input type="date" id="appointmentDate" class="input input-bordered w-full" 
                   min="<%= java.time.LocalDate.now().plusDays(1) %>"
                   required>
            <label class="label">
              <span class="label-text-alt">Appointment date (cannot select today or past dates)</span>
            </label>
          </div>
          
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Time *</span>
            </label>
            <select id="appointmentTime" class="select select-bordered w-full" required>
              <option value="" disabled selected>Select a date first to see available time slots</option>
            </select>
            <label class="label">
              <span class="label-text-alt">Appointment time</span>
            </label>
            <div id="availabilityInfo" class="text-sm text-gray-600 mt-2 hidden">
              <span class="icon-[tabler--info-circle] size-4 mr-1"></span>
              <span id="availabilityText"></span>
            </div>
          </div>
        </div>
        
        <!-- Status (Hidden - Always Confirmed) -->
        <input type="hidden" id="appointmentStatus" value="Confirmed">
        
        <!-- Description -->
        <div class="form-control">
          <label class="label">
            <span class="label-text font-semibold">Description</span>
          </label>
          <textarea id="appointmentDescription" class="textarea textarea-bordered h-32" 
                    placeholder="Enter appointment description, symptoms, or special instructions..."></textarea>
          <label class="label">
            <span class="label-text-alt">Additional notes about the appointment</span>
          </label>
        </div>
        
        <!-- Form Actions -->
        <div class="flex justify-end gap-4 pt-6 border-t">
          <a href="<%= request.getContextPath() %>/views/appointmentList.jsp" class="btn btn-outline">
            Cancel
          </a>
          <button type="submit" class="btn btn-primary">
            <span class="icon-[tabler--plus] size-4 mr-2"></span>
            Create Appointment
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Success Alert -->
  <div id="successAlert" class="alert alert-success fixed top-4 right-4 w-auto max-w-sm hidden">
    <span class="icon-[tabler--check] size-5"></span>
    <span id="successMessage"></span>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error fixed top-4 right-4 w-auto max-w-sm hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    loadPatients();
    setDefaultDateTime();
    hideLoading();
    showForm();
  });

  // Load patients for the datalist
  async function loadPatients() {
    try {
      const response = await fetch(API_BASE + '/patients');
      const data = await response.json();
      const patients = data.elements || data || [];
      
      const patientList = document.getElementById('patientList');
      
      patients.forEach(function(patient) {
        const option = document.createElement('option');
        option.value = patient.patientID;
        option.textContent = patient.firstName + ' ' + patient.lastName + ' (ID: ' + patient.patientID + ')';
        patientList.appendChild(option);
      });
      
    } catch (error) {
      console.error('Error loading patients:', error);
      showError('Failed to load patients: ' + error.message);
    }
  }

  // Validate patient selection
  function validatePatientSelection() {
    const patientInput = document.getElementById('patientInput');
    const patientList = document.getElementById('patientList');
    const selectedValue = patientInput.value;
    
    // Check if the selected value exists in the datalist
    const options = Array.from(patientList.options);
    const isValidPatient = options.some(option => option.value === selectedValue);
    
    if (!isValidPatient && selectedValue.trim() !== '') {
      patientInput.setCustomValidity('Please select a valid patient from the list');
      return false;
    } else {
      patientInput.setCustomValidity('');
      return true;
    }
  }

  // Available time slots (8 AM to 8 PM with 30-minute intervals)
  const timeSlots = [
    { value: '08:00', label: '08:00 AM' },
    { value: '08:30', label: '08:30 AM' },
    { value: '09:00', label: '09:00 AM' },
    { value: '09:30', label: '09:30 AM' },
    { value: '10:00', label: '10:00 AM' },
    { value: '10:30', label: '10:30 AM' },
    { value: '11:00', label: '11:00 AM' },
    { value: '11:30', label: '11:30 AM' },
    { value: '12:00', label: '12:00 PM' },
    { value: '12:30', label: '12:30 PM' },
    { value: '13:00', label: '01:00 PM' },
    { value: '13:30', label: '01:30 PM' },
    { value: '14:00', label: '02:00 PM' },
    { value: '14:30', label: '02:30 PM' },
    { value: '15:00', label: '03:00 PM' },
    { value: '15:30', label: '03:30 PM' },
    { value: '16:00', label: '04:00 PM' },
    { value: '16:30', label: '04:30 PM' },
    { value: '17:00', label: '05:00 PM' },
    { value: '17:30', label: '05:30 PM' },
    { value: '18:00', label: '06:00 PM' },
    { value: '18:30', label: '06:30 PM' },
    { value: '19:00', label: '07:00 PM' },
    { value: '19:30', label: '07:30 PM' },
    { value: '20:00', label: '08:00 PM' }
  ];

  // Set default date (not setting any default to trigger availability check)
  function setDefaultDateTime() {
    // Don't set any default date - let user select to trigger availability check
    const dateInput = document.getElementById('appointmentDate');
    dateInput.value = '';
  }

  // Load appointments for a specific date and check availability
  async function checkAvailability(selectedDate) {
    const timeSelect = document.getElementById('appointmentTime');
    const availabilityInfo = document.getElementById('availabilityInfo');
    const availabilityText = document.getElementById('availabilityText');
    
    // Clear current options
    timeSelect.innerHTML = '<option value="" disabled selected>Loading availability...</option>';
    
    try {
      // Get all appointments
      const response = await fetch(API_BASE + '/appointments');
      if (!response.ok) {
        throw new Error('Failed to load appointments');
      }
      
      const appointments = await response.json();
      const appointmentList = appointments.elements || appointments || [];
      
      // Filter appointments for the selected date
      const selectedDateAppointments = appointmentList.filter(apt => {
        if (!apt.appointmentTime) return false;
        const aptDate = new Date(apt.appointmentTime);
        const selected = new Date(selectedDate);
        return aptDate.toDateString() === selected.toDateString();
      });
      
      // Get booked time slots
      const bookedTimeSlots = selectedDateAppointments.map(apt => {
        const aptTime = new Date(apt.appointmentTime);
        return aptTime.toTimeString().substring(0, 5); // Get HH:MM format
      });
      
      // Populate time slots with availability
      timeSelect.innerHTML = '<option value="" disabled selected>Select a time slot</option>';
      
      let availableCount = 0;
      let totalCount = timeSlots.length;
      
      timeSlots.forEach(slot => {
        const isAvailable = !bookedTimeSlots.includes(slot.value);
        const option = document.createElement('option');
        option.value = slot.value;
        
        if (isAvailable) {
          option.textContent = slot.label + ' - Available';
          option.className = 'text-green-600';
          availableCount++;
        } else {
          option.textContent = slot.label + ' - Booked';
          option.disabled = true;
          option.className = 'text-red-600';
        }
        
        timeSelect.appendChild(option);
      });
      
      // Show availability summary
      availabilityInfo.classList.remove('hidden');
      if (availableCount === 0) {
        availabilityText.textContent = 'No available time slots for this date. Please select another date.';
        availabilityText.className = 'text-red-600';
      } else {
        availabilityText.textContent = availableCount + ' of ' + totalCount + ' time slots available';
        availabilityText.className = 'text-green-600';
      }
      
    } catch (error) {
      console.error('Error checking availability:', error);
      timeSelect.innerHTML = '<option value="" disabled selected>Error loading availability</option>';
      availabilityInfo.classList.remove('hidden');
      availabilityText.textContent = 'Error loading availability. Please try again.';
      availabilityText.className = 'text-red-600';
    }
  }

  // Add event listener for date selection
  document.getElementById('appointmentDate').addEventListener('change', function(e) {
    const selectedDate = e.target.value;
    if (selectedDate) {
      checkAvailability(selectedDate);
    } else {
      // Reset time select if no date is selected
      const timeSelect = document.getElementById('appointmentTime');
      const availabilityInfo = document.getElementById('availabilityInfo');
      timeSelect.innerHTML = '<option value="" disabled selected>Select a date first to see available time slots</option>';
      availabilityInfo.classList.add('hidden');
    }
  });

  // Add event listeners for patient validation
  document.getElementById('patientInput').addEventListener('input', validatePatientSelection);
  document.getElementById('patientInput').addEventListener('blur', validatePatientSelection);

  // Handle form submission
  document.getElementById('createAppointmentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    createAppointment();
  });

  // Create appointment
  async function createAppointment() {
    const form = document.getElementById('createAppointmentForm');
    
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }
    
    const patientID = document.getElementById('patientInput').value;
    const appointmentDate = document.getElementById('appointmentDate').value;
    const appointmentTime = document.getElementById('appointmentTime').value;
    const description = document.getElementById('appointmentDescription').value;
    const status = document.getElementById('appointmentStatus').value;
    
    // Combine date and time
    const appointmentDateTime = appointmentDate + 'T' + appointmentTime + ':00';
    
    const appointmentData = {
      patientID: patientID,
      appointmentTime: appointmentDateTime,
      status: status,
      description: description
    };
    
    try {
      // Show loading state
      const submitBtn = form.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;
      submitBtn.innerHTML = '<span class="loading loading-spinner loading-sm"></span> Creating...';
      submitBtn.disabled = true;
      
      const response = await fetch(API_BASE + '/appointments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(appointmentData)
      });
      
      if (!response.ok) {
        throw new Error('Failed to create appointment');
      }
      
      const result = await response.json();
      
      showSuccess('Appointment created successfully! Redirecting to appointment list...');
      
      // Redirect to appointment list after 2 seconds
      setTimeout(function() {
        window.location.href = '<%= request.getContextPath() %>/views/appointmentList.jsp';
      }, 2000);
      
    } catch (error) {
      console.error('Error creating appointment:', error);
      showError('Failed to create appointment: ' + error.message);
      
      // Reset button state
      const submitBtn = form.querySelector('button[type="submit"]');
      submitBtn.innerHTML = '<span class="icon-[tabler--plus] size-4 mr-2"></span>Create Appointment';
      submitBtn.disabled = false;
    }
  }

  // Show success message
  function showSuccess(message) {
    document.getElementById('successMessage').textContent = message;
    document.getElementById('successAlert').classList.remove('hidden');
    
    setTimeout(function() {
      document.getElementById('successAlert').classList.add('hidden');
    }, 5000);
  }

  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
    
    setTimeout(function() {
      document.getElementById('errorAlert').classList.add('hidden');
    }, 5000);
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
  }

  // Show form
  function showForm() {
    document.getElementById('formSection').classList.remove('hidden');
  }
</script>
</body>
</html>
