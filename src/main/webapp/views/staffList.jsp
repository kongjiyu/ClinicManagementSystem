<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Staff</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <h1 class="text-2xl font-bold mb-4">Staff</h1>
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>Staff ID</th>
        <th>Name</th>
        <th>Position</th>
        <th>Gender</th>
        <th>Age</th>
        <th>Contact</th>
        <th>Email</th>
        <th>Employment Date</th>
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
    new DataTable('#example', {
      ajax: {
        url: API_BASE + '/staff',
        dataSrc: function(json) {
          return json.elements || json || [];
        }
      },
      columns: [
        { 
          data: 'staffID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: null,
          render: function(data) {
            const firstName = data.firstName || '';
            const lastName = data.lastName || '';
            return (firstName + ' ' + lastName).trim() || 'N/A';
          }
        },
        { 
          data: 'position',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'gender',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'dateOfBirth',
          render: function(data) {
            if (!data) return 'N/A';
            try {
              const birthDate = new Date(data);
              const today = new Date();
              const age = today.getFullYear() - birthDate.getFullYear();
              const monthDiff = today.getMonth() - birthDate.getMonth();
              if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                return age - 1;
              }
              return age;
            } catch (error) {
              return 'N/A';
            }
          }
        },
        { 
          data: 'contactNumber',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'email',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'employmentDate',
          render: function(data) {
            return data ? new Date(data).toLocaleDateString() : 'N/A';
          },
          type: 'date',
          orderData: [7, 0] // Sort by date first, then by staff ID
        }
      ],
      order: [[0, 'asc']],
      pageLength: 10,
      responsive: true,
      rowCallback: function(row, data) {
        row.addEventListener('click', function() {
          window.location.href = '<%= request.getContextPath() %>/views/staffDetail.jsp?id=' + data.staffID;
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
