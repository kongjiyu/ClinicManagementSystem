<%--
Author: Kong Ji Yu
General Module
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>User Dashboard</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script defer src="<%= request.getContextPath() %>/static/malaysian-date-utils.js"></script>
</head>
<body>
<%@ include file="/views/userSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Welcome and Summary -->
  <div id="welcomeSection" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <h2 class="text-2xl font-bold mb-2">Welcome back, <span id="patientName">User</span>!</h2>
    <p class="text-sm text-base-content/70">Today is <%= java.time.LocalDate.now() %>.</p>
  </div>

  <!-- Patient Appointments -->
  <div id="appointmentSection" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-xl font-semibold">Your Active Appointments</h3>
      <a href="<%= request.getContextPath() %>/views/userCreateAppointment.jsp" class="btn btn-sm btn-accent flex items-center gap-2">
        <span class="icon-[tabler--calendar-plus] size-3"></span>
        New Appointment
      </a>
    </div>
    <div class="overflow-x-auto">
      <table class="table table-zebra w-full">
        <thead>
          <tr>
            <th>Date</th>
            <th>Time</th>
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

 

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>
</main>

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

  // Load dashboard data
  async function loadDashboardData() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
    try {
      // Load both patient information and appointments in parallel for better performance
      const [patientResponse, appointmentsResponse] = await Promise.all([
        fetch(API_BASE + '/patients/' + patientId),
        fetch(API_BASE + '/appointments/by-patient/' + patientId)
      ]);

      if (!patientResponse.ok) {
        throw new Error('Failed to load patient information');
      }
      if (!appointmentsResponse.ok) {
        throw new Error('Failed to load appointments');
      }

      const [patientData, appointmentsData] = await Promise.all([
        patientResponse.json(),
        appointmentsResponse.json()
      ]);

      const patientAppointments = appointmentsData.elements || appointmentsData || [];
      
      const dashboardData = {
        patient: patientData,
        appointments: patientAppointments
      };
      
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
    // Populate patient name
    if (data.patient) {
      const patientName = (data.patient.firstName || '') + ' ' + (data.patient.lastName || '');
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

    const appointments = data.appointments || [];

    if (!appointments || appointments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="text-center text-gray-500">No appointments found</td></tr>';
      return;
    }

    // Filter for active appointments only
    const activeAppointments = appointments.filter(appointment => {
      const status = appointment.status ? appointment.status.toLowerCase() : '';
      return status === 'scheduled' || status === 'confirmed' || status === 'check in' || status === 'checked-in';
    });

    if (activeAppointments.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="text-center text-gray-500">No active appointments found</td></tr>';
      return;
    }

    // Use DocumentFragment for better performance
    const fragment = document.createDocumentFragment();

    activeAppointments.forEach((appointment) => {
      const row = document.createElement('tr');
      
      // Format appointment date and time
      const appointmentDateTime = appointment.appointmentTime ? new Date(appointment.appointmentTime) : null;
      const date = appointmentDateTime ? formatMalaysianDate(appointmentDateTime) : 'N/A';
      const time = appointmentDateTime ? formatMalaysianTime(appointmentDateTime) : 'N/A';

      // Get status badge
      const statusBadge = getStatusBadge(appointment.status);

      // Check if appointment is cancelled, completed, or no-show - if so, don't show action buttons
      const isCancelled = appointment.status && appointment.status.toLowerCase() === 'cancelled';
      const isCompleted = appointment.status && appointment.status.toLowerCase() === 'completed';
      const isNoShow = appointment.status && (appointment.status.toLowerCase() === 'noshow' || appointment.status.toLowerCase() === 'no shown');
      
      row.innerHTML = 
        '<td>' + date + '</td>' +
        '<td>' + time + '</td>' +
        '<td>' + statusBadge + '</td>' +
        '<td class="flex gap-2">' +
          (isCancelled || isCompleted || isNoShow ? 
            '<span class="text-gray-500 text-sm">No actions available</span>' :
            '<button class="btn btn-sm btn-warning flex items-center gap-1" onclick="rescheduleAppointment(\'' + appointment.appointmentID + '\')">' +
              '<span class="icon-[tabler--calendar-time] size-3"></span>' +
              'Reschedule' +
            '</button>' +
            '<button class="btn btn-sm btn-error flex items-center gap-1" onclick="cancelAppointment(\'' + appointment.appointmentID + '\')">' +
              '<span class="icon-[tabler--x] size-3"></span>' +
              'Cancel' +
            '</button>'
          ) +
        '</td>';
      
      fragment.appendChild(row);
    });

    // Append all rows at once for better performance
    tbody.appendChild(fragment);
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
  async function rescheduleAppointment(appointmentId) {
    try {
      // Get the current appointment data
      const response = await fetch(API_BASE + '/appointments/' + appointmentId);
      if (!response.ok) {
        throw new Error('Failed to load appointment details');
      }
      
      const appointment = await response.json();
      
      // Create reschedule modal
      const modal = createRescheduleModal(appointment);
      document.body.appendChild(modal);
      
      // Show modal
      modal.classList.remove('hidden');
      
    } catch (error) {
      console.error('Error loading appointment:', error);
      alert('Failed to load appointment details: ' + error.message);
    }
  }

  // Cancel appointment
  async function cancelAppointment(appointmentId) {
    if (confirm('Are you sure you want to cancel this appointment?')) {
      try {
        // Show loading state on the button
        const button = event.target.closest('button');
        const originalText = button.innerHTML;
        button.innerHTML = '<span class="loading loading-spinner loading-xs"></span> Cancelling...';
        button.disabled = true;
        
        const response = await fetch(API_BASE + '/appointments/' + appointmentId + '/cancel', {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ appointmentID: appointmentId })
        });
        
        if (response.ok) {
          // Show success message briefly
          button.innerHTML = '<span class="icon-[tabler--check] size-3"></span> Cancelled!';
          button.className = 'btn btn-sm btn-success flex items-center gap-1';
          
          // Refresh the appointments table immediately
          await refreshAppointmentsTable();
          
          // Reset button after 2 seconds
          setTimeout(() => {
            button.innerHTML = originalText;
            button.className = 'btn btn-sm btn-error flex items-center gap-1';
            button.disabled = false;
          }, 2000);
        } else {
          const errorResult = await response.json();
          alert('Failed to cancel appointment: ' + (errorResult.message || 'Unknown error'));
          // Reset button
          button.innerHTML = originalText;
          button.disabled = false;
        }
      } catch (error) {
        console.error('Error cancelling appointment:', error);
        alert('Failed to cancel appointment: ' + error.message);
        // Reset button
        const button = event.target.closest('button');
        button.innerHTML = originalText;
        button.disabled = false;
      }
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

  // Check availability for reschedule
  async function checkRescheduleAvailability(selectedDate, currentAppointmentId) {
    const timeSelect = document.getElementById('rescheduleTime');
    const availabilityInfo = document.getElementById('rescheduleAvailabilityInfo');
    const availabilityText = document.getElementById('rescheduleAvailabilityText');
    const rescheduleSubmitButton = document.querySelector('#rescheduleForm button[type="submit"]');
    
    // Disable submit button and show loading state
    if (rescheduleSubmitButton) {
      rescheduleSubmitButton.disabled = true;
      rescheduleSubmitButton.innerHTML = '<span class="loading loading-spinner loading-sm"></span> Loading...';
    }
    
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
      
      // Filter appointments for the selected date, excluding the current appointment being rescheduled
      const selectedDateAppointments = appointmentList.filter(apt => {
        if (!apt.appointmentTime || apt.appointmentID === currentAppointmentId) return false;
        const aptDate = new Date(apt.appointmentTime);
        const selected = new Date(selectedDate);
        return aptDate.toDateString() === selected.toDateString();
      });
      
      // Count appointments per time slot
      const slotCounts = {};
      selectedDateAppointments.forEach(apt => {
        const aptTime = new Date(apt.appointmentTime);
        const timeSlot = aptTime.toTimeString().substring(0, 5); // Get HH:MM format
        slotCounts[timeSlot] = (slotCounts[timeSlot] || 0) + 1;
      });
      
      // Populate time slots with availability
      timeSelect.innerHTML = '<option value="" disabled selected>Select a time slot</option>';
      
      let availableCount = 0;
      let totalCount = timeSlots.length;
      
      timeSlots.forEach(slot => {
        const currentCount = slotCounts[slot.value] || 0;
        const isAvailable = currentCount < 2; // Allow up to 2 patients per slot
        const option = document.createElement('option');
        option.value = slot.value;
        
        if (isAvailable) {
          const remainingSlots = 2 - currentCount;
          option.textContent = slot.label + ' - ' + remainingSlots + ' slot' + (remainingSlots > 1 ? 's' : '') + ' available';
          option.className = 'text-green-600';
          availableCount++;
        } else {
          option.textContent = slot.label + ' - Fully Booked (2/2)';
          option.disabled = true;
          option.className = 'text-red-600';
        }
        
        timeSelect.appendChild(option);
      });
      
      // Show availability summary
      if (availabilityInfo && availabilityText) {
        availabilityInfo.classList.remove('hidden');
        if (availableCount === 0) {
          availabilityText.textContent = 'No available time slots for this date. Please select another date.';
          availabilityText.className = 'text-red-600';
        } else {
          availabilityText.textContent = availableCount + ' of ' + totalCount + ' time slots have availability (max 2 patients per slot)';
          availabilityText.className = 'text-green-600';
        }
      }
      
      // Re-enable submit button
      if (rescheduleSubmitButton) {
        rescheduleSubmitButton.disabled = false;
        rescheduleSubmitButton.innerHTML = '<span class="icon-[tabler--calendar-time] size-4"></span> Reschedule';
      }
      
    } catch (error) {
      console.error('Error checking availability:', error);
      timeSelect.innerHTML = '<option value="" disabled selected>Error loading availability</option>';
      if (availabilityInfo && availabilityText) {
        availabilityInfo.classList.remove('hidden');
        availabilityText.textContent = 'Error loading availability. Please try again.';
        availabilityText.className = 'text-red-600';
      }
      
      // Re-enable submit button on error
      if (rescheduleSubmitButton) {
        rescheduleSubmitButton.disabled = false;
        rescheduleSubmitButton.innerHTML = '<span class="icon-[tabler--calendar-time] size-4"></span> Reschedule';
      }
    }
  }

  // Create reschedule modal
  function createRescheduleModal(appointment) {
    const modal = document.createElement('div');
    modal.className = 'fixed inset-0 flex items-center justify-center';
    modal.style.cssText = 'background-color: rgba(0, 0, 0, 0.5) !important; z-index: 9999 !important;';
    
    // Calculate date constraints
    const today = new Date().toISOString().split('T')[0];
    const maxDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
    
    modal.innerHTML = 
      '<div class="bg-white rounded-lg p-6 w-full max-w-md mx-4" style="z-index: 10000 !important;">' +
        '<div class="flex justify-between items-center mb-4">' +
          '<h3 class="text-lg font-semibold">Reschedule Appointment</h3>' +
          '<button onclick="closeRescheduleModal()" class="text-gray-500 hover:text-gray-700">' +
            '<span class="icon-[tabler--x] size-5"></span>' +
          '</button>' +
        '</div>' +
        
        '<form id="rescheduleForm" class="space-y-4">' +
          '<input type="hidden" id="rescheduleAppointmentId" value="' + appointment.appointmentID + '">' +
          
          '<div>' +
            '<label class="label">New Date</label>' +
            '<input type="date" id="rescheduleDate" class="input input-bordered w-full"' +
                   ' min="' + today + '"' +
                   ' max="' + maxDate + '"' +
                   ' required />' +
          '</div>' +
          
          '<div>' +
            '<label class="label">New Time</label>' +
            '<select id="rescheduleTime" class="select select-bordered w-full" required>' +
              '<option value="" disabled selected>Select a date first to see available time slots</option>' +
            '</select>' +
            '<div id="rescheduleAvailabilityInfo" class="text-sm text-gray-600 mt-2 hidden">' +
              '<span class="icon-[tabler--info-circle] size-4 mr-1"></span>' +
              '<span id="rescheduleAvailabilityText"></span>' +
            '</div>' +
          '</div>' +
          
          '<div class="flex gap-2 justify-end">' +
            '<button type="button" onclick="closeRescheduleModal()" class="btn btn-outline">Cancel</button>' +
            '<button type="submit" class="btn btn-primary flex items-center gap-2">' +
              '<span class="icon-[tabler--calendar-time] size-4"></span>' +
              'Reschedule' +
            '</button>' +
          '</div>' +
        '</form>' +
      '</div>';
    
    // Add form submit handler
    modal.querySelector('#rescheduleForm').addEventListener('submit', handleRescheduleSubmit);
    
    // Add event listener for date selection to check availability
    const dateInput = modal.querySelector('#rescheduleDate');
    dateInput.addEventListener('change', function(e) {
      const selectedDate = e.target.value;
      const currentAppointmentId = document.getElementById('rescheduleAppointmentId').value;
      if (selectedDate) {
        checkRescheduleAvailability(selectedDate, currentAppointmentId);
      } else {
        // Reset time select if no date is selected
        const timeSelect = document.getElementById('rescheduleTime');
        const availabilityInfo = document.getElementById('rescheduleAvailabilityInfo');
        timeSelect.innerHTML = '<option value="" disabled selected>Select a date first to see available time slots</option>';
        if (availabilityInfo) {
          availabilityInfo.classList.add('hidden');
        }
      }
    });
    
    // Add click event to close modal when clicking backdrop
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeRescheduleModal();
      }
    });
    
    return modal;
  }

  // Handle reschedule form submission
  async function handleRescheduleSubmit(e) {
    e.preventDefault();
    
    const appointmentId = document.getElementById('rescheduleAppointmentId').value;
    const newDate = document.getElementById('rescheduleDate').value;
    const newTime = document.getElementById('rescheduleTime').value;
    
    if (!newDate || !newTime) {
      alert('Please select both date and time');
      return;
    }
    
    // Check if availability is still loading
    const timeSelect = document.getElementById('rescheduleTime');
    const firstOption = timeSelect.options[0];
    if (firstOption && firstOption.textContent.includes('Loading availability')) {
      alert('Please wait for availability to load before rescheduling');
      return;
    }
    
    // Show loading state on submit button
    const submitButton = e.target.querySelector('button[type="submit"]');
    const originalText = submitButton.innerHTML;
    submitButton.innerHTML = '<span class="loading loading-spinner loading-xs"></span> Rescheduling...';
    submitButton.disabled = true;
    
    try {
      // Get current appointment data
      const response = await fetch(API_BASE + '/appointments/' + appointmentId);
      if (!response.ok) {
        throw new Error('Failed to load appointment details');
      }
      
      const currentAppointment = await response.json();
      
      // Create updated appointment object
      const updatedAppointment = {
        appointmentID: appointmentId,
        patientID: currentAppointment.patientID,
        appointmentTime: newDate + 'T' + newTime + ':00',
        status: 'Scheduled',
        description: currentAppointment.description || ''
      };
      
      // Update appointment
      const updateResponse = await fetch(API_BASE + '/appointments/' + appointmentId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedAppointment)
      });
      
      if (updateResponse.ok) {
        // Show success message briefly
        submitButton.innerHTML = '<span class="icon-[tabler--check] size-3"></span> Rescheduled!';
        submitButton.className = 'btn btn-success flex items-center gap-2';
        
        // Close modal and refresh appointments table immediately
        closeRescheduleModal();
        await refreshAppointmentsTable();
        
        // Show brief success notification
        showSuccessNotification('Appointment rescheduled successfully!');
      } else {
        const errorResult = await updateResponse.json();
        alert('Failed to reschedule appointment: ' + (errorResult.message || 'Unknown error'));
        // Reset button
        submitButton.innerHTML = originalText;
        submitButton.disabled = false;
      }
    } catch (error) {
      console.error('Error rescheduling appointment:', error);
      alert('Failed to reschedule appointment: ' + error.message);
      // Reset button
      submitButton.innerHTML = originalText;
      submitButton.disabled = false;
    }
  }





  // Close reschedule modal
  function closeRescheduleModal() {
    const modal = document.querySelector('.fixed.inset-0');
    if (modal) {
      modal.remove();
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

  // Refresh only the appointments table (more efficient than full dashboard reload)
  async function refreshAppointmentsTable() {
    if (!patientId) return;
    
    try {
      const response = await fetch(API_BASE + '/appointments/by-patient/' + patientId);
      if (response.ok) {
        const appointmentsData = await response.json();
        const patientAppointments = appointmentsData.elements || appointmentsData || [];
        
        // Update only the appointments table
        populateAppointmentsTable({ appointments: patientAppointments });
      }
    } catch (error) {
      console.error('Error refreshing appointments:', error);
    }
  }

  // Show success notification
  function showSuccessNotification(message) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-success text-success-content px-4 py-2 rounded-lg shadow-lg z-50 flex items-center gap-2';
    notification.innerHTML = 
      '<span class="icon-[tabler--check] size-4"></span>' +
      '<span>' + message + '</span>';
    
    // Add to page
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(() => {
      if (notification.parentNode) {
        notification.parentNode.removeChild(notification);
      }
    }, 3000);
  }



  // Initialize dashboard
  document.addEventListener('DOMContentLoaded', function() {
    loadDashboardData();
  });
</script>
</body>
</html>
