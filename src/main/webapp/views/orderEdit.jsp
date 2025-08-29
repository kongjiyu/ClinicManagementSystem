<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Order</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8 w-full">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Edit Order</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/orderDetail.jsp?id=' + orderId">
        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
        Back to Order Detail
      </button>
      <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/orderList.jsp'">
        <span class="icon-[tabler--list] size-4 mr-2"></span>
        Back to Orders
      </button>
    </div>
  </div>

  <div class="bg-base-200 rounded-lg p-6 shadow space-y-6 w-full max-w-none">
    <form id="orderForm" class="space-y-6">
      <!-- Order ID (Read-only) -->
      <div>
        <label class="label">Order ID</label>
        <input type="text" id="orderId" class="input input-bordered w-full" readonly />
      </div>

      <!-- Medicine Selection (Read-only) -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="label">Medicine</label>
          <input type="text" id="medicineName" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Supplier</label>
          <input type="text" id="supplierName" class="input input-bordered w-full" readonly />
        </div>
      </div>

      <!-- Order Details (Read-only) -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div>
          <label class="label">Quantity</label>
          <input type="number" id="quantity" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Unit Price (RM)</label>
          <input type="number" id="unitPrice" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Total Amount (RM)</label>
          <input type="number" id="totalAmount" class="input input-bordered w-full" readonly />
        </div>
      </div>

      <!-- Dates -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="label">Order Date</label>
          <input type="text" id="orderDate" class="input input-bordered w-full" readonly />
        </div>
        <div>
          <label class="label">Expected Expiry Date</label>
          <input type="date" id="expiryDate" name="expiryDate" class="input input-bordered w-full" />
        </div>
      </div>

      <!-- Status Only -->
      <div>
        <label class="label">Order Status</label>
                  <select id="orderStatus" name="orderStatus" class="select select-bordered w-full">
            <option value="Pending">Pending</option>
            <option value="Shipped">Shipped</option>
            <option value="Delivered">Delivered</option>
            <option value="Completed">Completed</option>
            <option value="Cancelled">Cancelled</option>
          </select>
      </div>

      <!-- Submit Buttons -->
      <div class="flex gap-4 pt-6">
        <button type="submit" class="btn btn-primary">
          <span class="icon-[tabler--device-floppy] size-4 mr-2"></span>
          Update Order
        </button>
        <button type="button" class="btn btn-outline" onclick="resetToOriginal()">
          <span class="icon-[tabler--refresh] size-4 mr-2"></span>
          Reset to Original
        </button>
      </div>
    </form>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let orderId = '';
  let orderData = {};
  let originalOrderData = {};
  let medicines = [];
  let suppliers = [];

  // Get order ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  orderId = urlParams.get('id');

  if (!orderId) {
    alert('No order ID provided');
    window.location.href = '<%= request.getContextPath() %>/views/orderList.jsp';
  }

  // Initialize page
  // Format date to dd/mm/yyyy
  function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return day + '/' + month + '/' + year;
  }

  document.addEventListener('DOMContentLoaded', function() {
    loadOrderData();
  });



  // Load order data
  async function loadOrderData() {
    try {
      const response = await fetch(API_BASE + '/orders/' + orderId);
      if (!response.ok) {
        throw new Error('Failed to load order data');
      }

      const data = await response.json();
      orderData = data.elements || data; // Handle both elements wrapper and direct array
      originalOrderData = JSON.parse(JSON.stringify(orderData)); // Deep copy
      populateOrderForm();

    } catch (error) {
      console.error('Error loading order data:', error);
      alert('Error loading order data: ' + error.message);
    }
  }

  // Populate order form
  function populateOrderForm() {
    if (!orderData) return;

    // Order ID (read-only)
    document.getElementById('orderId').value = orderData.ordersID || '';

    // Medicine and Supplier names (read-only)
    document.getElementById('medicineName').value = orderData.medicineName || '';
    document.getElementById('supplierName').value = orderData.supplierName || '';

    // Order Details (read-only)
    document.getElementById('quantity').value = orderData.quantity || '';
    document.getElementById('unitPrice').value = orderData.unitPrice || '';
    document.getElementById('totalAmount').value = orderData.totalAmount || '';

    // Dates
    if (orderData.orderDate) {
      document.getElementById('orderDate').value = formatDate(orderData.orderDate);
    }
    if (orderData.expiryDate) {
      // Convert to YYYY-MM-DD format for date input
      const expiryDate = new Date(orderData.expiryDate);
      document.getElementById('expiryDate').value = expiryDate.toISOString().split('T')[0];
    }

    // Status
    document.getElementById('orderStatus').value = orderData.orderStatus || 'Pending';
  }



  // Reset to original data
  function resetToOriginal() {
    if (confirm('Are you sure you want to reset all changes?')) {
      orderData = JSON.parse(JSON.stringify(originalOrderData));
      populateOrderForm();
    }
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
    const orderData = {
      ordersID: orderId,
      medicineID: originalOrderData.medicineID, // Keep original values
      supplierID: originalOrderData.supplierID,
      staffID: originalOrderData.staffID,
      orderDate: originalOrderData.orderDate,
      orderStatus: formData.get('orderStatus'), // Status can be changed
      unitPrice: originalOrderData.unitPrice,
      quantity: originalOrderData.quantity,
      totalAmount: originalOrderData.totalAmount,
      expiryDate: formData.get('expiryDate'), // Expiry date can be changed
      stock: originalOrderData.stock
    };

    try {
      const response = await fetch(API_BASE + '/orders/' + orderId, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(orderData)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to update order');
      }

      const result = await response.json();
      alert('Order updated successfully!');
      
      // Redirect to order detail
      window.location.href = '<%= request.getContextPath() %>/views/orderDetail.jsp?id=' + orderId;

    } catch (error) {
      console.error('Error updating order:', error);
      alert('Error updating order: ' + error.message);
    }
  });

  // Validate form
  function validateForm() {
    const orderStatus = document.getElementById('orderStatus').value;

    if (!orderStatus) {
      alert('Please select an order status');
      return false;
    }

    return true;
  }
</script>
</body>
</html>
