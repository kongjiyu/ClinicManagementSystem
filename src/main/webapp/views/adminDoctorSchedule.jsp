<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
  Author: Kong Ji Yu
  Doctor Module
-->
<html>
<head>
  <title>Admin Dashboard</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  <style>
    /* Modal fallback styles */
    .modal.overlay-open {
      display: flex !important;
      opacity: 1 !important;
    }
    .modal.hidden {
      display: none !important;
    }
  </style>
</head>
<body class="bg-white min-h-screen">
  <%@ include file="/views/adminSidebar.jsp" %>

  <main class="p-6 md:ml-64">
    <div class="max-w-7xl mx-auto">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold">Doctor Schedule</h1>
        <div class="flex items-center gap-2">
          <button id="prev-month" class="btn btn-soft">Prev</button>
          <div class="flex items-center gap-2">
            <select id="month-select" class="select select-bordered w-32">
              <option value="0">Jan</option>
              <option value="1">Feb</option>
              <option value="2">Mar</option>
              <option value="3">Apr</option>
              <option value="4">May</option>
              <option value="5">Jun</option>
              <option value="6">Jul</option>
              <option value="7">Aug</option>
              <option value="8">Sep</option>
              <option value="9">Oct</option>
              <option value="10">Nov</option>
              <option value="11">Dec</option>
            </select>
            <select id="year-select" class="select select-bordered w-full"></select>
          </div>
          <button id="next-month" class="btn btn-soft">Next</button>
          <button id="today-btn" class="btn btn-primary">Today</button>
        </div>
      </div>

      <!-- Legend -->
      <div class="mb-4 flex flex-wrap items-center gap-4 text-sm">
        <span class="inline-flex items-center gap-2"><span class="w-3 h-3 rounded bg-blue-200 border border-blue-400"></span> Morning (08:00&ndash;14:00)</span>
        <span class="inline-flex items-center gap-2"><span class="w-3 h-3 rounded bg-amber-200 border border-amber-400"></span> Evening (14:00&ndash;20:00)</span>
        <span class="inline-flex items-center gap-2"><span class="w-3 h-3 rounded bg-base-300"></span> Unassigned</span>
      </div>

      <!-- Calendar -->
      <section class="bg-white rounded-xl shadow p-4">
        <div class="grid grid-cols-7 text-center font-semibold text-base-content/70 border-b mb-2">
          <div class="py-2">Mon</div>
          <div class="py-2">Tue</div>
          <div class="py-2">Wed</div>
          <div class="py-2">Thu</div>
          <div class="py-2">Fri</div>
          <div class="py-2">Sat</div>
          <div class="py-2">Sun</div>
        </div>
        <div id="calendar-grid" class="grid grid-cols-7 gap-2"></div>
      </section>
    </div>
  </main>

  <!-- Hidden opener for Edit Assignment Modal -->
  <button id="open-edit-shift" type="button" class="hidden" data-overlay="#edit-shift-modal" data-overlay-open="true"></button>

  <!-- Edit Assignment Modal -->
  <div id="edit-shift-modal" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">Edit Shift</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#edit-shift-modal">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <form id="assign-form">
          <div class="modal-body space-y-4">
            <input type="hidden" id="field-date" name="date" />
            <input type="hidden" id="field-shift" name="shift" />

            <div>
              <label class="label">Date</label>
              <input id="display-date" type="text" class="input input-bordered w-full" disabled />
            </div>

            <div>
              <label class="label">Shift</label>
              <input id="display-shift" type="text" class="input input-bordered w-full" disabled />
            </div>


            <div>
              <label class="label">Doctor 1</label>
              <select id="doctor-select-1" name="doctorID1" class="select select-bordered w-full" required></select>
              <small class="text-xs text-base-content/60">Pick the first doctor responsible for this shift.</small>
            </div>

            <div>
              <label class="label">Doctor 2</label>
              <select id="doctor-select-2" name="doctorID2" class="select select-bordered w-full"></select>
              <small class="text-xs text-base-content/60">Pick the second doctor (optional).</small>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#edit-shift-modal">Cancel</button>
            <button type="button" id="clear-assignment" class="btn btn-warning">Clear</button>
            <button type="submit" class="btn btn-primary">Save</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    // ====== API Configuration ======
    const API_BASE = '<%= request.getContextPath() %>/api';

    // ====== Global Data ======
    let doctors = [];
    let schedules = [];

    const dname = function(d){ return 'Dr. ' + d.firstName + ' ' + d.lastName; };

    // ====== State ======
    let current = new Date();
    const grid     = document.getElementById('calendar-grid');
    const monthSel = document.getElementById('month-select');
    const yearSel  = document.getElementById('year-select');

    // ====== API Functions ======
    async function fetchDoctors() {
      try {
        const response = await fetch(API_BASE + '/staff/doctors');
        if (!response.ok) throw new Error('Failed to fetch doctors');
        const data = await response.json();
        console.log('Raw doctors API response:', data);

        // Handle the wrapped response format with elements array
        doctors = data.elements || data || [];
        console.log('Processed doctors array:', doctors);
        console.log('Doctors array length:', doctors.length);

        // Filter out null/invalid doctors
        doctors = doctors.filter(function(d){ return d && d.staffID && d.firstName && d.lastName; });
        console.log('Valid doctors after filtering:', doctors.length);

      } catch (error) {
        console.error('Error fetching doctors:', error);
        // Fallback to demo data if API fails
        doctors = [
          { staffID: 'DR0001', firstName: 'Wei',  lastName: 'Jun', position: 'Doctor' },
          { staffID: 'DR0002', firstName: 'Amir', lastName: 'Rahman', position: 'Doctor' },
          { staffID: 'DR0003', firstName: 'Jane', lastName: 'Tan', position: 'Doctor' },
          { staffID: 'DR0004', firstName: 'Siti', lastName: 'Aziz', position: 'Doctor' },
        ];
      }
    }

    async function fetchSchedules(year, month) {
      try {
        const response = await fetch(API_BASE + '/schedules/month/' + year + '/' + (month + 1));
        if (!response.ok) throw new Error('Failed to fetch schedules');
        const data = await response.json();
        // Handle the wrapped response format with elements array
        schedules = data.elements || data || [];
        console.log('Fetched schedules:', schedules);
        console.log('Schedules length:', schedules.length);
      } catch (error) {
        console.error('Error fetching schedules:', error);
        schedules = [];
      }
    }

    async function parseError(response){
      try {
        const text = await response.text();
        try { const obj = JSON.parse(text); return obj.error || text; } catch(e) { return text || (response.status + ' ' + response.statusText); }
      } catch (e) {
        return response.status + ' ' + response.statusText;
      }
    }

    async function assignDoctor(date, shift, doctorID1, doctorID2) {
      try {
        const response = await fetch(API_BASE + '/schedules/assign', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ 
            date: date, 
            shift: shift, 
            doctorID1: doctorID1 || '', 
            doctorID2: doctorID2 || '' 
          })
        });

        if (!response.ok) {
          const msg = await parseError(response);
          throw new Error(msg || 'Failed to assign doctor');
        }
        return await response.json();
      } catch (error) {
        console.error('Error assigning doctor:', error);
        throw error;
      }
    }

    async function clearAssignment(date, shift) {
      try {
        const response = await fetch(API_BASE + '/schedules/assign?date=' + date + '&shift=' + shift, { method: 'DELETE' });
        if (!response.ok) {
          const msg = await parseError(response);
          throw new Error(msg || 'Failed to clear assignment');
        }
        return await response.json();
      } catch (error) {
        console.error('Error clearing assignment:', error);
        throw error;
      }
    }

    // ====== Year options ======
    (function initYearOptions(){
      const thisYear = new Date().getFullYear();
      for (let y = thisYear - 1; y <= thisYear + 2; y++) {
        const opt = document.createElement('option');
        opt.value = String(y);
        opt.textContent = String(y);
        yearSel.appendChild(opt);
      }
    })();

    monthSel.value = String(current.getMonth());
    yearSel.value  = String(current.getFullYear());

    // ====== Event Listeners ======
    document.getElementById('prev-month').addEventListener('click', async function(){
      const m = parseInt(monthSel.value, 10) - 1;
      if (m < 0) { monthSel.value = '11'; yearSel.value = String(parseInt(yearSel.value,10)-1); }
      else { monthSel.value = String(m); }
      await loadAndRender();
    });

    document.getElementById('next-month').addEventListener('click', async function(){
      const m = parseInt(monthSel.value, 10) + 1;
      if (m > 11) { monthSel.value = '0'; yearSel.value = String(parseInt(yearSel.value,10)+1); }
      else { monthSel.value = String(m); }
      await loadAndRender();
    });

    document.getElementById('today-btn').addEventListener('click', async function(){
      const now = new Date();
      monthSel.value = String(now.getMonth());
      yearSel.value  = String(now.getFullYear());
      await loadAndRender();
    });

    monthSel.addEventListener('change', loadAndRender);
    yearSel.addEventListener('change', loadAndRender);

    // ====== Load doctors for the modal ======
    const doctorSelect1 = document.getElementById('doctor-select-1');
    const doctorSelect2 = document.getElementById('doctor-select-2');
    function loadDoctors(){
      doctorSelect1.innerHTML = '';
      doctorSelect2.innerHTML = '';

      // Ensure doctors is an array and filter out null/invalid entries
      if (!Array.isArray(doctors)) {
        console.warn('Doctors is not an array:', doctors);
        return;
      }

      // Placeholder option for doctor 1
      const placeholder1 = document.createElement('option');
      placeholder1.value = '';
      placeholder1.textContent = 'Please select a doctor';
      placeholder1.selected = true;
      doctorSelect1.appendChild(placeholder1);

      // Placeholder option for doctor 2
      const placeholder2 = document.createElement('option');
      placeholder2.value = '';
      placeholder2.textContent = 'Please select a doctor (optional)';
      placeholder2.selected = true;
      doctorSelect2.appendChild(placeholder2);

      doctors.forEach(function(d){
        // Skip null or invalid doctor objects
        if (!d || !d.staffID || !d.firstName || !d.lastName) {
          console.warn('Invalid doctor object:', d);
          return;
        }

        const opt1 = document.createElement('option');
        opt1.value = d.staffID;
        opt1.textContent = d.firstName + ' ' + d.lastName + ' (' + d.staffID + ')';
        doctorSelect1.appendChild(opt1);

        const opt2 = document.createElement('option');
        opt2.value = d.staffID;
        opt2.textContent = d.firstName + ' ' + d.lastName + ' (' + d.staffID + ')';
        doctorSelect2.appendChild(opt2);
      });
    }

    // ====== Build schedule lookup ======
    function buildScheduleLookup() {
      const lookup = {};

      // Ensure schedules is an array before processing
      if (!Array.isArray(schedules)) {
        console.warn('Schedules is not an array:', schedules);
        return lookup;
      }

      schedules.forEach(function(schedule){
        // Skip null or undefined schedule objects
        if (!schedule || !schedule.date || !schedule.shift) {
          console.warn('Invalid schedule object:', schedule);
          return;
        }

        const dateKey = schedule.date;
        if (!lookup[dateKey]) {
          lookup[dateKey] = { morning: null, evening: null };
        }

        const doctor1 = doctors.find(function(d){ return d && d.staffID === schedule.doctorID1; });
        const doctor2 = doctors.find(function(d){ return d && d.staffID === schedule.doctorID2; });

        const assignment1 = doctor1 ? { doctorID: doctor1.staffID, name: dname(doctor1) } : null;
        const assignment2 = doctor2 ? { doctorID: doctor2.staffID, name: dname(doctor2) } : null;

        // Convert shift to lowercase to match frontend expectations
        const shiftKey = (schedule.shift + '').toLowerCase();
        lookup[dateKey][shiftKey] = { doctor1: assignment1, doctor2: assignment2 };
      });
      return lookup;
    }

    // ====== Load data and render ======
    async function loadAndRender() {
      const year = parseInt(yearSel.value, 10);
      const month = parseInt(monthSel.value, 10);

      await fetchSchedules(year, month);
      render();
    }

    // ====== Rendering calendar ======
    function render(){
      const year  = parseInt(yearSel.value, 10);
      const month = parseInt(monthSel.value, 10);
      const first = new Date(year, month, 1);
      const last  = new Date(year, month + 1, 0);

      const scheduleLookup = buildScheduleLookup();
      grid.innerHTML = '';

      // offset (Mon=0 .. Sun=6)
      const weekDay = (first.getDay() + 6) % 7;
      for (let i = 0; i < weekDay; i++) {
        const cell = document.createElement('div');
        cell.className = 'p-2 rounded bg-transparent';
        grid.appendChild(cell);
      }

      for (let day = 1; day <= last.getDate(); day++) {
        const dateStr = year + '-' + String(month+1).padStart(2,'0') + '-' + String(day).padStart(2,'0');
        const info = scheduleLookup[dateStr] || {};
        const morn = info.morning || { doctor1: null, doctor2: null };
        const eve  = info.evening || { doctor1: null, doctor2: null };

        const cell = document.createElement('div');
        cell.className = 'border rounded p-2 min-h-28 flex flex-col gap-2 hover:shadow transition';

        const header = document.createElement('div');
        header.className = 'flex items-center justify-between text-sm';
        header.innerHTML = '<span class="font-semibold">' + day + '</span>';
        cell.appendChild(header);

        // Morning
        const mBlock = document.createElement('button');
        mBlock.type = 'button';
        mBlock.className = 'text-left rounded p-2 bg-blue-50 border border-blue-200 hover:bg-blue-100';
        const mName1 = morn.doctor1 ? morn.doctor1.name : '<span class="text-base-content/50">Unassigned</span>';
        const mName2 = morn.doctor2 ? morn.doctor2.name : '';
        const mDisplay = mName2 ? mName1 + '<br/>' + mName2 : mName1;
        mBlock.innerHTML =
          '<div class="text-xs font-semibold">Morning <br/>(08:00&ndash;14:00)</div>' +
          '<div class="text-sm">' + mDisplay + '</div>';
        mBlock.addEventListener('click', function(){ openEditModal(dateStr, 'morning', morn); });
        cell.appendChild(mBlock);

        // Evening
        const eBlock = document.createElement('button');
        eBlock.type = 'button';
        eBlock.className = 'text-left rounded p-2 bg-amber-50 border border-amber-200 hover:bg-amber-100';
        const eName1 = eve.doctor1 ? eve.doctor1.name : '<span class="text-base-content/50">Unassigned</span>';
        const eName2 = eve.doctor2 ? eve.doctor2.name : '';
        const eDisplay = eName2 ? eName1 + '<br/>' + eName2 : eName1;
        eBlock.innerHTML =
          '<div class="text-xs font-semibold">Evening <br/>(14:00&ndash;20:00)</div>' +
          '<div class="text-sm">' + eDisplay + '</div>';
        eBlock.addEventListener('click', function(){ openEditModal(dateStr, 'evening', eve); });
        cell.appendChild(eBlock);

        grid.appendChild(cell);
      }
    }

    // ====== Modal controls ======
    const editModalId  = '#edit-shift-modal';
    const fieldDate    = document.getElementById('field-date');
    const fieldShift   = document.getElementById('field-shift');
    const displayDate  = document.getElementById('display-date');
    const displayShift = document.getElementById('display-shift');
    const clearBtn     = document.getElementById('clear-assignment');

    function openEditModal(dateStr, shift, existing){
      console.log('Opening modal for:', dateStr, shift, existing);

      // Load doctors and populate form
      loadDoctors();
      fieldDate.value   = dateStr;
      fieldShift.value  = shift;
      displayDate.value = dateStr;
      displayShift.value = (shift === 'morning') ? 'Morning (08:00\u2013 14:00)' : 'Evening (14:00\u2013 20:00)';

      // Set doctor selection after a brief delay to ensure options are loaded
      setTimeout(function(){
        if (existing && existing.doctor1 && existing.doctor1.doctorID) {
          doctorSelect1.value = existing.doctor1.doctorID;
        } else {
          doctorSelect1.value = '';
        }
        
        if (existing && existing.doctor2 && existing.doctor2.doctorID) {
          doctorSelect2.value = existing.doctor2.doctorID;
        } else {
          doctorSelect2.value = '';
        }
      }, 100);

      // Try multiple ways to open the modal
      const modal = document.getElementById('edit-shift-modal');
      if (modal) {
        // Method 1: Use the hidden button (FlyonUI way)
        document.getElementById('open-edit-shift').click();

        // Method 2: Fallback - directly show modal if FlyonUI doesn't work
        setTimeout(function(){
          if (modal.classList.contains('hidden')) {
            modal.classList.remove('hidden');
            modal.classList.add('overlay-open');
          }
        }, 200);
      }
    }

    // Bulk helpers removed (single-day only)

    document.getElementById('assign-form').addEventListener('submit', async function(e){
      e.preventDefault();
      const date = fieldDate.value;
      const shift = fieldShift.value;
      const docId1 = doctorSelect1.value;
      const docId2 = doctorSelect2.value;

      try {
        // Send both doctors in a single request
        await assignDoctor(date, shift, docId1, docId2);
        await loadAndRender();
        closeModal();
      } catch (error) {
        alert('Error assigning doctor: ' + error.message);
      }
    });

    clearBtn.addEventListener('click', async function(){
      const date = fieldDate.value;
      const shift = fieldShift.value;

      try {
        // Single-day only
        await clearAssignment(date, shift);
        await loadAndRender();
        closeModal();
      } catch (error) {
        alert('Error clearing assignment: ' + error.message);
      }
    });

    // Helper function to close modal
    function closeModal() {
      const modal = document.getElementById('edit-shift-modal');
      const closeBtn = document.querySelector('[data-overlay="#edit-shift-modal"]');

      // Try FlyonUI way first
      if (closeBtn) { closeBtn.click(); }

      // Fallback method
      setTimeout(function(){
        if (modal && !modal.classList.contains('hidden')) {
          modal.classList.add('hidden');
          modal.classList.remove('overlay-open');
        }
      }, 100);
    }

    // ====== Initialize ======
    async function init() {
      await fetchDoctors();
      await loadAndRender();
    }

    init();
  </script>
</body>
</html>
