<%--
Author: Anny Wong Ann Nee
Pharmacy Module
--%>
  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Medicine</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>


<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center mb-4">
    <div>
      <h1 class="text-2xl font-bold">Medicine</h1>
      <p class="text-sm text-gray-600 mt-1">Available Stock shows non-expired inventory only</p>
    </div>
    <button class="btn btn-primary" onclick="window.location.href='<%= request.getContextPath() %>/views/medicineDetail.jsp'">
      <span class="icon-[tabler--plus] size-4"></span>
      Add New Medicine
    </button>
  </div>
  
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>Medicine ID</th>
        <th>Medicine Name</th>
        <th>Description</th>
        <th>Available Stock</th>
        <th>Reorder Level</th>
        <th>Selling Price</th>
        <th>Stock Status</th>
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

  function initializeDataTable() {
    new DataTable('#example', {
      ajax: {
        url: API_BASE + '/medicines',
        dataSrc: function(json) {
          return json.elements || json || [];
        }
      },
      columns: [
        { 
          data: 'medicineID',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'medicineName',
          render: function(data) {
            return data || 'N/A';
          }
        },
        { 
          data: 'description',
          render: function(data) {
            return data ? (data.length > 50 ? data.substring(0, 50) + '...' : data) : 'N/A';
          }
        },
        { 
          data: 'availableStock', // Use availableStock instead of totalStock
          render: function(data) {
            return data || 0;
          }
        },
        { 
          data: 'reorderLevel',
          render: function(data) {
            return data || 0;
          }
        },
        { 
          data: 'sellingPrice',
          render: function(data) {
            return data ? 'RM ' + parseFloat(data).toFixed(2) : 'RM 0.00';
          }
        },
        { 
          data: null,
          render: function(data) {
            const stock = data.availableStock || 0; // Use availableStock instead of totalStock
            const reorderLevel = data.reorderLevel || 0;
            
            if (stock === 0) {
              return '<span class="badge badge-soft badge-error">Out of Stock</span>';
            } else if (stock <= reorderLevel) {
              return '<span class="badge badge-soft badge-warning">Low Stock</span>';
            } else {
              return '<span class="badge badge-soft badge-success">In Stock</span>';
            }
          }
        }
      ],
      order: [[0, 'asc']],
      pageLength: 10,
      responsive: true,
      rowCallback: function(row, data) {
        row.addEventListener('click', function() {
          window.location.href = '<%= request.getContextPath() %>/views/medicineDetail.jsp?id=' + data.medicineID;
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
