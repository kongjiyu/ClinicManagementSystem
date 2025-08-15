<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Medicine Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center">
    <h1 class="text-2xl font-bold" id="pageTitle">Medicine Detail</h1>
    <div class="flex gap-2">
      <button id="editBtn" class="btn btn-primary" onclick="toggleEditMode()">
        <span class="icon-[tabler--edit] size-4"></span>
        Edit
      </button>
      <button id="saveBtn" class="btn btn-success hidden" onclick="saveMedicine()">
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

  <div id="medicineContent" class="hidden">
    <form id="medicineForm" class="space-y-6">
      <!-- Basic Information -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Medicine Information</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Medicine ID</span>
              </label>
              <input type="text" id="medicineID" class="input input-bordered" readonly>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Medicine Name *</span>
              </label>
              <input type="text" id="medicineName" class="input input-bordered" required disabled>
            </div>
            <div class="form-control md:col-span-2">
              <label class="label">
                <span class="label-text">Description</span>
              </label>
              <textarea id="description" class="textarea textarea-bordered" rows="3" disabled></textarea>
            </div>
          </div>
        </div>
      </div>

      <!-- Stock Information -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Stock Information</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Total Stock *</span>
              </label>
              <input type="number" id="totalStock" class="input input-bordered" min="0" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Reorder Level *</span>
              </label>
              <input type="number" id="reorderLevel" class="input input-bordered" min="0" required disabled>
            </div>
            <div class="form-control">
              <label class="label">
                <span class="label-text">Selling Price *</span>
              </label>
              <div class="input-group">
                <span class="input-group-text">$</span>
                <input type="number" id="sellingPrice" class="input input-bordered" min="0" step="0.01" required disabled>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Stock Status Display -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h2 class="card-title">Stock Status</h2>
          <div class="flex items-center gap-4">
            <div class="stat">
              <div class="stat-title">Current Stock</div>
              <div class="stat-value text-primary" id="currentStockDisplay">0</div>
            </div>
            <div class="stat">
              <div class="stat-title">Reorder Level</div>
              <div class="stat-value text-secondary" id="reorderLevelDisplay">0</div>
            </div>
            <div class="stat">
              <div class="stat-title">Status</div>
              <div class="stat-value" id="stockStatusDisplay">
                <span class="badge badge-soft badge-neutral">Unknown</span>
              </div>
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
  let medicineData = null;
  let originalData = null;
  let isNewMedicine = false;

  // Get medicine ID from URL parameter
  function getMedicineId() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('id');
  }

  // Load medicine data
  async function loadMedicineData() {
    const medicineId = getMedicineId();
    
    if (!medicineId) {
      // New medicine
      isNewMedicine = true;
      document.getElementById('pageTitle').textContent = 'Add New Medicine';
      document.getElementById('editBtn').textContent = 'Create Medicine';
      document.getElementById('editBtn').innerHTML = '<span class="icon-[tabler--plus] size-4"></span>Create Medicine';
      populateForm();
      hideLoading();
      toggleEditMode(); // Start in edit mode for new medicine
      return;
    }

    try {
      const response = await fetch(API_BASE + '/medicine/' + medicineId);
      if (!response.ok) {
        throw new Error('Failed to fetch medicine data');
      }
      
      medicineData = await response.json();
      originalData = JSON.parse(JSON.stringify(medicineData)); // Deep copy for comparison
      populateForm();
      updateStockStatus();
      hideLoading();
    } catch (error) {
      console.error('Error loading medicine data:', error);
      showError('Failed to load medicine data: ' + error.message);
    }
  }

  // Populate form with medicine data
  function populateForm() {
    if (!medicineData && !isNewMedicine) return;

    document.getElementById('medicineID').value = medicineData?.medicineID || '';
    document.getElementById('medicineName').value = medicineData?.medicineName || '';
    document.getElementById('description').value = medicineData?.description || '';
    document.getElementById('totalStock').value = medicineData?.totalStock || 0;
    document.getElementById('reorderLevel').value = medicineData?.reorderLevel || 0;
    document.getElementById('sellingPrice').value = medicineData?.sellingPrice || 0.00;
  }

  // Update stock status display
  function updateStockStatus() {
    if (!medicineData) return;

    const stock = medicineData.totalStock || 0;
    const reorderLevel = medicineData.reorderLevel || 0;

    document.getElementById('currentStockDisplay').textContent = stock;
    document.getElementById('reorderLevelDisplay').textContent = reorderLevel;

    let statusBadge = '';
    if (stock === 0) {
      statusBadge = '<span class="badge badge-soft badge-error">Out of Stock</span>';
    } else if (stock <= reorderLevel) {
      statusBadge = '<span class="badge badge-soft badge-warning">Low Stock</span>';
    } else {
      statusBadge = '<span class="badge badge-soft badge-success">In Stock</span>';
    }

    document.getElementById('stockStatusDisplay').innerHTML = statusBadge;
  }

  // Toggle edit mode
  function toggleEditMode() {
    const form = document.getElementById('medicineForm');
    const inputs = form.querySelectorAll('input, textarea');
    const editBtn = document.getElementById('editBtn');
    const saveBtn = document.getElementById('saveBtn');
    const cancelBtn = document.getElementById('cancelBtn');

    // Enable/disable form fields
    inputs.forEach(input => {
      if (input.id !== 'medicineID') { // Keep medicine ID readonly
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
    if (isNewMedicine) {
      window.history.back();
      return;
    }

    medicineData = JSON.parse(JSON.stringify(originalData)); // Restore original data
    populateForm();
    updateStockStatus();
    toggleEditMode();
    hideAlerts();
  }

  // Save medicine data
  async function saveMedicine() {
    if (!validateForm()) {
      return;
    }

    const formData = collectFormData();
    const url = isNewMedicine ? API_BASE + '/medicine' : API_BASE + '/medicine/' + medicineData.medicineID;
    const method = isNewMedicine ? 'POST' : 'PUT';
    
    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to save medicine');
      }

      const savedMedicine = await response.json();
      medicineData = savedMedicine;
      originalData = JSON.parse(JSON.stringify(medicineData));
      
      if (isNewMedicine) {
        // Redirect to the detail page with the new ID
        window.location.href = '<%= request.getContextPath() %>/views/medicineDetail.jsp?id=' + savedMedicine.medicineID;
        return;
      }
      
      showSuccess('Medicine information updated successfully');
      toggleEditMode();
      updateStockStatus();
    } catch (error) {
      console.error('Error saving medicine data:', error);
      showError('Failed to save medicine data: ' + error.message);
    }
  }

  // Collect form data
  function collectFormData() {
    const formData = {
      medicineName: document.getElementById('medicineName').value,
      description: document.getElementById('description').value,
      totalStock: parseInt(document.getElementById('totalStock').value) || 0,
      reorderLevel: parseInt(document.getElementById('reorderLevel').value) || 0,
      sellingPrice: parseFloat(document.getElementById('sellingPrice').value) || 0.00
    };

    if (!isNewMedicine) {
      formData.medicineID = document.getElementById('medicineID').value;
    }

    return formData;
  }

  // Validate form
  function validateForm() {
    const requiredFields = ['medicineName', 'totalStock', 'reorderLevel', 'sellingPrice'];

    for (const fieldId of requiredFields) {
      const field = document.getElementById(fieldId);
      if (!field.value.trim()) {
        showError(field.previousElementSibling.textContent.replace(' *', '') + ' is required');
        field.focus();
        return false;
      }
    }

    // Validate numeric fields
    const totalStock = parseInt(document.getElementById('totalStock').value);
    const reorderLevel = parseInt(document.getElementById('reorderLevel').value);
    const sellingPrice = parseFloat(document.getElementById('sellingPrice').value);

    if (totalStock < 0) {
      showError('Total stock cannot be negative');
      document.getElementById('totalStock').focus();
      return false;
    }

    if (reorderLevel < 0) {
      showError('Reorder level cannot be negative');
      document.getElementById('reorderLevel').focus();
      return false;
    }

    if (sellingPrice < 0) {
      showError('Selling price cannot be negative');
      document.getElementById('sellingPrice').focus();
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
    document.getElementById('medicineContent').classList.remove('hidden');
  }

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    loadMedicineData();
  });
</script>
</body>
</html>
