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
  <h1 class="text-2xl font-bold mb-4">Order Management</h1>
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

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';

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
        render: function(data) {
          return data ? new Date(data).toLocaleDateString() : 'N/A';
        }
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
