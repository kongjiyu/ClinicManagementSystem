<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Order Management</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <!-- DataTables JS and CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
  <script src="https://cdn.datatables.net/2.3.2/js/dataTables.tailwindcss.js"></script>
  <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.tailwindcss.css" />
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center mb-4">
    <h1 class="text-2xl font-bold">Order Management</h1>
    <button class="btn btn-primary" onclick="showCreateOrderModal()">
      <span class="icon-[tabler--plus] size-4 mr-2"></span>
      Create Order
    </button>
  </div>
  <div class="overflow-x-auto">
    <table id="ordersTable" class="display">
      <thead>
        <tr>
          <th>Order ID</th>
          <th>Medicine</th>
          <th>Supplier</th>
          <th>Staff</th>
          <th>Order Date</th>
          <th>Status</th>
          <th>Quantity</th>
          <th>Total Amount</th>
        </tr>
      </thead>
      <tbody>
        <!-- Data will be populated by JavaScript -->
      </tbody>
    </table>
  </div>
</main>

<!-- Create Order Modal -->
<div id="createOrderModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
  <div class="bg-white rounded-lg p-6 w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-xl font-semibold">Create New Order</h2>
      <button onclick="hideCreateOrderModal()" class="text-gray-500 hover:text-gray-700">
        <span class="icon-[tabler--x] size-5"></span>
      </button>
    </div>
    
    <form id="createOrderForm" class="space-y-4">
      <!-- Medicine Selection -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label">Medicine *</label>
          <select id="modalMedicineId" name="medicineId" class="select select-bordered w-full" required>
            <option value="">Select Medicine</option>
          </select>
        </div>
        <div>
          <label class="label">Supplier *</label>
          <select id="modalSupplierId" name="supplierId" class="select select-bordered w-full" required>
            <option value="">Select Supplier</option>
          </select>
        </div>
      </div>

      <!-- Order Details -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label class="label">Quantity *</label>
          <input type="number" id="modalQuantity" name="quantity" class="input input-bordered w-full" 
                 min="1" required onchange="calculateModalTotal()">
        </div>
        <div>
          <label class="label">Unit Price (RM) *</label>
          <input type="number" id="modalUnitPrice" name="unitPrice" class="input input-bordered w-full" 
                 min="0" step="0.01" required onchange="calculateModalTotal()">
          <div id="priceInfo" class="text-sm text-gray-600 mt-1"></div>
        </div>
        <div>
          <label class="label">Total Amount (RM)</label>
          <input type="number" id="modalTotalAmount" name="totalAmount" class="input input-bordered w-full" 
                 readonly>
        </div>
      </div>

      <!-- Submit Buttons -->
      <div class="flex gap-4 pt-4 border-t">
        <button type="submit" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4 mr-2"></span>
          Create Order
        </button>
        <button type="button" class="btn btn-outline" onclick="resetModalForm()">
          <span class="icon-[tabler--refresh] size-4 mr-2"></span>
          Reset Form
        </button>
        <button type="button" class="btn btn-secondary" onclick="hideCreateOrderModal()">
          Cancel
        </button>
      </div>
    </form>
  </div>
</div>

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
      medicines = data.elements || data;
      const medicineSelect = document.getElementById('modalMedicineId');
      
      medicines.forEach(medicine => {
        const option = document.createElement('option');
        option.value = medicine.medicineID;
        option.textContent = medicine.medicineName + ' (Stock: ' + medicine.totalStock + ')';
        medicineSelect.appendChild(option);
      });

    } catch (error) {
      console.error('Error loading medicines:', error);
    }
  }

  // Get last order price for a medicine
  async function getLastOrderPrice(medicineId) {
    try {
      const response = await fetch(API_BASE + '/orders');
      if (!response.ok) {
        throw new Error('Failed to load orders');
      }

      const data = await response.json();
      const orders = data.elements || data || [];
      
      // Filter orders for this medicine and sort by order date (most recent first)
      const medicineOrders = orders
        .filter(order => order.medicineID === medicineId)
        .sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
      
      if (medicineOrders.length > 0) {
        return medicineOrders[0].unitPrice; // Return the most recent order's unit price
      }
      
      return null; // No previous orders found
    } catch (error) {
      console.error('Error getting last order price:', error);
      return null;
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
      suppliers = data.elements || data;
      const supplierSelect = document.getElementById('modalSupplierId');
      
      suppliers.forEach(supplier => {
        const option = document.createElement('option');
        option.value = supplier.supplierId;
        option.textContent = supplier.supplierName;
        supplierSelect.appendChild(option);
      });

    } catch (error) {
      console.error('Error loading suppliers:', error);
    }
  }

  // Show create order modal
  function showCreateOrderModal() {
    document.getElementById('createOrderModal').classList.remove('hidden');
    // Reset form when opening modal
    resetModalForm();
  }

  // Hide create order modal
  function hideCreateOrderModal() {
    document.getElementById('createOrderModal').classList.add('hidden');
    resetModalForm();
  }

  // Calculate total amount for modal
  function calculateModalTotal() {
    const quantity = parseFloat(document.getElementById('modalQuantity').value) || 0;
    const unitPrice = parseFloat(document.getElementById('modalUnitPrice').value) || 0;
    const total = quantity * unitPrice;
    document.getElementById('modalTotalAmount').value = total.toFixed(2);
  }

  // Reset modal form
  function resetModalForm() {
    document.getElementById('createOrderForm').reset();
    document.getElementById('modalTotalAmount').value = '';
    // Clear any previous price information
    const priceInfo = document.getElementById('priceInfo');
    if (priceInfo) {
      priceInfo.textContent = '';
      priceInfo.className = 'text-sm text-gray-600 mt-1';
    }
  }

  // Handle medicine selection change
  document.getElementById('modalMedicineId').addEventListener('change', async function(e) {
    const medicineId = e.target.value;
    if (medicineId) {
      const lastPrice = await getLastOrderPrice(medicineId);
      const priceInfo = document.getElementById('priceInfo');
      
      if (lastPrice !== null) {
        priceInfo.textContent = 'Last order price: RM ' + parseFloat(lastPrice).toFixed(2);
        priceInfo.className = 'text-sm text-blue-600 mt-1';
        
        // Auto-fill the unit price with the last order price
        document.getElementById('modalUnitPrice').value = parseFloat(lastPrice).toFixed(2);
        calculateModalTotal(); // Recalculate total
      } else {
        priceInfo.textContent = 'No previous orders found for this medicine';
        priceInfo.className = 'text-sm text-gray-500 mt-1';
        // Clear the unit price
        document.getElementById('modalUnitPrice').value = '';
        calculateModalTotal(); // Recalculate total
      }
    } else {
      // Clear price info when no medicine is selected
      const priceInfo = document.getElementById('priceInfo');
      priceInfo.textContent = '';
      priceInfo.className = 'text-sm text-gray-600 mt-1';
      document.getElementById('modalUnitPrice').value = '';
      calculateModalTotal(); // Recalculate total
    }
  });

  // Handle modal form submission
  document.getElementById('createOrderForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Validate form
    if (!validateModalForm()) {
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
      
      // Hide modal and refresh table
      hideCreateOrderModal();
      $('#ordersTable').DataTable().ajax.reload();

    } catch (error) {
      console.error('Error creating order:', error);
      alert('Error creating order: ' + error.message);
    }
  });

  // Validate modal form
  function validateModalForm() {
    const medicineId = document.getElementById('modalMedicineId').value;
    const supplierId = document.getElementById('modalSupplierId').value;
    const quantity = document.getElementById('modalQuantity').value;
    const unitPrice = document.getElementById('modalUnitPrice').value;

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

  new DataTable('#ordersTable', {
    ajax: {
      url: API_BASE + '/orders',
      dataSrc: 'elements'
    },
    columns: [
      { data: 'ordersID', title: 'Order ID' },
      { data: 'medicineName', title: 'Medicine' },
      { data: 'supplierName', title: 'Supplier' },
      { data: 'staffName', title: 'Staff' },
      { 
        data: 'orderDate', 
        title: 'Order Date',
        render: function(data, type, row) {
          if (!data) return 'N/A';
          try {
            const date = new Date(data);
            if (isNaN(date.getTime())) return 'N/A';
            
            // For sorting, return the original date string
            if (type === 'sort') {
              return data;
            }
            
            // For display, format as dd/mm/yyyy
            const day = date.getDate().toString().padStart(2, '0');
            const month = (date.getMonth() + 1).toString().padStart(2, '0');
            const year = date.getFullYear();
            
            return day + '/' + month + '/' + year;
          } catch (error) {
            console.error('Error formatting date:', error);
            return 'N/A';
          }
        },
        type: 'date'
      },
      { 
        data: 'orderStatus', 
        title: 'Status',
        render: function(data) {
          return getStatusBadge(data);
        }
      },
      { data: 'quantity', title: 'Quantity' },
      { 
        data: 'totalAmount', 
        title: 'Total Amount',
        render: function(data) {
          return 'RM ' + parseFloat(data).toFixed(2);
        }
      }
    ],
    rowCallback: function(row, data) {
      row.addEventListener('click', function() {
        window.location.href = '<%= request.getContextPath() %>/views/orderDetail.jsp?id=' + data.ordersID;
      });
      row.classList.add('cursor-pointer', 'hover:bg-gray-100');
    }
  });





  // Get status badge HTML
  function getStatusBadge(status) {
    const statusColors = {
              'Pending': 'badge badge-soft badge-warning',
        'Shipped': 'badge badge-soft badge-info',
        'Delivered': 'badge badge-soft badge-success',
        'Completed': 'badge badge-soft badge-primary',
        'Cancelled': 'badge badge-soft badge-error'
    };

    const color = statusColors[status] || 'badge badge-soft badge-neutral';
    return '<span class="' + color + '">' + status + '</span>';
  }




</script>
</body>
</html>
