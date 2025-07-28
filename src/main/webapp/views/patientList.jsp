<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Patient</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/sidebar.jsp" %>


<main class="flex-1 p-6 ml-64 space-y-6">
  <h1 class="text-2xl font-bold mb-4">Patient</h1>
  <div class="overflow-x-auto">
    <table id="example" class="display">
      <thead>
      <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Gender</th>
        <th>Age</th>
        <th>Phone</th>
        <th>Email</th>
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
    new DataTable('#example', {
      ajax: {
        url: '<%= request.getContextPath() %>/api/patients',
        dataSrc: ''
      },
      columns: [
        { data: 'patientID', title: 'ID' },
        { data: 'firstName', title: 'First Name' },
        { data: 'lastName', title: 'Last Name' },
        { data: 'gender', title: 'Gender' },
        { data: 'age', title: 'Age' },
        { data: 'contactNumber', title: 'Phone' },
        { data: 'email', title: 'Email' }
      ],
      rowCallback: function(row, data) {
        row.addEventListener('click', function() {
          window.location.href = '<%= request.getContextPath() %>/patient/detail?id=' + data.patientID;
        });
        row.classList.add('cursor-pointer', 'hover:bg-gray-100'); // optional styling
      }
    });
  </script>
</body>
</html>
