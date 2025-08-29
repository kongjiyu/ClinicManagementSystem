<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reports Dashboard</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="ml-64 p-6 space-y-8 w-full">
  <div class="flex justify-between items-center">
    <h1 class="text-3xl font-bold">Reports Dashboard</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="refreshAllReports()">
        <span class="icon-[tabler--refresh] size-4 mr-2"></span>
        Refresh All
      </button>
    </div>
  </div>

  <!-- Module Selection -->
  <div class="bg-base-200 rounded-lg p-6">
    <h2 class="text-xl font-semibold mb-4">Select Module</h2>
    <div class="grid grid-cols-2 lg:grid-cols-5 gap-4">
      <button class="btn btn-outline btn-lg" onclick="selectModule('patient')">
        <span class="icon-[tabler--user] size-6 mr-2"></span>
        Patient
      </button>
      <button class="btn btn-outline btn-lg" onclick="selectModule('doctor')">
        <span class="icon-[tabler--user-star] size-6 mr-2"></span>
        Doctor
      </button>
      <button class="btn btn-outline btn-lg" onclick="selectModule('consultation')">
        <span class="icon-[tabler--stethoscope] size-6 mr-2"></span>
        Consultation
      </button>
      <button class="btn btn-outline btn-lg" onclick="selectModule('medicine')">
        <span class="icon-[tabler--pill] size-6 mr-2"></span>
        Medicine
      </button>
      <button class="btn btn-outline btn-lg" onclick="selectModule('treatment')">
        <span class="icon-[tabler--medical-cross] size-6 mr-2"></span>
        Treatment
      </button>
    </div>
  </div>

  <!-- Date Range Filter -->
  <div id="dateFilterSection" class="bg-base-200 rounded-lg p-6" style="display: none;">
    <h2 class="text-xl font-semibold mb-4">Report Filters</h2>
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
      <div>
        <label class="label">Start Date</label>
        <input type="date" id="startDate" class="input input-bordered w-full" onchange="validateDateRange()">
      </div>
      <div>
        <label class="label">End Date</label>
        <input type="date" id="endDate" class="input input-bordered w-full" onchange="validateDateRange()">
      </div>
      <div class="flex items-end">
        <button class="btn btn-primary w-full" onclick="validateAndLoadReport()">
          <span class="icon-[tabler--filter] size-4 mr-2"></span>
          Apply Filters
        </button>
      </div>
    </div>
  </div>

  <!-- Reports Grid -->
  <div id="reportsGrid" class="grid grid-cols-1 gap-6" style="display: none;">

    <!-- Patient Registration Report -->
    <div id="patientReportCard" class="bg-base-200 rounded-lg p-6" style="display: none;">
      <h2 class="text-xl font-semibold mb-4">Patient Registration Trends</h2>
      <div id="patientReport" class="space-y-4">

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-80">
            <canvas id="patientGenderChart"></canvas>
          </div>
          <div class="h-80">
            <canvas id="patientAgeChart"></canvas>
          </div>
          <div class="h-80">
            <canvas id="patientBloodTypeChart"></canvas>
          </div>
          <div class="h-80">
            <canvas id="patientNationalityChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Doctor Management Report -->
    <div id="doctorReportCard" class="bg-base-200 rounded-lg p-6" style="display: none;">
      <h2 class="text-xl font-semibold mb-4">Doctor Management</h2>
      <div id="doctorReport" class="space-y-4">
        <div class="stats stats-horizontal shadow">
          <div class="stat">
            <div class="stat-title">Total Doctors</div>
            <div id="totalDoctors" class="stat-value text-primary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Avg Consultations</div>
            <div id="avgConsultations" class="stat-value text-secondary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Total Schedules</div>
            <div id="totalSchedules" class="stat-value text-info">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Avg Hours/Week</div>
            <div id="avgHoursPerWeek" class="stat-value text-warning">-</div>
          </div>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="doctorSpecialtyChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="doctorTreatmentChart"></canvas>
          </div>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="doctorScheduleChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="doctorExperienceChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Consultation Volume Report -->
    <div id="consultationReportCard" class="bg-base-200 rounded-lg p-6" style="display: none;">
      <h2 class="text-xl font-semibold mb-4">Consultation Analytics</h2>
      <div id="consultationReport" class="space-y-4">
        <div class="stats stats-horizontal shadow">
          <div class="stat">
            <div class="stat-title">Total Consultations</div>
            <div id="totalConsultations" class="stat-value text-primary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Avg/Day</div>
            <div id="avgConsultationsPerDay" class="stat-value text-secondary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Peak Hour</div>
            <div id="peakHour" class="stat-value text-accent">-</div>
          </div>
        </div>

        <!-- First Row: Status and Hourly -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="consultationStatusChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="consultationHourlyChart"></canvas>
          </div>
        </div>

        <!-- Second Row: Daily Trends and Monthly Comparison -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="consultationDailyTrendChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="monthlyComparisonChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Medicine Sales Report -->
    <div id="medicineReportCard" class="bg-base-200 rounded-lg p-6" style="display: none;">
      <h2 class="text-xl font-semibold mb-4">Medicine Sales Analytics</h2>
      <div id="medicineSalesReport" class="space-y-4">
        <!-- Enhanced Statistics -->
        <div class="stats stats-horizontal shadow">
          <div class="stat">
            <div class="stat-title">Total Revenue</div>
            <div id="totalRevenue" class="stat-value text-primary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Total Quantity</div>
            <div id="totalQuantitySold" class="stat-value text-secondary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Avg/Prescription</div>
            <div id="avgRevenuePerPrescription" class="stat-value text-accent">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Top Medicine</div>
            <div id="topSellingMedicine" class="stat-value text-info">-</div>
          </div>
        </div>

        <!-- First Row: Sales Chart -->
        <div class="grid grid-cols-1 gap-6">
          <div class="h-96">
            <canvas id="medicineSalesChart"></canvas>
          </div>
        </div>

        <!-- Second Row: Trends and Performance -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="medicineTrendsChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="medicinePerformanceChart"></canvas>
          </div>
        </div>

        <!-- Third Row: Top Medicines Table -->
        <div class="bg-base-100 rounded-lg p-4">
          <h3 class="text-lg font-semibold mb-3">Top Selling Medicines Details</h3>
          <div class="overflow-x-auto">
            <table class="table table-zebra w-full table-sm">
              <thead class="sticky top-0 bg-base-300">
                <tr>
                  <th>Rank</th>
                  <th>Medicine</th>
                  <th>Quantity Sold</th>
                  <th>Revenue</th>
                  <th>Avg Price</th>
                  <th>Growth</th>
                </tr>
              </thead>
              <tbody id="topSellingMedicines">
                <!-- Will be populated by JavaScript -->
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Treatment Management Report -->
    <div id="treatmentReportCard" class="bg-base-200 rounded-lg p-6" style="display: none;">
      <h2 class="text-xl font-semibold mb-4">Treatment Management Analytics</h2>
      <div id="treatmentReport" class="space-y-4">
        <!-- Enhanced Statistics -->
        <div class="stats stats-horizontal shadow">
          <div class="stat">
            <div class="stat-title">Total Treatments</div>
            <div id="totalTreatments" class="stat-value text-primary">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Success Rate</div>
            <div id="treatmentSuccessRate" class="stat-value text-info">-</div>
          </div>
          <div class="stat">
            <div class="stat-title">Completed</div>
            <div id="completedTreatments" class="stat-value text-success">-</div>
          </div>

        </div>

        <!-- First Row: Treatment Types and Outcomes -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="treatmentTypeChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="treatmentOutcomeChart"></canvas>
          </div>
        </div>

        <!-- Second Row: Treatment Duration and Revenue Analysis -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="h-96">
            <canvas id="treatmentDurationChart"></canvas>
          </div>
          <div class="h-96">
            <canvas id="treatmentRevenueChart"></canvas>
          </div>
        </div>

        <!-- Third Row: Treatment Details Table -->
        <div class="bg-base-100 rounded-lg p-4">
          <h3 class="text-lg font-semibold mb-3">Treatment Performance by Doctor</h3>
          <div class="overflow-x-auto">
            <table class="table table-zebra w-full table-sm">
              <thead class="sticky top-0 bg-base-300">
                <tr>
                  <th>Rank</th>
                  <th>Doctor</th>
                  <th>Total Treatments</th>
                  <th>Completed</th>
                  <th>Success Rate</th>
                  <th>Top Treatment Type</th>
                </tr>
              </thead>
              <tbody id="treatmentTable">
                <!-- Will be populated by JavaScript -->
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

  </div>
</main>

<script>
  const API_BASE = '/api';
  let charts = {};
  let selectedModule = null;

  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    setDefaultDateRange();
    // Don't load reports automatically - wait for module selection
  });

  // Set default date range (last month)
  function setDefaultDateRange() {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setMonth(startDate.getMonth() - 1);

    document.getElementById('startDate').value = startDate.toISOString().split('T')[0];
    document.getElementById('endDate').value = endDate.toISOString().split('T')[0];
  }



  // Module selection function
  function selectModule(module) {
    selectedModule = module;

    // Show date filter section only for non-patient modules
    if (module === 'patient') {
      document.getElementById('dateFilterSection').style.display = 'none';
    } else {
      document.getElementById('dateFilterSection').style.display = 'block';
    }

    // Show reports grid
    document.getElementById('reportsGrid').style.display = 'grid';

    // Hide all report cards
    document.getElementById('patientReportCard').style.display = 'none';
    document.getElementById('doctorReportCard').style.display = 'none';
    document.getElementById('consultationReportCard').style.display = 'none';
    document.getElementById('medicineReportCard').style.display = 'none';
    document.getElementById('treatmentReportCard').style.display = 'none';

    // Show selected report card
    switch(module) {
      case 'patient':
        document.getElementById('patientReportCard').style.display = 'block';
        break;
      case 'doctor':
        document.getElementById('doctorReportCard').style.display = 'block';
        break;
      case 'consultation':
        document.getElementById('consultationReportCard').style.display = 'block';
        break;
      case 'medicine':
        document.getElementById('medicineReportCard').style.display = 'block';
        break;
      case 'treatment':
        document.getElementById('treatmentReportCard').style.display = 'block';
        break;
    }

    // Load the selected report
    loadSelectedReport();
  }

  // Validate date range
  function validateDateRange() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    if (startDate && endDate) {
      const start = new Date(startDate);
      const end = new Date(endDate);
      
      if (end < start) {
        alert('End date cannot be earlier than start date. Please select a valid date range.');
        document.getElementById('endDate').value = startDate; // Reset end date to start date
        return false;
      }
    }
    return true;
  }

  // Validate and load report
  function validateAndLoadReport() {
    if (validateDateRange()) {
      loadSelectedReport();
    }
  }

  // Load selected report
  async function loadSelectedReport() {
    if (!selectedModule) return;

    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    try {
      switch(selectedModule) {
        case 'patient':
          await loadPatientRegistrationReport();
          break;
        case 'doctor':
          await loadDoctorManagementReport(startDate, endDate);
          break;
        case 'consultation':
          await loadConsultationVolumeReport(startDate, endDate);
          break;
        case 'medicine':
          await loadMedicineSalesReport(startDate, endDate);
          break;
        case 'treatment':
          await loadTreatmentManagementReport(startDate, endDate);
          break;
      }
    } catch (error) {
      console.error('Error loading report:', error);
      alert('Error loading report: ' + error.message);
    }
  }

  // Refresh current report
  function refreshAllReports() {
    loadSelectedReport();
  }



  // Load Doctor Management Report
  async function loadDoctorManagementReport(startDate, endDate) {
    try {
      const url = API_BASE + '/reports/doctor-management?startDate=' + startDate + '&endDate=' + endDate;
      console.log('Fetching doctor management report from:', url);
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to load doctor management report');

      const data = await response.json();
      const reportData = data.data;

      // Store data globally for PDF export
      window.doctorReportData = reportData;

      // Update statistics
      document.getElementById('totalDoctors').textContent = reportData.totalDoctors || '0';
      document.getElementById('avgConsultations').textContent = (reportData.avgConsultationsPerDoctor || 0).toFixed(1) + ' consultations';
      document.getElementById('totalSchedules').textContent = reportData.totalSchedules || '0';
      document.getElementById('avgHoursPerWeek').textContent = (reportData.avgHoursPerWeek || 0).toFixed(1) + ' hrs';

      // Create doctor consultation distribution chart (Horizontal Bar)
      if (reportData.doctorConsultationCounts && Array.isArray(reportData.doctorConsultationCounts) && reportData.doctorConsultationCounts.length > 0) {
        // Convert array format to object format for charts
        const consultationData = {};
        reportData.doctorConsultationCounts.forEach(item => {
          consultationData[item.doctorName] = item.consultationCount;
        });
        createHorizontalBarChart('doctorSpecialtyChart', 'Doctor Consultation Distribution', consultationData);
      } else {
        // Create empty chart if no data
        createHorizontalBarChart('doctorSpecialtyChart', 'Doctor Consultation Distribution', {});
      }

      // Create doctor treatment distribution chart (Radar Chart)
      if (reportData.doctorPerformance && reportData.doctorPerformance.elements && reportData.doctorPerformance.elements.length > 0) {
        const treatmentData = {};
        reportData.doctorPerformance.elements.forEach(doctor => {
          treatmentData[doctor.doctorName] = doctor.treatments || 0;
        });
        createRadarChart('doctorTreatmentChart', 'Doctor Treatment Distribution', treatmentData);
      } else {
        createRadarChart('doctorTreatmentChart', 'Doctor Treatment Distribution', {});
      }

      // Create doctor schedule distribution chart (Polar Area Chart)
      if (reportData.doctorSchedules && Array.isArray(reportData.doctorSchedules) && reportData.doctorSchedules.length > 0) {
        // Convert array format to object format for charts
        const scheduleData = {};
        reportData.doctorSchedules.forEach(item => {
          scheduleData[item.doctorName] = item.scheduleHours;
        });
        createPolarAreaChart('doctorScheduleChart', 'Doctor Schedule Distribution (Hours/Week)', scheduleData);
      } else {
        createPolarAreaChart('doctorScheduleChart', 'Doctor Schedule Distribution (Hours/Week)', {});
      }

      // Create doctor experience chart (Horizontal Bar with gradient)
      if (reportData.doctorPerformance && reportData.doctorPerformance.elements && reportData.doctorPerformance.elements.length > 0) {
        const experienceData = {};
        reportData.doctorPerformance.elements.forEach(doctor => {
          experienceData[doctor.doctorName] = doctor.experience || 0;
        });
        createHorizontalBarChart('doctorExperienceChart', 'Doctor Experience (Years)', experienceData);
      } else {
        createHorizontalBarChart('doctorExperienceChart', 'Doctor Experience (Years)', {});
      }

    } catch (error) {
      console.error('Error loading doctor management report:', error);
      // Show error message instead of sample data
      showDoctorReportError('Failed to load doctor management data: ' + error.message);
    }
  }

  // Show doctor report error
  function showDoctorReportError(message) {
    document.getElementById('totalDoctors').textContent = 'Error';
    document.getElementById('avgConsultations').textContent = 'Error';
    document.getElementById('totalSchedules').textContent = 'Error';
    document.getElementById('avgHoursPerWeek').textContent = 'Error';

    showChartError('doctorSpecialtyChart', message);
    showChartError('doctorTreatmentChart', message);
    showChartError('doctorScheduleChart', message);
    showChartError('doctorExperienceChart', message);
  }

  // Load Patient Registration Report
  async function loadPatientRegistrationReport() {
    try {
      const url = API_BASE + '/reports/patient-registration';
      console.log('Fetching patient registration report from:', url);
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to load patient registration report');

      const data = await response.json();
      const reportData = data.data;

      // Create gender distribution chart
      createPieChart('patientGenderChart', 'Gender Distribution', reportData.genderDistribution);

      // Create age distribution chart
      createBarChart('patientAgeChart', 'Age Distribution', reportData.ageDistribution);

      // Create blood type distribution chart
      createPieChart('patientBloodTypeChart', 'Blood Type Distribution', reportData.bloodTypeDistribution);

      // Create nationality distribution chart
      createBarChart('patientNationalityChart', 'Nationality Distribution', reportData.nationalityDistribution);

    } catch (error) {
      console.error('Error loading patient registration report:', error);
      showPatientReportError('Failed to load patient registration data: ' + error.message);
    }
  }

  // Load Consultation Volume Report
  async function loadConsultationVolumeReport(startDate, endDate) {
    try {
      const url = API_BASE + '/reports/consultation-volume?startDate=' + startDate + '&endDate=' + endDate;
      console.log('Fetching consultation volume report from:', url);
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to load consultation volume report');

      const data = await response.json();
      const reportData = data.data;

      // Update statistics
      document.getElementById('totalConsultations').textContent = reportData.totalConsultations;
      document.getElementById('avgConsultationsPerDay').textContent = reportData.averageConsultationsPerDay.toFixed(1);

      // Create status distribution chart
      createPieChart('consultationStatusChart', 'Consultation Status Distribution', reportData.statusDistribution);

      // Create hourly distribution chart
      createBarChart('consultationHourlyChart', 'Consultations by Hour', reportData.hourlyConsultations);

      // Load additional consultation charts with sample data
      loadAdditionalConsultationCharts(reportData);

    } catch (error) {
      console.error('Error loading consultation volume report:', error);
      // Show error message instead of sample data
      showConsultationReportError('Failed to load consultation data: ' + error.message);
    }
  }

  // Load additional consultation charts
  async function loadAdditionalConsultationCharts(reportData) {
    // Update additional statistics
    const peakHourData = convertArrayToObject(reportData.hourlyConsultations || []);
    const peakHour = Object.keys(peakHourData).reduce((a, b) => peakHourData[a] > peakHourData[b] ? a : b, '0');
    document.getElementById('peakHour').textContent = peakHour + ':00';

    // Load real data for additional charts
    await loadRealConsultationCharts();
  }

  // Show consultation report error
  function showConsultationReportError(message) {
    document.getElementById('totalConsultations').textContent = 'Error';
    document.getElementById('avgConsultationsPerDay').textContent = 'Error';
    document.getElementById('peakHour').textContent = 'Error';

    showChartError('consultationStatusChart', message);
    showChartError('consultationHourlyChart', message);
    showChartError('consultationDailyTrendChart', message);
    showChartError('monthlyComparisonChart', message);
  }

  // Load real data for consultation charts
  async function loadRealConsultationCharts() {
    try {
      const startDate = document.getElementById('startDate').value;
      const endDate = document.getElementById('endDate').value;

      // Load Daily Trends
      const dailyTrendsResponse = await fetch(API_BASE + '/reports/consultation-daily-trends?startDate=' + startDate + '&endDate=' + endDate);
      if (dailyTrendsResponse.ok) {
        const dailyTrendsData = await dailyTrendsResponse.json();
        createLineChart('consultationDailyTrendChart', 'Daily Consultation Trends', dailyTrendsData);
      } else {
        showChartError('consultationDailyTrendChart', 'Failed to load daily trends data');
      }

      // Load Monthly Comparison
      const monthlyResponse = await fetch(API_BASE + '/reports/consultation-monthly-comparison?months=6');
      if (monthlyResponse.ok) {
        const monthlyData = await monthlyResponse.json();
        createLineChart('monthlyComparisonChart', 'Monthly Consultation Trends', monthlyData);
      } else {
        showChartError('monthlyComparisonChart', 'Failed to load monthly comparison data');
      }

    } catch (error) {
      console.error('Error loading real consultation charts:', error);
      // Show error message instead of sample data
      showConsultationReportError('Failed to load additional consultation charts: ' + error.message);
    }
  }

  // Load Medicine Sales Report
  async function loadMedicineSalesReport(startDate, endDate) {
    try {
      const url = API_BASE + '/reports/medicine-sales?startDate=' + startDate + '&endDate=' + endDate;
      console.log('Fetching medicine sales report from:', url);
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to load medicine sales report');

      const data = await response.json();
      const reportData = data.data;

      // Update enhanced statistics
              document.getElementById('totalRevenue').textContent = 'RM ' + reportData.totalRevenue.toFixed(2);
        document.getElementById('avgRevenuePerPrescription').textContent = 'RM ' + reportData.averageRevenuePerPrescription.toFixed(2);

      // Calculate additional statistics
      let totalQuantity = 0;
      let topMedicine = '';
      let maxQuantity = 0;

      // Handle elements array structure
      const medicinesArray = reportData.topSellingMedicines && reportData.topSellingMedicines.elements ?
        reportData.topSellingMedicines.elements :
        (Array.isArray(reportData.topSellingMedicines) ? reportData.topSellingMedicines : []);

      if (medicinesArray.length > 0) {
        medicinesArray.forEach(medicine => {
          totalQuantity += medicine.quantitySold || 0;
          if ((medicine.quantitySold || 0) > maxQuantity) {
            maxQuantity = medicine.quantitySold || 0;
            topMedicine = medicine.medicineName || 'Unknown';
          }
        });
      }

      document.getElementById('totalQuantitySold').textContent = totalQuantity.toLocaleString();
      document.getElementById('topSellingMedicine').textContent = topMedicine || 'N/A';

      // Create enhanced charts
      await loadMedicineCharts(reportData, startDate, endDate);

      // Update enhanced top selling medicines table
      await updateEnhancedMedicinesTable(medicinesArray);

    } catch (error) {
      console.error('Error loading medicine sales report:', error);
      // Show error message instead of sample data
      showMedicineReportError('Failed to load medicine sales data: ' + error.message);
    }
  }

  // Load medicine charts with enhanced visualizations
  async function loadMedicineCharts(reportData, startDate, endDate) {
    try {
      // Chart 1: Medicine Sales (Bar Chart)
      createBarChart('medicineSalesChart', 'Medicine Sales by Quantity', reportData.medicineSales);

      // Chart 2: Growth Comparison (Horizontal Bar Chart) - Load real growth data
      const growthResponse = await fetch(API_BASE + '/reports/medicine-growth-comparison?startDate=' + startDate + '&endDate=' + endDate);
      if (growthResponse.ok) {
        const growthData = await growthResponse.json();
        createHorizontalBarChart('medicineTrendsChart', 'Medicine Growth vs Previous Period (%)', growthData);
      } else {
        showChartError('medicineTrendsChart', 'Failed to load growth comparison data');
      }

      // Chart 3: Performance Analysis (Bar Chart) - Load real data
      const performanceResponse = await fetch(API_BASE + '/reports/medicine-performance-analysis?startDate=' + startDate + '&endDate=' + endDate);
      if (performanceResponse.ok) {
        const performanceData = await performanceResponse.json();
        createBarChart('medicinePerformanceChart', 'Medicine Performance Analysis', performanceData);
      } else {
        showChartError('medicinePerformanceChart', 'Failed to load performance analysis data');
      }

    } catch (error) {
      console.error('Error loading medicine charts:', error);
      showMedicineReportError('Failed to load medicine charts: ' + error.message);
    }
  }



  // Show medicine report error
  function showMedicineReportError(message) {
    document.getElementById('totalRevenue').textContent = 'Error';
    document.getElementById('totalQuantitySold').textContent = 'Error';
    document.getElementById('avgRevenuePerPrescription').textContent = 'Error';
    document.getElementById('topSellingMedicine').textContent = 'Error';

    showChartError('medicineSalesChart', message);
    showChartError('medicineTrendsChart', message);
    showChartError('medicinePerformanceChart', message);

    // Show error in table
    const tbody = document.getElementById('topSellingMedicines');
    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-error">Error loading medicine data: ' + message + '</td></tr>';
  }

  // Load Treatment Management Report
  async function loadTreatmentManagementReport(startDate, endDate) {
    try {
      const url = API_BASE + '/reports/treatment-analytics?startDate=' + startDate + '&endDate=' + endDate;
      console.log('Fetching treatment analytics report from:', url);
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to load treatment analytics report');

      const data = await response.json();
      const reportData = data.data;

      // Update statistics
      document.getElementById('totalTreatments').textContent = reportData.totalTreatments || '0';
      document.getElementById('completedTreatments').textContent = reportData.completedTreatments || '0';
      document.getElementById('treatmentSuccessRate').textContent = (reportData.successRate || 0).toFixed(1) + '%';

      // Load charts
      await loadTreatmentCharts(reportData);

      // Update treatment table
      updateTreatmentTable(reportData.doctorPerformance);

    } catch (error) {
      console.error('Error loading treatment management report:', error);
      showTreatmentReportError('Failed to load treatment management data: ' + error.message);
    }
  }





  // Show treatment report error
  function showTreatmentReportError(message) {
    document.getElementById('totalTreatments').textContent = 'Error';
    document.getElementById('treatmentSuccessRate').textContent = 'Error';
    document.getElementById('completedTreatments').textContent = 'Error';

    showChartError('treatmentTypeChart', message);
    showChartError('treatmentOutcomeChart', message);
    showChartError('treatmentDurationChart', message);
    showChartError('treatmentRevenueChart', message);

    // Show error in table
    const tbody = document.getElementById('treatmentTable');
    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-error">Error loading treatment data: ' + message + '</td></tr>';
  }



  // Load treatment charts
  async function loadTreatmentCharts(reportData) {
    try {
      // Chart 1: Treatment Types Distribution (Pie Chart)
      if (reportData.treatmentTypes && Object.keys(reportData.treatmentTypes).length > 0) {
        createDoughnutChart('treatmentTypeChart', 'Treatment Types Distribution', reportData.treatmentTypes);
      } else {
        showChartError('treatmentTypeChart', 'No treatment types data available');
      }



      // Chart 2: Treatment Outcomes (Horizontal Bar Chart)
      if (reportData.treatmentOutcomes && Object.keys(reportData.treatmentOutcomes).length > 0) {
        createHorizontalBarChart('treatmentOutcomeChart', 'Treatment Outcomes', reportData.treatmentOutcomes);
      } else {
        showChartError('treatmentOutcomeChart', 'No treatment outcomes data available');
      }

      // Chart 3: Treatment Duration Analysis (Radar Chart)
      if (reportData.treatmentDurations && Object.keys(reportData.treatmentDurations).length > 0) {
        createRadarChart('treatmentDurationChart', 'Treatment Duration Analysis', reportData.treatmentDurations);
      } else {
        showChartError('treatmentDurationChart', 'No duration data available');
      }

      // Chart 4: Treatment Revenue Analysis (Polar Area Chart)
      if (reportData.treatmentRevenue && Object.keys(reportData.treatmentRevenue).length > 0) {
        createPolarAreaChart('treatmentRevenueChart', 'Treatment Revenue Analysis', reportData.treatmentRevenue);
      } else {
        showChartError('treatmentRevenueChart', 'No revenue data available');
      }

    } catch (error) {
      console.error('Error loading treatment charts:', error);
      showTreatmentReportError('Failed to load treatment charts: ' + error.message);
    }
  }

  // Update treatment table
  function updateTreatmentTable(doctorPerformance) {
    try {
      const tbody = document.getElementById('treatmentTable');
      tbody.innerHTML = '';

      // Handle different data structures
      let doctorArray = [];

      if (Array.isArray(doctorPerformance)) {
        doctorArray = doctorPerformance;
      } else if (doctorPerformance && typeof doctorPerformance === 'object') {
        // If it's an object, try to extract the elements array
        if (doctorPerformance.elements && Array.isArray(doctorPerformance.elements)) {
          doctorArray = doctorPerformance.elements;
        } else {
          // If it's a plain object, convert to array
          doctorArray = Object.values(doctorPerformance);
        }
      }

      if (!doctorArray || doctorArray.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center text-error">No treatment data available</td></tr>';
        return;
      }

      // Sort by total treatments (descending)
      const sortedDoctors = doctorArray.sort((a, b) => {
        const aTotal = a.totalTreatments || 0;
        const bTotal = b.totalTreatments || 0;
        return bTotal - aTotal;
      });

      sortedDoctors.forEach((doctor, index) => {
        const row = tbody.insertRow();
        row.innerHTML =
          '<td>' + (index + 1) + '</td>' +
          '<td>' + (doctor.doctorName || doctor.doctorId || 'Unknown') + '</td>' +
          '<td>' + (doctor.totalTreatments || 0) + '</td>' +
          '<td>' + (doctor.completedTreatments || 0) + '</td>' +
          '<td>' + (doctor.successRate || 0).toFixed(1) + '%</td>' +
          '<td>' + (doctor.topTreatmentType || 'N/A') + '</td>';
      });

    } catch (error) {
      console.error('Error updating treatment table:', error);
      const tbody = document.getElementById('treatmentTable');
      tbody.innerHTML = '<tr><td colspan="6" class="text-center text-error">Error updating treatment table: ' + error.message + '</td></tr>';
    }
  }

  // Create pie chart
  function createPieChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);
    const labels = Object.keys(chartData);
    const values = Object.values(chartData);
    const colors = ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#06B6D4'];

    charts[canvasId] = new Chart(canvas, {
      type: 'pie',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: colors.slice(0, labels.length),
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            position: 'bottom'
          }
        }
      }
    });
  }

  // Create bar chart
  function createBarChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);

    charts[canvasId] = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: title,
          data: values,
          backgroundColor: '#3B82F6',
          borderColor: '#2563EB',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
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

  // Create horizontal bar chart
  function createHorizontalBarChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);

    // Create gradient backgrounds with fallback
    const gradients = labels.map((_, index) => {
      const colors = [
        '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
        '#06B6D4', '#84CC16', '#F97316', '#EC4899', '#6366F1'
      ];

      // Try to create gradient, fallback to solid color if not available
      try {
        const ctx2d = canvas.getContext('2d');
        if (ctx2d && typeof ctx2d.createLinearGradient === 'function') {
          const gradient = ctx2d.createLinearGradient(0, 0, 0, 400);
          const colorPair = [
            colors[index % colors.length],
            colors[(index + 5) % colors.length] // Use a different color for gradient end
          ];
          gradient.addColorStop(0, colorPair[0]);
          gradient.addColorStop(1, colorPair[1]);
          return gradient;
        }
      } catch (error) {
        console.warn('Gradient creation failed, using solid color:', error);
      }

      // Fallback to solid color
      return colors[index % colors.length];
    });

    charts[canvasId] = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: title,
          data: values,
          backgroundColor: gradients,
          borderColor: '#2563EB',
          borderWidth: 2,
          borderRadius: 8,
          borderSkipped: false
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.1)',
              drawBorder: false
            },
            ticks: {
              font: {
                weight: 'bold'
              }
            }
          },
          y: {
            grid: {
              display: false
            },
            ticks: {
              font: {
                weight: 'bold'
              }
            }
          }
        }
      }
    });
  }

  // Create doughnut chart
  function createDoughnutChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);
    const colors = [
      '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
      '#06B6D4', '#84CC16', '#F97316', '#EC4899', '#6366F1'
    ];

    charts[canvasId] = new Chart(canvas, {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: colors.slice(0, labels.length),
          borderWidth: 4,
          borderColor: '#fff',
          hoverBorderWidth: 6,
          hoverOffset: 10
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            position: 'bottom',
            labels: {
              padding: 25,
              usePointStyle: true,
              font: {
                weight: 'bold'
              }
            }
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#3B82F6',
            borderWidth: 2,
            cornerRadius: 8
          }
        },
        cutout: '65%',
        animation: {
          animateRotate: true,
          animateScale: true
        }
      }
    });
  }

  // Create radar chart
  function createRadarChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);

    charts[canvasId] = new Chart(canvas, {
      type: 'radar',
      data: {
        labels: labels,
        datasets: [{
          label: title,
          data: values,
          backgroundColor: 'rgba(59, 130, 246, 0.3)',
          borderColor: '#3B82F6',
          borderWidth: 4,
          pointBackgroundColor: '#3B82F6',
          pointBorderColor: '#fff',
          pointBorderWidth: 3,
          pointRadius: 8,
          pointHoverRadius: 12,
          pointHoverBackgroundColor: '#2563EB',
          pointHoverBorderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#3B82F6',
            borderWidth: 2,
            cornerRadius: 8
          }
        },
        scales: {
          r: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.1)',
              circular: true
            },
            pointLabels: {
              font: {
                size: 12,
                weight: 'bold'
              },
              color: '#374151'
            },
            ticks: {
              font: {
                weight: 'bold'
              },
              color: '#6B7280'
            }
          }
        },
        animation: {
          duration: 2000,
          easing: 'easeInOutQuart'
        }
      }
    });
  }

  // Create polar area chart
  function createPolarAreaChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);
    const colors = [
      '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
      '#06B6D4', '#84CC16', '#F97316', '#EC4899', '#6366F1'
    ];

    charts[canvasId] = new Chart(canvas, {
      type: 'polarArea',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: colors.slice(0, labels.length).map(color =>
            color + '80' // Add transparency
          ),
          borderColor: colors.slice(0, labels.length),
          borderWidth: 3,
          hoverBorderWidth: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            position: 'bottom',
            labels: {
              padding: 25,
              usePointStyle: true,
              font: {
                weight: 'bold'
              }
            }
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#3B82F6',
            borderWidth: 2,
            cornerRadius: 8
          }
        },
        animation: {
          duration: 1500,
          easing: 'easeInOutQuart'
        }
      }
    });
  }

  // Create bubble chart for nationality distribution
  function createBubbleChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);

    const labels = Object.keys(chartData);
    const values = Object.values(chartData);
    const total = values.reduce((sum, val) => sum + val, 0);

    // Create bubble data with size based on percentage
    const bubbleData = labels.map((label, index) => {
      const value = values[index];
      const percentage = (value / total) * 100;
      return {
        x: Math.random() * 100, // Random x position
        y: Math.random() * 100, // Random y position
        r: Math.max(10, percentage * 2) // Size based on percentage
      };
    });

    const colors = [
      '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
      '#06B6D4', '#84CC16', '#F97316', '#EC4899', '#6366F1'
    ];

    charts[canvasId] = new Chart(canvas, {
      type: 'bubble',
      data: {
        datasets: [{
          label: title,
          data: bubbleData,
          backgroundColor: colors.slice(0, labels.length).map(color =>
            color + '80' // Add transparency
          ),
          borderColor: colors.slice(0, labels.length),
          borderWidth: 2,
          hoverBackgroundColor: colors.slice(0, labels.length),
          hoverBorderColor: '#000',
          hoverBorderWidth: 3
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#3B82F6',
            borderWidth: 2,
            cornerRadius: 8,
            callbacks: {
              label: function(context) {
                const index = context.dataIndex;
                const label = labels[index];
                const value = values[index];
                const percentage = ((value / total) * 100).toFixed(1);
                return label + ": " + value + " patients (" + percentage + "%)";
              }
            }
          }
        },
        scales: {
          x: {
            display: false,
            min: 0,
            max: 100
          },
          y: {
            display: false,
            min: 0,
            max: 100
          }
        },
        animation: {
          duration: 1500,
          easing: 'easeInOutQuart'
        }
      }
    });
  }

  // Create line chart
  function createLineChart(canvasId, title, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
      console.error('Canvas element not found:', canvasId);
      return;
    }

    if (charts[canvasId]) {
      charts[canvasId].destroy();
    }

    // Convert array format to object format for charts
    const chartData = convertArrayToObject(data);
    const labels = Object.keys(chartData);
    const values = Object.values(chartData);

    charts[canvasId] = new Chart(canvas, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: title,
          data: values,
          borderColor: '#10B981',
          backgroundColor: 'rgba(16, 185, 129, 0.1)',
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointBackgroundColor: '#10B981',
          pointBorderColor: '#059669',
          pointBorderWidth: 2,
          pointRadius: 5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: title,
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            display: false
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.1)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    });
  }

  // Update enhanced top selling medicines table
  async function updateEnhancedMedicinesTable(medicines) {
    const tbody = document.getElementById('topSellingMedicines');
    tbody.innerHTML = '';

    if (!medicines || medicines.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" class="text-center">No data available</td></tr>';
      return;
    }

    const medicineArray = Array.isArray(medicines) ? medicines : Object.values(medicines);

    // Sort medicines by quantity sold (descending) for proper ranking
    medicineArray.sort((a, b) => {
      const quantityA = a.quantitySold || 0;
      const quantityB = b.quantitySold || 0;
      return quantityB - quantityA; // Descending order
    });

    // Get real growth data
    let growthData = {};
    try {
      const startDateElement = document.getElementById('startDate');
      const endDateElement = document.getElementById('endDate');

      const startDate = startDateElement ? startDateElement.value : '';
      const endDate = endDateElement ? endDateElement.value : '';

      // Only make API call if we have valid dates
      if (startDate && endDate) {
        const growthResponse = await fetch(API_BASE + '/reports/medicine-growth-comparison?startDate=' + startDate + '&endDate=' + endDate);
        if (growthResponse.ok) {
          growthData = await growthResponse.json();
        }
      }
    } catch (error) {
      console.warn('Failed to load growth data:', error);
    }

    medicineArray.slice(0, 10).forEach((medicine, index) => {
      const row = tbody.insertRow();

      // Safe data access with fallbacks
      const quantitySold = medicine.quantitySold || 0;
      const revenue = medicine.revenue || 0;
      const medicineName = medicine.medicineName || 'Unknown Medicine';
      const avgPrice = quantitySold > 0 ? (revenue / quantitySold) : 0;

      // Get real growth data for this medicine
      let growth = 0;
      let growthClass = 'text-neutral';
      let growthIcon = '→';

      // Find growth data for this medicine
      if (Array.isArray(growthData)) {
        for (const item of growthData) {
          if (item && item.key && (item.key.includes(medicine.medicineId) || item.key.includes(medicineName))) {
            growth = item.sum || 0;
            growthClass = growth >= 0 ? 'text-success' : 'text-error';
            growthIcon = growth >= 0 ? '↗' : '↘';
            break;
          }
        }
      } else {
        // Fallback for old format
        for (const [key, value] of Object.entries(growthData)) {
          if (key.includes(medicine.medicineId) || key.includes(medicineName)) {
            growth = value;
            growthClass = growth >= 0 ? 'text-success' : 'text-error';
            growthIcon = growth >= 0 ? '↗' : '↘';
            break;
          }
        }
      }

      row.innerHTML =
        '<td><div class="badge badge-primary">' + (index + 1) + '</div></td>' +
        '<td class="font-medium">' + medicineName + '</td>' +
        '<td>' + quantitySold.toLocaleString() + '</td>' +
                    '<td>RM ' + revenue.toFixed(2) + '</td>' +
            '<td>RM ' + avgPrice.toFixed(2) + '</td>' +
        '<td class="' + growthClass + '">' + growthIcon + ' ' + Math.abs(growth).toFixed(1) + '%</td>';
    });
  }

  // Update top selling medicines table (legacy function for compatibility)
  function updateTopSellingMedicinesTable(medicines) {
    updateEnhancedMedicinesTable(medicines);
  }

  // Show chart error
  function showChartError(canvasId, message) {
    const canvas = document.getElementById(canvasId);
    if (canvas) {
      const ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.font = '16px Arial';
      ctx.fillStyle = '#ef4444';
      ctx.textAlign = 'center';
      ctx.fillText('Error: ' + message, canvas.width / 2, canvas.height / 2);
    }
  }

  // Show patient report error
  function showPatientReportError(message) {
    showChartError('patientGenderChart', message);
    showChartError('patientAgeChart', message);
    showChartError('patientBloodTypeChart', message);
    showChartError('patientNationalityChart', message);
  }

  // Helper function to convert array format to object for charts
  function convertArrayToObject(dataArray) {
    // If it's already an object, return it as is
    if (dataArray && typeof dataArray === 'object' && !Array.isArray(dataArray)) {
      return dataArray;
    }
    
    const obj = {};
    if (Array.isArray(dataArray)) {
      dataArray.forEach(item => {
        if (item && item.key !== undefined && item.count !== undefined) {
          obj[item.key] = item.count;
        } else if (item && item.key !== undefined && item.sum !== undefined) {
          obj[item.key] = item.sum;
        } else if (item && item.doctorName !== undefined && item.consultationCount !== undefined) {
          obj[item.doctorName] = item.consultationCount;
        } else if (item && item.doctorName !== undefined && item.scheduleHours !== undefined) {
          obj[item.doctorName] = item.scheduleHours;
        } else if (item && item.monthKey !== undefined && item.totalCount !== undefined) {
          obj[item.monthKey] = item.totalCount;
        }
      });
    }
    return obj;
  }

  // Helper function to convert MultiMap format to object (legacy support)
  function convertMultiMapToObject(multiMap) {
    const obj = {};
    for (const key in multiMap) {
      if (Object.prototype.hasOwnProperty.call(multiMap, key)) {
        obj[key] = multiMap[key];
      }
    }
    return obj;
  }
</script>
</body>
</html>


