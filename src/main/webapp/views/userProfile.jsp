<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>User Profile</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/userSidebar.jsp" %>

<div class="flex flex-col gap-6 p-8 pt-[5.5rem] backdrop-blur-lg min-h-screen md:ml-64">
  <div class="bg-base-100 p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-2">User Profile</h1>
    <p class="text-sm text-base-content/70">Update your personal information</p>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Success Alert -->
  <div id="successAlert" class="alert alert-success hidden">
    <span class="icon-[tabler--check] size-5"></span>
    <span id="successMessage"></span>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>

  <!-- Profile Form -->
  <div id="profileContent" class="bg-base-100 p-6 rounded-lg shadow-md hidden">
    <div class="alert alert-info mb-6">
      <span class="icon-[tabler--info-circle] size-5"></span>
      <span>You can only update contact information, emergency contacts, and allergies. Other fields are read-only for security reasons.</span>
    </div>

    <form id="profileForm" class="space-y-6">
      <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
        <!-- Read-only fields -->
        <div>
          <label class="label">Patient ID</label>
          <input type="text" id="patientID" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Student ID</label>
          <input type="text" id="studentId" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">First Name</label>
          <input type="text" id="firstName" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Last Name</label>
          <input type="text" id="lastName" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Gender</label>
          <input type="text" id="gender" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Date of Birth</label>
          <input type="text" id="dateOfBirth" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Age</label>
          <input type="number" id="age" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Nationality</label>
          <input type="text" id="nationality" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">ID Type</label>
          <input type="text" id="idType" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">ID Number</label>
          <input type="text" id="idNumber" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label">Blood Type</label>
          <input type="text" id="bloodType" class="input input-bordered w-full" disabled />
        </div>

        <!-- Editable fields -->
        <div>
          <label class="label">Contact Number</label>
          <input type="text" id="contactNumber" class="input input-bordered w-full" required />
        </div>
        <div>
          <label class="label">Email</label>
          <input type="email" id="email" class="input input-bordered w-full" required />
        </div>
        <div class="md:col-span-2">
          <label class="label">Address</label>
          <input type="text" id="address" class="input input-bordered w-full" required />
        </div>
        <div>
          <label class="label">Emergency Contact Name</label>
          <input type="text" id="emergencyContactName" class="input input-bordered w-full" required />
        </div>
        <div>
          <label class="label">Emergency Contact Number</label>
          <input type="text" id="emergencyContactNumber" class="input input-bordered w-full" required />
        </div>
        <div class="md:col-span-2">
          <label class="label">Allergies</label>
          <textarea id="allergies" class="textarea textarea-bordered w-full" placeholder="List any allergies or leave blank if none"></textarea>
        </div>
      </div>

      <div class="flex gap-4 justify-end">
        <button type="button" onclick="resetForm()" class="btn btn-outline">Reset</button>
        <button type="submit" class="btn btn-primary flex items-center gap-2">
          <span class="icon-[tabler--device-floppy] size-4"></span>
          Save Changes
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let patientId = null;
  let originalData = null;

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

  // Load patient data
  async function loadPatientData() {
    patientId = await getPatientId();
    
    if (!patientId) {
      showError('You must be logged in as a patient to access this page');
      hideLoading();
      return;
    }
    
    try {
      const response = await fetch(API_BASE + '/patients/' + patientId);
      if (!response.ok) {
        throw new Error('Failed to load patient data');
      }
      
      const patientData = await response.json();
      populateForm(patientData);
      originalData = { ...patientData };
      hideLoading();
    } catch (error) {
      console.error('Error loading patient data:', error);
      showError('Failed to load patient data: ' + error.message);
      hideLoading();
    }
  }

  // Populate form with patient data
  function populateForm(data) {
    // Read-only fields
    document.getElementById('patientID').value = data.patientID || '';
    document.getElementById('studentId').value = data.studentId || '';
    document.getElementById('firstName').value = data.firstName || '';
    document.getElementById('lastName').value = data.lastName || '';
    document.getElementById('gender').value = data.gender || '';
    document.getElementById('dateOfBirth').value = data.dateOfBirth || '';
    document.getElementById('age').value = data.age || '';
    document.getElementById('nationality').value = data.nationality || '';
    document.getElementById('idType').value = data.idType || '';
    document.getElementById('idNumber').value = data.idNumber || '';
    document.getElementById('bloodType').value = data.bloodType || '';

    // Editable fields
    document.getElementById('contactNumber').value = data.contactNumber || '';
    document.getElementById('email').value = data.email || '';
    document.getElementById('address').value = data.address || '';
    document.getElementById('emergencyContactName').value = data.emergencyContactName || '';
    document.getElementById('emergencyContactNumber').value = data.emergencyContactNumber || '';
    document.getElementById('allergies').value = data.allergies || '';

    // Show form
    document.getElementById('profileContent').classList.remove('hidden');
  }

  // Handle form submission
  document.getElementById('profileForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Show loading state
    const submitButton = e.target.querySelector('button[type="submit"]');
    const originalText = submitButton.innerHTML;
    submitButton.innerHTML = '<span class="loading loading-spinner loading-sm"></span> Saving...';
    submitButton.disabled = true;
    
    // Hide alerts
    document.getElementById('successAlert').classList.add('hidden');
    document.getElementById('errorAlert').classList.add('hidden');
    
    try {
      // Get form data
      const updatedData = {
        contactNumber: document.getElementById('contactNumber').value,
        email: document.getElementById('email').value,
        address: document.getElementById('address').value,
        emergencyContactName: document.getElementById('emergencyContactName').value,
        emergencyContactNumber: document.getElementById('emergencyContactNumber').value,
        allergies: document.getElementById('allergies').value
      };

      // Send update request
      const response = await fetch(API_BASE + '/patients/' + patientId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedData)
      });

      if (response.ok) {
        const updatedPatient = await response.json();
        originalData = { ...updatedPatient };
        showSuccess('Profile updated successfully!');
      } else {
        const errorResult = await response.json();
        showError('Failed to update profile: ' + (errorResult.message || 'Unknown error'));
      }
    } catch (error) {
      console.error('Error updating profile:', error);
      showError('Failed to update profile: ' + error.message);
    } finally {
      // Reset button state
      submitButton.innerHTML = originalText;
      submitButton.disabled = false;
    }
  });

  // Reset form to original values
  function resetForm() {
    if (originalData) {
      populateForm(originalData);
      showSuccess('Form reset to original values');
    }
  }

  // Show success message
  function showSuccess(message) {
    document.getElementById('successMessage').textContent = message;
    document.getElementById('successAlert').classList.remove('hidden');
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

  // Initialize profile
  document.addEventListener('DOMContentLoaded', function() {
    loadPatientData();
  });
</script>
</body>
</html>
