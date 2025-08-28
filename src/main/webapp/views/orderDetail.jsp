<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Order Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Order Detail</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/orderList.jsp'">
        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
        Back to Orders
      </button>
      <button class="btn btn-primary" onclick="editOrder()">
        <span class="icon-[tabler--edit] size-4 mr-2"></span>
        Edit Order
      </button>
    </div>
  </div>

  <div class="bg-base-200 rounded-lg p-6 shadow space-y-6 w-full">
    <!-- Order Information -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Order Information</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label">Order ID</label>
          <input type="text" id="orderId" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Order Status</label>
          <div id="orderStatus" class="badge badge-lg"></div>
        </div>
        <div>
          <label class="label">Order Date</label>
          <input type="text" id="orderDate" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Expiry Date</label>
          <input type="text" id="expiryDate" class="input input-bordered w-full" readonly />
        </div>
      </div>
    </div>

    <!-- Medicine Information -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Medicine Information</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label">Medicine Name</label>
          <input type="text" id="medicineName" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Medicine ID</label>
          <input type="text" id="medicineId" class="input input-bordered w-full" readonly />
        </div>
      </div>
    </div>

    <!-- Supplier Information -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Supplier Information</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label">Supplier Name</label>
          <input type="text" id="supplierName" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Supplier ID</label>
          <input type="text" id="supplierId" class="input input-bordered w-full" readonly />
        </div>
      </div>
    </div>

    <!-- Order Details -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Order Details</h2>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label class="label">Quantity</label>
          <input type="text" id="quantity" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Unit Price (RM)</label>
          <input type="text" id="unitPrice" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Total Amount (RM)</label>
          <input type="text" id="totalAmount" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Stock</label>
          <input type="text" id="stock" class="input input-bordered w-full" readonly />
        </div>
      </div>
    </div>

    <!-- Staff Information -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Staff Information</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label">Staff Name</label>
          <input type="text" id="staffName" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Staff ID</label>
          <input type="text" id="staffId" class="input input-bordered w-full" readonly />
        </div>
      </div>
    </div>

    <!-- Status Update Section -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Order Status Management</h2>
      
      <!-- Status Progression Buttons -->
      <div class="flex gap-4 mb-6">
        <button id="shipButton" class="btn btn-info" onclick="shipOrder()" style="display: none;">
          <span class="icon-[tabler--truck] size-4 mr-2"></span>
          Mark as Shipped
        </button>
        <button id="deliverButton" class="btn btn-success" onclick="deliverOrder()" style="display: none;">
          <span class="icon-[tabler--truck-delivery] size-4 mr-2"></span>
          Mark as Delivered
        </button>
        <button id="completeButton" class="btn btn-primary" onclick="completeOrder()" style="display: none;">
          <span class="icon-[tabler--check] size-4 mr-2"></span>
          Mark as Completed
        </button>
        <button id="cancelButton" class="btn btn-error" onclick="cancelOrder()" style="display: none;">
          <span class="icon-[tabler--x] size-4 mr-2"></span>
          Cancel Order
        </button>
      </div>

      <!-- Expiry Date Input (shown only when delivering) -->
      <div id="expiryDateSection" class="hidden">
        <div class="flex gap-4 items-end">
          <div class="flex-1">
            <label class="label">Expiry Date *</label>
            <input type="date" id="expiryDateInput" class="input input-bordered w-full" 
                   min="<%= java.time.LocalDate.now() %>" required>
          </div>
          <button class="btn btn-success" onclick="confirmDelivery()">
            <span class="icon-[tabler--check] size-4 mr-2"></span>
            Confirm Delivery
          </button>
        </div>
      </div>

      <!-- Status History -->
      <div class="mt-6">
        <h3 class="text-lg font-semibold mb-3">Status History</h3>
        <div id="statusHistory" class="space-y-2">
          <!-- Status history will be populated here -->
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let orderId = '';
  let orderData = {};

  // Get order ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  orderId = urlParams.get('id');

  if (!orderId) {
    alert('No order ID provided');
    window.location.href = '<%= request.getContextPath() %>/views/orderList.jsp';
  }

  // Load order data
  async function loadOrderData() {
    try {
      const response = await fetch(API_BASE + '/orders/' + orderId);
      if (!response.ok) {
        throw new Error('Failed to load order data');
      }

      const data = await response.json();
      orderData = data.elements || data; // Handle both elements wrapper and direct array
      populateOrderForm();

    } catch (error) {
      console.error('Error loading order data:', error);
      alert('Error loading order data: ' + error.message);
    }
  }

  // Populate order form
  function populateOrderForm() {
    if (!orderData) return;

    // Order Information
    document.getElementById('orderId').value = orderData.ordersID || '';
    document.getElementById('orderDate').value = orderData.orderDate ? new Date(orderData.orderDate).toLocaleDateString() : '';
    document.getElementById('expiryDate').value = orderData.expiryDate ? new Date(orderData.expiryDate).toLocaleDateString() : '';
    
    // Set status badge
    const statusElement = document.getElementById('orderStatus');
    statusElement.textContent = orderData.orderStatus || '';
    statusElement.className = 'badge badge-lg ' + getStatusBadgeClass(orderData.orderStatus);

    // Medicine Information
    document.getElementById('medicineName').value = orderData.medicineName || '';
    document.getElementById('medicineId').value = orderData.medicineID || '';

    // Supplier Information
    document.getElementById('supplierName').value = orderData.supplierName || '';
    document.getElementById('supplierId').value = orderData.supplierID || '';

    // Order Details
    document.getElementById('quantity').value = orderData.quantity || '';
    document.getElementById('unitPrice').value = 'RM ' + (orderData.unitPrice || 0).toFixed(2);
    document.getElementById('totalAmount').value = 'RM ' + (orderData.totalAmount || 0).toFixed(2);
    document.getElementById('stock').value = orderData.stock || '';

    // Staff Information
    document.getElementById('staffName').value = orderData.staffName || '';
    document.getElementById('staffId').value = orderData.staffID || '';

    // Update status buttons visibility
    updateStatusButtons();
    
    // Update status history
    updateStatusHistory();
  }

  // Get status badge class
  function getStatusBadgeClass(status) {
    const statusColors = {
      'Pending': 'badge-warning',
      'Shipped': 'badge-info',
      'Delivered': 'badge-success',
      'Completed': 'badge-primary',
      'Cancelled': 'badge-error'
    };
    return statusColors[status] || 'badge-neutral';
  }

  // Update status buttons visibility based on current status
  function updateStatusButtons() {
    const currentStatus = orderData.orderStatus;
    const shipButton = document.getElementById('shipButton');
    const deliverButton = document.getElementById('deliverButton');
    const completeButton = document.getElementById('completeButton');
    const cancelButton = document.getElementById('cancelButton');

    // Hide all buttons first
    shipButton.style.display = 'none';
    deliverButton.style.display = 'none';
    completeButton.style.display = 'none';
    cancelButton.style.display = 'none';

    // Show appropriate buttons based on current status
    switch (currentStatus) {
      case 'Pending':
        shipButton.style.display = 'inline-flex';
        cancelButton.style.display = 'inline-flex';
        break;
      case 'Shipped':
        deliverButton.style.display = 'inline-flex';
        cancelButton.style.display = 'inline-flex';
        break;
      case 'Delivered':
        completeButton.style.display = 'inline-flex';
        break;
      case 'Completed':
      case 'Cancelled':
        // No buttons shown for final states
        break;
    }
  }

  // Update status history display
  function updateStatusHistory() {
    const historyContainer = document.getElementById('statusHistory');
    const currentStatus = orderData.orderStatus;
    const orderDate = orderData.orderDate;
    
    let historyHTML = '';
    
    // Add order creation
    if (orderDate) {
      const formattedDate = new Date(orderDate).toLocaleDateString();
      historyHTML += '<div class="flex items-center gap-3 p-3 bg-base-100 rounded-lg">' +
        '<div class="badge badge-success">✓</div>' +
        '<div>' +
        '<div class="font-medium">Order Created</div>' +
        '<div class="text-sm text-base-content/70">' + formattedDate + '</div>' +
        '</div>' +
        '</div>';
    }

    // Add current status
    if (currentStatus && currentStatus !== 'Pending') {
      const statusBadgeClass = getStatusBadgeClass(currentStatus).replace('badge-', 'badge-');
      historyHTML += '<div class="flex items-center gap-3 p-3 bg-base-100 rounded-lg">' +
        '<div class="badge ' + statusBadgeClass + '">✓</div>' +
        '<div>' +
        '<div class="font-medium">Status: ' + currentStatus + '</div>' +
        '<div class="text-sm text-base-content/70">Updated</div>' +
        '</div>' +
        '</div>';
    }

    historyContainer.innerHTML = historyHTML;
  }

  // Ship order
  async function shipOrder() {
    if (!confirm('Are you sure you want to mark this order as shipped?')) {
      return;
    }

    try {
      const response = await fetch(API_BASE + '/orders/' + orderId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Shipped' })
      });

      if (!response.ok) {
        throw new Error('Failed to update order status');
      }

      alert('Order marked as shipped successfully');
      loadOrderData(); // Reload order data

    } catch (error) {
      console.error('Error updating order status:', error);
      alert('Error updating order status: ' + error.message);
    }
  }

  // Deliver order (show expiry date input)
  function deliverOrder() {
    document.getElementById('expiryDateSection').classList.remove('hidden');
    document.getElementById('expiryDateInput').focus();
  }

  // Confirm delivery with expiry date
  async function confirmDelivery() {
    const expiryDate = document.getElementById('expiryDateInput').value;
    
    if (!expiryDate) {
      alert('Please enter the expiry date');
      return;
    }

    const today = new Date();
    const expiry = new Date(expiryDate);
    if (expiry <= today) {
      alert('Expiry date must be in the future');
      return;
    }

    try {
      // Update order with status and expiry date
      const response = await fetch(API_BASE + '/orders/' + orderId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ordersID: orderId,
          medicineID: orderData.medicineID,
          supplierID: orderData.supplierID,
          staffID: orderData.staffID,
          orderDate: orderData.orderDate,
          orderStatus: 'Delivered',
          unitPrice: orderData.unitPrice,
          quantity: orderData.quantity,
          totalAmount: orderData.totalAmount,
          expiryDate: expiryDate,
          stock: orderData.stock
        })
      });

      if (!response.ok) {
        throw new Error('Failed to update order');
      }

      alert('Order delivered successfully');
      
      // Hide the expiry date section
      document.getElementById('expiryDateSection').classList.add('hidden');
      
      // Clear the expiry date input
      document.getElementById('expiryDateInput').value = '';
      
      loadOrderData(); // Reload order data

    } catch (error) {
      console.error('Error updating order:', error);
      alert('Error updating order: ' + error.message);
    }
  }

  // Complete order (after quantity check)
  async function completeOrder() {
    if (!confirm('Are you sure you want to mark this order as completed? This indicates that the quantity has been verified.')) {
      return;
    }

    try {
      const response = await fetch(API_BASE + '/orders/' + orderId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Completed' })
      });

      if (!response.ok) {
        throw new Error('Failed to update order status');
      }

      alert('Order marked as completed successfully');
      loadOrderData(); // Reload order data

    } catch (error) {
      console.error('Error updating order status:', error);
      alert('Error updating order status: ' + error.message);
    }
  }

  // Cancel order
  async function cancelOrder() {
    if (!confirm('Are you sure you want to cancel this order?')) {
      return;
    }

    try {
      const response = await fetch(API_BASE + '/orders/' + orderId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: 'Cancelled' })
      });

      if (!response.ok) {
        throw new Error('Failed to cancel order');
      }

      alert('Order cancelled successfully');
      loadOrderData(); // Reload order data

    } catch (error) {
      console.error('Error cancelling order:', error);
      alert('Error cancelling order: ' + error.message);
    }
  }

  // Edit order
  function editOrder() {
    window.location.href = '<%= request.getContextPath() %>/views/orderEdit.jsp?id=' + orderId;
  }

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', loadOrderData);
</script>
</body>
</html>
