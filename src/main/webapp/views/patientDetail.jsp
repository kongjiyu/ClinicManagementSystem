<%@ page import="models.Patient" %><%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 24/07/2025
  Time: 11:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Patient Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <h1 class="text-3xl font-bold">Patient Detail</h1>

  <!-- Success Alert -->
  <div id="successAlert" class="alert alert-success hidden">
    <span class="icon-[tabler--check] size-5"></span>
    <span id="successMessage">Patient information updated successfully!</span>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8 hidden">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Personal Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Personal Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">First Name *</label>
        <input type="text" class="input input-bordered w-full" id="firstName" required minlength="2" maxlength="50" />
        <div class="text-error text-sm hidden" id="firstNameError"></div>
      </div>
      <div>
        <label class="label">Last Name *</label>
        <input type="text" class="input input-bordered w-full" id="lastName" required minlength="2" maxlength="50" />
        <div class="text-error text-sm hidden" id="lastNameError"></div>
      </div>
      <div>
        <label class="label">Gender *</label>
        <select class="select select-bordered w-full" id="gender" required>
          <option value="">-- Select Gender --</option>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>
        <div class="text-error text-sm hidden" id="genderError"></div>
      </div>
      <div>
        <label class="label">Date of Birth *</label>
        <input type="date" class="input input-bordered w-full" id="dateOfBirth" required max="<%= java.time.LocalDate.now() %>" />
        <div class="text-error text-sm hidden" id="dateOfBirthError"></div>
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" class="input input-bordered w-full" id="age" min="0" max="150" readonly />
        <div class="text-xs text-base-content/70">Calculated automatically from date of birth</div>
      </div>
      <div>
        <label class="label">Nationality</label>
        <select class="select select-bordered w-full" id="nationality">
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
          <option value="Dominican">Dominican</option>
          <option value="Other">Other</option>
        </select>
      </div>
    </div>
  </section>

  <!-- Identification Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Identification</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">ID Type</label>
        <select class="select select-bordered w-full" id="idType">
          <option value="">-- Select ID Type --</option>
          <option value="IC">IC</option>
          <option value="Passport">Passport</option>
        </select>
      </div>
      <div>
        <label class="label">ID Number</label>
        <input type="text" class="input input-bordered w-full" id="idNumber" placeholder="Enter ID number based on selected type" />
        <div class="text-error text-sm hidden" id="idNumberError"></div>
      </div>
      <div>
        <label class="label">Student ID</label>
        <input type="text" class="input input-bordered w-full" id="studentId" />
      </div>
    </div>
  </section>

  <!-- Contact Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Contact Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Phone Number *</label>
        <input type="tel" class="input input-bordered w-full" id="contactNumber" required pattern="[0-9+\-\s()]+" minlength="8" maxlength="20" />
        <div class="text-error text-sm hidden" id="contactNumberError"></div>
      </div>
      <div>
        <label class="label">Email *</label>
        <input type="email" class="input input-bordered w-full" id="email" required />
        <div class="text-error text-sm hidden" id="emailError"></div>
      </div>
      <div class="md:col-span-2">
        <label class="label">Address *</label>
        <input type="text" class="input input-bordered w-full" id="address" required minlength="5" maxlength="200" />
        <div class="text-error text-sm hidden" id="addressError"></div>
      </div>
    </div>
  </section>

  <!-- Emergency Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Emergency Contact</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Emergency Contact Name *</label>
        <input type="text" class="input input-bordered w-full" id="emergencyContactName" required minlength="2" maxlength="100" />
        <div class="text-error text-sm hidden" id="emergencyContactNameError"></div>
      </div>
      <div>
        <label class="label">Emergency Contact Number *</label>
        <input type="tel" class="input input-bordered w-full" id="emergencyContactNumber" required pattern="[0-9+\-\s()]+" minlength="8" maxlength="20" />
        <div class="text-error text-sm hidden" id="emergencyContactNumberError"></div>
      </div>
    </div>
  </section>

  <!-- Medical Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Medical Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Allergies</label>
        <input type="text" class="input input-bordered w-full" id="allergies" />
      </div>
      <div>
        <label class="label">Blood Type</label>
        <select class="select select-bordered w-full" id="bloodType">
          <option value="">-- Select --</option>
          <option value="O+">O+</option>
          <option value="O-">O-</option>
          <option value="A+">A+</option>
          <option value="A-">A-</option>
          <option value="B+">B+</option>
          <option value="B-">B-</option>
          <option value="AB+">AB+</option>
          <option value="AB-">AB-</option>
        </select>
      </div>
    </div>
  </section>

  <!-- Submit -->
  <div class="flex justify-end gap-4">
    <button type="button" class="btn btn-outline" onclick="resetForm()">Reset</button>
    <button type="button" class="btn btn-primary" onclick="savePatient()" id="saveButton">
      <span class="icon-[tabler--device-floppy] size-4 mr-2"></span>
      Save Changes
    </button>
  </div>
</main>
<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  const patientId = new URLSearchParams(window.location.search).get('id');
  let originalPatientData = null;

  // Load patient data
  async function loadPatientData() {
    if (!patientId) {
      showError("No patient ID specified in URL.");
      return;
    }

    try {
      showLoading();
      const response = await fetch(API_BASE + '/patients/' + patientId);
      if (!response.ok) {
        throw new Error("Patient not found");
      }
      
      const patient = await response.json();
      originalPatientData = { ...patient }; // Store original data for reset
      populateForm(patient);
      hideLoading();
    } catch (error) {
      console.error('Error loading patient:', error);
      showError("Failed to load patient data: " + error.message);
      hideLoading();
    }
  }

  // Populate form with patient data
  function populateForm(patient) {
    document.getElementById("firstName").value = patient.firstName || "";
    document.getElementById("lastName").value = patient.lastName || "";
    document.getElementById("gender").value = patient.gender || "";
    document.getElementById("dateOfBirth").value = patient.dateOfBirth || "";
    document.getElementById("age").value = patient.age || "";
    document.getElementById("nationality").value = patient.nationality || "";
    document.getElementById("idType").value = patient.idType || "";
    document.getElementById("idNumber").value = patient.idNumber || "";
    document.getElementById("studentId").value = patient.studentId || "";
    document.getElementById("contactNumber").value = patient.contactNumber || "";
    document.getElementById("email").value = patient.email || "";
    document.getElementById("address").value = patient.address || "";
    document.getElementById("emergencyContactName").value = patient.emergencyContactName || "";
    document.getElementById("emergencyContactNumber").value = patient.emergencyContactNumber || "";
    document.getElementById("allergies").value = patient.allergies || "";
    document.getElementById("bloodType").value = patient.bloodType || "";
  }

  // Calculate age from date of birth
  function calculateAge(dateOfBirth) {
    if (!dateOfBirth) return 0;
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    return age;
  }

  // Validate form
  function validateForm() {
    let isValid = true;
    clearAllErrors();

    // Validate First Name
    const firstName = document.getElementById("firstName").value.trim();
    if (!firstName) {
      showFieldError("firstName", "First name is required");
      isValid = false;
    } else if (firstName.length < 2) {
      showFieldError("firstName", "First name must be at least 2 characters");
      isValid = false;
    } else if (!/^[a-zA-Z\s]+$/.test(firstName)) {
      showFieldError("firstName", "First name can only contain letters and spaces");
      isValid = false;
    }

    // Validate Last Name
    const lastName = document.getElementById("lastName").value.trim();
    if (!lastName) {
      showFieldError("lastName", "Last name is required");
      isValid = false;
    } else if (lastName.length < 2) {
      showFieldError("lastName", "Last name must be at least 2 characters");
      isValid = false;
    } else if (!/^[a-zA-Z\s]+$/.test(lastName)) {
      showFieldError("lastName", "Last name can only contain letters and spaces");
      isValid = false;
    }

    // Validate Gender
    const gender = document.getElementById("gender").value;
    if (!gender) {
      showFieldError("gender", "Please select a gender");
      isValid = false;
    }

    // Validate Date of Birth
    const dateOfBirth = document.getElementById("dateOfBirth").value;
    if (!dateOfBirth) {
      showFieldError("dateOfBirth", "Date of birth is required");
      isValid = false;
    } else {
      const birthDate = new Date(dateOfBirth);
      const today = new Date();
      if (birthDate > today) {
        showFieldError("dateOfBirth", "Date of birth cannot be in the future");
        isValid = false;
      } else if (birthDate < new Date('1900-01-01')) {
        showFieldError("dateOfBirth", "Date of birth seems invalid");
        isValid = false;
      }
    }

    // Validate ID Number based on ID Type
    const idType = document.getElementById("idType").value;
    const idNumber = document.getElementById("idNumber").value.trim();
    
    if (idType && idNumber) {
      if (idType === "IC") {
        // Malaysian IC format: YYMMDD-PB-XXXX (12 digits with hyphens)
        if (!/^\d{6}-\d{2}-\d{4}$/.test(idNumber)) {
          showFieldError("idNumber", "Malaysian IC must be in format: YYMMDD-PB-XXXX (e.g., 900101-01-1234)");
          isValid = false;
        } else {
          // Validate date part (YYMMDD)
          const datePart = idNumber.substring(0, 6);
          const year = parseInt(datePart.substring(0, 2));
          const month = parseInt(datePart.substring(2, 4));
          const day = parseInt(datePart.substring(4, 6));
          
          if (month < 1 || month > 12 || day < 1 || day > 31) {
            showFieldError("idNumber", "Invalid date in Malaysian IC number");
            isValid = false;
          }
        }
      } else if (idType === "Passport") {
        // Passport format: 1-2 letters followed by 6-9 digits
        if (!/^[A-Z]{1,2}\d{6,9}$/.test(idNumber)) {
          showFieldError("idNumber", "Passport must be in format: 1-2 letters followed by 6-9 digits (e.g., A1234567 or AB123456789)");
          isValid = false;
        }
      }
    }

    // Validate Contact Number
    const contactNumber = document.getElementById("contactNumber").value.trim();
    if (!contactNumber) {
      showFieldError("contactNumber", "Phone number is required");
      isValid = false;
    } else if (!/^[0-9+\-\s()]+$/.test(contactNumber)) {
      showFieldError("contactNumber", "Phone number can only contain numbers, spaces, hyphens, and parentheses");
      isValid = false;
    } else if (contactNumber.length < 8) {
      showFieldError("contactNumber", "Phone number must be at least 8 digits");
      isValid = false;
    }

    // Validate Email
    const email = document.getElementById("email").value.trim();
    if (!email) {
      showFieldError("email", "Email is required");
      isValid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showFieldError("email", "Please enter a valid email address");
      isValid = false;
    }

    // Validate Address
    const address = document.getElementById("address").value.trim();
    if (!address) {
      showFieldError("address", "Address is required");
      isValid = false;
    } else if (address.length < 5) {
      showFieldError("address", "Address must be at least 5 characters");
      isValid = false;
    }

    // Validate Emergency Contact Name
    const emergencyContactName = document.getElementById("emergencyContactName").value.trim();
    if (!emergencyContactName) {
      showFieldError("emergencyContactName", "Emergency contact name is required");
      isValid = false;
    } else if (emergencyContactName.length < 2) {
      showFieldError("emergencyContactName", "Emergency contact name must be at least 2 characters");
      isValid = false;
    }

    // Validate Emergency Contact Number
    const emergencyContactNumber = document.getElementById("emergencyContactNumber").value.trim();
    if (!emergencyContactNumber) {
      showFieldError("emergencyContactNumber", "Emergency contact number is required");
      isValid = false;
    } else if (!/^[0-9+\-\s()]+$/.test(emergencyContactNumber)) {
      showFieldError("emergencyContactNumber", "Emergency contact number can only contain numbers, spaces, hyphens, and parentheses");
      isValid = false;
    } else if (emergencyContactNumber.length < 8) {
      showFieldError("emergencyContactNumber", "Emergency contact number must be at least 8 digits");
      isValid = false;
    }

    return isValid;
  }

  // Show field error
  function showFieldError(fieldId, message) {
    const errorElement = document.getElementById(fieldId + "Error");
    if (errorElement) {
      errorElement.textContent = message;
      errorElement.classList.remove("hidden");
    }
    const inputElement = document.getElementById(fieldId);
    if (inputElement) {
      inputElement.classList.add("input-error");
    }
  }

  // Clear all errors
  function clearAllErrors() {
    const errorElements = document.querySelectorAll('[id$="Error"]');
    errorElements.forEach(element => {
      element.classList.add("hidden");
      element.textContent = "";
    });
    
    const inputElements = document.querySelectorAll('.input-error');
    inputElements.forEach(element => {
      element.classList.remove("input-error");
    });
  }

  // Save patient data
  async function savePatient() {
    if (!validateForm()) {
      showError("Please fix the validation errors before saving.");
      return;
    }

    try {
      showLoading();
      const saveButton = document.getElementById("saveButton");
      const originalText = saveButton.innerHTML;
      saveButton.innerHTML = '<span class="loading loading-spinner loading-sm"></span> Saving...';
      saveButton.disabled = true;

      const patientData = {
        patientID: patientId,
        firstName: document.getElementById("firstName").value.trim(),
        lastName: document.getElementById("lastName").value.trim(),
        gender: document.getElementById("gender").value,
        dateOfBirth: document.getElementById("dateOfBirth").value,
        age: calculateAge(document.getElementById("dateOfBirth").value),
        nationality: document.getElementById("nationality").value.trim(),
        idType: document.getElementById("idType").value.trim(),
        idNumber: document.getElementById("idNumber").value.trim(),
        studentId: document.getElementById("studentId").value.trim(),
        contactNumber: document.getElementById("contactNumber").value.trim(),
        email: document.getElementById("email").value.trim(),
        address: document.getElementById("address").value.trim(),
        emergencyContactName: document.getElementById("emergencyContactName").value.trim(),
        emergencyContactNumber: document.getElementById("emergencyContactNumber").value.trim(),
        allergies: document.getElementById("allergies").value.trim(),
        bloodType: document.getElementById("bloodType").value,
        password: originalPatientData ? originalPatientData.password : ""
      };

      const response = await fetch(API_BASE + '/patients/' + patientId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(patientData)
      });

      if (response.ok) {
        const updatedPatient = await response.json();
        originalPatientData = { ...updatedPatient };
        showSuccess("Patient information updated successfully!");
        
        // Update age field
        document.getElementById("age").value = updatedPatient.age || calculateAge(updatedPatient.dateOfBirth);
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to update patient');
      }
    } catch (error) {
      console.error('Error saving patient:', error);
      showError("Failed to save patient: " + error.message);
    } finally {
      hideLoading();
      const saveButton = document.getElementById("saveButton");
      saveButton.innerHTML = '<span class="icon-[tabler--device-floppy] size-4 mr-2"></span> Save Changes';
      saveButton.disabled = false;
    }
  }

  // Reset form to original data
  function resetForm() {
    if (originalPatientData) {
      populateForm(originalPatientData);
      clearAllErrors();
      hideAlerts();
    }
  }

  // Show success message
  function showSuccess(message) {
    document.getElementById("successMessage").textContent = message;
    document.getElementById("successAlert").classList.remove("hidden");
    document.getElementById("errorAlert").classList.add("hidden");
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
      document.getElementById("successAlert").classList.add("hidden");
    }, 5000);
  }

  // Show error message
  function showError(message) {
    document.getElementById("errorMessage").textContent = message;
    document.getElementById("errorAlert").classList.remove("hidden");
    document.getElementById("successAlert").classList.add("hidden");
  }

  // Hide all alerts
  function hideAlerts() {
    document.getElementById("successAlert").classList.add("hidden");
    document.getElementById("errorAlert").classList.add("hidden");
  }

  // Show loading spinner
  function showLoading() {
    document.getElementById("loadingSpinner").classList.remove("hidden");
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById("loadingSpinner").classList.add("hidden");
  }

  // Event listeners
  document.addEventListener('DOMContentLoaded', function() {
    loadPatientData();
    
    // Auto-calculate age when date of birth changes
    document.getElementById("dateOfBirth").addEventListener('change', function() {
      const age = calculateAge(this.value);
      document.getElementById("age").value = age;
    });

    // Real-time validation for email
    document.getElementById("email").addEventListener('blur', function() {
      const email = this.value.trim();
      if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        showFieldError("email", "Please enter a valid email address");
      } else {
        const errorElement = document.getElementById("emailError");
        if (errorElement) {
          errorElement.classList.add("hidden");
        }
        this.classList.remove("input-error");
      }
    });

    // Real-time validation for phone numbers
    ['contactNumber', 'emergencyContactNumber'].forEach(fieldId => {
      document.getElementById(fieldId).addEventListener('blur', function() {
        const value = this.value.trim();
        if (value && !/^[0-9+\-\s()]+$/.test(value)) {
          showFieldError(fieldId, "Phone number can only contain numbers, spaces, hyphens, and parentheses");
        } else if (value && value.length < 8) {
          showFieldError(fieldId, "Phone number must be at least 8 digits");
        } else {
          const errorElement = document.getElementById(fieldId + "Error");
          if (errorElement) {
            errorElement.classList.add("hidden");
          }
          this.classList.remove("input-error");
        }
      });
    });

    // Real-time validation for ID number based on ID type
    document.getElementById("idType").addEventListener('change', function() {
      const idNumberField = document.getElementById("idNumber");
      const idType = this.value;
      
      // Clear previous error
      const errorElement = document.getElementById("idNumberError");
      if (errorElement) {
        errorElement.classList.add("hidden");
      }
      idNumberField.classList.remove("input-error");
      
      // Update placeholder based on ID type
      if (idType === "IC") {
        idNumberField.placeholder = "Format: YYMMDD-PB-XXXX (e.g., 900101-01-1234)";
      } else if (idType === "Passport") {
        idNumberField.placeholder = "Format: 1-2 letters + 6-9 digits (e.g., A1234567)";
      } else {
        idNumberField.placeholder = "Enter ID number based on selected type";
      }
    });

    // Real-time validation for ID number
    document.getElementById("idNumber").addEventListener('blur', function() {
      const idType = document.getElementById("idType").value;
      const idNumber = this.value.trim();
      
      if (idType && idNumber) {
        let isValid = true;
        let errorMessage = "";
        
        if (idType === "IC") {
          if (!/^\d{6}-\d{2}-\d{4}$/.test(idNumber)) {
            errorMessage = "Malaysian IC must be in format: YYMMDD-PB-XXXX (e.g., 900101-01-1234)";
            isValid = false;
          } else {
            // Validate date part
            const datePart = idNumber.substring(0, 6);
            const month = parseInt(datePart.substring(2, 4));
            const day = parseInt(datePart.substring(4, 6));
            
            if (month < 1 || month > 12 || day < 1 || day > 31) {
              errorMessage = "Invalid date in Malaysian IC number";
              isValid = false;
            }
          }
        } else if (idType === "Passport") {
          if (!/^[A-Z]{1,2}\d{6,9}$/.test(idNumber)) {
            errorMessage = "Passport must be in format: 1-2 letters followed by 6-9 digits (e.g., A1234567 or AB123456789)";
            isValid = false;
          }
        }
        
        if (!isValid) {
          showFieldError("idNumber", errorMessage);
        } else {
          const errorElement = document.getElementById("idNumberError");
          if (errorElement) {
            errorElement.classList.add("hidden");
          }
          this.classList.remove("input-error");
        }
      }
    });
  });
</script>
</body>
</html>
