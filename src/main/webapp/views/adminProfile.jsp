<%--
Author: Kong Ji Yu
General Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Profile - Clinic Management System</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>

</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <!-- Header -->
  <div class="flex justify-between items-center">
    <div>
      <h1 class="text-3xl font-bold">Admin Profile</h1>
      <p class="text-base-content/70">Manage your profile information and settings</p>
    </div>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Profile Form -->
  <div id="profileSection" class="hidden">
    <div class="bg-base-200 p-6 rounded-lg shadow-lg w-full">
      <!-- Editable Fields Notice -->
      <div class="alert alert-info mb-6">
        <span class="icon-[tabler--info-circle] size-5"></span>
        <div>
          <h4 class="font-semibold">Profile Information</h4>
          <p class="text-sm">You can only edit your contact information (phone, email, address). Other fields require administrator approval to change.</p>
        </div>
      </div>
      
      <form id="profileForm" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Staff ID (Read-only) -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Staff ID</span>
            </label>
            <input type="text" id="staffID" class="input input-bordered w-full" disabled>
            <label class="label">
              <span class="label-text-alt">Your unique staff identifier</span>
            </label>
          </div>

          <!-- First Name -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">First Name</span>
            </label>
            <input type="text" id="firstName" class="input input-bordered w-full" disabled>
            <label class="label">
              <span class="label-text-alt">Your first name (contact administrator to change)</span>
            </label>
          </div>

          <!-- Last Name -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Last Name</span>
            </label>
            <input type="text" id="lastName" class="input input-bordered w-full" disabled>
            <label class="label">
              <span class="label-text-alt">Your last name (contact administrator to change)</span>
            </label>
          </div>

          <!-- Gender -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Gender</span>
            </label>
            <select id="gender" class="select select-bordered w-full" disabled>
              <option value="">Select Gender</option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
            <label class="label">
              <span class="label-text-alt">Your gender (contact administrator to change)</span>
            </label>
          </div>

          <!-- Date of Birth -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Date of Birth</span>
            </label>
            <input type="date" id="dateOfBirth" class="input input-bordered w-full" disabled>
            <label class="label">
              <span class="label-text-alt">Your date of birth (contact administrator to change)</span>
            </label>
          </div>

          <!-- Nationality -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Nationality</span>
            </label>
            <input type="text" id="nationality" class="input input-bordered w-full" placeholder="e.g., Malaysian" disabled>
            <label class="label">
              <span class="label-text-alt">Your nationality (contact administrator to change)</span>
            </label>
          </div>

          <!-- ID Type -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">ID Type</span>
            </label>
            <select id="idType" class="select select-bordered w-full" disabled>
              <option value="">Select ID Type</option>
              <option value="IC">IC</option>
              <option value="Passport">Passport</option>
              <option value="Driver License">Driver License</option>
              <option value="Other">Other</option>
            </select>
            <label class="label">
              <span class="label-text-alt">Type of identification (contact administrator to change)</span>
            </label>
          </div>

          <!-- ID Number -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">ID Number</span>
            </label>
            <input type="text" id="idNumber" class="input input-bordered w-full" placeholder="e.g., 123456789" disabled>
            <label class="label">
              <span class="label-text-alt">Your identification number (contact administrator to change)</span>
            </label>
          </div>

          <!-- Contact Number -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Contact Number *</span>
            </label>
            <input type="tel" id="contactNumber" class="input input-bordered w-full" required placeholder="e.g., 012-3456789">
            <label class="label">
              <span class="label-text-alt">Your phone number (Malaysian format: 012-3456789)</span>
            </label>
          </div>

          <!-- Email -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Email *</span>
            </label>
            <input type="email" id="email" class="input input-bordered w-full" required placeholder="e.g., staff@clinic.com">
            <label class="label">
              <span class="label-text-alt">Your email address</span>
            </label>
          </div>

          <!-- Address -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Address</span>
            </label>
            <textarea id="address" class="textarea textarea-bordered h-20" placeholder="Enter your full address" maxlength="500"></textarea>
            <label class="label">
              <span class="label-text-alt">Your residential address (max 500 characters)</span>
            </label>
          </div>

          <!-- Position -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Position</span>
            </label>
            <select id="position" class="select select-bordered w-full" disabled>
              <option value="">Select Position</option>
              <option value="Admin">Admin</option>
              <option value="Doctor">Doctor</option>
              <option value="Nurse">Nurse</option>
              <option value="Receptionist">Receptionist</option>
              <option value="Pharmacist">Pharmacist</option>
            </select>
            <label class="label">
              <span class="label-text-alt">Your job position (contact administrator to change)</span>
            </label>
          </div>

          <!-- Medical License Number -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Medical License No.</span>
            </label>
            <input type="text" id="medicalLicenseNumber" class="input input-bordered w-full" placeholder="e.g., ML123456" disabled>
            <label class="label">
              <span class="label-text-alt">Your medical license number (contact administrator to change)</span>
            </label>
          </div>

          <!-- Employment Date -->
          <div class="form-control">
            <label class="label">
              <span class="label-text font-semibold">Employment Date</span>
            </label>
            <input type="date" id="employmentDate" class="input input-bordered w-full" disabled>
            <label class="label">
              <span class="label-text-alt">Date you started employment (contact administrator to change)</span>
            </label>
          </div>
        </div>

        <!-- Form Actions -->
        <div class="flex justify-end gap-4 pt-6 border-t">
          <button type="button" class="btn btn-outline" onclick="openChangePasswordModal()">
            <span class="icon-[tabler--lock] size-4 mr-2"></span>
            Change Password
          </button>
          <button type="submit" class="btn btn-primary">
            <span class="icon-[tabler--device-floppy] size-4 mr-2"></span>
            Save Changes
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Change Password Modal -->
  <div id="changePasswordModal" class="fixed inset-0 flex items-center justify-center hidden" style="background-color: rgba(0, 0, 0, 0.5) !important; z-index: 9999 !important;">
    <div class="bg-white rounded-lg shadow-xl p-6 w-11/12 max-w-md mx-4 relative">
      <!-- Modal Header -->
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-semibold text-gray-900">Change Password</h3>
        <button onclick="closeChangePasswordModal()" class="text-gray-400 hover:text-gray-600">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
      
      <!-- Modal Body -->
      <form id="changePasswordForm" class="space-y-4">
        <div>
          <label for="currentPassword" class="block text-sm font-medium text-gray-700 mb-1">
            Current Password *
          </label>
          <input 
            type="password" 
            id="currentPassword" 
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
            required
          >
        </div>
        
        <div>
          <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">
            New Password *
          </label>
          <input 
            type="password" 
            id="newPassword" 
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
            required
          >
          <p class="mt-1 text-xs text-gray-500">Minimum 6 characters</p>
        </div>
        
        <div>
          <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">
            Confirm New Password *
          </label>
          <input 
            type="password" 
            id="confirmPassword" 
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
            required
          >
        </div>
      </form>
      
      <!-- Modal Footer -->
      <div class="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-200">
        <button 
          onclick="closeChangePasswordModal()" 
          class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Cancel
        </button>
        <button 
          onclick="changePassword()" 
          class="px-6 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 flex items-center"
        >
          <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
          </svg>
          Change Password
        </button>
      </div>
    </div>
  </div>

  <!-- Success Alert -->
  <div id="successAlert" class="alert alert-success fixed top-4 right-4 w-auto max-w-sm hidden">
    <span class="icon-[tabler--check] size-5"></span>
    <span id="successMessage"></span>
  </div>

  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error fixed top-4 right-4 w-auto max-w-sm hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let currentStaff = null;

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    loadStaffProfile();
  });

  // Load staff profile data
  async function loadStaffProfile() {
    try {
      // Get current user session
      const sessionResponse = await fetch(API_BASE + '/auth/session');
      const sessionData = await sessionResponse.json();
      
      if (!sessionData.authenticated || sessionData.userType !== 'staff') {
        showError('You must be logged in as staff to access this page');
        return;
      }

      // Load staff data
      const response = await fetch(API_BASE + '/staff/' + sessionData.userId);
      if (!response.ok) {
        throw new Error('Failed to load staff profile');
      }

      const staffData = await response.json();
      currentStaff = staffData;
      
      populateForm(staffData);
      hideLoading();
      showProfile();
      
    } catch (error) {
      console.error('Error loading staff profile:', error);
      showError('Failed to load profile: ' + error.message);
      hideLoading();
    }
  }

  // Populate form with staff data
  function populateForm(staff) {
    document.getElementById('staffID').value = staff.staffID || '';
    document.getElementById('firstName').value = staff.firstName || '';
    document.getElementById('lastName').value = staff.lastName || '';
    document.getElementById('gender').value = staff.gender || '';
    document.getElementById('dateOfBirth').value = staff.dateOfBirth || '';
    document.getElementById('nationality').value = staff.nationality || '';
    document.getElementById('idType').value = staff.idType || '';
    document.getElementById('idNumber').value = staff.idNumber || '';
    document.getElementById('contactNumber').value = staff.contactNumber || '';
    document.getElementById('email').value = staff.email || '';
    document.getElementById('address').value = staff.address || '';
    document.getElementById('position').value = staff.position || '';
    document.getElementById('medicalLicenseNumber').value = staff.medicalLicenseNumber || '';
    document.getElementById('employmentDate').value = staff.employmentDate || '';
  }

  // Handle form submission
  document.getElementById('profileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    updateProfile();
  });

  // Update profile
  async function updateProfile() {
    const form = document.getElementById('profileForm');
    
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    // Validate contact number (Malaysian format)
    const contactNumber = document.getElementById('contactNumber').value;
    const phoneRegex = /^(\+?6?01)[0-46-9]-*[0-9]{7,8}$/;
    if (!phoneRegex.test(contactNumber.replace(/\s/g, ''))) {
      showError('Please enter a valid Malaysian phone number (e.g., 012-3456789, +6012-3456789)');
      document.getElementById('contactNumber').focus();
      return;
    }

    // Validate email format
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showError('Please enter a valid email address');
      document.getElementById('email').focus();
      return;
    }

    // Validate address length
    const address = document.getElementById('address').value;
    if (address && address.length > 500) {
      showError('Address cannot exceed 500 characters');
      document.getElementById('address').focus();
      return;
    }

    // Only include editable fields in the update
    const profileData = {
      staffID: document.getElementById('staffID').value,
      contactNumber: contactNumber,
      email: email,
      address: address
    };

    try {
      const response = await fetch(API_BASE + '/staff/' + profileData.staffID, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(profileData)
      });

      if (!response.ok) {
        throw new Error('Failed to update profile');
      }

      showSuccess('Profile updated successfully!');
      
    } catch (error) {
      console.error('Error updating profile:', error);
      showError('Failed to update profile: ' + error.message);
    }
  }

  // Open change password modal
  function openChangePasswordModal() {
    console.log('Opening change password modal');
    const modal = document.getElementById('changePasswordModal');
    const form = document.getElementById('changePasswordForm');
    
    if (modal && form) {
      modal.classList.remove('hidden');
      form.reset();
      
      // Focus on the first input field
      const firstInput = form.querySelector('input');
      if (firstInput) {
        firstInput.focus();
      }
      
      console.log('Modal opened successfully');
    } else {
      console.error('Modal or form not found');
    }
  }

  // Close change password modal
  function closeChangePasswordModal() {
    console.log('Closing change password modal');
    const modal = document.getElementById('changePasswordModal');
    
    if (modal) {
      modal.classList.add('hidden');
      console.log('Modal closed successfully');
    } else {
      console.error('Modal not found');
    }
  }

  // Change password
  async function changePassword() {
    console.log('Attempting to change password');
    const form = document.getElementById('changePasswordForm');
    
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    console.log('Password validation:', {
      currentPasswordLength: currentPassword.length,
      newPasswordLength: newPassword.length,
      passwordsMatch: newPassword === confirmPassword
    });

    if (newPassword !== confirmPassword) {
      showError('New passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      showError('New password must be at least 6 characters long');
      return;
    }

    if (!currentStaff || !currentStaff.staffID) {
      showError('Staff information not available');
      return;
    }

    try {
      console.log('Sending password change request to:', API_BASE + '/staff/' + currentStaff.staffID + '/password');
      
      const response = await fetch(API_BASE + '/staff/' + currentStaff.staffID + '/password', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          currentPassword: currentPassword,
          newPassword: newPassword
        })
      });

      console.log('Password change response status:', response.status);

      if (!response.ok) {
        const errorData = await response.text();
        console.error('Password change error response:', errorData);
        throw new Error('Failed to change password: ' + response.status);
      }

      showSuccess('Password changed successfully!');
      closeChangePasswordModal();
      
    } catch (error) {
      console.error('Error changing password:', error);
      showError('Failed to change password: ' + error.message);
    }
  }

  // Show success message
  function showSuccess(message) {
    document.getElementById('successMessage').textContent = message;
    document.getElementById('successAlert').classList.remove('hidden');
    
    setTimeout(function() {
      document.getElementById('successAlert').classList.add('hidden');
    }, 3000);
  }

  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
    
    setTimeout(function() {
      document.getElementById('errorAlert').classList.add('hidden');
    }, 5000);
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
  }

  // Show profile section
  function showProfile() {
    document.getElementById('profileSection').classList.remove('hidden');
  }

  // Close modal when clicking outside
  document.getElementById('changePasswordModal').addEventListener('click', function(e) {
    if (e.target === this) {
      closeChangePasswordModal();
    }
  });

  // Close modal with Escape key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      const modal = document.getElementById('changePasswordModal');
      if (modal && !modal.classList.contains('hidden')) {
        closeChangePasswordModal();
      }
    }
  });

  // Prevent modal close when clicking inside modal content
  document.addEventListener('DOMContentLoaded', function() {
    const modalContent = document.querySelector('#changePasswordModal > div');
    if (modalContent) {
      modalContent.addEventListener('click', function(e) {
        e.stopPropagation();
      });
    }
  });
</script>
</body>
</html>
