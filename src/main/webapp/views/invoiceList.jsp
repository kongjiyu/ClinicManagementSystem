<%--
Author: Oh Wan Ting
Pharmacy Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Invoices</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <h1 class="text-2xl font-bold mb-4">Invoices</h1>
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>Bill ID</th>
        <th>Patient Name</th>
        <th>Doctor</th>
        <th>Consultation ID</th>
        <th>Amount</th>
        <th>Date</th>
      </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>
</main>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<!-- DataTables JS and CSS -->
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.tailwindcss.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.tailwindcss.css" />
<script>
  // Custom date sorting function
  function customDateSort(a, b) {
    if (a === 'N/A' && b === 'N/A') return 0;
    if (a === 'N/A') return 1;
    if (b === 'N/A') return -1;
    
    const dateA = new Date(a);
    const dateB = new Date(b);
    
    if (isNaN(dateA.getTime()) && isNaN(dateB.getTime())) return 0;
    if (isNaN(dateA.getTime())) return 1;
    if (isNaN(dateB.getTime())) return -1;
    
    return dateA - dateB;
  }

  new DataTable('#example', {
    ajax: {
      url: '<%= request.getContextPath() %>/api/bills',
      dataSrc: 'elements'
    },
    columns: [
      { 
        data: 'billID', 
        title: 'Bill ID',
        render: function(data) {
          return data || 'N/A';
        }
      },
      { 
        data: 'patientName', 
        title: 'Patient Name',
        render: function(data) {
          return data || 'N/A';
        }
      },
      { 
        data: 'doctorName', 
        title: 'Doctor',
        render: function(data) {
          return data || 'N/A';
        }
      },
      { 
        data: 'consultationID', 
        title: 'Consultation ID',
        render: function(data) {
          return data || 'N/A';
        }
      },
      { 
        data: 'totalAmount', 
        title: 'Amount',
        render: function(data) {
          return data ? 'RM ' + parseFloat(data).toFixed(2) : 'RM 0.00';
        }
      },
      { 
        data: 'consultationDate', 
        title: 'Consultation Date',
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
      }
    ],
    order: [[5, 'desc']], // Sort by date desc
    pageLength: 10,
    responsive: true,
    rowCallback: function(row, data) {
      row.classList.add('cursor-pointer', 'hover:bg-gray-100');
      // Make entire row clickable
      row.addEventListener('click', function() {
        window.location.href = '<%= request.getContextPath() %>/views/invoiceDetail.jsp?id=' + data.billID;
      });
    }
  });
</script>
</body>
</html>
