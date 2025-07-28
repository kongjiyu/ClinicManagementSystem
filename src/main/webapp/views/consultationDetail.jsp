<%--
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
<%@ include file="/views/sidebar.jsp" %>

<main class="ml-64 p-6 space-y-8">
  <h1 class="text-3xl font-bold">Consultation Detail</h1>

  <!-- Personal Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Personal Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">First Name</label>
        <input type="text" class="input input-bordered w-full" value="${patient.firstName}" />
      </div>
      <div>
        <label class="label">Last Name</label>
        <input type="text" class="input input-bordered w-full" value="${patient.lastName}" />
      </div>
      <div>
        <label class="label">Gender</label>
        <select class="select select-bordered w-full">
          <option value="Male" ${patient.gender == 'Male' ? 'selected' : ''}>Male</option>
          <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
          <option value="Other" ${patient.gender == 'Other' ? 'selected' : ''}>Other</option>
        </select>
      </div>
      <div>
        <label class="label">Date of Birth</label>
        <input type="date" class="input input-bordered w-full" value="${patient.dateOfBirth}" />
      </div>
      <div>
        <label class="label">Age</label>
        <input type="number" class="input input-bordered w-full" value="${patient.age}" />
      </div>
      <div>
        <label class="label">Nationality</label>
        <input type="text" class="input input-bordered w-full" value="${patient.nationality}" />
      </div>
    </div>
  </section>

  <!-- Identification Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Identification</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">ID Type</label>
        <input type="text" class="input input-bordered w-full" value="${patient.idType}" />
      </div>
      <div>
        <label class="label">ID Number</label>
        <input type="text" class="input input-bordered w-full" value="${patient.idNumber}" />
      </div>
      <div>
        <label class="label">Student ID</label>
        <input type="text" class="input input-bordered w-full" value="${patient.studentId}" />
      </div>
    </div>
  </section>

  <!-- Contact Info Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Contact Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Phone Number</label>
        <input type="text" class="input input-bordered w-full" value="${patient.contactNumber}" />
      </div>
      <div>
        <label class="label">Email</label>
        <input type="email" class="input input-bordered w-full" value="${patient.email}" />
      </div>
      <div class="md:col-span-2">
        <label class="label">Address</label>
        <input type="text" class="input input-bordered w-full" value="${patient.address}" />
      </div>
    </div>
  </section>

  <!-- Emergency Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Emergency Contact</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Emergency Contact Name</label>
        <input type="text" class="input input-bordered w-full" value="${patient.emergencyContactName}" />
      </div>
      <div>
        <label class="label">Emergency Contact Number</label>
        <input type="text" class="input input-bordered w-full" value="${patient.emergencyContactNumber}" />
      </div>
    </div>
  </section>

  <!-- Medical Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Medical Information</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="label">Allergies</label>
        <input type="text" class="input input-bordered w-full" value="${patient.allergies}" />
      </div>
      <div>
        <label class="label">Blood Type</label>
        <select class="select select-bordered w-full">
          <option>-- Select --</option>
          <option value="O+" ${patient.bloodType == 'O+' ? 'selected' : ''}>O+</option>
          <option value="O-" ${patient.bloodType == 'O-' ? 'selected' : ''}>O-</option>
          <option value="A+" ${patient.bloodType == 'A+' ? 'selected' : ''}>A+</option>
          <option value="A-" ${patient.bloodType == 'A-' ? 'selected' : ''}>A-</option>
          <option value="B+" ${patient.bloodType == 'B+' ? 'selected' : ''}>B+</option>
          <option value="B-" ${patient.bloodType == 'B-' ? 'selected' : ''}>B-</option>
          <option value="AB+" ${patient.bloodType == 'AB+' ? 'selected' : ''}>AB+</option>
          <option value="AB-" ${patient.bloodType == 'AB-' ? 'selected' : ''}>AB-</option>
        </select>
      </div>
    </div>
  </section>

  <!-- Consultation Information Section -->
  <section class="bg-base-200 rounded-lg p-6 shadow space-y-4">
    <h2 class="text-xl font-semibold mb-2">Consultation Information</h2>
    <form>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="label" for="consultationId">Consultation ID</label>
          <input type="text" id="consultationId" name="consultationId" class="input input-bordered w-full" value="${consultation.consultationId}" readonly />
          <input type="hidden" name="consultationId" value="${consultation.consultationId}" />
        </div>
        <div>
          <label class="label" for="consultationDate">Consultation Date</label>
          <input type="date" id="consultationDate" name="consultationDate" class="input input-bordered w-full" value="${consultation.consultationDate}" />
        </div>
        <div>
          <label class="label" for="checkInTime">Check-in Time</label>
          <input type="time" id="checkInTime" name="checkInTime" class="input input-bordered w-full" value="${consultation.checkInTime}" />
        </div>
        <div>
          <label class="label" for="symptoms">Symptoms</label>
          <input type="text" id="symptoms" name="symptoms" class="input input-bordered w-full" value="${consultation.symptoms}" />
        </div>
        <div>
          <label class="label" for="diagnosis">Diagnosis</label>
          <input type="text" id="diagnosis" name="diagnosis" class="input input-bordered w-full" value="${consultation.diagnosis}" />
        </div>
        <div>
          <label class="label" for="status">Status</label>
          <select id="status" name="status" class="select select-bordered w-full">
            <option value="Waiting" ${consultation.status == 'Waiting' ? 'selected' : ''}>Waiting</option>
            <option value="In Progress" ${consultation.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
            <option value="Completed" ${consultation.status == 'Completed' ? 'selected' : ''}>Completed</option>
            <option value="Cancelled" ${consultation.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
          </select>
        </div>
        <div>
          <label class="label" for="isFollowUpRequired">Is Follow-up Required</label>
          <select id="isFollowUpRequired" name="isFollowUpRequired" class="select select-bordered w-full" onchange="document.getElementById('followUpDateDiv').style.display = this.value == 'Yes' ? 'block' : 'none';">
            <option value="No" ${consultation.isFollowUpRequired == 'No' ? 'selected' : ''}>No</option>
            <option value="Yes" ${consultation.isFollowUpRequired == 'Yes' ? 'selected' : ''}>Yes</option>
          </select>
        </div>
        <div id="followUpDateDiv" style="display: ${consultation.isFollowUpRequired == 'Yes' ? 'block' : 'none'};">
          <label class="label" for="followUpDate">Follow-up Date</label>
          <input type="date" id="followUpDate" name="followUpDate" class="input input-bordered w-full" value="${consultation.followUpDate}" />
        </div>
        <div>
          <label class="label" for="startDate">Start Date</label>
          <input type="date" id="startDate" name="startDate" class="input input-bordered w-full" value="${consultation.startDate}" />
        </div>
        <div>
          <label class="label" for="endDate">End Date</label>
          <input type="date" id="endDate" name="endDate" class="input input-bordered w-full" value="${consultation.endDate}" />
        </div>
        <div>
          <label class="label" for="billId">Bill ID</label>
          <input type="text" id="billId" name="billId" class="input input-bordered w-full" value="${consultation.billId}" readonly />
          <input type="hidden" name="billId" value="${consultation.billId}" />
        </div>
        <div>
          <label class="label" for="staffId">Staff ID</label>
          <input type="text" id="staffId" name="staffId" class="input input-bordered w-full" value="${consultation.staffId}" readonly />
          <input type="hidden" name="staffId" value="${consultation.staffId}" />
        </div>
        <div>
          <label class="label" for="doctorId">Doctor ID</label>
          <input type="text" id="doctorId" name="doctorId" class="input input-bordered w-full" value="${consultation.doctorId}" readonly />
          <input type="hidden" name="doctorId" value="${consultation.doctorId}" />
        </div>
      </div>
      <div class="flex justify-end mt-6">
        <button type="submit" class="btn btn-primary">Save Consultation Info</button>
      </div>
    </form>
  </section>
</main>
</body>
</html>
