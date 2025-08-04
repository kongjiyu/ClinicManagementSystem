<%--
  Created by IntelliJ IDEA.
  User: kongjy
  Date: 29/07/2025
  Time: 11:09 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Admin Profile</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body>
<%@ include file="/views/adminSidebar.jsp" %>

<div class="bg-base-100 p-8 rounded-lg shadow-lg max-w-5xl mx-auto mt-10">
  <h1 class="text-2xl font-bold mb-6">Admin Profile</h1>
  <form action="/admin/profile" method="post" class="space-y-6">
    <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
      <div>
        <label class="label">Staff ID</label>
        <input type="text" class="input input-bordered w-full" value="${staff.staffID}" disabled />
      </div>
      <div>
        <label class="label">First Name</label>
        <input type="text" class="input input-bordered w-full" name="firstName" value="${staff.firstName}" />
      </div>
      <div>
        <label class="label">Last Name</label>
        <input type="text" class="input input-bordered w-full" name="lastName" value="${staff.lastName}" />
      </div>
      <div>
        <label class="label">Gender</label>
        <input type="text" class="input input-bordered w-full" name="gender" value="${staff.gender}" />
      </div>
      <div>
        <label class="label">Date of Birth</label>
        <input type="date" class="input input-bordered w-full" name="dateOfBirth" value="${staff.dateOfBirth}" />
      </div>
      <div>
        <label class="label">Nationality</label>
        <input type="text" class="input input-bordered w-full" name="nationality" value="${staff.nationality}" />
      </div>
      <div>
        <label class="label">ID Type</label>
        <input type="text" class="input input-bordered w-full" name="idType" value="${staff.idType}" />
      </div>
      <div>
        <label class="label">ID Number</label>
        <input type="text" class="input input-bordered w-full" name="idNumber" value="${staff.idNumber}" />
      </div>
      <div>
        <label class="label">Contact Number</label>
        <input type="text" class="input input-bordered w-full" name="contactNumber" value="${staff.contactNumber}" />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" class="input input-bordered w-full" name="email" value="${staff.email}" />
      </div>
      <div>
        <label class="label">Address</label>
        <input type="text" class="input input-bordered w-full" name="address" value="${staff.address}" />
      </div>
      <div>
        <label class="label">Position</label>
        <input type="text" class="input input-bordered w-full" name="position" value="${staff.position}" />
      </div>
      <div>
        <label class="label">Medical License No.</label>
        <input type="text" class="input input-bordered w-full" name="medicalLicenseNumber" value="${staff.medicalLicenseNumber}" />
      </div>
      <div>
        <label class="label">Employment Date</label>
        <input type="date" class="input input-bordered w-full" name="employmentDate" value="${staff.employmentDate}" />
      </div>
    </div>
    <div class="text-right mt-16 space-x-6">
      <button type="submit" class="btn btn-primary">Save Changes</button>
      <button type="button" class="btn btn-warning" data-overlay="#change-password-modal">Change Password</button>
    </div>
  </form>
</div>

<div id="change-password-modal" class="overlay modal modal-middle hidden" role="dialog" tabindex="-1">
  <div class="modal-dialog max-w-md w-full">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">Change Password</h3>
        <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" data-overlay="#change-password-modal">
          <span class="icon-[tabler--x] size-4"></span>
        </button>
      </div>
      <form method="post" action="/admin/profile">
        <div class="modal-body space-y-4">
          <input type="password" name="currentPassword" class="input input-bordered w-full" placeholder="Current Password" required />
          <input type="password" name="newPassword" class="input input-bordered w-full" placeholder="New Password" required />
          <input type="password" name="confirmPassword" class="input input-bordered w-full" placeholder="Confirm Password" required />
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Save</button>
          <button type="button" class="btn btn-secondary" data-overlay="#change-password-modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
