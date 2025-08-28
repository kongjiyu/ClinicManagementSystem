<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
  Author: Kong Ji Yu
  Doctor Module
-->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Staff Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center">
    <h1 class="text-2xl font-bold">Staff Detail</h1>
    <div class="flex gap-2">
      <button id="editBtn" class="btn btn-primary" onclick="toggleEditMode()">
        <span class="icon-[tabler--edit] size-4"></span>
        Edit
      </button>
      <button id="saveBtn" class="btn btn-success hidden" onclick="saveStaff()">
        <span class="icon-[tabler--device-floppy] size-4"></span>
        Save
      </button>
      <button id="cancelBtn" class="btn btn-secondary hidden" onclick="cancelEdit()">
        <span class="icon-[tabler--x] size-4"></span>
        Cancel
      </button>
      <button class="btn btn-outline" onclick="window.history.back()">
        <span class="icon-[tabler--arrow-left] size-4"></span>
        Back
      </button>
    </div>
  </div>

  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <div id="staffContent" class="hidden">
    <form id="staffForm" class="space-y-6">
      <!-- Basic Information -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Basic Information</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Staff ID</span>
              </label>
              <input type="text" id="staffID" class="input input-bordered" readonly>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">First Name *</span>
              </label>
              <input type="text" id="firstName" class="input input-bordered" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Last Name *</span>
              </label>
              <input type="text" id="lastName" class="input input-bordered" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Gender *</span>
              </label>
              <select id="gender" class="select select-bordered" required disabled>
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Date of Birth *</span>
              </label>
              <input type="date" id="dateOfBirth" class="input input-bordered" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Nationality</span>
              </label>
              <input type="text" id="nationality" class="input input-bordered" disabled>
            </div>
          </div>
        </div>
      </div>

      <!-- Identification -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Identification</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">ID Type</span>
              </label>
              <select id="idType" class="select select-bordered" disabled>
                <option value="">Select ID Type</option>
                <option value="IC">IC</option>
                <option value="Passport">Passport</option>
                <option value="Driver License">Driver License</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">ID Number</span>
              </label>
              <input type="text" id="idNumber" class="input input-bordered" disabled>
            </div>
          </div>
        </div>
      </div>

      <!-- Contact Information -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Contact Information</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Contact Number *</span>
              </label>
              <input type="tel" id="contactNumber" class="input input-bordered" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Email *</span>
              </label>
              <input type="email" id="email" class="input input-bordered" required disabled>
            </div>
            <div class="form-control md:col-span-2">
              <label class="label">
                <span class="label-text">Address</span>
              </label>
              <textarea id="address" class="textarea textarea-bordered" rows="3" disabled></textarea>
            </div>
          </div>
        </div>
      </div>

      <!-- Employment Information -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Employment Information</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Position *</span>
              </label>
              <select id="position" class="select select-bordered" required disabled>
                <option value="">Select Position</option>
                <option value="Doctor">Doctor</option>
                <option value="Nurse">Nurse</option>
                <option value="Receptionist">Receptionist</option>
                <option value="Administrator">Administrator</option>
                <option value="Pharmacist">Pharmacist</option>
                <option value="Lab Technician">Lab Technician</option>
                <option value="Cleaner">Cleaner</option>
                <option value="Security">Security</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Medical License Number</span>
              </label>
              <input type="text" id="medicalLicenseNumber" class="input input-bordered" disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Employment Date *</span>
              </label>
              <input type="date" id="employmentDate" class="input input-bordered" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Password</span>
              </label>
              <input type="password" id="password" class="input input-bordered" placeholder="Leave blank to keep current password" disabled>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>

  <!-- Success Alert -->
  <div id="successAlert" class="alert alert-success hidden">
    <span class="icon-[tabler--check] size-5"></span>
    <span id="successMessage"></span>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let staffData = null;
  let originalData = null;

  // Get staff ID from URL parameter
  function getStaffId() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('id');
  }

  // Load staff data
  async function loadStaffData() {
    const staffId = getStaffId();
    if (!staffId) {
      showError('Staff ID is required');
      return;
    }

    try {
      const response = await fetch(API_BASE + '/staff/' + staffId);
      if (!response.ok) {
        throw new Error('Failed to fetch staff data');
      }
      
      staffData = await response.json();
      originalData = JSON.parse(JSON.stringify(staffData)); // Deep copy for comparison
      populateForm();
      hideLoading();
    } catch (error) {
      console.error('Error loading staff data:', error);
      showError('Failed to load staff data: ' + error.message);
    }
  }

  // Populate form with staff data
  function populateForm() {
    if (!staffData) return;

    // Basic Information
    document.getElementById('staffID').value = staffData.staffID || '';
    document.getElementById('firstName').value = staffData.firstName || '';
    document.getElementById('lastName').value = staffData.lastName || '';
    document.getElementById('gender').value = staffData.gender || '';
    document.getElementById('dateOfBirth').value = staffData.dateOfBirth || '';
    document.getElementById('nationality').value = staffData.nationality || '';

    // Identification
    document.getElementById('idType').value = staffData.idType || '';
    document.getElementById('idNumber').value = staffData.idNumber || '';

    // Contact Information
    document.getElementById('contactNumber').value = staffData.contactNumber || '';
    document.getElementById('email').value = staffData.email || '';
    document.getElementById('address').value = staffData.address || '';

    // Employment Information
    document.getElementById('position').value = staffData.position || '';
    document.getElementById('medicalLicenseNumber').value = staffData.medicalLicenseNumber || '';
    document.getElementById('employmentDate').value = staffData.employmentDate || '';
    document.getElementById('password').value = ''; // Don't populate password field
  }

  // Toggle edit mode
  function toggleEditMode() {
    const form = document.getElementById('staffForm');
    const inputs = form.querySelectorAll('input, select, textarea');
    const editBtn = document.getElementById('editBtn');
    const saveBtn = document.getElementById('saveBtn');
    const cancelBtn = document.getElementById('cancelBtn');

    // Enable/disable form fields
    inputs.forEach(input => {
      if (input.id !== 'staffID') { // Keep staff ID readonly
        input.disabled = !input.disabled;
      }
    });

    // Toggle button visibility
    editBtn.classList.toggle('hidden');
    saveBtn.classList.toggle('hidden');
    cancelBtn.classList.toggle('hidden');
  }

  // Cancel edit mode
  function cancelEdit() {
    staffData = JSON.parse(JSON.stringify(originalData)); // Restore original data
    populateForm();
    toggleEditMode();
    hideAlerts();
  }

  // Save staff data
  async function saveStaff() {
    if (!validateForm()) {
      return;
    }

    const formData = collectFormData();
    
    try {
      const response = await fetch(API_BASE + '/staff/' + staffData.staffID, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to update staff');
      }

      const updatedStaff = await response.json();
      staffData = updatedStaff;
      originalData = JSON.parse(JSON.stringify(staffData));
      
      showSuccess('Staff information updated successfully');
      toggleEditMode();
      
      // Clear password field
      document.getElementById('password').value = '';
    } catch (error) {
      console.error('Error saving staff data:', error);
      showError('Failed to save staff data: ' + error.message);
    }
  }

  // Collect form data
  function collectFormData() {
    const formData = {
      staffID: document.getElementById('staffID').value,
      firstName: document.getElementById('firstName').value,
      lastName: document.getElementById('lastName').value,
      gender: document.getElementById('gender').value,
      dateOfBirth: document.getElementById('dateOfBirth').value,
      nationality: document.getElementById('nationality').value,
      idType: document.getElementById('idType').value,
      idNumber: document.getElementById('idNumber').value,
      contactNumber: document.getElementById('contactNumber').value,
      email: document.getElementById('email').value,
      address: document.getElementById('address').value,
      position: document.getElementById('position').value,
      medicalLicenseNumber: document.getElementById('medicalLicenseNumber').value,
      employmentDate: document.getElementById('employmentDate').value
    };

    // Only include password if it's not empty
    const password = document.getElementById('password').value;
    if (password.trim() !== '') {
      formData.password = password;
    }

    return formData;
  }

  // Validate form
  function validateForm() {
    const requiredFields = [
      'firstName', 'lastName', 'gender', 'dateOfBirth', 
      'contactNumber', 'email', 'position', 'employmentDate'
    ];

    for (const fieldId of requiredFields) {
      const field = document.getElementById(fieldId);
      if (!field.value.trim()) {
        showError(field.previousElementSibling.textContent.replace(' *', '') + ' is required');
        field.focus();
        return false;
      }
    }

    // Validate email format
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showError('Please enter a valid email address');
      document.getElementById('email').focus();
      return false;
    }

    // Validate date of birth (must be in the past)
    const dateOfBirth = new Date(document.getElementById('dateOfBirth').value);
    const today = new Date();
    if (dateOfBirth >= today) {
      showError('Date of birth must be in the past');
      document.getElementById('dateOfBirth').focus();
      return false;
    }

    // Validate employment date (must be in the past or today)
    const employmentDate = new Date(document.getElementById('employmentDate').value);
    if (employmentDate > today) {
      showError('Employment date cannot be in the future');
      document.getElementById('employmentDate').focus();
      return false;
    }

    return true;
  }

  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
    document.getElementById('successAlert').classList.add('hidden');
  }

  // Show success message
  function showSuccess(message) {
    document.getElementById('successMessage').textContent = message;
    document.getElementById('successAlert').classList.remove('hidden');
    document.getElementById('errorAlert').classList.add('hidden');
  }

  // Hide all alerts
  function hideAlerts() {
    document.getElementById('errorAlert').classList.add('hidden');
    document.getElementById('successAlert').classList.add('hidden');
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
    document.getElementById('staffContent').classList.remove('hidden');
  }

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    loadStaffData();
  });
</script>
</body>
</html>
