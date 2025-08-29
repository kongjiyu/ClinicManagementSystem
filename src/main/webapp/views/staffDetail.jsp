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
              <input type="text" id="staffID" class="input input-bordered" readonly disabled>
              <div id="staffIDError" class="text-error text-sm mt-1 hidden"></div>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">First Name *</span>
              </label>
              <input type="text" id="firstName" class="input input-bordered" required disabled>
              <div id="firstNameError" class="text-error text-sm mt-1 hidden"></div>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Last Name *</span>
              </label>
              <input type="text" id="lastName" class="input input-bordered" required disabled>
              <div id="lastNameError" class="text-error text-sm mt-1 hidden"></div>
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
              <select id="nationality" class="select select-bordered" disabled>
                <option value="">-- Select Nationality --</option>
                <option value="Malaysian">Malaysian</option>
                <option value="Singaporean">Singaporean</option>
                <option value="Indonesian">Indonesian</option>
                <option value="Thai">Thai</option>
                <option value="Filipino">Filipino</option>
                <option value="Vietnamese">Vietnamese</option>
                <option value="Chinese">Chinese</option>
                <option value="Indian">Indian</option>
                <option value="Pakistani">Pakistani</option>
                <option value="Bangladeshi">Bangladeshi</option>
                <option value="Sri Lankan">Sri Lankan</option>
                <option value="Nepalese">Nepalese</option>
                <option value="Myanmar">Myanmar</option>
                <option value="Cambodian">Cambodian</option>
                <option value="Laotian">Laotian</option>
                <option value="Bruneian">Bruneian</option>
                <option value="American">American</option>
                <option value="Canadian">Canadian</option>
                <option value="British">British</option>
                <option value="Australian">Australian</option>
                <option value="New Zealander">New Zealander</option>
                <option value="German">German</option>
                <option value="French">French</option>
                <option value="Italian">Italian</option>
                <option value="Spanish">Spanish</option>
                <option value="Portuguese">Portuguese</option>
                <option value="Dutch">Dutch</option>
                <option value="Belgian">Belgian</option>
                <option value="Swiss">Swiss</option>
                <option value="Austrian">Austrian</option>
                <option value="Swedish">Swedish</option>
                <option value="Norwegian">Norwegian</option>
                <option value="Danish">Danish</option>
                <option value="Finnish">Finnish</option>
                <option value="Polish">Polish</option>
                <option value="Czech">Czech</option>
                <option value="Slovak">Slovak</option>
                <option value="Hungarian">Hungarian</option>
                <option value="Romanian">Romanian</option>
                <option value="Bulgarian">Bulgarian</option>
                <option value="Croatian">Croatian</option>
                <option value="Serbian">Serbian</option>
                <option value="Slovenian">Slovenian</option>
                <option value="Bosnian">Bosnian</option>
                <option value="Montenegrin">Montenegrin</option>
                <option value="Macedonian">Macedonian</option>
                <option value="Albanian">Albanian</option>
                <option value="Greek">Greek</option>
                <option value="Turkish">Turkish</option>
                <option value="Russian">Russian</option>
                <option value="Ukrainian">Ukrainian</option>
                <option value="Belarusian">Belarusian</option>
                <option value="Moldovan">Moldovan</option>
                <option value="Georgian">Georgian</option>
                <option value="Armenian">Armenian</option>
                <option value="Azerbaijani">Azerbaijani</option>
                <option value="Kazakh">Kazakh</option>
                <option value="Uzbek">Uzbek</option>
                <option value="Kyrgyz">Kyrgyz</option>
                <option value="Tajik">Tajik</option>
                <option value="Turkmen">Turkmen</option>
                <option value="Afghan">Afghan</option>
                <option value="Iranian">Iranian</option>
                <option value="Iraqi">Iraqi</option>
                <option value="Syrian">Syrian</option>
                <option value="Lebanese">Lebanese</option>
                <option value="Jordanian">Jordanian</option>
                <option value="Palestinian">Palestinian</option>
                <option value="Israeli">Israeli</option>
                <option value="Saudi Arabian">Saudi Arabian</option>
                <option value="Kuwaiti">Kuwaiti</option>
                <option value="Bahraini">Bahraini</option>
                <option value="Qatari">Qatari</option>
                <option value="UAE">UAE</option>
                <option value="Omani">Omani</option>
                <option value="Yemeni">Yemeni</option>
                <option value="Egyptian">Egyptian</option>
                <option value="Sudanese">Sudanese</option>
                <option value="Libyan">Libyan</option>
                <option value="Tunisian">Tunisian</option>
                <option value="Algerian">Algerian</option>
                <option value="Moroccan">Moroccan</option>
                <option value="Mauritanian">Mauritanian</option>
                <option value="Senegalese">Senegalese</option>
                <option value="Gambian">Gambian</option>
                <option value="Guinea-Bissauan">Guinea-Bissauan</option>
                <option value="Guinean">Guinean</option>
                <option value="Sierra Leonean">Sierra Leonean</option>
                <option value="Liberian">Liberian</option>
                <option value="Ivorian">Ivorian</option>
                <option value="Ghanaian">Ghanaian</option>
                <option value="Togolese">Togolese</option>
                <option value="Beninese">Beninese</option>
                <option value="Nigerian">Nigerian</option>
                <option value="Nigerien">Nigerien</option>
                <option value="Chadian">Chadian</option>
                <option value="Cameroonian">Cameroonian</option>
                <option value="Central African">Central African</option>
                <option value="Equatorial Guinean">Equatorial Guinean</option>
                <option value="Gabonese">Gabonese</option>
                <option value="Congolese">Congolese</option>
                <option value="DR Congolese">DR Congolese</option>
                <option value="Angolan">Angolan</option>
                <option value="Zambian">Zambian</option>
                <option value="Malawian">Malawian</option>
                <option value="Mozambican">Mozambican</option>
                <option value="Zimbabwean">Zimbabwean</option>
                <option value="Botswanan">Botswanan</option>
                <option value="Namibian">Namibian</option>
                <option value="South African">South African</option>
                <option value="Lesothan">Lesothan</option>
                <option value="Eswatini">Eswatini</option>
                <option value="Madagascan">Madagascan</option>
                <option value="Comorian">Comorian</option>
                <option value="Mauritian">Mauritian</option>
                <option value="Seychellois">Seychellois</option>
                <option value="Kenyan">Kenyan</option>
                <option value="Ugandan">Ugandan</option>
                <option value="Tanzanian">Tanzanian</option>
                <option value="Rwandan">Rwandan</option>
                <option value="Burundian">Burundian</option>
                <option value="Ethiopian">Ethiopian</option>
                <option value="Eritrean">Eritrean</option>
                <option value="Djiboutian">Djiboutian</option>
                <option value="Somali">Somali</option>
                <option value="South Sudanese">South Sudanese</option>
                <option value="Brazilian">Brazilian</option>
                <option value="Argentine">Argentine</option>
                <option value="Chilean">Chilean</option>
                <option value="Peruvian">Peruvian</option>
                <option value="Colombian">Colombian</option>
                <option value="Venezuelan">Venezuelan</option>
                <option value="Ecuadorian">Ecuadorian</option>
                <option value="Bolivian">Bolivian</option>
                <option value="Paraguayan">Paraguayan</option>
                <option value="Uruguayan">Uruguayan</option>
                <option value="Guyanese">Guyanese</option>
                <option value="Surinamese">Surinamese</option>
                <option value="Mexican">Mexican</option>
                <option value="Guatemalan">Guatemalan</option>
                <option value="Belizean">Belizean</option>
                <option value="Honduran">Honduran</option>
                <option value="Salvadoran">Salvadoran</option>
                <option value="Nicaraguan">Nicaraguan</option>
                <option value="Costa Rican">Costa Rican</option>
                <option value="Panamanian">Panamanian</option>
                <option value="Cuban">Cuban</option>
                <option value="Jamaican">Jamaican</option>
                <option value="Haitian">Haitian</option>
                <option value="Dominican">Dominican</option>
                <option value="Puerto Rican">Puerto Rican</option>
                <option value="Bahamian">Bahamian</option>
                <option value="Barbadian">Barbadian</option>
                <option value="Trinidadian">Trinidadian</option>
                <option value="Grenadian">Grenadian</option>
                <option value="Saint Lucian">Saint Lucian</option>
                <option value="Vincentian">Vincentian</option>
                <option value="Antiguan">Antiguan</option>
                <option value="Kittitian">Kittitian</option>
                <option value="Other">Other</option>
              </select>
              <div id="nationalityError" class="text-error text-sm mt-1 hidden"></div>
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
              <div id="idNumberError" class="text-error text-sm mt-1 hidden"></div>
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
              <div id="contactNumberError" class="text-error text-sm mt-1 hidden"></div>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Email *</span>
              </label>
              <input type="email" id="email" class="input input-bordered" required disabled>
              <div id="emailError" class="text-error text-sm mt-1 hidden"></div>
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
                <option value="Staff">Staff</option>
              </select>
              <div id="positionError" class="text-error text-sm mt-1 hidden"></div>
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
              <div id="passwordError" class="text-error text-sm mt-1 hidden"></div>
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
    
    // Set initial state for medical license field based on position
    handlePositionChange();
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
      if (input.id !== 'staffID') { // Keep staff ID disabled
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
    } else {
      // Explicitly set password to null to indicate no change
      formData.password = null;
    }

    return formData;
  }

  // Validate form
  function validateForm() {
    clearAllFieldErrors();
    let isValid = true;

    // Validate staff ID format
    const staffID = document.getElementById('staffID').value.trim();
    if (staffID && !/^ST\d{4}$/.test(staffID)) {
      showFieldError('staffID', 'Staff ID must be in format ST#### (e.g., ST0001)');
      isValid = false;
    }

    // Validate required fields
    const requiredFields = [
      'firstName', 'lastName', 'gender', 'dateOfBirth', 
      'contactNumber', 'email', 'position', 'employmentDate'
    ];

    for (const fieldId of requiredFields) {
      const field = document.getElementById(fieldId);
      if (!field.value.trim()) {
        showFieldError(fieldId, field.previousElementSibling.textContent.replace(' *', '') + ' is required');
        field.focus();
        isValid = false;
      }
    }

    // Validate first name (letters and spaces only, 2-50 characters)
    const firstName = document.getElementById('firstName').value.trim();
    if (firstName && !/^[a-zA-Z\s]{2,50}$/.test(firstName)) {
      showFieldError('firstName', 'First name must contain only letters and spaces (2-50 characters)');
      isValid = false;
    }

    // Validate last name (letters and spaces only, 2-50 characters)
    const lastName = document.getElementById('lastName').value.trim();
    if (lastName && !/^[a-zA-Z\s]{2,50}$/.test(lastName)) {
      showFieldError('lastName', 'Last name must contain only letters and spaces (2-50 characters)');
      isValid = false;
    }

    // Validate nationality (must be selected)
    const nationality = document.getElementById('nationality').value;
    if (!nationality) {
      showFieldError('nationality', 'Nationality is required');
      isValid = false;
    }

    // Validate ID number based on ID type
    const idType = document.getElementById('idType').value;
    const idNumber = document.getElementById('idNumber').value.trim();
    if (idNumber && !validateIdNumber(idType, idNumber)) {
      showFieldError('idNumber', getInvalidIdMessage(idType));
      isValid = false;
    }

    // Validate contact number (Malaysian phone number format)
    const contactNumber = document.getElementById('contactNumber').value.trim();
    if (contactNumber && !/^(\+?6?01)[0-46-9]-*[0-9]{7,8}$/.test(contactNumber.replace(/\s/g, ''))) {
      showFieldError('contactNumber', 'Please enter a valid Malaysian phone number (e.g., 012-3456789)');
      isValid = false;
    }

    // Validate email format
    const email = document.getElementById('email').value.trim();
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showFieldError('email', 'Please enter a valid email address');
      isValid = false;
    }

    // Validate date of birth (must be in the past)
    const dateOfBirth = new Date(document.getElementById('dateOfBirth').value);
    const today = new Date();
    if (dateOfBirth >= today) {
      showFieldError('dateOfBirth', 'Date of birth must be in the past');
      isValid = false;
    }

    // Validate employment date (must be in the past or today)
    const employmentDate = new Date(document.getElementById('employmentDate').value);
    if (employmentDate > today) {
      showFieldError('employmentDate', 'Employment date cannot be in the future');
      isValid = false;
    }

    // Validate position (must be selected)
    const position = document.getElementById('position').value;
    if (!position) {
      showFieldError('position', 'Position is required');
      isValid = false;
    }

    // Validate password if provided (minimum 6 characters)
    const password = document.getElementById('password').value.trim();
    if (password !== '' && password.length < 6) {
      showFieldError('password', 'Password must be at least 6 characters long');
      isValid = false;
    }

    return isValid;
  }

  // Validate ID number based on ID type
  function validateIdNumber(idType, idNumber) {
    switch (idType) {
      case 'IC':
        // Malaysian IC format: YYMMDD-PB-XXXX (12 digits)
        return /^\d{6}-\d{2}-\d{4}$/.test(idNumber);
      case 'Passport':
        // Passport format: A12345678 (letter + 8 digits)
        return /^[A-Z]\d{8}$/.test(idNumber);
      case 'Driver License':
        // Driver license format: A12345678 (letter + 8 digits)
        return /^[A-Z]\d{8}$/.test(idNumber);
      case 'Other':
        // Other ID: at least 5 characters
        return idNumber.length >= 5;
      default:
        return true; // No validation for empty ID type
    }
  }

  // Get error message for invalid ID number
  function getInvalidIdMessage(idType) {
    switch (idType) {
      case 'IC':
        return 'Please enter a valid Malaysian IC (format: YYMMDD-PB-XXXX)';
      case 'Passport':
        return 'Please enter a valid passport number (format: A12345678)';
      case 'Driver License':
        return 'Please enter a valid driver license number (format: A12345678)';
      case 'Other':
        return 'ID number must be at least 5 characters long';
      default:
        return 'Please enter a valid ID number';
    }
  }

  // Show field-specific error
  function showFieldError(fieldId, message) {
    const errorElement = document.getElementById(fieldId + 'Error');
    const inputElement = document.getElementById(fieldId);
    
    if (errorElement) {
      errorElement.textContent = message;
      errorElement.classList.remove('hidden');
    }
    
    if (inputElement) {
      inputElement.classList.add('input-error');
    }
  }

  // Hide field-specific error
  function hideFieldError(fieldId) {
    const errorElement = document.getElementById(fieldId + 'Error');
    const inputElement = document.getElementById(fieldId);
    
    if (errorElement) {
      errorElement.classList.add('hidden');
    }
    
    if (inputElement) {
      inputElement.classList.remove('input-error');
    }
  }

  // Clear all field errors
  function clearAllFieldErrors() {
    const errorElements = document.querySelectorAll('[id$="Error"]');
    const inputElements = document.querySelectorAll('.input-error');
    
    errorElements.forEach(element => {
      element.classList.add('hidden');
    });
    
    inputElements.forEach(element => {
      element.classList.remove('input-error');
    });
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
    addValidationListeners();
  });

  // Add validation listeners to form fields
  function addValidationListeners() {
    // Real-time validation for text fields
    const textFields = ['firstName', 'lastName', 'nationality', 'idNumber', 'contactNumber', 'email', 'password'];
    textFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        field.addEventListener('blur', () => validateField(fieldId));
        field.addEventListener('input', () => hideFieldError(fieldId));
      }
    });

    // Real-time validation for select fields
    const selectFields = ['position'];
    selectFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        field.addEventListener('change', () => {
          validateField(fieldId);
          handlePositionChange();
        });
      }
    });

    // Real-time validation for ID number when ID type changes
    const idTypeField = document.getElementById('idType');
    if (idTypeField) {
      idTypeField.addEventListener('change', () => validateField('idNumber'));
    }

    // Real-time validation for date fields
    const dateFields = ['dateOfBirth', 'employmentDate'];
    dateFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        field.addEventListener('change', () => validateField(fieldId));
      }
    });
  }

  // Handle position change to enable/disable medical license number
  function handlePositionChange() {
    const position = document.getElementById('position').value;
    const medicalLicenseField = document.getElementById('medicalLicenseNumber');
    const isEditMode = !document.getElementById('firstName').disabled;
    
    if (position === 'Staff') {
      // Disable medical license number field for staff
      medicalLicenseField.disabled = true;
      medicalLicenseField.value = ''; // Clear the value
      medicalLicenseField.placeholder = 'Not applicable for staff';
    } else if (position === 'Doctor') {
      // Enable medical license number field for doctors only in edit mode
      medicalLicenseField.disabled = !isEditMode;
      medicalLicenseField.placeholder = isEditMode ? 'Enter medical license number' : '';
    }
  }

  // Validate individual field
  function validateField(fieldId) {
    const field = document.getElementById(fieldId);
    if (!field || field.disabled) return;

    const value = field.value.trim();
    
    // Clear previous error
    hideFieldError(fieldId);

    // Validate based on field type
    switch (fieldId) {
      case 'firstName':
      case 'lastName':
        if (value && !/^[a-zA-Z\s]{2,50}$/.test(value)) {
          var fieldName = fieldId === 'firstName' ? 'First name' : 'Last name';
          showFieldError(fieldId, fieldName + ' must contain only letters and spaces (2-50 characters)');
        }
        break;
      
      case 'nationality':
        if (!value) {
          showFieldError(fieldId, 'Nationality is required');
        }
        break;
      
      case 'idNumber':
        const idType = document.getElementById('idType').value;
        if (value && !validateIdNumber(idType, value)) {
          showFieldError(fieldId, getInvalidIdMessage(idType));
        }
        break;
      
      case 'contactNumber':
        if (value && !/^(\+?6?01)[0-46-9]-*[0-9]{7,8}$/.test(value.replace(/\s/g, ''))) {
          showFieldError(fieldId, 'Please enter a valid Malaysian phone number (e.g., 012-3456789)');
        }
        break;
      
      case 'email':
        if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
          showFieldError(fieldId, 'Please enter a valid email address');
        }
        break;
      
      case 'dateOfBirth':
        if (value) {
          const dateOfBirth = new Date(value);
          const today = new Date();
          if (dateOfBirth >= today) {
            showFieldError(fieldId, 'Date of birth must be in the past');
          }
        }
        break;
      
      case 'employmentDate':
        if (value) {
          const employmentDate = new Date(value);
          const today = new Date();
          if (employmentDate > today) {
            showFieldError(fieldId, 'Employment date cannot be in the future');
          }
        }
        break;
      
      case 'position':
        if (!value) {
          showFieldError(fieldId, 'Position is required');
        }
        break;
      
      case 'password':
        if (value && value.length < 6) {
          showFieldError(fieldId, 'Password must be at least 6 characters long');
        }
        break;
    }
  }
</script>
</body>
</html>
