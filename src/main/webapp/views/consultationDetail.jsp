<%--
Author: Yap Yu Xin
Consultation Module
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Consultation Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Consultation Detail</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="goBack()">
        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
        <span id="backButtonText">Back</span>
      </button>
      <button id="cancelConsultationBtn" class="btn btn-error" onclick="cancelConsultation()" style="display: none;">
        <span class="icon-[tabler--x] size-4 mr-2"></span>
        Cancel Consultation
      </button>
    </div>
  </div>

  <!-- Patient Basic Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Patient Basic Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label class="label">Patient Name</label>
        <input type="text" id="patientName" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" id="age" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Gender</label>
        <select id="gender" class="select select-bordered w-full" disabled>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>
      </div>
    </div>
  </section>

  <!-- Medical Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Medical Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Blood Type</label>
        <select id="bloodType" class="select select-bordered w-full" disabled>
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
      <div>
        <label class="label">Allergies</label>
        <input type="text" id="allergies" class="input input-bordered w-full" disabled />
      </div>
    </div>
  </section>

  <!-- Consultation Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Consultation Information</h2>
    <form id="consultation-form">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label" for="consultationId">Consultation ID</label>
          <input type="text" id="consultationId" name="consultationId" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="consultationDate">Consultation Date</label>
          <input type="date" id="consultationDate" name="consultationDate" class="input input-bordered w-full" disabled />
        </div>
        <div>
          <label class="label" for="doctor">Doctor in Charge</label>
          <select id="doctor" name="doctor" class="select select-bordered w-full">
            <option value="">-- Select Doctor --</option>
          </select>
        </div>
        <div>
          <label class="label" for="symptoms">Symptoms</label>
          <textarea id="symptoms" name="symptoms" class="textarea textarea-bordered w-full" rows="3"></textarea>
        </div>
        <div>
          <label class="label" for="diagnosis">Diagnosis</label>
          <select id="diagnosis" name="diagnosis" class="select select-bordered w-full" onchange="handleDiagnosisChange()">
            <option value="">-- Select Diagnosis --</option>
            <option value="Common Cold">Common Cold</option>
            <option value="Influenza">Influenza</option>
            <option value="Hypertension">Hypertension</option>
            <option value="Diabetes">Diabetes</option>
            <option value="Asthma">Asthma</option>
            <option value="Bronchitis">Bronchitis</option>
            <option value="Pneumonia">Pneumonia</option>
            <option value="Gastritis">Gastritis</option>
            <option value="Urinary Tract Infection">Urinary Tract Infection</option>
            <option value="Migraine">Migraine</option>
            <option value="Anxiety">Anxiety</option>
            <option value="Depression">Depression</option>
            <option value="Arthritis">Arthritis</option>
            <option value="Back Pain">Back Pain</option>
            <option value="Skin Rash">Skin Rash</option>
            <option value="Ear Infection">Ear Infection</option>
            <option value="Sinusitis">Sinusitis</option>
            <option value="Allergic Rhinitis">Allergic Rhinitis</option>
            <option value="Other">Other (Specify)</option>
          </select>
          <div id="other-diagnosis-container" class="mt-2" style="display: none;">
            <label class="label">Specify Diagnosis</label>
            <textarea id="other-diagnosis" name="otherDiagnosis" class="textarea textarea-bordered w-full" rows="2" placeholder="Please specify the diagnosis..."></textarea>
          </div>
        </div>
        <div>
          <label class="label" for="status">Status</label>
          <input type="text" id="status" name="status" class="input input-bordered w-full" readonly />
        </div>

      </div>
      <div class="flex justify-end mt-6">
        <button type="submit" class="btn btn-primary">Save Consultation</button>
      </div>
    </form>
  </section>

  <!-- Prescription Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <div class="flex justify-between items-center">
      <h2 class="text-xl font-semibold mb-2">Prescription</h2>
      <button class="btn btn-primary" onclick="addPrescriptionRow()">
        <span class="icon-[tabler--plus] size-4"></span>
        Add Medicine
      </button>
    </div>

    <div id="prescription-container" class="space-y-4">
      <!-- Prescription rows will be added here dynamically -->
    </div>

    <div class="flex justify-end mt-6">
      <button type="button" class="btn btn-primary" onclick="savePrescriptions()">Save Prescriptions</button>
    </div>
  </section>

  <!-- Treatment Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <div class="flex justify-between items-center">
      <h2 class="text-xl font-semibold mb-2">Treatment Management</h2>
      <div class="flex gap-2">
        <button id="create-treatment-btn" class="btn btn-primary" onclick="showCreateTreatmentForm()">
          <span class="icon-[tabler--plus] size-4 mr-2"></span>
          Start Treatment
        </button>
      </div>
    </div>

    <!-- Treatment List -->
    <div id="treatments-list" class="space-y-4" style="display: none;">
      <div class="overflow-x-auto">
        <table class="table table-zebra w-full">
          <thead>
            <tr>
              <th>Treatment ID</th>
              <th>Type</th>
              <th>Name</th>
              <th>Status</th>
              <th>Outcome</th>
              <th>Duration</th>
              <th>Price</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="treatments-table-body">
            <!-- Treatments will be populated here -->
                  </tbody>
      </table>
    </div>
    
    <!-- Update Progress Form -->
    <div id="update-progress-form" class="mt-6" style="display: none;">
      <div class="bg-white rounded-lg p-4 border border-gray-200">
        <h3 class="text-lg font-semibold mb-4">Update Treatment Progress</h3>
        <form id="treatment-progress-form">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="label">Status</label>
              <select id="progressStatus" name="status" class="select select-bordered w-full" required>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
                <option value="Cancelled">Cancelled</option>
                <option value="On Hold">On Hold</option>
              </select>
            </div>
            <div>
              <label class="label">Outcome</label>
              <select id="progressOutcome" name="outcome" class="select select-bordered w-full">
                <option value="">-- Select Outcome --</option>
                <option value="Successful">Successful</option>
                <option value="Partial Success">Partial Success</option>
                <option value="Unsuccessful">Unsuccessful</option>
                <option value="Complications">Complications</option>
                <option value="Patient Discontinued">Patient Discontinued</option>
              </select>
            </div>
          </div>
          <div class="mb-4">
            <label class="label">Notes</label>
            <textarea id="progressNotes" name="notes" class="textarea textarea-bordered w-full" rows="3" placeholder="Additional notes about the treatment progress..."></textarea>
          </div>
          <div class="flex justify-end gap-2">
            <button type="button" class="btn btn-secondary" onclick="hideUpdateProgressForm()">Cancel</button>
            <button type="submit" class="btn btn-primary">Update Progress</button>
          </div>
        </form>
      </div>
    </div>
  </div>

    <!-- Create Treatment Form -->
    <div id="create-treatment-form" style="display: none;">
      <div class="bg-white rounded-lg p-4 border border-gray-200">
        <h3 class="text-lg font-semibold mb-4">Start New Treatment</h3>
        <form id="treatment-form">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="label">Treatment Type</label>
              <select id="treatmentType" name="treatmentType" class="select select-bordered w-full" required>
                <option value="">-- Select Type --</option>
                <option value="Physical Therapy">Physical Therapy</option>
                <option value="Medication">Medication</option>
                <option value="Counseling">Counseling</option>
                <option value="Diagnostics">Diagnostics</option>
              </select>
            </div>
            <div>
              <label class="label">Treatment Name</label>
              <input type="text" id="treatmentName" name="treatmentName" class="input input-bordered w-full" placeholder="e.g., Antibiotic Therapy, Physical Therapy Session" required />
            </div>
            <div>
              <label class="label">Duration (minutes)</label>
              <input type="number" id="duration" name="duration" class="input input-bordered w-full" min="5" max="480" value="30" required />
            </div>
            <div>
              <label class="label">Price (RM)</label>
              <input type="number" id="treatmentPrice" name="price" class="input input-bordered w-full" min="1.00" step="0.01" placeholder="0.00" required />
              <div class="text-xs text-gray-500 mt-1">Price must be higher than RM 1.00</div>
            </div>
          </div>
          <div class="mb-4">
            <label class="label">Description</label>
            <textarea id="treatmentDescription" name="description" class="textarea textarea-bordered w-full" rows="3" placeholder="Describe the treatment procedure..." required></textarea>
          </div>
          <div class="mb-4">
            <label class="label">Treatment Procedure</label>
            <textarea id="treatmentProcedure" name="treatmentProcedure" class="textarea textarea-bordered w-full" rows="3" placeholder="Detailed steps of the treatment..." required></textarea>
          </div>
          <div class="flex justify-end gap-2">
            <button type="button" class="btn btn-secondary" onclick="hideCreateTreatmentForm()">Cancel</button>
            <button type="submit" class="btn btn-primary">Start Treatment</button>
          </div>
        </form>
      </div>
    </div>


  </section>

  <!-- Follow-up Appointment Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <div class="flex justify-between items-center">
      <h2 class="text-xl font-semibold mb-2">Follow-up Appointment</h2>
      <div class="flex gap-2">
        <button id="create-followup-btn" class="btn btn-primary" onclick="showCreateFollowupForm()">Schedule Follow-up</button>
        <button id="view-followup-btn" class="btn btn-secondary" onclick="viewFollowup()" style="display: none;">View Follow-up</button>
      </div>
    </div>

    <!-- Follow-up Info -->
    <div id="followup-info" class="grid grid-cols-1 md:grid-cols-2 gap-4" style="display: none;">
      <div>
        <label class="label">Follow-up Appointment ID</label>
        <input type="text" id="followupAppointmentId" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Follow-up Date</label>
        <input type="date" id="followupDate" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Follow-up Time</label>
        <input type="time" id="followupTime" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Doctor</label>
        <input type="text" id="followupDoctor" class="input input-bordered w-full" disabled />
      </div>
      <div class="md:col-span-2">
        <label class="label">Follow-up Reason</label>
        <input type="text" id="followupReason" class="input input-bordered w-full" disabled />
      </div>
    </div>

    <!-- Create Follow-up Form -->
    <div id="create-followup-form" style="display: none;">
      <div class="bg-white rounded-lg p-4 border border-gray-200">
        <h3 class="text-lg font-semibold mb-4">Schedule Follow-up Appointment</h3>
        <form id="followup-form">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="label">Follow-up Date</label>
              <input type="date" id="followup-appointment-date" name="appointmentDate" class="input input-bordered w-full" required />
            </div>
            <div>
              <label class="label">Follow-up Time</label>
              <select id="followup-appointment-time" name="appointmentTime" class="select select-bordered w-full" required>
                <option value="">-- Select Time --</option>
              </select>
              <div id="followup-availability-info" class="text-sm text-gray-600 mt-1"></div>
            </div>
            <div>
              <label class="label">Doctor</label>
              <input type="text" value="To be assigned on follow-up day" class="input input-bordered w-full" disabled />
            </div>
            <div>
              <label class="label">Follow-up Reason</label>
              <select id="followup-reason" name="reason" class="select select-bordered w-full" required onchange="handleFollowupReasonChange()">
                <option value="">-- Select Reason --</option>
                <option value="Review Progress">Review Progress</option>
                <option value="Medication Adjustment">Medication Adjustment</option>
                <option value="Test Results Review">Test Results Review</option>
                <option value="Treatment Continuation">Treatment Continuation</option>
                <option value="Symptom Monitoring">Symptom Monitoring</option>
                <option value="Post-Surgery Check">Post-Surgery Check</option>
                <option value="Preventive Care">Preventive Care</option>
                <option value="Other">Other (Specify)</option>
              </select>
            </div>
          </div>
          <div class="mb-4">
            <label class="label">Additional Notes</label>
            <textarea id="followup-notes" name="notes" class="textarea textarea-bordered w-full" rows="3" placeholder="Additional notes for the follow-up appointment..."></textarea>
          </div>
          <div id="other-reason-container" class="mb-4" style="display: none;">
            <label class="label">Specify Reason</label>
            <textarea id="other-reason" name="otherReason" class="textarea textarea-bordered w-full" rows="2" placeholder="Please specify the follow-up reason..."></textarea>
          </div>
          <div class="flex justify-end gap-2">
            <button type="button" class="btn btn-outline" onclick="cancelCreateFollowup()">Cancel</button>
            <button type="submit" class="btn btn-primary">Schedule Follow-up</button>
          </div>
        </form>
      </div>
    </div>
  </section>

  <!-- Medical Certificate Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <div class="flex justify-between items-center">
      <h2 class="text-xl font-semibold mb-2">Medical Certificate</h2>
      <div class="flex gap-2">
        <button id="create-mc-btn" class="btn btn-primary" onclick="showCreateMCForm()">Create MC</button>
        <button id="view-mc-btn" class="btn btn-secondary" onclick="viewMC()" style="display: none;">View MC</button>
      </div>
    </div>

    <!-- Existing MC Info -->
    <div id="mc-info" class="grid grid-cols-1 md:grid-cols-2 gap-4" style="display: none;">
      <div>
        <label class="label">MC ID</label>
        <input type="text" id="mcId" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Start Date</label>
        <input type="date" id="mcStartDate" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">End Date</label>
        <input type="date" id="mcEndDate" class="input input-bordered w-full" disabled />
      </div>
      <div class="md:col-span-2">
        <label class="label">Diagnosis</label>
        <input type="text" id="mcDiagnosis" class="input input-bordered w-full" disabled />
      </div>
      <div class="md:col-span-2">
        <label class="label">Symptoms</label>
        <input type="text" id="mcSymptoms" class="input input-bordered w-full" disabled />
      </div>
    </div>

    <!-- Create MC Form -->
    <div id="create-mc-form" style="display: none;">
      <div class="bg-white rounded-lg p-4 border border-gray-200">
        <h3 class="text-lg font-semibold mb-4">Create Medical Certificate</h3>
        <form id="mc-form">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="label">Start Date</label>
              <input type="date" id="mc-start-date" name="startDate" class="input input-bordered w-full" required onchange="validateMCDates()" />
              <div class="text-xs text-gray-500 mt-1">Cannot be more than 1 week before today</div>
            </div>
            <div>
              <label class="label">End Date</label>
              <input type="date" id="mc-end-date" name="endDate" class="input input-bordered w-full" required onchange="validateMCDates()" />
            </div>
          </div>
          <div class="mb-4">
            <label class="label">Additional Notes (Optional)</label>
            <textarea id="mc-description" name="description" class="textarea textarea-bordered w-full" rows="4" placeholder="Enter additional medical certificate notes (optional)..."></textarea>
            <small class="text-xs text-base-content/60">Diagnosis and symptoms from the consultation will be automatically included in the MC.</small>
          </div>
          <div class="flex justify-end gap-2">
            <button type="button" class="btn btn-outline" onclick="cancelCreateMC()">Cancel</button>
            <button type="submit" class="btn btn-primary">Create MC</button>
          </div>
        </form>
      </div>
    </div>
  </section>
</main>



<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let consultationId = '';
  let consultationData = {};
  let patientData = {};
  let medicines = [];
  let prescriptions = [];
  let doctors = []; // Array to store doctors
  let nextRowId = 0; // For generating unique row IDs
  let isCheckingAvailability = false; // Track availability checking state

  // Get consultation ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  consultationId = urlParams.get('id');

  if (!consultationId) {
    alert('No consultation ID provided');
    window.location.href = '<%= request.getContextPath() %>/views/consultationList.jsp';
  }

  // Load consultation data
  async function loadConsultationData() {
    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId);
      if (!response.ok) {
        throw new Error('Failed to load consultation data');
      }

      consultationData = await response.json();
      patientId = consultationData.patientID;

      // Load patient data
      await loadPatientData();

      // Load doctors first (needed for doctor dropdown)
      await loadDoctors();

      // Populate consultation form (now that doctors are loaded)
      populateConsultationForm();

      // Check for MC data
      await checkMCData();

      // Check for follow-up appointment data
      await checkFollowupData();

      // Load medicines and prescriptions
      await loadMedicines();
      await loadPrescriptions();

      // Load treatments for this consultation
      await loadTreatments();

    } catch (error) {
      console.error('Error loading consultation data:', error);
      alert('Error loading consultation data: ' + error.message);
    }
  }

  // Load patient data
  async function loadPatientData() {
    try {
      const response = await fetch(API_BASE + '/patients/' + patientId);
      if (!response.ok) {
        throw new Error('Failed to load patient data');
      }

      patientData = await response.json();
      populatePatientForm();

    } catch (error) {
      console.error('Error loading patient data:', error);
      alert('Error loading patient data: ' + error.message);
    }
  }

  // Populate patient form
  function populatePatientForm() {
    if (!patientData) return;

    document.getElementById('patientName').value = (patientData.firstName || '') + ' ' + (patientData.lastName || '');
    document.getElementById('age').value = patientData.age || '';
    document.getElementById('gender').value = patientData.gender || '';
    document.getElementById('allergies').value = patientData.allergies || '';
    document.getElementById('bloodType').value = patientData.bloodType || '';
  }

  // Populate consultation form
  function populateConsultationForm() {
    if (!consultationData) return;

    document.getElementById('consultationId').value = consultationData.consultationID || '';
    document.getElementById('consultationDate').value = consultationData.consultationDate || '';
    document.getElementById('symptoms').value = consultationData.symptoms || '';
    
    // Set the selected doctor
    const doctorSelect = document.getElementById('doctor');
    const doctorID = consultationData.doctorID || '';
    
    console.log('DEBUG: Setting doctor dropdown to:', doctorID);
    console.log('DEBUG: Available doctor options:', Array.from(doctorSelect.options).map(opt => opt.value + ' - ' + opt.text));
    
    doctorSelect.value = doctorID;
    
    // Verify the selection worked
    console.log('DEBUG: Doctor dropdown value after setting:', doctorSelect.value);
    if (doctorSelect.value !== doctorID && doctorID) {
      console.warn('DEBUG: Failed to set doctor dropdown value! Expected:', doctorID, 'Got:', doctorSelect.value);
    }
    
    // Handle diagnosis population
    const diagnosis = consultationData.diagnosis || '';
    const diagnosisSelect = document.getElementById('diagnosis');
    const otherContainer = document.getElementById('other-diagnosis-container');
    const otherTextarea = document.getElementById('other-diagnosis');
    
    // Check if the diagnosis is in our predefined list
    const predefinedDiagnoses = Array.from(diagnosisSelect.options).map(option => option.value);
    if (predefinedDiagnoses.includes(diagnosis) && diagnosis !== '') {
      diagnosisSelect.value = diagnosis;
      otherContainer.style.display = 'none';
    } else if (diagnosis !== '') {
      // If it's not in the list, set to "Other" and populate the textarea
      diagnosisSelect.value = 'Other';
      otherContainer.style.display = 'block';
      otherTextarea.value = diagnosis;
    } else {
      diagnosisSelect.value = '';
      otherContainer.style.display = 'none';
    }
    
    document.getElementById('status').value = consultationData.status || 'Waiting';
    
    // Show/hide cancel button based on consultation status
    updateCancelButtonVisibility();
  }

  // Check for existing MC data
  async function checkMCData() {
    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId + '/mc');
      if (response.ok) {
        const mcData = await response.json();
        showMCInfo(mcData);
      }
    } catch (error) {
      console.log('No MC found for this consultation');
    }
  }

  // Show MC information
  function showMCInfo(mcData) {
    document.getElementById('mc-info').style.display = 'grid';
    document.getElementById('create-mc-form').style.display = 'none';
    document.getElementById('create-mc-btn').style.display = 'none';
    document.getElementById('view-mc-btn').style.display = 'inline-block';
    
    populateMCInfo(mcData);
  }

  // Populate MC info
  function populateMCInfo(mcData) {
    document.getElementById('mcId').value = mcData.mcID || '';
    document.getElementById('mcStartDate').value = mcData.startDate || '';
    document.getElementById('mcEndDate').value = mcData.endDate || '';
    document.getElementById('mcDiagnosis').value = mcData.diagnosis || '';
    document.getElementById('mcSymptoms').value = mcData.symptoms || '';
  }



  // Show create MC form
  function showCreateMCForm() {
    console.log('DEBUG: showCreateMCForm called');
    document.getElementById('create-mc-form').style.display = 'block';
    document.getElementById('create-mc-btn').style.display = 'none';
    console.log('DEBUG: Create MC form should now be visible');
  }

  // Cancel create MC
  function cancelCreateMC() {
    document.getElementById('create-mc-form').style.display = 'none';
    document.getElementById('create-mc-btn').style.display = 'inline-block';
    document.getElementById('mc-form').reset();
  }

  // View MC
  function viewMC() {
    window.open('<%= request.getContextPath() %>/views/mcDetail.jsp?consultationId=' + consultationId, '_blank');
  }

  // Handle diagnosis selection change
  function handleDiagnosisChange() {
    const diagnosisSelect = document.getElementById('diagnosis');
    const otherContainer = document.getElementById('other-diagnosis-container');
    const otherTextarea = document.getElementById('other-diagnosis');
    
    if (diagnosisSelect.value === 'Other') {
      otherContainer.style.display = 'block';
      otherTextarea.focus();
    } else {
      otherContainer.style.display = 'none';
      otherTextarea.value = '';
    }
  }



  // Smart back navigation function
  function goBack() {
    // Check if we came from a specific page via URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const fromPage = urlParams.get('from');
    
    if (fromPage) {
      // Navigate to the specific page we came from
      switch (fromPage) {
        case 'queue':
          window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
          break;
        case 'consultations':
          window.location.href = '<%= request.getContextPath() %>/views/consultationList.jsp';
          break;
        case 'patients':
          window.location.href = '<%= request.getContextPath() %>/views/patientList.jsp';
          break;
        case 'appointments':
          window.location.href = '<%= request.getContextPath() %>/views/appointmentList.jsp';
          break;
        default:
          // Default fallback to queue
          window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
      }
    } else {
      // Check document.referrer to determine where we came from
      const referrer = document.referrer;
      if (referrer.includes('adminQueue.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
      } else if (referrer.includes('consultationList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/consultationList.jsp';
      } else if (referrer.includes('patientList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/patientList.jsp';
      } else if (referrer.includes('appointmentList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/appointmentList.jsp';
      } else {
        // Default fallback to queue
        window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
      }
    }
  }

  // Set back button text based on where we came from
  function setBackButtonText() {
    const urlParams = new URLSearchParams(window.location.search);
    const fromPage = urlParams.get('from');
    
    if (fromPage) {
      switch (fromPage) {
        case 'queue':
          document.getElementById('backButtonText').textContent = 'Back to Queue';
          break;
        case 'consultations':
          document.getElementById('backButtonText').textContent = 'Back to Consultations';
          break;
        case 'patients':
          document.getElementById('backButtonText').textContent = 'Back to Patients';
          break;
        case 'appointments':
          document.getElementById('backButtonText').textContent = 'Back to Appointments';
          break;
        default:
          document.getElementById('backButtonText').textContent = 'Back to Queue';
      }
    } else {
      // Try to determine from referrer
      const referrer = document.referrer;
      if (referrer.includes('adminQueue.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Queue';
      } else if (referrer.includes('consultationList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Consultations';
      } else if (referrer.includes('patientList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Patients';
      } else if (referrer.includes('appointmentList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Appointments';
      } else {
        document.getElementById('backButtonText').textContent = 'Back to Queue';
      }
    }
  }

  // Handle consultation form submission
  document.getElementById('consultation-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Get diagnosis value - if "Other" is selected, use the textarea value
    const diagnosisSelect = document.getElementById('diagnosis');
    const otherDiagnosis = document.getElementById('other-diagnosis').value;
    const diagnosis = diagnosisSelect.value === 'Other' ? otherDiagnosis : diagnosisSelect.value;
    
    // Get current consultation data to preserve follow-up fields
    const currentConsultation = consultationData;
    
    const formData = {
      consultationID: consultationId,
      consultationDate: document.getElementById('consultationDate').value,
      doctorID: document.getElementById('doctor').value,
      symptoms: document.getElementById('symptoms').value,
      diagnosis: diagnosis,
      // Preserve follow-up related fields
      isFollowUpRequired: currentConsultation.isFollowUpRequired,
      appointmentID: currentConsultation.appointmentID,
      // Preserve other fields that should not be changed
      patientID: currentConsultation.patientID,
      staffID: currentConsultation.staffID,
      billID: currentConsultation.billID,
      checkInTime: currentConsultation.checkInTime,
      status: currentConsultation.status,
      mcID: currentConsultation.mcID,
      startDate: currentConsultation.startDate,
      endDate: currentConsultation.endDate
    };

    console.log('DEBUG: Form data being sent:', formData);
    console.log('DEBUG: Selected doctor value:', document.getElementById('doctor').value);

    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        const result = await response.json();
        console.log('DEBUG: Update successful, response:', result);
        alert('Consultation updated successfully!');
        await loadConsultationData(); // Reload data
      } else {
        const error = await response.json();
        console.log('DEBUG: Update failed, error:', error);
        alert('Error updating consultation: ' + error.error);
      }
    } catch (error) {
      alert('Error updating consultation: ' + error.message);
    }
  });

  // Validate MC dates
  function validateMCDates() {
    const startDateInput = document.getElementById('mc-start-date');
    const endDateInput = document.getElementById('mc-end-date');
    
    if (!startDateInput.value || !endDateInput.value) {
      return true; // Allow empty values for now
    }
    
    const startDate = new Date(startDateInput.value);
    const endDate = new Date(endDateInput.value);
    const today = new Date();
    const oneWeekAgo = new Date(today);
    oneWeekAgo.setDate(today.getDate() - 7);
    
    // Reset any previous error styling
    startDateInput.classList.remove('input-error');
    endDateInput.classList.remove('input-error');
    
    let isValid = true;
    
    // Check if start date is more than 1 week before today
    if (startDate < oneWeekAgo) {
      startDateInput.classList.add('input-error');
      alert('Start date cannot be more than 1 week before today.');
      isValid = false;
    }
    
    // Check if end date is before start date
    if (endDate < startDate) {
      endDateInput.classList.add('input-error');
      alert('End date cannot be before start date.');
      isValid = false;
    }
    
    return isValid;
  }

  // Handle MC form submission
  document.getElementById('mc-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Validate dates before submission
    if (!validateMCDates()) {
      return;
    }

    const formData = {
      startDate: document.getElementById('mc-start-date').value,
      endDate: document.getElementById('mc-end-date').value,
      description: document.getElementById('mc-description').value
    };

    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId + '/mc', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        alert('Medical Certificate created successfully!');
        cancelCreateMC(); // Hide the form
        await checkMCData(); // Reload MC data
      } else {
        const error = await response.json();
        alert('Error creating MC: ' + error.error);
      }
    } catch (error) {
      alert('Error creating MC: ' + error.message);
    }
  });

  // Load doctors from API
  async function loadDoctors() {
    try {
      const response = await fetch(API_BASE + '/staff');
      if (!response.ok) {
        throw new Error('Failed to load doctors');
      }
      const data = await response.json();
      const allStaff = data.elements || data || [];
      
      // Filter only doctors
      doctors = allStaff.filter(staff => staff.position && staff.position.toLowerCase() === 'doctor');
      
      console.log('DEBUG: Loaded doctors:', doctors.map(d => d.staffID + ' - Dr. ' + d.firstName + ' ' + d.lastName));
      
      // Populate doctor dropdown
      populateDoctorDropdown();
    } catch (error) {
      console.error('Error loading doctors:', error);
    }
  }

  // Populate doctor dropdown
  function populateDoctorDropdown() {
    const doctorSelect = document.getElementById('doctor');
    doctorSelect.innerHTML = '<option value="">-- Select Doctor --</option>';
    
    doctors.forEach(doctor => {
      const option = document.createElement('option');
      option.value = doctor.staffID;
      option.textContent = 'Dr. ' + doctor.firstName + ' ' + doctor.lastName;
      doctorSelect.appendChild(option);
    });
  }

  // Load medicines from API
  async function loadMedicines() {
    try {
      const response = await fetch(API_BASE + '/medicines');
      if (!response.ok) {
        throw new Error('Failed to load medicines');
      }
      const data = await response.json();
      medicines = data.elements || data || [];
    } catch (error) {
      console.error('Error loading medicines:', error);
    }
  }

  // Load existing prescriptions
  async function loadPrescriptions() {
    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId + '/prescriptions');
      if (response.ok) {
        const data = await response.json();
        prescriptions = data.elements || data || [];
        renderPrescriptions();
      }
    } catch (error) {
      console.log('No existing prescriptions found');
    }
  }

  // Render prescription rows
  function renderPrescriptions() {
    const container = document.getElementById('prescription-container');
    container.innerHTML = '';

    if (prescriptions.length === 0) {
      container.innerHTML = '<p class="text-gray-500 text-center py-4">No prescriptions added yet.</p>';
      return;
    }

    prescriptions.forEach((prescription, index) => {
      addPrescriptionRow(prescription, index);
    });
    
    // Update nextRowId to be higher than the highest index used
    nextRowId = Math.max(nextRowId, prescriptions.length);
    
    // Update medicine options after rendering all prescriptions
    updateMedicineOptions();
  }

  // Add prescription row
  function addPrescriptionRow(prescription = null, index = null) {
    const container = document.getElementById('prescription-container');
    // Use provided index if available, otherwise use nextRowId
    const uniqueRowId = index !== null ? index : nextRowId++;
    

    
    const row = document.createElement('div');
    row.className = 'bg-white rounded-lg p-4 border border-gray-200';
    row.id = "prescription-row-" + uniqueRowId;
    
    // Store prescription ID if it exists
    if (prescription && prescription.prescriptionID) {
      row.setAttribute('data-prescription-id', prescription.prescriptionID);
    }
    
    // Store medicine ID for easier identification
    if (prescription && prescription.medicineID) {
      row.setAttribute('data-medicine-id', prescription.medicineID);
    }

    // Get currently selected medicines to disable them in other rows
    const selectedMedicines = getSelectedMedicines();
    
    const medicineOptions = medicines.map(medicine => {
      const isSelected = prescription && prescription.medicineID === medicine.medicineID;
      const isDisabled = !isSelected && selectedMedicines.includes(medicine.medicineID);
      const hasStock = medicine.availableStock > 0;
      const disabledAttr = (isDisabled || !hasStock) ? 'disabled' : '';
      const selectedAttr = isSelected ? 'selected' : '';
      const stockInfo = hasStock ? ' (Stock: ' + medicine.availableStock + ')' : ' (Out of Stock)';
      
      return '<option value="' + medicine.medicineID + '" ' + selectedAttr + ' ' + disabledAttr + '>' +
        medicine.medicineName + ' (' + medicine.medicineID + ')' + stockInfo +
        (isDisabled ? ' (Already selected)' : '') +
      '</option>';
    }).join('');

    const isExisting = prescription && prescription.prescriptionID;
    const statusBadge = isExisting ? 
      '<div class="mb-2"><span class="badge badge-info">Existing Prescription</span></div>' : 
      '<div class="mb-2"><span class="badge badge-warning">New Prescription</span></div>';
    
    // Add stock information display
    const stockInfoDiv = '<div class="mb-2" id="stock-info-' + uniqueRowId + '"><span class="text-sm text-gray-500">Select a medicine to see stock information</span></div>';
    
    row.innerHTML = 
      statusBadge +
      stockInfoDiv +
      '<div class="grid grid-cols-1 md:grid-cols-2 gap-4">' +
        '<div class="md:col-span-2">' +
          '<label class="label">Medicine</label>' +
          '<select class="select select-bordered w-full prescription-medicine" data-row-id="' + uniqueRowId + '">' +
            '<option value="">Select Medicine</option>' +
            medicineOptions +
          '</select>' +
        '</div>' +
        '<div>' +
          '<label class="label">Dosage</label>' +
          '<div class="flex gap-2">' +
            '<input type="number" class="input input-bordered w-20 prescription-dosage" data-row-id="' + uniqueRowId + '" ' +
                   'value="' + (prescription ? prescription.dosage : '') + '" min="1" />' +
            '<input type="text" class="input input-bordered w-24 prescription-unit" data-row-id="' + uniqueRowId + '" ' +
                   'value="' + (prescription ? prescription.dosageUnit : '') + '" readonly />' +
          '</div>' +
        '</div>' +
        '<div>' +
          '<label class="label">Times per Day</label>' +
          '<input type="number" class="input input-bordered w-full prescription-frequency" data-row-id="' + uniqueRowId + '" ' +
                 'value="' + (prescription ? prescription.servingPerDay : '') + '" min="1" max="6" />' +
        '</div>' +
        '<div>' +
          '<label class="label">Quantity Dispensed</label>' +
          '<input type="number" class="input input-bordered w-full prescription-quantity" data-row-id="' + uniqueRowId + '" ' +
                 'value="' + (prescription ? prescription.quantityDispensed : '') + '" min="1" />' +
        '</div>' +
        '<div class="md:col-span-2">' +
          '<label class="label">Instruction</label>' +
          '<select class="select select-bordered w-full prescription-instruction" data-row-id="' + uniqueRowId + '">' +
            '<option value="Take with food"' + (prescription && prescription.instruction === 'Take with food' ? ' selected' : '') + '>Take with food</option>' +
            '<option value="Take before meals"' + (prescription && prescription.instruction === 'Take before meals' ? ' selected' : '') + '>Take before meals</option>' +
            '<option value="Take after meals"' + (prescription && prescription.instruction === 'Take after meals' ? ' selected' : '') + '>Take after meals</option>' +
            '<option value="Take on empty stomach"' + (prescription && prescription.instruction === 'Take on empty stomach' ? ' selected' : '') + '>Take on empty stomach</option>' +
            '<option value="Take with plenty of water"' + (prescription && prescription.instruction === 'Take with plenty of water' ? ' selected' : '') + '>Take with plenty of water</option>' +
            '<option value="Take at bedtime"' + (prescription && prescription.instruction === 'Take at bedtime' ? ' selected' : '') + '>Take at bedtime</option>' +
            '<option value="Take as needed"' + (prescription && prescription.instruction === 'Take as needed' ? ' selected' : '') + '>Take as needed</option>' +
          '</select>' +
        '</div>' +
      '</div>' +
      '<div class="mt-4">' +
        '<label class="label">Description/Notes</label>' +
        '<textarea class="textarea textarea-bordered w-full prescription-description" data-row-id="' + uniqueRowId + '" rows="2" ' +
                  'placeholder="Additional notes about this medicine...">' + (prescription ? prescription.description : '') + '</textarea>' +
      '</div>' +
      '<div class="flex justify-end mt-4">' +
        '<button type="button" class="btn btn-error btn-sm" onclick="removePrescriptionRow(' + uniqueRowId + ')" ' +
               'title="' + (isExisting ? 'Delete this prescription from database' : 'Remove this new prescription row') + '">' +
          '<span class="icon-[tabler--trash] size-4"></span>' +
          (isExisting ? 'Delete' : 'Remove') +
        '</button>' +
      '</div>';

    container.appendChild(row);
    
    // Add event listener to the medicine select to update other rows when selection changes
    const medicineSelect = row.querySelector('.prescription-medicine');
    medicineSelect.addEventListener('change', function() {
      updateMedicineOptions();
      updateUnitField(this, uniqueRowId);
    });
    
    // Add event listener to quantity input for stock validation
    const quantityInput = row.querySelector('.prescription-quantity');
    quantityInput.addEventListener('input', function() {
      validateQuantity(uniqueRowId);
    });
  }

  // Get currently selected medicines across all prescription rows
  function getSelectedMedicines() {
    const container = document.getElementById('prescription-container');
    const medicineSelects = container.querySelectorAll('.prescription-medicine');
    const selectedMedicines = [];
    
    medicineSelects.forEach(select => {
      if (select.value) {
        selectedMedicines.push(select.value);
      }
    });
    
    return selectedMedicines;
  }

  // Update unit field and stock information when medicine is selected
  function updateUnitField(medicineSelect, rowId) {
    const selectedMedicineId = medicineSelect.value;
    const selectedMedicine = medicines.find(med => med.medicineID === selectedMedicineId);
    const unitField = document.querySelector('[data-row-id="' + rowId + '"].prescription-unit');
    const stockInfoDiv = document.getElementById('stock-info-' + rowId);
    
    if (selectedMedicine && unitField) {
      unitField.value = selectedMedicine.unit || 'tablet';
      
      // Update stock information
      if (stockInfoDiv) {
        const stock = selectedMedicine.availableStock || 0;
        const stockStatus = stock > 0 ? 
          '<span class="text-success">✓ In Stock: ' + stock + ' available</span>' : 
          '<span class="text-error">✗ Out of Stock</span>';
        stockInfoDiv.innerHTML = '<span class="text-sm">' + stockStatus + '</span>';
      }
    } else {
      if (unitField) {
        unitField.value = '';
      }
      if (stockInfoDiv) {
        stockInfoDiv.innerHTML = '<span class="text-sm text-gray-500">Select a medicine to see stock information</span>';
      }
    }
  }

  // Validate quantity against available stock
  function validateQuantity(rowId) {
    const row = document.getElementById('prescription-row-' + rowId);
    
    // Check if row exists
    if (!row) {
      console.warn('Row not found for ID:', rowId);
      return true; // Allow validation to pass if row doesn't exist
    }
    
    const medicineSelect = row.querySelector('.prescription-medicine');
    const quantityInput = row.querySelector('.prescription-quantity');
    const stockInfoDiv = document.getElementById('stock-info-' + rowId);
    
    // Check if required elements exist
    if (!medicineSelect || !quantityInput) {
      console.warn('Required elements not found in row:', rowId);
      return true; // Allow validation to pass if elements don't exist
    }
    
    if (medicineSelect.value && quantityInput.value) {
      const selectedMedicine = medicines.find(med => med.medicineID === medicineSelect.value);
      const requestedQuantity = parseInt(quantityInput.value) || 0;
      
      if (selectedMedicine && selectedMedicine.availableStock < requestedQuantity) {
        // Update stock info to show warning
        if (stockInfoDiv) {
          stockInfoDiv.innerHTML = '<span class="text-sm text-error">⚠ Insufficient stock! Available: ' + selectedMedicine.availableStock + ', Requested: ' + requestedQuantity + '</span>';
        }
        return false;
      } else if (selectedMedicine) {
        // Update stock info to show success
        if (stockInfoDiv) {
          const stock = selectedMedicine.availableStock || 0;
          stockInfoDiv.innerHTML = '<span class="text-sm text-success">✓ In Stock: ' + stock + ' available</span>';
        }
        return true;
      }
    }
    return true;
  }

  // Update medicine options in all rows when a selection changes
  function updateMedicineOptions() {
    const container = document.getElementById('prescription-container');
    const rows = container.querySelectorAll('[id^="prescription-row-"]');
    const selectedMedicines = getSelectedMedicines();
    
    rows.forEach(row => {
      const medicineSelect = row.querySelector('.prescription-medicine');
      const currentValue = medicineSelect.value;
      const rowId = row.id.replace('prescription-row-', '');
      
      // Update options
      medicineSelect.innerHTML = '<option value="">Select Medicine</option>';
      
      medicines.forEach(medicine => {
        const isSelected = currentValue === medicine.medicineID;
        const isDisabled = !isSelected && selectedMedicines.includes(medicine.medicineID);
        const hasStock = medicine.availableStock > 0;
        const disabledAttr = (isDisabled || !hasStock) ? 'disabled' : '';
        const selectedAttr = isSelected ? 'selected' : '';
        const stockInfo = hasStock ? ' (Stock: ' + medicine.availableStock + ')' : ' (Out of Stock)';
        
        const option = document.createElement('option');
        option.value = medicine.medicineID;
        option.textContent = medicine.medicineName + ' (' + medicine.medicineID + ')' + stockInfo + (isDisabled ? ' (Already selected)' : '');
        option.disabled = isDisabled || !hasStock;
        option.selected = isSelected;
        
        medicineSelect.appendChild(option);
      });
      
      // Update unit field for current selection
      if (currentValue) {
        updateUnitField(medicineSelect, rowId);
      }
    });
  }

  // Remove prescription row
  async function removePrescriptionRow(rowId) {
    const row = document.getElementById("prescription-row-" + rowId);
    
    if (row) {
      const medicineSelect = row.querySelector('.prescription-medicine');
      const medicineId = medicineSelect.value;
      const prescriptionId = row.getAttribute('data-prescription-id');
      
      if (medicineId) {
        // Existing prescription - confirm deletion from database
        if (!confirm('Are you sure you want to remove this prescription? This action cannot be undone.')) {
          return;
        }
        
        try {
          const response = await fetch(API_BASE + '/consultations/' + consultationId + '/prescriptions/' + medicineId, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json',
            }
          });

          if (response.ok) {
            row.remove();
            updateMedicineOptions(); // Update options after removal
            alert('Prescription removed successfully!');
          } else {
            throw new Error('Failed to remove prescription');
          }
        } catch (error) {
          alert('Error removing prescription: ' + error.message);
        }
      } else {
        // New prescription - just remove from UI
        if (!confirm('Remove this new prescription row?')) {
          return;
        }
        row.remove();
        updateMedicineOptions(); // Update options after removal
      }
    }
  }

  // Save prescriptions
  async function savePrescriptions() {
    const container = document.getElementById('prescription-container');
    const rows = container.querySelectorAll('[id^="prescription-row-"]');
    
    const prescriptionsToSave = [];
    
    rows.forEach((row) => {
      const medicineSelect = row.querySelector('.prescription-medicine');
      const dosageInput = row.querySelector('.prescription-dosage');
      const unitSelect = row.querySelector('.prescription-unit');
      const frequencyInput = row.querySelector('.prescription-frequency');
      const quantityInput = row.querySelector('.prescription-quantity');
      const instructionSelect = row.querySelector('.prescription-instruction');
      const descriptionTextarea = row.querySelector('.prescription-description');

      if (medicineSelect.value && dosageInput.value && frequencyInput.value) {
        // Extract row ID from the row element
        const rowId = row.id.replace('prescription-row-', '');
        
        // Get the selected medicine to get its unit and check stock
        const selectedMedicine = medicines.find(med => med.medicineID === medicineSelect.value);
        const medicineUnit = selectedMedicine ? selectedMedicine.unit : 'tablet'; // Default fallback
        const requestedQuantity = parseInt(quantityInput.value) || 0;
        
        // Check if there's enough stock
        if (!validateQuantity(rowId)) {
          alert('Insufficient stock for ' + selectedMedicine.medicineName + '. Available: ' + selectedMedicine.availableStock + ', Requested: ' + requestedQuantity);
          return;
        }
        
        prescriptionsToSave.push({
          consultationID: consultationId,
          medicineID: medicineSelect.value,
          dosage: parseInt(dosageInput.value),
          dosageUnit: medicineUnit,
          servingPerDay: parseInt(frequencyInput.value),
          quantityDispensed: requestedQuantity,
          instruction: instructionSelect.value,
          description: descriptionTextarea.value,
          price: 0 // Will be calculated based on medicine
        });
      }
    });

    if (prescriptionsToSave.length === 0) {
      alert('Please add at least one prescription');
      return;
    }

    try {
      let createdCount = 0;
      let updatedCount = 0;
      
      // Save each prescription
      for (const prescription of prescriptionsToSave) {
        const response = await fetch(API_BASE + '/consultations/' + consultationId + '/prescriptions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(prescription)
        });

        if (!response.ok) {
          throw new Error('Failed to save prescription');
        }
        
        // Check if it was created (201) or updated (200)
        if (response.status === 201) {
          createdCount++;
        } else if (response.status === 200) {
          updatedCount++;
        }
      }

      let message = '';
      if (createdCount > 0 && updatedCount > 0) {
        message = "Prescriptions saved successfully! " + createdCount + " new prescriptions created, " + updatedCount + " prescriptions updated.";
      } else if (createdCount > 0) {
        message = "Prescriptions saved successfully! " + createdCount + " new prescriptions created.";
      } else if (updatedCount > 0) {
        message = "Prescriptions updated successfully! " + updatedCount + " prescriptions updated.";
      } else {
        message = 'Prescriptions saved successfully!';
      }
      
      alert(message);
      await loadPrescriptions(); // Reload prescriptions
    } catch (error) {
      alert('Error saving prescriptions: ' + error.message);
    }
  }

  // ===== TREATMENT MANAGEMENT FUNCTIONS =====

  // Show create treatment form
  function showCreateTreatmentForm() {
    document.getElementById('create-treatment-form').style.display = 'block';
    document.getElementById('treatments-list').style.display = 'none';
    loadDoctorsForTreatment();
  }

  // Hide create treatment form
  function hideCreateTreatmentForm() {
    document.getElementById('create-treatment-form').style.display = 'none';
    document.getElementById('treatments-list').style.display = 'block';
  }



  // Handle treatment form submission
  document.getElementById('treatment-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const price = parseFloat(formData.get('price')) || 0.0;
    
    // Validate price is higher than 1
    if (price < 1.0) {
      alert('Error: Treatment price must be higher than RM 1.00');
      document.getElementById('treatmentPrice').focus();
      return;
    }
    
    const treatmentData = {
      consultationID: consultationId,
      patientID: patientId,
      treatmentType: formData.get('treatmentType'),
      treatmentName: formData.get('treatmentName'),
      description: formData.get('description'),
      treatmentProcedure: formData.get('treatmentProcedure'),
      duration: parseInt(formData.get('duration')),
      price: price,
      treatmentDate: new Date().toISOString().slice(0, 19), // Remove timezone info, keep only YYYY-MM-DDTHH:mm:ss
      status: 'In Progress',
      outcome: null,
      notes: ''
    };

    try {
      const response = await fetch(API_BASE + '/treatments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(treatmentData)
      });

      if (response.ok) {
        const result = await response.json();
        alert('Treatment started successfully! Treatment ID: ' + result.treatmentID);
        hideCreateTreatmentForm();
        loadTreatments();
      } else {
        const error = await response.json();
        alert('Error starting treatment: ' + error.error);
      }
    } catch (error) {
      alert('Error starting treatment: ' + error.message);
    }
  });



  // Load treatments for this consultation
  async function loadTreatments() {
    try {
      const response = await fetch(API_BASE + '/treatments/by-consultation/' + consultationId);
      
      if (!response.ok) {
        console.error('Treatment API error:', response.status, response.statusText);
        return;
      }
      
      if (response.ok) {
        let treatmentsData;
        try {
          treatmentsData = await response.json();
        } catch (jsonError) {
          console.error('Error parsing JSON response:', jsonError);
          return;
        }
        
        // Handle different response formats
        let treatments = [];
        if (Array.isArray(treatmentsData)) {
          treatments = treatmentsData;
        } else if (treatmentsData && Array.isArray(treatmentsData.elements)) {
          treatments = treatmentsData.elements;
        } else if (treatmentsData && treatmentsData.elements) {
          treatments = [treatmentsData.elements]; // Single object wrapped in elements
        } else {
          treatments = [];
        }
        
        // Filter out null or invalid treatments
        treatments = treatments.filter(treatment => treatment && treatment.treatmentID);
        
        const tbody = document.getElementById('treatments-table-body');
        tbody.innerHTML = '';
        
        if (treatments.length === 0) {
          tbody.innerHTML = '<tr><td colspan="8" class="text-center text-gray-500">No treatments found for this consultation</td></tr>';
          // Hide treatments list
          document.getElementById('treatments-list').style.display = 'none';
          return;
        }
        
        treatments.forEach(treatment => {
          // Skip null or invalid treatment objects
          if (!treatment || !treatment.treatmentID) {
            console.warn('Skipping invalid treatment object:', treatment);
            return;
          }
          
          const row = document.createElement('tr');
          row.innerHTML = 
            '<td><a href="<%= request.getContextPath() %>/views/treatmentDetail.jsp?id=' + (treatment.treatmentID || 'N/A') + '" class="link link-primary hover:underline">' + (treatment.treatmentID || 'N/A') + '</a></td>' +
            '<td>' + (treatment.treatmentType || 'N/A') + '</td>' +
            '<td>' + (treatment.treatmentName || 'N/A') + '</td>' +
            '<td>' + getStatusBadge(treatment.status) + '</td>' +
            '<td>' + getOutcomeBadge(treatment.outcome) + '</td>' +
            '<td>' + (treatment.duration || 0) + ' min</td>' +
            '<td>RM ' + (treatment.price || 0).toFixed(2) + '</td>' +
            '<td>' + getTreatmentActions(treatment) + '</td>';
          tbody.appendChild(row);
        });
        
        // Show treatments list if there are treatments
        document.getElementById('treatments-list').style.display = 'block';
      }
    } catch (error) {
      console.error('Error loading treatments:', error);
    }
  }

  // Get status badge HTML
  function getStatusBadge(status) {
    const statusClasses = {
      'In Progress': 'badge badge-soft badge-warning',
      'Completed': 'badge badge-soft badge-success',
      'Cancelled': 'badge badge-soft badge-error',
      'On Hold': 'badge badge-soft badge-secondary'
    };
    const className = statusClasses[status] || 'badge badge-soft badge-secondary';
    return '<span class="' + className + '">' + (status || 'Unknown') + '</span>';
  }

  // Get outcome badge HTML
  function getOutcomeBadge(outcome) {
    if (!outcome) return '<span class="text-gray-400">N/A</span>';
    
    const outcomeClasses = {
      'Successful': 'badge badge-soft badge-success',
      'Partial Success': 'badge badge-soft badge-warning',
      'Unsuccessful': 'badge badge-soft badge-error',
      'Complications': 'badge badge-soft badge-error',
      'Patient Discontinued': 'badge badge-soft badge-secondary'
    };
    const className = outcomeClasses[outcome] || 'badge badge-soft badge-secondary';
    return '<span class="' + className + '">' + outcome + '</span>';
  }

  // Get treatment actions HTML
  function getTreatmentActions(treatment) {
    if (!treatment || !treatment.treatmentID) {
      return '<span class="text-gray-400">No actions available</span>';
    }
    
    let actions = '';
    
    if (treatment.status === 'In Progress') {
      actions += '<button class="btn btn-sm btn-primary mr-1" onclick="showUpdateProgressForm(\'' + treatment.treatmentID + '\')">Update Progress</button>';
    }
    
    actions += '<a href="<%= request.getContextPath() %>/views/treatmentDetail.jsp?id=' + treatment.treatmentID + '" class="btn btn-sm btn-info mr-1">View</a>';
    
    return actions;
  }

  // Show update progress form
  async function showUpdateProgressForm(treatmentId) {
    try {
      // Store treatment ID for the form
      window.currentTreatmentId = treatmentId;
      
      // Load current treatment data
      const response = await fetch(API_BASE + '/treatments/' + treatmentId);
      if (!response.ok) {
        throw new Error('Failed to load treatment data');
      }
      
      const treatment = await response.json();
      
      // Populate form with current values
      document.getElementById('progressStatus').value = treatment.status || 'In Progress';
      document.getElementById('progressOutcome').value = treatment.outcome || '';
      document.getElementById('progressNotes').value = treatment.notes || '';
      
      // Store current treatment data for update
      window.currentTreatmentData = treatment;
      
      // Show form
      document.getElementById('update-progress-form').style.display = 'block';
      
      // Scroll to form
      document.getElementById('update-progress-form').scrollIntoView({ behavior: 'smooth' });
      
    } catch (error) {
      console.error('Error loading treatment data:', error);
      alert('Error loading treatment data: ' + error.message);
    }
  }

  // Hide update progress form
  function hideUpdateProgressForm() {
    document.getElementById('update-progress-form').style.display = 'none';
    window.currentTreatmentId = null;
    window.currentTreatmentData = null;
    
    // Reset form
    document.getElementById('treatment-progress-form').reset();
  }

  // Handle treatment progress form submission
  document.getElementById('treatment-progress-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    if (!window.currentTreatmentId || !window.currentTreatmentData) {
      alert('No treatment selected');
      return;
    }
    
    const formData = new FormData(e.target);
    
          // Create update data by preserving existing treatment data and updating only specific fields
      const updateData = {
        // Preserve all existing treatment data
        treatmentID: window.currentTreatmentData.treatmentID,
        consultationID: window.currentTreatmentData.consultationID,
        patientID: window.currentTreatmentData.patientID,
        doctorID: window.currentTreatmentData.doctorID,
        treatmentType: window.currentTreatmentData.treatmentType,
        treatmentName: window.currentTreatmentData.treatmentName,
        description: window.currentTreatmentData.description,
        treatmentProcedure: window.currentTreatmentData.treatmentProcedure,
        treatmentDate: window.currentTreatmentData.treatmentDate,
        duration: window.currentTreatmentData.duration,
        price: window.currentTreatmentData.price,
        
        // Update only the progress-related fields
        status: formData.get('status'),
        outcome: formData.get('outcome') || null,
        notes: formData.get('notes')
      };

    try {
      const response = await fetch(API_BASE + '/treatments/' + window.currentTreatmentId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData)
      });

      if (response.ok) {
        alert('Treatment progress updated successfully!');
        hideUpdateProgressForm();
        loadTreatments(); // Reload treatments
      } else {
        const error = await response.json();
        alert('Error updating treatment progress: ' + error.error);
      }
    } catch (error) {
      alert('Error updating treatment progress: ' + error.message);
    }
  });

  // ===== FOLLOW-UP APPOINTMENT FUNCTIONS =====

  // Show create follow-up form
  function showCreateFollowupForm() {
    document.getElementById('create-followup-form').style.display = 'block';
    document.getElementById('create-followup-btn').style.display = 'none';
    setDefaultFollowupDate();
  }

  // Hide create follow-up form
  function cancelCreateFollowup() {
    document.getElementById('create-followup-form').style.display = 'none';
    document.getElementById('create-followup-btn').style.display = 'inline-block';
    document.getElementById('followup-form').reset();
  }

  // Set default follow-up date (7 days from today)
  function setDefaultFollowupDate() {
    const today = new Date();
    const followupDate = new Date(today);
    followupDate.setDate(today.getDate() + 7);
    
    const dateInput = document.getElementById('followup-appointment-date');
    dateInput.min = new Date(today.getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0]; // Tomorrow
    dateInput.value = followupDate.toISOString().split('T')[0];
    
    // Check availability for the default date
    checkFollowupAvailability();
  }



  // Time slots for followup appointments (8 AM to 8 PM, 30-minute intervals)
  const followupTimeSlots = [
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

  // Check followup availability for selected date
  async function checkFollowupAvailability() {
    const dateInput = document.getElementById('followup-appointment-date');
    const timeSelect = document.getElementById('followup-appointment-time');
    const availabilityInfo = document.getElementById('followup-availability-info');
    const submitButton = document.querySelector('#followup-form button[type="submit"]');
    
    if (!dateInput.value) {
      timeSelect.innerHTML = '<option value="">-- Select Time --</option>';
      availabilityInfo.textContent = '';
      return;
    }

    // Set loading state
    isCheckingAvailability = true;
    if (submitButton) {
      submitButton.disabled = true;
      submitButton.innerHTML = '<span class="loading loading-spinner loading-sm"></span> Checking Availability...';
    }
    availabilityInfo.textContent = 'Checking availability...';
    availabilityInfo.className = 'text-blue-600';

    try {
      // Get all appointments for the selected date
      const response = await fetch(API_BASE + '/appointments');
      if (!response.ok) {
        throw new Error('Failed to fetch appointments');
      }

      const data = await response.json();
      const appointments = data.elements || data || [];
      
      // Filter appointments for the selected date
      const selectedDate = dateInput.value;
      const selectedDateAppointments = appointments.filter(apt => {
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
      timeSelect.innerHTML = '<option value="">-- Select Time --</option>';
      
      let availableCount = 0;
      let totalCount = followupTimeSlots.length;
      
      followupTimeSlots.forEach(slot => {
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

      // Update availability info
      if (availableCount === 0) {
        availabilityInfo.textContent = 'No available time slots for this date. Please select another date.';
        availabilityInfo.className = 'text-red-600';
      } else {
        availabilityInfo.textContent = availableCount + ' of ' + totalCount + ' time slots have availability (max 2 patients per slot) for ' + formatDate(selectedDate);
        availabilityInfo.className = 'text-green-600';
      }

    } catch (error) {
      console.error('Error checking followup availability:', error);
      availabilityInfo.textContent = 'Error checking availability';
      availabilityInfo.className = 'text-red-600';
    } finally {
      // Reset loading state
      isCheckingAvailability = false;
      if (submitButton) {
        submitButton.disabled = false;
        submitButton.innerHTML = 'Schedule Follow-up';
      }
    }
  }

  // Format time slot for display (keeping for backward compatibility)
  function formatTimeSlot(timeSlot) {
    const [hours, minutes] = timeSlot.split(':');
    const hour = parseInt(hours);
    const ampm = hour >= 12 ? 'PM' : 'AM';
    const displayHour = hour > 12 ? hour - 12 : hour === 0 ? 12 : hour;
    return displayHour + ':' + minutes + ' ' + ampm;
  }

  // Format date for display
  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  }

  // Handle follow-up reason change
  function handleFollowupReasonChange() {
    const reasonSelect = document.getElementById('followup-reason');
    const otherContainer = document.getElementById('other-reason-container');
    const otherTextarea = document.getElementById('other-reason');
    
    if (reasonSelect.value === 'Other') {
      otherContainer.style.display = 'block';
      otherTextarea.focus();
    } else {
      otherContainer.style.display = 'none';
      otherTextarea.value = '';
    }
  }

  // Check for existing follow-up appointment
  async function checkFollowupData() {
    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId + '/followup');
      if (response.ok) {
        const followupData = await response.json();
        showFollowupInfo(followupData);
      }
    } catch (error) {
      console.log('No follow-up appointment found for this consultation');
    }
  }

  // Show follow-up information
  function showFollowupInfo(followupData) {
    document.getElementById('followup-info').style.display = 'grid';
    document.getElementById('create-followup-form').style.display = 'none';
    document.getElementById('create-followup-btn').style.display = 'none';
    document.getElementById('view-followup-btn').style.display = 'inline-block';
    
    populateFollowupInfo(followupData);
  }

  // Populate follow-up info
  function populateFollowupInfo(followupData) {
    document.getElementById('followupAppointmentId').value = followupData.appointmentID || '';
    document.getElementById('followupDate').value = followupData.appointmentDate || '';
    document.getElementById('followupTime').value = followupData.appointmentTime || '';
    document.getElementById('followupDoctor').value = followupData.doctorName || '';
    document.getElementById('followupReason').value = followupData.reason || '';
  }

  // View follow-up appointment
  function viewFollowup() {
    // Get the appointment ID from the follow-up info
    const appointmentId = document.getElementById('followupAppointmentId').value;
    if (appointmentId) {
      window.open('<%= request.getContextPath() %>/views/appointmentDetail.jsp?from=consultation&id=' + appointmentId, '_blank');
    } else {
      alert('No follow-up appointment found');
    }
  }

  // Handle follow-up form submission
  document.getElementById('followup-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Check if availability is still being fetched
    if (isCheckingAvailability) {
      alert('Please wait while availability is being checked. You cannot schedule a follow-up appointment at this time.');
      return;
    }

    // Get reason value - if "Other" is selected, use the textarea value
    const reasonSelect = document.getElementById('followup-reason');
    const otherReason = document.getElementById('other-reason').value;
    const reason = reasonSelect.value === 'Other' ? otherReason : reasonSelect.value;

    // Combine date and time into appointmentTime
    const appointmentDate = document.getElementById('followup-appointment-date').value;
    const appointmentTime = document.getElementById('followup-appointment-time').value;
    
    // Validate that a time slot is selected
    if (!appointmentTime) {
      alert('Please select a time slot for the follow-up appointment.');
      document.getElementById('followup-appointment-time').focus();
      return;
    }
    
    const combinedDateTime = appointmentDate + 'T' + appointmentTime + ':00';

    const formData = {
      patientID: patientId,
      appointmentTime: combinedDateTime,
      status: 'Scheduled',
      reason: reason,
      description: document.getElementById('followup-notes').value || 'Follow-up appointment'
    };

    try {
      const response = await fetch(API_BASE + '/appointments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        const result = await response.json();
        alert('Follow-up appointment scheduled successfully! Appointment ID: ' + result.appointmentID);
        
        // Update consultation to link with the follow-up appointment
        await updateConsultationFollowupStatus(true, result.appointmentID);
        
        // Refresh consultation data to include the new appointmentID
        await loadConsultationData();
        
        cancelCreateFollowup();
        await checkFollowupData();
      } else {
        const error = await response.json();
        alert('Error scheduling follow-up appointment: ' + error.error);
      }
    } catch (error) {
      alert('Error scheduling follow-up appointment: ' + error.message);
    }
  });

  // Update consultation follow-up status
  async function updateConsultationFollowupStatus(isRequired, appointmentId = null) {
    try {
      // Get current consultation data first
      const consultationResponse = await fetch(API_BASE + '/consultations/' + consultationId);
      if (!consultationResponse.ok) {
        console.error('Failed to get current consultation data');
        return;
      }
      
      const currentConsultation = await consultationResponse.json();
      
              // Update only the follow-up fields while preserving all other data
        const updateData = {
          consultationID: currentConsultation.consultationID,
          patientID: currentConsultation.patientID,
          doctorID: currentConsultation.doctorID,
          staffID: currentConsultation.staffID,
          billID: currentConsultation.billID,
          symptoms: currentConsultation.symptoms,
          diagnosis: currentConsultation.diagnosis,
          consultationDate: currentConsultation.consultationDate,
          checkInTime: currentConsultation.checkInTime,
          status: currentConsultation.status,
          mcID: currentConsultation.mcID,
          startDate: currentConsultation.startDate,
          endDate: currentConsultation.endDate,
          isFollowUpRequired: isRequired,
          appointmentID: appointmentId || currentConsultation.appointmentID
        };

      const response = await fetch(API_BASE + '/consultations/' + consultationId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData)
      });

      if (!response.ok) {
        console.error('Failed to update consultation follow-up status');
      }
    } catch (error) {
      console.error('Error updating consultation follow-up status:', error);
    }
  }

  // Update cancel button visibility based on consultation status
  function updateCancelButtonVisibility() {
    const cancelBtn = document.getElementById('cancelConsultationBtn');
    const currentStatus = consultationData.status;
    
    // Show cancel button only for consultations that can be cancelled
    if (currentStatus && ['Waiting', 'In Progress'].includes(currentStatus)) {
      cancelBtn.style.display = 'inline-flex';
    } else {
      cancelBtn.style.display = 'none';
    }
  }

  // Cancel consultation
  async function cancelConsultation() {
    if (!confirm('Are you sure you want to cancel this consultation? This action cannot be undone.')) {
      return;
    }

    try {
      // Update consultation status to Cancelled
      const updateData = {
        consultationID: consultationId,
        patientID: consultationData.patientID,
        doctorID: consultationData.doctorID,
        staffID: consultationData.staffID,
        billID: consultationData.billID,
        symptoms: consultationData.symptoms,
        diagnosis: consultationData.diagnosis,
        consultationDate: consultationData.consultationDate,
        checkInTime: consultationData.checkInTime,
        status: 'Cancelled', // Set status to Cancelled
        mcID: consultationData.mcID,
        startDate: consultationData.startDate,
        endDate: consultationData.endDate,
        isFollowUpRequired: consultationData.isFollowUpRequired,
        appointmentID: consultationData.appointmentID
      };

      const response = await fetch(API_BASE + '/consultations/' + consultationId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData)
      });

      if (!response.ok) {
        throw new Error('Failed to cancel consultation');
      }

      alert('Consultation cancelled successfully!');
      
      // Reload consultation data to reflect the change
      await loadConsultationData();
      
      // Update cancel button visibility
      updateCancelButtonVisibility();

    } catch (error) {
      console.error('Error cancelling consultation:', error);
      alert('Error cancelling consultation: ' + error.message);
    }
  }

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', function() {
    setBackButtonText();
    loadConsultationData();
    
    // Add event listener for followup date to check availability
    const followupDateInput = document.getElementById('followup-appointment-date');
    if (followupDateInput) {
      followupDateInput.addEventListener('change', checkFollowupAvailability);
    }
  });
</script>
</body>
</html>
