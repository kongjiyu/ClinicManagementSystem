<%--
Author: Yap Yu Xin
Appointment Module
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Appointment Calendar</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  
  <style>

    /* Custom Color Theme */
    .btn-primary {
      background-color: #5E83F2 !important;
      border-color: #5E83F2 !important;
    }

    .btn-primary:hover {
      background-color: #457ABF !important;
      border-color: #457ABF !important;
    }

    .btn-outline {
      border-color: #5E83F2 !important;
      color: #5E83F2 !important;
    }

    .btn-outline:hover {
      background-color: #5E83F2 !important;
      color: white !important;
    }

    .badge-info {
      background-color: #73A9D9 !important;
      color: white !important;
    }

    .badge-success {
      background-color: #5E83F2 !important;
      color: white !important;
    }

    .badge-error {
      background-color: #F2668B !important;
      color: white !important;
    }

    .badge-warning {
      background-color: #457ABF !important;
      color: white !important;
    }

    .badge-primary {
      background-color: #5E83F2 !important;
      color: white !important;
    }

    .badge-secondary {
      background-color: #73A9D9 !important;
      color: white !important;
    }

    .link-primary {
      color: #5E83F2 !important;
    }

    .link-primary:hover {
      color: #457ABF !important;
    }

    /* FullCalendar Event Text Color Fix */
    .fc-event {
      color: white !important;
    }

    .fc-event-title {
      color: white !important;
    }

    .fc-event-main {
      color: white !important;
    }

    .fc-event-main-frame {
      color: white !important;
    }

    .fc-daygrid-event {
      color: white !important;
    }

    .fc-timegrid-event {
      color: white !important;
    }

    .fc-list-event {
      color: white !important;
    }

    .fc-list-event-title {
      color: white !important;
    }

    .fc-list-event-dot {
      border-color: white !important;
    }

    /* Ensure text is visible on all background colors */
    .fc-event-title,
    .fc-event-main,
    .fc-event-main-frame,
    .fc-daygrid-event,
    .fc-timegrid-event,
    .fc-list-event,
    .fc-list-event-title {
      color: white !important;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3) !important;
    }
  </style>
  
  <!-- FullCalendar CSS -->
  <link href='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/index.global.min.css' rel='stylesheet' />
  <link href='https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@6.1.10/index.global.min.css' rel='stylesheet' />
  <link href='https://cdn.jsdelivr.net/npm/@fullcalendar/timegrid@6.1.10/index.global.min.css' rel='stylesheet' />
  <link href='https://cdn.jsdelivr.net/npm/@fullcalendar/list@6.1.10/index.global.min.css' rel='stylesheet' />
  <link href='https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@6.1.10/index.global.min.css' rel='stylesheet' />
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6">
  <div class="flex justify-between items-center">
    <h1 class="text-2xl font-bold">Appointment Calendar</h1>
    <div class="flex gap-2">
      <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/appointmentList.jsp'">
        <span class="icon-[tabler--list] size-4 mr-2"></span>
        List View
      </button>
    </div>
  </div>

  <!-- Calendar Container -->
  <div class="bg-white rounded-lg shadow-lg p-6">
    <div id="calendar"></div>
  </div>


</main>

<!-- FullCalendar JS -->
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/timegrid@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/list@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@6.1.10/index.global.min.js'></script>

<script>
  const API_BASE = '<%= request.getContextPath() %>/api';
  let calendar = null;

  // Initialize FullCalendar
  document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('calendar');
    
    calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'timeGridWeek,timeGridDay,listWeek'
      },
      height: 'auto',
      expandRows: true,
      slotMinTime: '08:00:00',
      slotMaxTime: '18:00:00',
      allDaySlot: false,
      slotDuration: '00:30:00',
      selectable: false,
      dayMaxEvents: true,
      weekends: true,
      events: fetchAppointments,
      eventClick: handleEventClick,
      eventDidMount: handleEventDidMount,
      loading: function(isLoading) {
        // You can add loading indicators here
      }
    });

    calendar.render();
  });

  // Fetch appointments from API
  async function fetchAppointments(info, successCallback, failureCallback) {
    try {
      const response = await fetch(API_BASE + '/appointments');
      if (!response.ok) {
        throw new Error('Failed to fetch appointments');
      }

      const data = await response.json();
      const appointments = data.elements || data || [];

      const events = appointments.map(appointment => {
        const start = new Date(appointment.appointmentTime);
        const end = new Date(start.getTime() + 30 * 60000); // 30 minutes duration

        return {
          id: appointment.appointmentID,
          title: appointment.patientName,
          start: start,
          end: end,
          extendedProps: {
            patientName: appointment.patientName,
            status: appointment.status,
            description: appointment.description,
            patientID: appointment.patientID
          }
        };
      });

      successCallback(events);
    } catch (error) {
      console.error('Error fetching appointments:', error);
      failureCallback(error);
    }
  }

  // Handle event click - go directly to appointment detail
  function handleEventClick(info) {
    window.location.href = '<%= request.getContextPath() %>/views/appointmentDetail.jsp?id=' + info.event.id;
  }

  // Handle event mount (for styling)
  function handleEventDidMount(info) {
    const status = info.event.extendedProps.status;
    let backgroundColor = '#5E83F2'; // Default bright cornflower blue

    // Color coding based on status using custom theme
    switch(status.toLowerCase()) {
      case 'scheduled':
        backgroundColor = '#73A9D9'; // Light steel blue
        break;
      case 'confirmed':
        backgroundColor = '#5E83F2'; // Bright cornflower blue
        break;
      case 'cancelled':
        backgroundColor = '#F2668B'; // Medium pink
        break;
      case 'completed':
        backgroundColor = '#457ABF'; // Steel blue
        break;
      case 'check in':
        backgroundColor = '#5E83F2'; // Bright cornflower blue
        break;
      case 'no show':
        backgroundColor = '#182158'; // Dark navy blue
        break;
    }

    info.el.style.backgroundColor = backgroundColor;
    info.el.style.borderColor = backgroundColor;
  }



  // Get status badge class
  function getStatusBadgeClass(status) {
    switch(status.toLowerCase()) {
      case 'scheduled':
        return 'badge-info';
      case 'confirmed':
        return 'badge-success';
      case 'cancelled':
        return 'badge-error';
      case 'completed':
        return 'badge-warning';
      case 'check in':
        return 'badge-primary';
      case 'no show':
        return 'badge-secondary';
      default:
        return 'badge-ghost';
    }
  }

  // Format date and time
  function formatDateTime(date) {
    return date.toLocaleString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
  }


</script>
</body>
</html>
