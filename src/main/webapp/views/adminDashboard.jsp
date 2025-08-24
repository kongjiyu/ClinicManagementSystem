<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - Clinic Management System</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-6">
  <!-- Header -->
  <div class="flex justify-between items-center">
    <div>
      <h1 class="text-3xl font-bold">Admin Dashboard</h1>
      <p class="text-base-content/70">Welcome back! Here's what's happening in your clinic today.</p>
    </div>
    <div class="text-right">
      <p class="text-sm text-base-content/70">Today is <%= java.time.LocalDate.now() %></p>
      <p class="text-sm text-base-content/70" id="currentTime"></p>
    </div>
  </div>

  <!-- Loading Spinner -->
  <div id="loadingSpinner" class="flex justify-center items-center py-8">
    <div class="loading loading-spinner loading-lg"></div>
  </div>

  <!-- Statistics Cards -->
  <div id="statsSection" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 hidden">
    <div class="stat bg-base-100 shadow-lg rounded-lg">
      <div class="stat-figure text-primary">
        <span class="icon-[tabler--users] size-8"></span>
      </div>
      <div class="stat-title">Total Patients</div>
      <div class="stat-value text-primary" id="totalPatients">-</div>
      <div class="stat-desc">Registered patients</div>
    </div>

    <div class="stat bg-base-100 shadow-lg rounded-lg">
      <div class="stat-figure text-secondary">
        <span class="icon-[tabler--calendar-event] size-8"></span>
      </div>
      <div class="stat-title">Today's Appointments</div>
      <div class="stat-value text-secondary" id="todayAppointments">-</div>
      <div class="stat-desc">Scheduled for today</div>
    </div>

    <div class="stat bg-base-100 shadow-lg rounded-lg">
      <div class="stat-figure text-accent">
        <span class="icon-[tabler--stethoscope] size-8"></span>
      </div>
      <div class="stat-title">Active Consultations</div>
      <div class="stat-value text-accent" id="activeConsultations">-</div>
      <div class="stat-desc">In progress</div>
    </div>

    <div class="stat bg-base-100 shadow-lg rounded-lg">
      <div class="stat-figure text-info">
        <span class="icon-[tabler--pills] size-8"></span>
      </div>
      <div class="stat-title">Low Stock Items</div>
      <div class="stat-value text-info" id="lowStockItems">-</div>
      <div class="stat-desc">Need reordering</div>
    </div>
  </div>

    <!-- Charts Row -->
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Appointments Chart -->
    <div class="bg-base-100 p-6 rounded-lg shadow-lg">
      <h3 class="text-xl font-semibold mb-4">Appointments This Week</h3>
      <canvas id="appointmentsChart" width="400" height="200"></canvas>
    </div>

    <!-- Quick Actions -->
    <div class="bg-base-100 p-6 rounded-lg shadow-lg">
      <h3 class="text-xl font-semibold mb-4">Quick Actions</h3>
      <div class="space-y-3">
        <a href="<%= request.getContextPath() %>/views/patientAdd.jsp" class="btn btn-primary w-full justify-start">
          <span class="icon-[tabler--user-plus] size-4 mr-2"></span>
          Add New Patient
        </a>
        <a href="<%= request.getContextPath() %>/views/orderCreate.jsp" class="btn btn-secondary w-full justify-start">
          <span class="icon-[tabler--shopping-cart-plus] size-4 mr-2"></span>
          Create Order
        </a>
        <a href="<%= request.getContextPath() %>/views/adminQueue.jsp" class="btn btn-accent w-full justify-start">
          <span class="icon-[tabler--list] size-4 mr-2"></span>
          Manage Queue
        </a>
        <a href="<%= request.getContextPath() %>/views/reportsDashboard.jsp" class="btn btn-outline w-full justify-start">
          <span class="icon-[tabler--chart-bar] size-4 mr-2"></span>
          View Reports
        </a>
      </div>
    </div>
  </div>

  <!-- Recent Activities -->
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Recent Appointments -->
    <div class="bg-base-100 p-6 rounded-lg shadow-lg">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Recent Appointments</h3>
        <a href="<%= request.getContextPath() %>/views/appointmentList.jsp" class="btn btn-xs btn-outline">View All</a>
      </div>
      <div id="recentAppointments" class="space-y-3">
        <!-- Recent appointments will be populated by JavaScript -->
      </div>
    </div>

    <!-- Recent Orders -->
    <div class="bg-base-100 p-6 rounded-lg shadow-lg">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Recent Orders</h3>
        <a href="<%= request.getContextPath() %>/views/orderList.jsp" class="btn btn-xs btn-outline">View All</a>
      </div>
      <div id="recentOrders" class="space-y-3">
        <!-- Recent orders will be populated by JavaScript -->
      </div>
    </div>

    <!-- Recent Treatments -->
    <div class="bg-base-100 p-6 rounded-lg shadow-lg">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Recent Treatments</h3>
        <a href="<%= request.getContextPath() %>/views/treatmentList.jsp" class="btn btn-xs btn-outline">View All</a>
      </div>
      <div id="recentTreatments" class="space-y-3">
        <!-- Recent treatments will be populated by JavaScript -->
      </div>
    </div>
  </div>



  <!-- Error Alert -->
  <div id="errorAlert" class="alert alert-error hidden">
    <span class="icon-[tabler--alert-circle] size-5"></span>
    <span id="errorMessage"></span>
  </div>
</main>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let appointmentsChart;

  // Update current time
  function updateCurrentTime() {
    const now = new Date();
    document.getElementById('currentTime').textContent = now.toLocaleTimeString();
  }

  // Load dashboard data
  async function loadDashboardData() {
    try {
      // Load statistics
      await loadStatistics();
      
      // Load recent data
      await loadRecentAppointments();
      await loadRecentOrders();
      await loadRecentTreatments();
      
      // Initialize charts
      initializeCharts();
      
      // Hide loading and show content
      hideLoading();
      showContent();
      
    } catch (error) {
      console.error('Error loading dashboard data:', error);
      showError('Failed to load dashboard data: ' + error.message);
      hideLoading();
    }
  }

  // Load statistics
  async function loadStatistics() {
    try {
      // Load patients count
      const patientsResponse = await fetch(API_BASE + '/patients');
      const patientsData = await patientsResponse.json();
      const patientsCount = patientsData.elements ? patientsData.elements.length : 0;
      document.getElementById('totalPatients').textContent = patientsCount;

      // Load today's appointments
      const appointmentsResponse = await fetch(API_BASE + '/appointments');
      const appointmentsData = await appointmentsResponse.json();
      const appointments = appointmentsData.elements || appointmentsData || [];
      const today = new Date().toDateString();
      const todayAppointments = appointments.filter(apt => {
        const aptDate = new Date(apt.appointmentTime).toDateString();
        return aptDate === today;
      }).length;
      document.getElementById('todayAppointments').textContent = todayAppointments;

      // Load active consultations
      const consultationsResponse = await fetch(API_BASE + '/consultations');
      const consultationsData = await consultationsResponse.json();
      const consultations = consultationsData.elements || consultationsData || [];
      const activeConsultations = consultations.filter(cons => 
        cons.status && cons.status.toLowerCase() === 'in progress'
      ).length;
      document.getElementById('activeConsultations').textContent = activeConsultations;

      // Load low stock medicines
      const medicinesResponse = await fetch(API_BASE + '/medicines');
      const medicinesData = await medicinesResponse.json();
      const medicines = medicinesData.elements || medicinesData || [];
      const lowStockItems = medicines.filter(med => 
        med.totalStock < med.reorderLevel
      ).length;
      document.getElementById('lowStockItems').textContent = lowStockItems;

    } catch (error) {
      console.error('Error loading statistics:', error);
    }
  }

  // Load recent appointments
  async function loadRecentAppointments() {
    try {
      const response = await fetch(API_BASE + '/appointments');
      const data = await response.json();
      const appointments = data.elements || data || [];
      
      // Get 5 most recent appointments
      const recentAppointments = appointments
        .sort((a, b) => new Date(b.appointmentTime) - new Date(a.appointmentTime))
        .slice(0, 5);

      const container = document.getElementById('recentAppointments');
      container.innerHTML = '';

      if (recentAppointments.length === 0) {
        container.innerHTML = '<p class="text-base-content/70">No recent appointments</p>';
        return;
      }

      recentAppointments.forEach(function(appointment) {
        const appointmentDate = new Date(appointment.appointmentTime);
        const statusBadge = getStatusBadge(appointment.status);
        
        const appointmentElement = document.createElement('div');
        appointmentElement.className = 'flex justify-between items-center p-3 bg-white rounded-lg border border-gray-200';
        
        const patientName = appointment.patientName || 'Unknown Patient';
        const dateString = appointmentDate.toLocaleDateString();
        const timeString = appointmentDate.toLocaleTimeString('en-US', {hour: '2-digit', minute: '2-digit'});
        
        appointmentElement.innerHTML = 
          '<div>' +
            '<p class="font-medium">' + patientName + '</p>' +
            '<p class="text-sm text-base-content/70">' + dateString + ' ' + timeString + '</p>' +
          '</div>' +
          '<div>' + statusBadge + '</div>';
        
        container.appendChild(appointmentElement);
      });

    } catch (error) {
      console.error('Error loading recent appointments:', error);
    }
  }

  // Load recent orders
  async function loadRecentOrders() {
    try {
      const response = await fetch(API_BASE + '/orders');
      const data = await response.json();
      const orders = data.elements || data || [];
      
      // Get 5 most recent orders
      const recentOrders = orders
        .sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate))
        .slice(0, 5);

      const container = document.getElementById('recentOrders');
      container.innerHTML = '';

      if (recentOrders.length === 0) {
        container.innerHTML = '<p class="text-base-content/70">No recent orders</p>';
        return;
      }

      recentOrders.forEach(function(order) {
        const orderDate = new Date(order.orderDate);
        const statusBadge = getStatusBadge(order.orderStatus);
        
        const orderElement = document.createElement('div');
        orderElement.className = 'flex justify-between items-center p-3 bg-white rounded-lg border border-gray-200';
        
        const medicineName = order.medicineName || 'Unknown Medicine';
        const dateString = orderDate.toLocaleDateString();
        const quantity = order.quantity;
        
        orderElement.innerHTML = 
          '<div>' +
            '<p class="font-medium">' + medicineName + '</p>' +
            '<p class="text-sm text-base-content/70">' + dateString + ' - Qty: ' + quantity + '</p>' +
          '</div>' +
          '<div>' + statusBadge + '</div>';
        
        container.appendChild(orderElement);
      });

    } catch (error) {
      console.error('Error loading recent orders:', error);
    }
  }

  // Load recent treatments
  async function loadRecentTreatments() {
    try {
      const response = await fetch(API_BASE + '/treatments');
      const data = await response.json();
      const treatments = data.elements || data || [];
      
      // Filter out treatments with null dates and get 5 most recent treatments
      const validTreatments = treatments.filter(treatment => 
        treatment && treatment.treatmentDate && treatment.treatmentDate !== null
      );
      
      const recentTreatments = validTreatments
        .sort((a, b) => new Date(b.treatmentDate) - new Date(a.treatmentDate))
        .slice(0, 5);

      const container = document.getElementById('recentTreatments');
      container.innerHTML = '';

      if (recentTreatments.length === 0) {
        container.innerHTML = '<p class="text-base-content/70">No recent treatments</p>';
        return;
      }

      recentTreatments.forEach(function(treatment) {
        const treatmentDate = new Date(treatment.treatmentDate);
        const statusBadge = getTreatmentStatusBadge(treatment.status);
        
        const treatmentElement = document.createElement('div');
        treatmentElement.className = 'flex justify-between items-center p-3 bg-white rounded-lg border border-gray-200';
        
        const treatmentName = treatment.treatmentName || 'Unknown Treatment';
        const dateString = treatmentDate.toLocaleDateString();
        const timeString = treatmentDate.toLocaleTimeString('en-US', {hour: '2-digit', minute: '2-digit'});
        
        treatmentElement.innerHTML = 
          '<div>' +
            '<p class="font-medium">' + treatmentName + '</p>' +
            '<p class="text-sm text-base-content/70">' + dateString + ' ' + timeString + '</p>' +
          '</div>' +
          '<div>' + statusBadge + '</div>';
        
        container.appendChild(treatmentElement);
      });

    } catch (error) {
      console.error('Error loading recent treatments:', error);
    }
  }



  // Initialize charts
  function initializeCharts() {
    const ctx = document.getElementById('appointmentsChart').getContext('2d');
    appointmentsChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'Appointments',
          data: [12, 19, 15, 25, 22, 18, 14],
          backgroundColor: 'rgba(94, 131, 242, 0.2)',
          borderColor: '#5E83F2',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
  }

  // Get status badge HTML
  function getStatusBadge(status) {
    if (!status) return '<span class="badge badge-soft badge-neutral">Unknown</span>';
    
    const statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'scheduled':
      case 'confirmed':
        return '<span class="badge badge-soft badge-success">Confirmed</span>';
      case 'cancelled':
        return '<span class="badge badge-soft badge-error">Cancelled</span>';
      case 'completed':
        return '<span class="badge badge-soft badge-warning">Completed</span>';
      case 'check in':
      case 'checked-in':
        return '<span class="badge badge-soft badge-primary">Checked In</span>';
      case 'pending':
        return '<span class="badge badge-soft badge-warning">Pending</span>';
      case 'shipped':
        return '<span class="badge badge-soft badge-info">Shipped</span>';
      case 'delivered':
        return '<span class="badge badge-soft badge-success">Delivered</span>';
      default:
        return '<span class="badge badge-soft badge-neutral">' + status + '</span>';
    }
  }

  // Get treatment status badge HTML
  function getTreatmentStatusBadge(status) {
    if (!status) return '<span class="badge badge-soft badge-neutral">Unknown</span>';
    
    const statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'scheduled':
        return '<span class="badge badge-soft badge-info">Scheduled</span>';
      case 'in progress':
        return '<span class="badge badge-soft badge-warning">In Progress</span>';
      case 'completed':
        return '<span class="badge badge-soft badge-success">Completed</span>';
      case 'cancelled':
        return '<span class="badge badge-soft badge-error">Cancelled</span>';
      case 'on hold':
        return '<span class="badge badge-soft badge-secondary">On Hold</span>';
      default:
        return '<span class="badge badge-soft badge-neutral">' + status + '</span>';
    }
  }

  // Show error message
  function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    document.getElementById('errorAlert').classList.remove('hidden');
  }

  // Hide loading spinner
  function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
  }

  // Show content
  function showContent() {
    document.getElementById('statsSection').classList.remove('hidden');
  }

  // Initialize dashboard
  document.addEventListener('DOMContentLoaded', function() {
    loadDashboardData();
    updateCurrentTime();
    setInterval(updateCurrentTime, 1000);
  });
</script>
</body>
</html>
