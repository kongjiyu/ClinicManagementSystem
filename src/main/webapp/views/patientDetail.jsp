<%@ page import="models.Patient" %><%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 24/07/2025
  Time: 11:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Patient Detail</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <h1 class="text-3xl font-bold">Patient Detail</h1>

  <!-- Personal Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Personal Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">First Name</label>
        <input type="text" class="input input-bordered w-full" id="firstName" />
      </div>
      <div>
        <label class="label">Last Name</label>
        <input type="text" class="input input-bordered w-full" id="lastName" />
      </div>
      <div>
        <label class="label">Gender</label>
        <select class="select select-bordered w-full" id="gender">
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>
      </div>
      <div>
        <label class="label">Date of Birth</label>
        <input type="date" class="input input-bordered w-full" id="dateOfBirth" />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" class="input input-bordered w-full" id="age" />
      </div>
      <div>
        <label class="label">Nationality</label>
        <input type="text" class="input input-bordered w-full" id="nationality" />
      </div>
    </div>
  </section>

  <!-- Identification Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Identification</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">ID Type</label>
        <input type="text" class="input input-bordered w-full" id="idType" />
      </div>
      <div>
        <label class="label">ID Number</label>
        <input type="text" class="input input-bordered w-full" id="idNumber" />
      </div>
      <div>
        <label class="label">Student ID</label>
        <input type="text" class="input input-bordered w-full" id="studentId" />
      </div>
    </div>
  </section>

  <!-- Contact Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Contact Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Phone Number</label>
        <input type="text" class="input input-bordered w-full" id="contactNumber" />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" class="input input-bordered w-full" id="email" />
      </div>
      <div class="md:col-span-2">
        <label class="label">Address</label>
        <input type="text" class="input input-bordered w-full" id="address" />
      </div>
    </div>
  </section>

  <!-- Emergency Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Emergency Contact</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Emergency Contact Name</label>
        <input type="text" class="input input-bordered w-full" id="emergencyContactName" />
      </div>
      <div>
        <label class="label">Emergency Contact Number</label>
        <input type="text" class="input input-bordered w-full" id="emergencyContactNumber" />
      </div>
    </div>
  </section>

  <!-- Medical Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Medical Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Allergies</label>
        <input type="text" class="input input-bordered w-full" id="allergies" />
      </div>
      <div>
        <label class="label">Blood Type</label>
        <select class="select select-bordered w-full" id="bloodType">
          <option value="">-- Select --</option>
          <option value="O+">O+</option>
          <option value="O-">O-</option>
          <option value="A+">A+</option>
          <option value="A-">A-</option>
          <option value="B+">B+</option>
          <option value="B-">B-</option>
          <option value="AB+">AB+</option>
          <option value="AB-">AB-</option>
        </select>
      </div>
    </div>
  </section>

  <!-- Submit -->
  <div class="flex justify-end">
    <button class="btn btn-primary">Save Changes</button>
  </div>
</main>
<script>
  const patientId = new URLSearchParams(window.location.search).get('id');
  if (!patientId) {
    alert("No patient ID specified in URL.");
  } else {
    fetch(`<%=request.getContextPath()%>/api/patients/` + patientId)
      .then(res => {
        if (!res.ok) throw new Error("Patient not found");
        return res.json();
      })
      .then(p => {
        document.getElementById("firstName").value = p.firstName || "";
        document.getElementById("lastName").value = p.lastName || "";
        document.getElementById("gender").value = p.gender || "";
        document.getElementById("dateOfBirth").value = p.dateOfBirth || "";
        document.getElementById("age").value = p.age || "";
        document.getElementById("nationality").value = p.nationality || "";
        document.getElementById("idType").value = p.idType || "";
        document.getElementById("idNumber").value = p.idNumber || "";
        document.getElementById("studentId").value = p.studentId || "";
        document.getElementById("contactNumber").value = p.contactNumber || "";
        document.getElementById("email").value = p.email || "";
        document.getElementById("address").value = p.address || "";
        document.getElementById("emergencyContactName").value = p.emergencyContactName || "";
        document.getElementById("emergencyContactNumber").value = p.emergencyContactNumber || "";
        document.getElementById("allergies").value = p.allergies || "";
        document.getElementById("bloodType").value = p.bloodType || "";
      })
      .catch(err => {
        alert("Failed to load patient data.");
        console.error(err);
      });
  }
</script>
</body>
</html>
