<%--
Author: Kong Ji Yu
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Clinic Management System - Login</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
  <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-16 w-16 bg-blue-600 rounded-full flex items-center justify-center">
          <span class="icon-[tabler--stethoscope] size-8 text-white"></span>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">Clinic Management System</h2>
        <p class="mt-2 text-sm text-gray-600">Please sign in to your account</p>
      </div>

      <!-- Login Form -->
      <div class="bg-white rounded-lg shadow-lg p-8">
        <form class="space-y-6" id="loginForm" onsubmit="handleLogin(event)">
          <!-- Role Selection -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-3">Login as:</label>
            <div class="grid grid-cols-2 gap-4">
              <label class="relative cursor-pointer">
                <input type="radio" name="userType" value="staff" class="sr-only peer" checked>
                <div class="bg-white border-2 border-gray-200 rounded-lg p-4 text-center peer-checked:border-blue-600 peer-checked:bg-blue-50 hover:border-gray-300 transition-colors">
                  <span class="icon-[tabler--user-star] size-8 mx-auto text-gray-400 peer-checked:text-blue-600"></span>
                  <div class="mt-2 text-sm font-medium text-gray-900">Staff</div>
                  <div class="text-xs text-gray-500">Admin & Doctor</div>
                </div>
              </label>
              <label class="relative cursor-pointer">
                <input type="radio" name="userType" value="patient" class="sr-only peer">
                <div class="bg-white border-2 border-gray-200 rounded-lg p-4 text-center peer-checked:border-blue-600 peer-checked:bg-blue-50 hover:border-gray-300 transition-colors">
                  <span class="icon-[tabler--user] size-8 mx-auto text-gray-400 peer-checked:text-blue-600"></span>
                  <div class="mt-2 text-sm font-medium text-gray-900">Patient</div>
                  <div class="text-xs text-gray-500">User Portal</div>
                </div>
              </label>
            </div>
          </div>

          <!-- Username -->
          <div>
            <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
            <input 
              id="username" 
              name="username" 
              type="text" 
              required 
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="Enter Staff ID or Student ID"
            >
            <p class="mt-1 text-xs text-gray-500" id="usernameHelp">
              Staff: Enter your Staff ID (e.g., ST0001)<br>
              Patient: Enter your Student ID
            </p>
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
            <input 
              id="password" 
              name="password" 
              type="password" 
              required 
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="Enter your password"
            >
          </div>

          <!-- Remember Me
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input 
                id="remember-me" 
                name="remember-me" 
                type="checkbox" 
                class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
              >
              <label for="remember-me" class="ml-2 block text-sm text-gray-900">Remember me</label>
            </div>
            <div class="text-sm">
              <a href="#" class="font-medium text-blue-600 hover:text-blue-500">Forgot password?</a>
            </div>
          </div> -->

          <!-- Submit Button -->
          <div>
            <button 
              type="submit" 
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              id="loginButton"
            >
              <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                <span class="icon-[tabler--lock] size-4 text-blue-500 group-hover:text-blue-400"></span>
              </span>
              Sign In
            </button>
          </div>
        </form>

      </div>
    </div>
  </div>

  <!-- Loading Overlay -->
  <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden">
    <div class="bg-white rounded-lg p-6 flex items-center space-x-3">
      <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
      <span class="text-gray-700">Signing in...</span>
    </div>
  </div>

  <script>
    // Update username help text based on user type selection
    document.addEventListener('DOMContentLoaded', function() {
      const userTypeInputs = document.querySelectorAll('input[name="userType"]');
      const usernameHelp = document.getElementById('usernameHelp');
      
      function updateUsernameHelp() {
        const selectedType = document.querySelector('input[name="userType"]:checked').value;
        if (selectedType === 'staff') {
          usernameHelp.innerHTML = 'Staff: Enter your Staff ID (e.g., ST0001)';
        } else {
          usernameHelp.innerHTML = 'Patient: Enter your Student ID';
        }
      }
      
      userTypeInputs.forEach(input => {
        input.addEventListener('change', updateUsernameHelp);
      });
      
      // Set initial help text
      updateUsernameHelp();
    });

    async function handleLogin(event) {
      event.preventDefault();
      
      const form = event.target;
      const formData = new FormData(form);
      const loginButton = document.getElementById('loginButton');
      const loadingOverlay = document.getElementById('loadingOverlay');
      
      // Show loading state
      loginButton.disabled = true;
      loadingOverlay.classList.remove('hidden');
      
      try {
        const response = await fetch('<%= request.getContextPath() %>/api/auth/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            username: formData.get('username'),
            password: formData.get('password'),
            userType: formData.get('userType'),
            rememberMe: formData.get('remember-me') === 'on'
          })
        });
        
        const result = await response.json();
        
        if (response.ok && result.success) {
          // Redirect based on user type
          if (result.userType === 'staff') {
            window.location.href = '<%= request.getContextPath() %>/views/adminDashboard.jsp';
          } else {
            window.location.href = '<%= request.getContextPath() %>/views/userDashboard.jsp';
          }
        } else {
          // Show error message
          alert(result.message || 'Login failed. Please check your credentials.');
        }
      } catch (error) {
        console.error('Login error:', error);
        alert('An error occurred during login. Please try again.');
      } finally {
        // Hide loading state
        loginButton.disabled = false;
        loadingOverlay.classList.add('hidden');
      }
    }
  </script>
</body>
</html>
