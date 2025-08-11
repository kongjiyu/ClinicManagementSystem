<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 24/07/2025
  Time: 11:51 PM
  To change this template use File | Settings | File Templates.
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
  <h1 class="text-3xl font-bold">Consultation Detail</h1>

  <!-- Patient Basic Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Patient Basic Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label class="label">Patient Name</label>
        <input type="text" id="patientName" class="input input-bordered w-full" readonly />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" id="age" class="input input-bordered w-full" readonly />
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
        <input type="text" id="allergies" class="input input-bordered w-full" readonly />
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
          <input type="text" id="consultationId" name="consultationId" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label" for="consultationDate">Consultation Date</label>
          <input type="date" id="consultationDate" name="consultationDate" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label" for="symptoms">Symptoms</label>
          <textarea id="symptoms" name="symptoms" class="textarea textarea-bordered w-full" rows="3"></textarea>
        </div>
        <div>
          <label class="label" for="diagnosis">Diagnosis</label>
          <textarea id="diagnosis" name="diagnosis" class="textarea textarea-bordered w-full" rows="3"></textarea>
        </div>
        <div>
          <label class="label" for="status">Status</label>
          <select id="status" name="status" class="select select-bordered w-full">
            <option value="Waiting">Waiting</option>
            <option value="In Progress">In Progress</option>
            <option value="Completed">Completed</option>
            <option value="Cancelled">Cancelled</option>
          </select>
        </div>
        <div>
          <label class="label" for="isFollowUpRequired">Follow-up Required</label>
          <select id="isFollowUpRequired" name="isFollowUpRequired" class="select select-bordered w-full" onchange="toggleFollowUpDate()">
            <option value="false">No</option>
            <option value="true">Yes</option>
          </select>
        </div>
        <div id="followUpDateDiv" style="display: none;">
          <label class="label" for="followUpDate">Follow-up Date</label>
          <input type="date" id="followUpDate" name="followUpDate" class="input input-bordered w-full" />
        </div>
      </div>
      <div class="flex justify-end mt-6">
        <button type="submit" class="btn btn-primary">Save Consultation</button>
      </div>
    </form>
  </section>

  <!-- Medical Certificate Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <div class="flex justify-between items-center">
      <h2 class="text-xl font-semibold mb-2">Medical Certificate</h2>
      <div class="flex gap-2">
        <button id="create-mc-btn" class="btn btn-primary" onclick="openCreateMCModal()">Create MC</button>
        <button id="view-mc-btn" class="btn btn-secondary" onclick="viewMC()" style="display: none;">View MC</button>
      </div>
    </div>

    <div id="mc-info" class="grid grid-cols-1 md:grid-cols-2 gap-4" style="display: none;">
      <div>
        <label class="label">MC ID</label>
        <input type="text" id="mcId" class="input input-bordered w-full" readonly />
      </div>
      <div>
        <label class="label">Start Date</label>
        <input type="date" id="mcStartDate" class="input input-bordered w-full" readonly />
      </div>
      <div>
        <label class="label">End Date</label>
        <input type="date" id="mcEndDate" class="input input-bordered w-full" readonly />
      </div>
      <div class="md:col-span-2">
        <label class="label">Diagnosis</label>
        <input type="text" id="mcDiagnosis" class="input input-bordered w-full" readonly />
      </div>
      <div class="md:col-span-2">
        <label class="label">Symptoms</label>
        <input type="text" id="mcSymptoms" class="input input-bordered w-full" readonly />
      </div>
    </div>
  </section>
</main>

<!-- Create MC Modal -->
<div id="create-mc-modal" class="overlay modal modal-middle hidden" role="dialog" tabindex="-1">
  <div class="modal-dialog max-w-lg w-full">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">Create Medical Certificate</h3>
        <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" onclick="closeCreateMCModal()">
          <span class="icon-[tabler--x] size-4"></span>
        </button>
      </div>
      <form id="mc-form">
        <div class="modal-body space-y-4">
          <div>
            <label class="label">Start Date</label>
            <input type="date" id="mc-start-date" name="startDate" class="input input-bordered w-full" required />
          </div>
          <div>
            <label class="label">End Date</label>
            <input type="date" id="mc-end-date" name="endDate" class="input input-bordered w-full" required />
          </div>
          <div>
            <label class="label">Additional Notes (Optional)</label>
            <textarea id="mc-description" name="description" class="textarea textarea-bordered w-full" rows="4" placeholder="Enter additional medical certificate notes (optional)..."></textarea>
            <small class="text-xs text-base-content/60">Diagnosis and symptoms from the consultation will be automatically included in the MC.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-soft btn-secondary" onclick="closeCreateMCModal()">Cancel</button>
          <button type="submit" class="btn btn-primary">Create MC</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let consultationId = '';
  let consultationData = {};
  let patientData = {};

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

      // Populate consultation form
      populateConsultationForm();

      // Check for MC data
      await checkMCData();

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
    document.getElementById('diagnosis').value = consultationData.diagnosis || '';
    document.getElementById('status').value = consultationData.status || 'Waiting';
    document.getElementById('isFollowUpRequired').value = consultationData.isFollowUpRequired || 'false';
    
    if (consultationData.followUpDate) {
      document.getElementById('followUpDate').value = consultationData.followUpDate;
      document.getElementById('followUpDateDiv').style.display = 'block';
    }
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

  // Toggle follow-up date visibility
  function toggleFollowUpDate() {
    const followUpRequired = document.getElementById('isFollowUpRequired').value;
    const followUpDateDiv = document.getElementById('followUpDateDiv');
    followUpDateDiv.style.display = followUpRequired === 'true' ? 'block' : 'none';
  }

  // Open create MC modal
  function openCreateMCModal() {
    document.getElementById('create-mc-modal').classList.remove('hidden');
  }

  // Close create MC modal
  function closeCreateMCModal() {
    document.getElementById('create-mc-modal').classList.add('hidden');
    document.getElementById('mc-form').reset();
  }

  // View MC
  function viewMC() {
    window.open('<%= request.getContextPath() %>/views/mcDetail.jsp?consultationId=' + consultationId, '_blank');
  }

  // Handle consultation form submission
  document.getElementById('consultation-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    const formData = {
      consultationID: consultationId,
      consultationDate: document.getElementById('consultationDate').value,
      symptoms: document.getElementById('symptoms').value,
      diagnosis: document.getElementById('diagnosis').value,
      status: document.getElementById('status').value,
      isFollowUpRequired: document.getElementById('isFollowUpRequired').value === 'true',
      followUpDate: document.getElementById('followUpDate').value || null
    };

    try {
      const response = await fetch(API_BASE + '/consultations/' + consultationId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        alert('Consultation updated successfully!');
        await loadConsultationData(); // Reload data
      } else {
        const error = await response.json();
        alert('Error updating consultation: ' + error.error);
      }
    } catch (error) {
      alert('Error updating consultation: ' + error.message);
    }
  });

  // Handle MC form submission
  document.getElementById('mc-form').addEventListener('submit', async function(e) {
    e.preventDefault();

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
        closeCreateMCModal();
        await checkMCData(); // Reload MC data
      } else {
        const error = await response.json();
        alert('Error creating MC: ' + error.error);
      }
    } catch (error) {
      alert('Error creating MC: ' + error.message);
    }
  });

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', loadConsultationData);
</script>
</body>
</html>
