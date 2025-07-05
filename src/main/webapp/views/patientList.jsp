<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List, models.Patient" %>
<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Patient List</h2>
    <a href="patientAdd.jsp" class="btn btn-primary mb-3">Add New Patient</a>
    <table id="patientsTable" class="table table-striped table-bordered" style="width:100%">
        <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Gender</th>
        </tr>
        </thead>
        <tbody></tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  $(document).ready(function () {
    $('#patientsTable').DataTable({
      "ajax": {
        "url": "<%=request.getContextPath()%>/api/patients",
        "dataSrc": ""
      },
      "columns": [
        { "data": "id" },
        { "data": "name" },
        { "data": "gender" }
      ]
    });
  });
</script>
</body>
</html>
