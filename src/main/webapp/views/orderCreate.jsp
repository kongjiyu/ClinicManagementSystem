<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Order</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Create New Order</h1>
    <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/orderList.jsp'">
      <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
      Back to Orders
    </button>
  </div>

  <div class="bg-base-200 rounded-lg p-6 shadow">
    <form id="orderForm" class="space-y-6">
      <!-- Medicine Selection -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="label">Medicine *</label>
          <select id="medicineId" name="medicineId" class="select select-bordered w-full" required>
            <option value="">Select Medicine</option>
          </select>
        </div>
        <div>
          <label class="label">Supplier *</label>
          <select id="supplierId" name="supplierId" class="select select-bordered w-full" required>
            <option value="">Select Supplier</option>
          </select>
        </div>
      </div>

      <!-- Order Details -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div>
          <label class="label">Quantity *</label>
          <input type="number" id="quantity" name="quantity" class="input input-bordered w-full" 
                 min="1" required onchange="calculateTotal()">
        </div>
        <div>
          <label class="label">Unit Price (RM) *</label>
          <input type="number" id="unitPrice" name="unitPrice" class="input input-bordered w-full" 
                 min="0" step="0.01" required onchange="calculateTotal()">
        </div>
        <div>
          <label class="label">Total Amount (RM)</label>
          <input type="number" id="totalAmount" name="totalAmount" class="input input-bordered w-full" 
                 readonly>
        </div>
      </div>



      <!-- Submit Buttons -->
      <div class="flex gap-4 pt-6">
        <button type="submit" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4 mr-2"></span>
          Create Order
        </button>
        <button type="button" class="btn btn-outline" onclick="resetForm()">
          <span class="icon-[tabler--refresh] size-4 mr-2"></span>
          Reset Form
        </button>
      </div>
    </form>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let medicines = [];
  let suppliers = [];
  let currentStaffId = null;

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    getCurrentStaffId();
    loadMedicines();
    loadSuppliers();
  });

  // Get current staff ID from session
  async function getCurrentStaffId() {
    try {
      const response = await fetch(API_BASE + '/auth/session');
      if (response.ok) {
        const session = await response.json();
        if (session.authenticated && session.userType === 'staff' && session.userId) {
          currentStaffId = session.userId;
        } else {
          console.warn('User not authenticated as staff or no staff ID found');
          currentStaffId = 'ST001'; // Fallback
        }
      } else {
        console.warn('Failed to get session, using fallback staff ID');
        currentStaffId = 'ST001'; // Fallback
      }
    } catch (error) {
      console.error('Error getting staff ID from session:', error);
      currentStaffId = 'ST001'; // Fallback
    }
  }

  // Load medicines for dropdown
  async function loadMedicines() {
    try {
      const response = await fetch(API_BASE + '/medicines');
      if (!response.ok) {
        throw new Error('Failed to load medicines');
      }

      const data = await response.json();
      medicines = data.elements || data; // Handle both elements wrapper and direct array
      const medicineSelect = document.getElementById('medicineId');
      
      medicines.forEach(medicine => {
        const option = document.createElement('option');
        option.value = medicine.medicineID;
        option.textContent = medicine.medicineName + ' (Stock: ' + medicine.totalStock + ')';
        medicineSelect.appendChild(option);
      });

    } catch (error) {
      console.error('Error loading medicines:', error);
      alert('Error loading medicines: ' + error.message);
    }
  }

  // Load suppliers for dropdown
  async function loadSuppliers() {
    try {
      const response = await fetch(API_BASE + '/suppliers');
      if (!response.ok) {
        throw new Error('Failed to load suppliers');
      }

      const data = await response.json();
      suppliers = data.elements || data; // Handle both elements wrapper and direct array
      const supplierSelect = document.getElementById('supplierId');
      
      suppliers.forEach(supplier => {
        const option = document.createElement('option');
        option.value = supplier.supplierId;
        option.textContent = supplier.supplierName;
        supplierSelect.appendChild(option);
      });

    } catch (error) {
      console.error('Error loading suppliers:', error);
      alert('Error loading suppliers: ' + error.message);
    }
  }

  // Calculate total amount
  function calculateTotal() {
    const quantity = parseFloat(document.getElementById('quantity').value) || 0;
    const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
    const total = quantity * unitPrice;
    document.getElementById('totalAmount').value = total.toFixed(2);
  }

  // Reset form
  function resetForm() {
    document.getElementById('orderForm').reset();
    document.getElementById('totalAmount').value = '';
  }

  // Handle form submission
  document.getElementById('orderForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Validate form
    if (!validateForm()) {
      return;
    }

    // Get form data
    const formData = new FormData(e.target);
    const quantity = parseInt(formData.get('quantity'));
    const orderData = {
      medicineID: formData.get('medicineId'),
      supplierID: formData.get('supplierId'),
      staffID: currentStaffId || 'ST001', // Use current staff ID from session
      orderDate: new Date().toISOString().split('T')[0], // Set to today automatically
      orderStatus: 'Pending', // Always start with Pending
      unitPrice: parseFloat(formData.get('unitPrice')),
      quantity: quantity,
      totalAmount: parseFloat(formData.get('totalAmount')),
      expiryDate: null, // Will be set when medicine arrives
      stock: quantity // Initial stock equals quantity
    };

    try {
      const response = await fetch(API_BASE + '/orders', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(orderData)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to create order');
      }

      const result = await response.json();
      alert('Order created successfully! Order ID: ' + result.ordersID);
      
      // Redirect to order list
      window.location.href = '<%= request.getContextPath() %>/views/orderList.jsp';

    } catch (error) {
      console.error('Error creating order:', error);
      alert('Error creating order: ' + error.message);
    }
  });

  // Validate form
  function validateForm() {
    const medicineId = document.getElementById('medicineId').value;
    const supplierId = document.getElementById('supplierId').value;
    const quantity = document.getElementById('quantity').value;
    const unitPrice = document.getElementById('unitPrice').value;

    if (!medicineId) {
      alert('Please select a medicine');
      return false;
    }

    if (!supplierId) {
      alert('Please select a supplier');
      return false;
    }

    if (!quantity || quantity <= 0) {
      alert('Please enter a valid quantity');
      return false;
    }

    if (!unitPrice || unitPrice <= 0) {
      alert('Please enter a valid unit price');
      return false;
    }

    return true;
  }
</script>
</body>
</html>
