<%--
Author: Yap Yu Xin
Consultation Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Consultation</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <h1 class="text-2xl font-bold mb-4">Consultation</h1>
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>Consultation ID</th>
        <th>Patient ID</th>
        <th>Doctor ID</th>
        <th>Date</th>
        <th>Status</th>
        <th>Diagnosis</th>
      </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>
</main>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.tailwindcss.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.tailwindcss.css" />

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';

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

  function initializeDataTable() {
    new DataTable('#example', {
      ajax: {
        url: API_BASE + '/consultations',
        dataSrc: function(json) {
          return json.elements || json || [];
        }
      },
      columns: [
        { 
          data: 'consultationID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'patientID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'doctorID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'consultationDate',
          render: function(data) {
            return data ? new Date(data).toLocaleDateString() : 'N/A';
          },
          type: 'date',
          orderData: [3, 0] // Sort by date first, then by consultation ID
        },
        { 
          data: 'status',
          render: function(data) {
            if (!data) return 'N/A';
            const status = data.toLowerCase();
            let badgeClass = 'badge badge-soft badge-neutral';
            
            switch (status) {
              case 'waiting': badgeClass = 'badge badge-soft badge-warning'; break;
              case 'in progress': badgeClass = 'badge badge-soft badge-info'; break;
              case 'completed': badgeClass = 'badge badge-soft badge-success'; break;
              case 'cancelled': badgeClass = 'badge badge-soft badge-error'; break;
              case 'billing': badgeClass = 'badge badge-soft badge-primary'; break;
            }
            
            return '<span class="' + badgeClass + '">' + data + '</span>';
          }
        },
        { 
          data: 'diagnosis',
          render: function(data) {
            return data ? (data.length > 50 ? data.substring(0, 50) + '...' : data) : 'N/A';
          }
        }
      ],
      order: [[3, 'desc']],
      pageLength: 10,
      responsive: true,
      rowCallback: function(row, data) {
        row.addEventListener('click', function() {
          window.location.href = '<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + data.consultationID;
        });
        row.classList.add('cursor-pointer', 'hover:bg-gray-100');
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function() {
    initializeDataTable();
  });
</script>
</body>
</html>
