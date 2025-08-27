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

  <!-- Patient Appointments -->
  <div id="appointmentSection" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-xl font-semibold">Your Appointments</h3>
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

  // Load dashboard data
  async function loadDashboardData() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
    try {
      // Load patient information
      const patientResponse = await fetch(API_BASE + '/patients/' + patientId);
      if (!patientResponse.ok) {
        throw new Error('Failed to load patient information');
      }
      const patientData = await patientResponse.json();
      
      // Load patient's appointments
      const appointmentsResponse = await fetch(API_BASE + '/appointments');
      if (!appointmentsResponse.ok) {
        throw new Error('Failed to load appointments');
      }
      const allAppointments = await appointmentsResponse.json();
      
      // Filter appointments for this patient
      const appointments = allAppointments.elements || allAppointments || [];
      const patientAppointments = appointments.filter(apt => apt.patientID === patientId);
      
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
      tbody.innerHTML = '<tr><td colspan="5" class="text-center text-gray-500">No appointments found</td></tr>';
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
        '<td class="flex gap-2">' +
          '<button class="btn btn-sm btn-warning flex items-center gap-1" onclick="rescheduleAppointment(\'' + appointment.appointmentID + '\')">' +
            '<span class="icon-[tabler--calendar-time] size-3"></span>' +
            'Reschedule' +
          '</button>' +
          '<button class="btn btn-sm btn-error flex items-center gap-1" onclick="cancelAppointment(\'' + appointment.appointmentID + '\')">' +
            '<span class="icon-[tabler--x] size-3"></span>' +
            'Cancel' +
          '</button>' +
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
        const response = await fetch(API_BASE + '/appointments/' + appointmentId + '/cancel', {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ appointmentID: appointmentId })
        });
        
        if (response.ok) {
          alert('Appointment cancelled successfully!');
          // Reload dashboard data
          loadDashboardData();
        } else {
          const errorResult = await response.json();
          alert('Failed to cancel appointment: ' + (errorResult.message || 'Unknown error'));
        }
      } catch (error) {
        console.error('Error cancelling appointment:', error);
        alert('Failed to cancel appointment: ' + error.message);
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
      
    } catch (error) {
      console.error('Error checking availability:', error);
      timeSelect.innerHTML = '<option value="" disabled selected>Error loading availability</option>';
      if (availabilityInfo && availabilityText) {
        availabilityInfo.classList.remove('hidden');
        availabilityText.textContent = 'Error loading availability. Please try again.';
        availabilityText.className = 'text-red-600';
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
        alert('Appointment rescheduled successfully!');
        closeRescheduleModal();
        // Reload dashboard data
        loadDashboardData();
      } else {
        const errorResult = await updateResponse.json();
        alert('Failed to reschedule appointment: ' + (errorResult.message || 'Unknown error'));
      }
    } catch (error) {
      console.error('Error rescheduling appointment:', error);
      alert('Failed to reschedule appointment: ' + error.message);
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



  // Initialize dashboard
  document.addEventListener('DOMContentLoaded', function() {
    loadDashboardData();
  });
</script>
</body>
</html>
