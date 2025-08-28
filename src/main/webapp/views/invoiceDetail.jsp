<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Invoice Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.29/jspdf.plugin.autotable.min.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
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
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4 w-full">
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
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4 w-full">
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
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4 w-full">
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
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4 w-full">
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

    // Calculate Total Amount correctly
    const calculatedTotal = calculateTotalAmount();
    document.getElementById('totalAmount').textContent = 'RM ' + calculatedTotal.toFixed(2);
  }

  // Calculate total amount from bill items
  function calculateTotalAmount() {
    let total = 0;
    
    // Add consultation fee (RM 20.00)
    total += 20.00;
    
    // Add prescription items
    if (billData.billItems && billData.billItems.elements && Array.isArray(billData.billItems.elements)) {
      billData.billItems.elements.forEach(item => {
        // Skip consultation fee as it's already added above
        if (item.itemName === 'Consultation Fee') {
          return;
        }
        
        // Add the total price for this item
        total += (item.totalPrice || 0);
      });
    }
    
    return total;
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
  async function printInvoice() {
    if (!billData) {
      alert('Please wait for invoice data to load');
      return;
    }

    try {
      // Create new PDF document
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF('portrait', 'mm', 'a4');
      
      // Set document properties
      doc.setProperties({
        title: 'Invoice ' + billId,
        subject: 'Medical Invoice',
        author: 'Clinic Management System',
        creator: 'Clinic Management System'
      });

      // Add header
      doc.setFontSize(24);
      doc.setFont('helvetica', 'bold');
      doc.text('MEDICAL INVOICE', 105, 20, { align: 'center' });
      
      // Add invoice details
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      doc.text('Invoice #: ' + billId, 20, 35);
      doc.text('Date: ' + (billData.consultationDate ? new Date(billData.consultationDate).toLocaleDateString() : 'N/A'), 20, 42);
      doc.text('Payment Method: ' + (billData.paymentMethod || 'N/A'), 20, 49);

      // Add patient information
      doc.setFontSize(14);
      doc.setFont('helvetica', 'bold');
      doc.text('Patient Information', 20, 65);
      
      doc.setFontSize(10);
      doc.setFont('helvetica', 'normal');
      doc.text('Name: ' + (billData.patientName || 'N/A'), 20, 75);
      doc.text('Contact: ' + (billData.patientContact || 'N/A'), 20, 82);
      doc.text('Email: ' + (billData.patientEmail || 'N/A'), 20, 89);

      // Add consultation information
      doc.setFontSize(14);
      doc.setFont('helvetica', 'bold');
      doc.text('Consultation Information', 20, 105);
      
      doc.setFontSize(10);
      doc.setFont('helvetica', 'normal');
      doc.text('Consultation ID: ' + (billData.consultationID || 'N/A'), 20, 115);
      doc.text('Doctor: ' + (billData.doctorName || 'N/A'), 20, 122);

      // Add bill items table
      doc.setFontSize(14);
      doc.setFont('helvetica', 'bold');
      doc.text('Bill Items', 20, 140);

      // Prepare table data
      const tableData = [];
      
      // Add consultation fee
      tableData.push(['Consultation Fee', 'Medical consultation service', '1', 'RM 20.00', 'RM 20.00']);
      
      // Add prescription items
      if (billData.billItems && billData.billItems.elements && Array.isArray(billData.billItems.elements)) {
        billData.billItems.elements.forEach(item => {
          if (item.itemName !== 'Consultation Fee') {
            tableData.push([
              item.itemName || 'N/A',
              item.description || 'N/A',
              (item.quantity || 1).toString(),
              'RM ' + (item.unitPrice || 0).toFixed(2),
              'RM ' + (Math.round((item.totalPrice || 0) * 100) / 100).toFixed(2)
            ]);
          }
        });
      }

      // Create table
      doc.autoTable({
        startY: 150,
        head: [['Item', 'Description', 'Quantity', 'Unit Price', 'Total']],
        body: tableData,
        theme: 'grid',
        headStyles: { fillColor: [59, 130, 246], textColor: 255 },
        styles: { fontSize: 8 },
        columnStyles: {
          0: { cellWidth: 40 },
          1: { cellWidth: 60 },
          2: { cellWidth: 20 },
          3: { cellWidth: 30 },
          4: { cellWidth: 30 }
        },
        margin: { top: 5, right: 20, bottom: 5, left: 20 }
      });

      // Add total amount
      const finalY = doc.lastAutoTable.finalY + 10;
      doc.setFontSize(14);
      doc.setFont('helvetica', 'bold');
      const calculatedTotal = calculateTotalAmount();
      doc.text('Total Amount: RM ' + calculatedTotal.toFixed(2), 150, finalY, { align: 'right' });

      // Add footer
      doc.setFontSize(8);
      doc.setFont('helvetica', 'normal');
      doc.text('Generated on: ' + new Date().toLocaleDateString() + ' ' + new Date().toLocaleTimeString(), 105, 280, { align: 'center' });
      doc.text('Thank you for choosing our clinic', 105, 285, { align: 'center' });

      // Save the PDF
      const filename = 'invoice_' + billId + '_' + new Date().toISOString().split('T')[0] + '.pdf';
      doc.save(filename);
      
    } catch (error) {
      console.error('Error generating PDF:', error);
      alert('Error generating PDF: ' + error.message);
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
