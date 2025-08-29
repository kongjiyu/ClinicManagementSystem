<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
  Author: Yap Ern Tong
  Patient Module
-->
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
          <label class="label">Contact Number <span class="text-error">*</span></label>
          <input type="text" id="contactNumber" class="input input-bordered w-full" required />
          <div id="contactNumberError" class="text-error text-sm mt-1 hidden"></div>
        </div>
        <div>
          <label class="label">Email <span class="text-error">*</span></label>
          <input type="email" id="email" class="input input-bordered w-full" required />
          <div id="emailError" class="text-error text-sm mt-1 hidden"></div>
        </div>
        <div class="md:col-span-2">
          <label class="label">Address <span class="text-error">*</span></label>
          <input type="text" id="address" class="input input-bordered w-full" required />
          <div id="addressError" class="text-error text-sm mt-1 hidden"></div>
        </div>
        <div>
          <label class="label">Emergency Contact Name <span class="text-error">*</span></label>
          <input type="text" id="emergencyContactName" class="input input-bordered w-full" required />
          <div id="emergencyContactNameError" class="text-error text-sm mt-1 hidden"></div>
        </div>
        <div>
          <label class="label">Emergency Contact Number <span class="text-error">*</span></label>
          <input type="text" id="emergencyContactNumber" class="input input-bordered w-full" required />
          <div id="emergencyContactNumberError" class="text-error text-sm mt-1 hidden"></div>
        </div>
        <div class="md:col-span-2">
          <label class="label">Allergies</label>
          <textarea id="allergies" class="textarea textarea-bordered w-full" placeholder="List any allergies or leave blank if none"></textarea>
          <div id="allergiesError" class="text-error text-sm mt-1 hidden"></div>
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
    
    // Add validation listeners after form is populated
    addValidationListeners();
  }

  // Handle form submission
  document.getElementById('profileForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Validate form before submission
    if (!validateForm()) {
      showError('Please fix the validation errors before submitting');
      return;
    }
    
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
        contactNumber: document.getElementById('contactNumber').value.trim(),
        email: document.getElementById('email').value.trim(),
        address: document.getElementById('address').value.trim(),
        emergencyContactName: document.getElementById('emergencyContactName').value.trim(),
        emergencyContactNumber: document.getElementById('emergencyContactNumber').value.trim(),
        allergies: document.getElementById('allergies').value.trim()
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
        clearAllFieldErrors(); // Clear any remaining errors
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
      clearAllFieldErrors(); // Clear any validation errors
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

  // Validation functions
  function validateContactNumber(value) {
    const phoneRegex = /^(\+?6?01)[0-46-9]-*[0-9]{7,8}$/;
    if (!value.trim()) {
      return 'Contact number is required';
    }
    if (!phoneRegex.test(value.replace(/\s/g, ''))) {
      return 'Please enter a valid Malaysian phone number (e.g., 012-3456789 or +6012-3456789)';
    }
    return null;
  }

  function validateEmail(value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!value.trim()) {
      return 'Email is required';
    }
    if (!emailRegex.test(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  function validateAddress(value) {
    if (!value.trim()) {
      return 'Address is required';
    }
    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters long';
    }
    if (value.trim().length > 200) {
      return 'Address must not exceed 200 characters';
    }
    return null;
  }

  function validateEmergencyContactName(value) {
    const nameRegex = /^[a-zA-Z\s]+$/;
    if (!value.trim()) {
      return 'Emergency contact name is required';
    }
    if (!nameRegex.test(value.trim())) {
      return 'Emergency contact name can only contain letters and spaces';
    }
    if (value.trim().length < 2) {
      return 'Emergency contact name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Emergency contact name must not exceed 50 characters';
    }
    return null;
  }

  function validateEmergencyContactNumber(value) {
    const phoneRegex = /^(\+?6?01)[0-46-9]-*[0-9]{7,8}$/;
    if (!value.trim()) {
      return 'Emergency contact number is required';
    }
    if (!phoneRegex.test(value.replace(/\s/g, ''))) {
      return 'Please enter a valid Malaysian phone number (e.g., 012-3456789 or +6012-3456789)';
    }
    return null;
  }

  function validateAllergies(value) {
    if (value.trim() && value.trim().length > 500) {
      return 'Allergies description must not exceed 500 characters';
    }
    return null;
  }

  // Show field error
  function showFieldError(fieldId, message) {
    const errorElement = document.getElementById(fieldId + 'Error');
    const inputElement = document.getElementById(fieldId);
    
    if (errorElement && inputElement) {
      errorElement.textContent = message;
      errorElement.classList.remove('hidden');
      inputElement.classList.add('input-error');
    }
  }

  // Hide field error
  function hideFieldError(fieldId) {
    const errorElement = document.getElementById(fieldId + 'Error');
    const inputElement = document.getElementById(fieldId);
    
    if (errorElement && inputElement) {
      errorElement.classList.add('hidden');
      inputElement.classList.remove('input-error');
    }
  }

  // Clear all field errors
  function clearAllFieldErrors() {
    const fields = ['contactNumber', 'email', 'address', 'emergencyContactName', 'emergencyContactNumber', 'allergies'];
    fields.forEach(field => hideFieldError(field));
  }

  // Validate all fields
  function validateForm() {
    clearAllFieldErrors();
    
    const contactNumber = document.getElementById('contactNumber').value;
    const email = document.getElementById('email').value;
    const address = document.getElementById('address').value;
    const emergencyContactName = document.getElementById('emergencyContactName').value;
    const emergencyContactNumber = document.getElementById('emergencyContactNumber').value;
    const allergies = document.getElementById('allergies').value;

    let isValid = true;

    // Validate each field
    const contactNumberError = validateContactNumber(contactNumber);
    if (contactNumberError) {
      showFieldError('contactNumber', contactNumberError);
      isValid = false;
    }

    const emailError = validateEmail(email);
    if (emailError) {
      showFieldError('email', emailError);
      isValid = false;
    }

    const addressError = validateAddress(address);
    if (addressError) {
      showFieldError('address', addressError);
      isValid = false;
    }

    const emergencyContactNameError = validateEmergencyContactName(emergencyContactName);
    if (emergencyContactNameError) {
      showFieldError('emergencyContactName', emergencyContactNameError);
      isValid = false;
    }

    const emergencyContactNumberError = validateEmergencyContactNumber(emergencyContactNumber);
    if (emergencyContactNumberError) {
      showFieldError('emergencyContactNumber', emergencyContactNumberError);
      isValid = false;
    }

    const allergiesError = validateAllergies(allergies);
    if (allergiesError) {
      showFieldError('allergies', allergiesError);
      isValid = false;
    }

    return isValid;
  }

  // Add real-time validation event listeners
  function addValidationListeners() {
    const fields = [
      { id: 'contactNumber', validator: validateContactNumber },
      { id: 'email', validator: validateEmail },
      { id: 'address', validator: validateAddress },
      { id: 'emergencyContactName', validator: validateEmergencyContactName },
      { id: 'emergencyContactNumber', validator: validateEmergencyContactNumber },
      { id: 'allergies', validator: validateAllergies }
    ];

    fields.forEach(field => {
      const element = document.getElementById(field.id);
      if (element) {
        element.addEventListener('blur', function() {
          const error = field.validator(this.value);
          if (error) {
            showFieldError(field.id, error);
          } else {
            hideFieldError(field.id);
          }
        });

        element.addEventListener('input', function() {
          // Clear error when user starts typing
          hideFieldError(field.id);
        });
      }
    });
  }

  // Initialize profile
  document.addEventListener('DOMContentLoaded', function() {
    loadPatientData();
  });
</script>
</body>
</html>
