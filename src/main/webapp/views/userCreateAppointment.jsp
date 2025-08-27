<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>New Appointment</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="p-8 bg-gray-50 text-sm">
<%@ include file="/views/userSidebar.jsp" %>

  <div class="max-w-3xl mx-auto bg-white shadow-md p-8 rounded-md">
    <div class="max-w-xl mx-auto">
      <h2 class="text-2xl font-semibold mb-6">Create New Appointment</h2>
      
      <!-- Success Alert -->
      <div id="successAlert" class="alert alert-success hidden mb-4">
        <span class="icon-[tabler--check] size-5"></span>
        <span id="successMessage"></span>
      </div>
      
      <!-- Error Alert -->
      <div id="errorAlert" class="alert alert-error hidden mb-4">
        <span class="icon-[tabler--alert-circle] size-5"></span>
        <span id="errorMessage"></span>
      </div>
      
      <!-- Loading Spinner -->
      <div id="loadingSpinner" class="flex justify-center items-center py-8 hidden">
        <div class="loading loading-spinner loading-lg"></div>
      </div>

      <form id="appointmentForm" class="space-y-6">
        <!-- Select Date -->
        <div>
            <label class="label">Appointment Date</label>
            <input type="date" name="appointmentDate" id="appointmentDate" class="input input-bordered w-full"
                   min="<%= java.time.LocalDate.now().plusDays(1) %>"
                   max="<%= java.time.LocalDate.now().plusMonths(1) %>"
                   required />
        </div>

        <!-- Select Time -->
        <div>
            <label class="label">Appointment Time</label>
            <select name="appointmentTime" id="appointmentTime" class="select select-bordered w-full" required>
                <option value="" disabled selected>Select a date first to see available time slots</option>
            </select>
            <div id="availabilityInfo" class="text-sm text-gray-600 mt-2 hidden">
                <span class="icon-[tabler--info-circle] size-4 mr-1"></span>
                <span id="availabilityText"></span>
            </div>
        </div>

        <!-- Notes (Optional) -->
        <div>
            <label class="label">Notes / Reason</label>
            <textarea name="note" id="note" class="textarea textarea-bordered w-full" placeholder="Describe your reason (optional)"></textarea>
        </div>

        <!-- Submit -->
        <div class="flex gap-4 justify-end">
            <a href="<%= request.getContextPath() %>/views/userDashboard.jsp" class="btn btn-outline">Cancel</a>
            <button type="submit" class="btn btn-primary flex items-center gap-2">
              <span class="icon-[tabler--calendar-plus] size-4"></span>
              Create Appointment
            </button>
        </div>
      </form>
    </div>
  </div>

  <script>
    const API_BASE = '<%= request.getContextPath() %>/api';
    
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
        availabilityInfo.classList.remove('hidden');
        if (availableCount === 0) {
          availabilityText.textContent = 'No available time slots for this date. Please select another date.';
          availabilityText.className = 'text-red-600';
        } else {
          availabilityText.textContent = availableCount + ' of ' + totalCount + ' time slots have availability (max 2 patients per slot)';
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
    
    document.getElementById('appointmentForm').addEventListener('submit', async function(e) {
      e.preventDefault();
      
      // Show loading spinner
      document.getElementById('loadingSpinner').classList.remove('hidden');
      document.getElementById('successAlert').classList.add('hidden');
      document.getElementById('errorAlert').classList.add('hidden');
      
      try {
        // Get patient ID from session
        const patientId = await getPatientId();
        if (!patientId) {
          document.getElementById('errorMessage').textContent = 'You must be logged in as a patient to create appointments';
          document.getElementById('errorAlert').classList.remove('hidden');
          return;
        }
        
        // Get form data
        const appointmentDate = document.getElementById('appointmentDate').value;
        const appointmentTime = document.getElementById('appointmentTime').value;
        const notes = document.getElementById('note').value;
        
        // Validate required fields
        if (!appointmentDate || !appointmentTime) {
          document.getElementById('errorMessage').textContent = 'Please select both date and time';
          document.getElementById('errorAlert').classList.remove('hidden');
          return;
        }
        
        // Create appointment object
        const appointmentData = {
          patientID: patientId,
          appointmentTime: appointmentDate + 'T' + appointmentTime + ':00',
          status: 'Scheduled',
          description: notes || ''
        };
        
        // Send to API
        const response = await fetch(API_BASE + '/appointments', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(appointmentData)
        });
        
        if (response.ok) {
          const result = await response.json();
          
          // Show success message
          document.getElementById('successMessage').textContent = 'Appointment created successfully! (ID: ' + result.appointmentID + ')';
          document.getElementById('successAlert').classList.remove('hidden');
          
          // Reset form
          document.getElementById('appointmentForm').reset();
          
          // Redirect to dashboard after 2 seconds
          setTimeout(() => {
            window.location.href = '<%= request.getContextPath() %>/views/userDashboard.jsp';
          }, 2000);
        } else {
          const errorResult = await response.json();
          document.getElementById('errorMessage').textContent = errorResult.message || 'Failed to create appointment';
          document.getElementById('errorAlert').classList.remove('hidden');
        }
      } catch (error) {
        console.error('Error:', error);
        document.getElementById('errorMessage').textContent = 'Network error. Please try again.';
        document.getElementById('errorAlert').classList.remove('hidden');
      } finally {
        // Hide loading spinner
        document.getElementById('loadingSpinner').classList.add('hidden');
      }
    });
  </script>
</body>
</html>
