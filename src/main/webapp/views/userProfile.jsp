<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>User Profile</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/userSidebar.jsp" %>

<div class="bg-base-100 p-8 rounded-lg shadow-lg max-w-5xl mx-auto mt-10">
  <h1 class="text-2xl font-bold mb-6">User Profile</h1>
  <form action="/user/profile" method="post" class="space-y-6">
    <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
      <div>
        <label class="label">Patient ID</label>
        <input type="text" class="input input-bordered w-full" value="${patient.patientID}" disabled />
      </div>
      <div>
        <label class="label">First Name</label>
        <input type="text" class="input input-bordered w-full" name="firstName" value="${patient.firstName}" />
      </div>
      <div>
        <label class="label">Last Name</label>
        <input type="text" class="input input-bordered w-full" name="lastName" value="${patient.lastName}" />
      </div>
      <div>
        <label class="label">Gender</label>
        <input type="text" class="input input-bordered w-full" name="gender" value="${patient.gender}" />
      </div>
      <div>
        <label class="label">Date of Birth</label>
        <input type="text" class="input input-bordered w-full" name="dateOfBirth" value="${patient.dateOfBirth}" />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" class="input input-bordered w-full" name="age" value="${patient.age}" />
      </div>
      <div>
        <label class="label">Nationality</label>
        <input type="text" class="input input-bordered w-full" name="nationality" value="${patient.nationality}" />
      </div>
      <div>
        <label class="label">ID Type</label>
        <input type="text" class="input input-bordered w-full" name="idType" value="${patient.idType}" />
      </div>
      <div>
        <label class="label">ID Number</label>
        <input type="text" class="input input-bordered w-full" name="idNumber" value="${patient.idNumber}" />
      </div>
      <div>
        <label class="label">Student ID</label>
        <input type="text" class="input input-bordered w-full" name="studentId" value="${patient.studentId}" />
      </div>
      <div>
        <label class="label">Contact Number</label>
        <input type="text" class="input input-bordered w-full" name="contactNumber" value="${patient.contactNumber}" />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" class="input input-bordered w-full" name="email" value="${patient.email}" />
      </div>
      <div>
        <label class="label">Address</label>
        <input type="text" class="input input-bordered w-full" name="address" value="${patient.address}" />
      </div>
      <div>
        <label class="label">Emergency Contact Name</label>
        <input type="text" class="input input-bordered w-full" name="emergencyContactName" value="${patient.emergencyContactName}" />
      </div>
      <div>
        <label class="label">Emergency Contact Number</label>
        <input type="text" class="input input-bordered w-full" name="emergencyContactNumber" value="${patient.emergencyContactNumber}" />
      </div>
      <div>
        <label class="label">Allergies</label>
        <input type="text" class="input input-bordered w-full" name="allergies" value="${patient.allergies}" />
      </div>
      <div>
        <label class="label">Blood Type</label>
        <input type="text" class="input input-bordered w-full" name="bloodType" value="${patient.bloodType}" />
      </div>
    </div>
    <div class="text-right mt-16 space-x-6">
      <button type="submit" class="btn btn-primary">Save Changes</button>
    </div>
  </form>
</div>

</body>
</html>
