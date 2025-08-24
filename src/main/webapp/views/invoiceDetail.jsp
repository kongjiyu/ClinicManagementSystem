<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Invoice Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Invoice Detail</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="goBack()">
        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
        <span id="backButtonText">Back</span>
      </button>
      <button class="btn btn-primary" onclick="printInvoice()">
        <span class="icon-[tabler--printer] size-4 mr-2"></span>
        Print Invoice
      </button>
    </div>
  </div>



  <!-- Patient Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-4">Patient Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label class="label">Patient Name</label>
        <input type="text" id="patientName" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Contact Number</label>
        <input type="text" id="patientContact" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" id="patientEmail" class="input input-bordered w-full" disabled />
      </div>
    </div>
  </section>

  <!-- Consultation Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-4">Consultation Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Consultation ID</label>
        <input type="text" id="consultationId" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Doctor</label>
        <input type="text" id="doctorName" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Consultation Date</label>
        <input type="text" id="consultationDate" class="input input-bordered w-full" disabled />
      </div>
      <div>
        <label class="label">Payment Method</label>
        <input type="text" id="paymentMethod" class="input input-bordered w-full" disabled />
      </div>
    </div>
  </section>

  <!-- Bill Items Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-4">Bill Items</h2>
    <div class="overflow-x-auto">
      <table class="table table-zebra w-full">
        <thead>
          <tr>
            <th>Item</th>
            <th>Description</th>
            <th>Quantity</th>
            <th>Unit Price</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody id="bill-items">
          <!-- Bill items will be populated by JavaScript -->
        </tbody>
      </table>
    </div>
  </section>

  <!-- Total Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-4">Total</h2>
    <div class="flex justify-end">
      <div class="text-right space-y-2">
        <div class="text-lg">
          <span class="font-semibold">Total Amount: </span>
          <span id="totalAmount" class="text-2xl font-bold text-primary">RM 0.00</span>
        </div>
      </div>
    </div>
  </section>


</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let billId = '';
  let billData = {};

  // Get bill ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  billId = urlParams.get('id');

  if (!billId) {
    alert('No bill ID provided');
    window.location.href = '<%= request.getContextPath() %>/views/invoiceList.jsp';
  }

  // Load bill data
  async function loadBillData() {
    try {
      const response = await fetch(API_BASE + '/bills/' + billId);
      if (!response.ok) {
        throw new Error('Failed to load bill data');
      }

      billData = await response.json();
      populateBillForm();

    } catch (error) {
      console.error('Error loading bill data:', error);
      alert('Error loading bill data: ' + error.message);
    }
  }

  // Populate bill form
  function populateBillForm() {
    if (!billData) return;

    // Patient Information
    document.getElementById('patientName').value = billData.patientName || '';
    document.getElementById('patientContact').value = billData.patientContact || '';
    document.getElementById('patientEmail').value = billData.patientEmail || '';

    // Consultation Information
    document.getElementById('consultationId').value = billData.consultationID || '';
    document.getElementById('doctorName').value = billData.doctorName || '';
    document.getElementById('consultationDate').value = billData.consultationDate ? new Date(billData.consultationDate).toLocaleDateString() : '';
    document.getElementById('paymentMethod').value = billData.paymentMethod || '';

    // Bill Items
    populateBillItems();

    // Total Amount
    document.getElementById('totalAmount').textContent = 'RM ' + (billData.totalAmount || 0).toFixed(2);
  }

  // Populate bill items
  function populateBillItems() {
    const tbody = document.getElementById('bill-items');
    tbody.innerHTML = '';

    // Add consultation fee first
    const consultationRow = document.createElement('tr');
    consultationRow.innerHTML = 
      '<td>Consultation Fee</td>' +
      '<td>Medical consultation service</td>' +
      '<td>1</td>' +
      '<td>RM 20.00</td>' +
      '<td>RM 20.00</td>';
    tbody.appendChild(consultationRow);

    // Add prescription items if available
    if (billData.billItems && billData.billItems.elements && Array.isArray(billData.billItems.elements)) {
      billData.billItems.elements.forEach(item => {
        // Skip consultation fee as it's already added above
        if (item.itemName === 'Consultation Fee') {
          return;
        }
        
        const row = document.createElement('tr');
        row.innerHTML = 
          '<td>' + (item.itemName || 'N/A') + '</td>' +
          '<td>' + (item.description || 'N/A') + '</td>' +
          '<td>' + (item.quantity || 1) + '</td>' +
          '<td>RM ' + (item.unitPrice || 0).toFixed(2) + '</td>' +
          '<td>RM ' + (Math.round((item.totalPrice || 0) * 100) / 100).toFixed(2) + '</td>';
        tbody.appendChild(row);
      });
    }
  }



  // Print Invoice
  function printInvoice() {
    // Open the invoice in a new tab for printing/downloading as PDF
    const invoiceWindow = window.open(API_BASE + '/bills/' + billId + '/pdf', '_blank');
    
    // Add a message to guide the user
    if (invoiceWindow) {
      invoiceWindow.onload = function() {
        // Add a helpful message to the invoice page
        const messageDiv = invoiceWindow.document.createElement('div');
        messageDiv.innerHTML = `
          <div style="position: fixed; top: 20px; left: 20px; background: #007bff; color: white; padding: 15px; border-radius: 5px; z-index: 1000; max-width: 300px;">
            <strong>Instructions:</strong><br>
            1. Click the "Print PDF" button to save as PDF<br>
            2. Or use Ctrl+P (Cmd+P on Mac) to print<br>
            3. Choose "Save as PDF" in the print dialog
          </div>
        `;
        invoiceWindow.document.body.appendChild(messageDiv);
        
        // Auto-remove the message after 5 seconds
        setTimeout(() => {
          if (messageDiv.parentNode) {
            messageDiv.parentNode.removeChild(messageDiv);
          }
        }, 5000);
      };
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
        case 'invoices':
          window.location.href = '<%= request.getContextPath() %>/views/invoiceList.jsp';
          break;
        case 'queue':
          window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
          break;
        case 'consultations':
          window.location.href = '<%= request.getContextPath() %>/views/consultationList.jsp';
          break;
        case 'patients':
          window.location.href = '<%= request.getContextPath() %>/views/patientList.jsp';
          break;
        default:
          // Default fallback to invoice list
          window.location.href = '<%= request.getContextPath() %>/views/invoiceList.jsp';
      }
    } else {
      // Check document.referrer to determine where we came from
      const referrer = document.referrer;
      if (referrer.includes('invoiceList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/invoiceList.jsp';
      } else if (referrer.includes('adminQueue.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/adminQueue.jsp';
      } else if (referrer.includes('consultationList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/consultationList.jsp';
      } else if (referrer.includes('patientList.jsp')) {
        window.location.href = '<%= request.getContextPath() %>/views/patientList.jsp';
      } else {
        // Default fallback to invoice list
        window.location.href = '<%= request.getContextPath() %>/views/invoiceList.jsp';
      }
    }
  }

  // Set back button text based on where we came from
  function setBackButtonText() {
    const urlParams = new URLSearchParams(window.location.search);
    const fromPage = urlParams.get('from');
    
    if (fromPage) {
      switch (fromPage) {
        case 'invoices':
          document.getElementById('backButtonText').textContent = 'Back to Invoices';
          break;
        case 'queue':
          document.getElementById('backButtonText').textContent = 'Back to Queue';
          break;
        case 'consultations':
          document.getElementById('backButtonText').textContent = 'Back to Consultations';
          break;
        case 'patients':
          document.getElementById('backButtonText').textContent = 'Back to Patients';
          break;
        default:
          document.getElementById('backButtonText').textContent = 'Back to Invoices';
      }
    } else {
      // Try to determine from referrer
      const referrer = document.referrer;
      if (referrer.includes('invoiceList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Invoices';
      } else if (referrer.includes('adminQueue.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Queue';
      } else if (referrer.includes('consultationList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Consultations';
      } else if (referrer.includes('patientList.jsp')) {
        document.getElementById('backButtonText').textContent = 'Back to Patients';
      } else {
        document.getElementById('backButtonText').textContent = 'Back to Invoices';
      }
    }
  }

  // Load data when page loads
  document.addEventListener('DOMContentLoaded', function() {
    setBackButtonText();
    loadBillData();
  });
</script>
</body>
</html>
