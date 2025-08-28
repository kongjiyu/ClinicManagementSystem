<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
  Author: Yap Ern Tong
  Patient Module
-->
<html>
<head>
  <title>Register Patient</title>
  <!-- Optional: Bootstrap CDN for better styling -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
  <h2 class="mb-4">Register Patient</h2>
  <form id="patientForm">
    <div class="mb-3">
      <label for="name" class="form-label">Patient Name</label>
      <input type="text" class="form-control" id="name" name="name" required>
    </div>
    <div class="mb-3">
      <label for="gender" class="form-label">Gender</label>
      <select class="form-select" id="gender" name="gender" required>
        <option value="">-- Select Gender --</option>
        <option value="Male">Male</option>
        <option value="Female">Female</option>
        <option value="Other">Other</option>
      </select>
    </div>
    <button type="submit" class="btn btn-primary">Register Patient</button>
  </form>
</div>
<script>
  document.getElementById('patientForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const data = {
      name: this.name.value,
      gender: this.gender.value,
    };

    fetch('<%=request.getContextPath()%>/api/patients', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    }).then(response => {
      if (response.ok) {
        alert('Patient saved!');
      } else {
        alert('Error occurred');
        alert(response.statusText);
      }
    });
  });
</script>
</body>
</html>
