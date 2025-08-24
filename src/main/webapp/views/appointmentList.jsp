<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Appointments</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <style>
    .modal {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    
    .modal.hidden {
      display: none;
    }
    
    .modal-box {
      background: white;
      border-radius: 0.5rem;
      padding: 1.5rem;
      max-height: 90vh;
      overflow-y: auto;
    }
  </style>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center">
    <h1 class="text-2xl font-bold">Appointments</h1>
    <div class="flex gap-2">
      <a href="<%= request.getContextPath() %>/views/appointmentCreate.jsp" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4 mr-2"></span>
        Create Appointment
      </a>
      <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/appointmentCalendar.jsp'">
        <span class="icon-[tabler--calendar] size-4 mr-2"></span>
        Calendar View
      </button>
    </div>
  </div>
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>Appointment ID</th>
        <th>Patient Name</th>
        <th>Appointment Date & Time</th>
        <th>Status</th>
        <th>Description</th>
      </tr>
      </thead>
      <tbody>
      </tbody>
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
    window.appointmentsTable = new DataTable('#example', {
      ajax: {
        url: API_BASE + '/appointments',
        dataSrc: function(json) {
          return json.elements || json || [];
        }
      },
      columns: [
        { 
          data: 'appointmentID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'patientName',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'appointmentTime',
          render: function(data) {
            if (!data) return 'N/A';
            try {
              const dateTime = new Date(data);
              return dateTime.toLocaleString('en-US', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
              });
            } catch (error) {
              return data;
            }
          },
          type: 'date',
          orderData: [2, 0] // Sort by date first, then by appointment ID
        },
        { 
          data: 'status',
          render: function(data) {
            if (!data) return 'N/A';
            
            // Add status-specific styling
            let statusClass = '';
            switch(data.toLowerCase()) {
              case 'cancelled':
                statusClass = 'badge badge-soft badge-error';
                break;
              case 'completed':
                statusClass = 'badge badge-soft badge-warning';
                break;
              case 'checked-in':
                statusClass = 'badge badge-soft badge-primary';
                break;
              case 'no show':
                statusClass = 'badge badge-soft badge-secondary';
                break;
              default:
                statusClass = 'badge badge-soft badge-neutral';
            }
            
            return '<span class="' + statusClass + '">' + data + '</span>';
          }
        },
        { 
          data: 'description',
          render: function(data) {
            if (!data) return 'N/A';
            // Truncate long descriptions
            return data.length > 50 ? data.substring(0, 50) + '...' : data;
          }
        }
      ],
      order: [[2, 'desc']], // Sort by appointment date/time desc
      pageLength: 10,
      responsive: true,
      rowCallback: function(row, data) {
        row.addEventListener('click', function() {
          window.location.href = '<%= request.getContextPath() %>/views/appointmentDetail.jsp?id=' + data.appointmentID;
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
