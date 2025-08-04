<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Queue Management</title>
  <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
  <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
<%@ include file="/views/adminSidebar.jsp" %>

<main class="flex-1 p-6 ml-64 space-y-6 pr-6">
  <h1 class="text-2xl font-bold">Today's Queue</h1>

  <div class="space-y-8">
    <h2 class="text-xl font-semibold mb-2">Appointments</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table">
        <thead>
        <tr>
          <th>Appointment ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>C001</td>
          <td>09:00 AM</td>
          <td>00:15</td>
          <td>John Doe</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C001" data-overlay="#middle-center-modal-C001">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C002</td>
          <td>09:30 AM</td>
          <td>00:10</td>
          <td>Jane Smith</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C002" data-overlay="#middle-center-modal-C002">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C003</td>
          <td>10:00 AM</td>
          <td>00:05</td>
          <td>Alice Johnson</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C003" data-overlay="#middle-center-modal-C003">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C004</td>
          <td>10:30 AM</td>
          <td>00:20</td>
          <td>Bob Brown</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C004" data-overlay="#middle-center-modal-C004">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Waiting List</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>C005</td>
          <td>11:00 AM</td>
          <td>00:12</td>
          <td>John Doe</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C005" data-overlay="#middle-center-modal-C005">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C006</td>
          <td>11:30 AM</td>
          <td>00:08</td>
          <td>Jane Smith</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C006" data-overlay="#middle-center-modal-C006">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C007</td>
          <td>12:00 PM</td>
          <td>00:18</td>
          <td>Alice Johnson</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C007" data-overlay="#middle-center-modal-C007">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C008</td>
          <td>12:30 PM</td>
          <td>00:22</td>
          <td>Bob Brown</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="middle-center-modal-C008" data-overlay="#middle-center-modal-C008">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">In Progress</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>C009</td>
          <td>01:00 PM</td>
          <td>00:11</td>
          <td>John Doe</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C009" data-overlay="#update-status-modal-C009">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C010</td>
          <td>01:30 PM</td>
          <td>00:09</td>
          <td>Jane Smith</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C010" data-overlay="#update-status-modal-C010">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C011</td>
          <td>02:00 PM</td>
          <td>00:14</td>
          <td>Alice Johnson</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C011" data-overlay="#update-status-modal-C011">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C012</td>
          <td>02:30 PM</td>
          <td>00:19</td>
          <td>Bob Brown</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C012" data-overlay="#update-status-modal-C012">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Bill</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>C013</td>
          <td>03:00 PM</td>
          <td>00:17</td>
          <td>John Doe</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C013" data-overlay="#update-status-modal-C013">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C014</td>
          <td>03:30 PM</td>
          <td>00:13</td>
          <td>Jane Smith</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C014" data-overlay="#update-status-modal-C014">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C015</td>
          <td>04:00 PM</td>
          <td>00:16</td>
          <td>Alice Johnson</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C015" data-overlay="#update-status-modal-C015">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C016</td>
          <td>04:30 PM</td>
          <td>00:21</td>
          <td>Bob Brown</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C016" data-overlay="#update-status-modal-C016">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <h2 class="text-xl font-semibold mb-2">Completed</h2>
    <div class="border-base-content/25 w-full overflow-x-auto border">
      <table class="table">
        <thead>
        <tr>
          <th>Consultation ID</th>
          <th>Arrival Time</th>
          <th>Waiting Time</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>C017</td>
          <td>05:00 PM</td>
          <td>00:23</td>
          <td>John Doe</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C017" data-overlay="#update-status-modal-C017">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C018</td>
          <td>05:30 PM</td>
          <td>00:07</td>
          <td>Jane Smith</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C018" data-overlay="#update-status-modal-C018">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C019</td>
          <td>06:00 PM</td>
          <td>00:09</td>
          <td>Alice Johnson</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C019" data-overlay="#update-status-modal-C019">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        <tr>
          <td>C020</td>
          <td>06:30 PM</td>
          <td>00:24</td>
          <td>Bob Brown</td>
          <td>
            <button type="button" class="btn btn-circle btn-text btn-sm" aria-haspopup="dialog" aria-expanded="false" aria-controls="update-status-modal-C020" data-overlay="#update-status-modal-C020">
              <span class="icon-[tabler--pencil] size-5"></span>
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Update Status Modal for C001 -->
  <div id="middle-center-modal-C001" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C001">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C001">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C001" value="C001">

            <!-- Dropdown for status -->
            <label for="modal-status-C001" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C001" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C001">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C002 -->
  <div id="middle-center-modal-C002" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C001">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C002">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C002" value="C001">

            <!-- Dropdown for status -->
            <label for="modal-status-C001" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C002" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C002">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C003 -->
  <div id="middle-center-modal-C003" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C003">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C001">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C003" value="C001">

            <!-- Dropdown for status -->
            <label for="modal-status-C001" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C003" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C003">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C004 -->
  <div id="middle-center-modal-C004" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C004">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C004">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C004" value="C001">

            <!-- Dropdown for status -->
            <label for="modal-status-C001" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C004" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C004">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C005 -->
  <div id="middle-center-modal-C005" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C005">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C005">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C005" value="C005">

            <!-- Dropdown for status -->
            <label for="modal-status-C005" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C005" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C005">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C006 -->
  <div id="middle-center-modal-C006" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C006">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C006">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C006" value="C006">

            <!-- Dropdown for status -->
            <label for="modal-status-C006" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C006" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C006">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C007 -->
  <div id="middle-center-modal-C007" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C007">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C007">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C007" value="C007">

            <!-- Dropdown for status -->
            <label for="modal-status-C007" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C007" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C007">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <!-- Update Status Modal for C008 -->
  <div id="middle-center-modal-C008" class="overlay modal modal-middle overlay-open:opacity-100 overlay-open:duration-300 hidden overflow-y-auto backdrop-blur-sm [--body-scroll:true] z-0" role="dialog" tabindex="-1">
    <div class="modal-dialog overlay-open:opacity-100 overlay-open:duration-300 max-w-xl w-full">
      <div class="modal-content max-w-xl break-words whitespace-normal">
        <div class="modal-header">
          <h3 class="modal-title">Update Status</h3>
          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3" aria-label="Close" data-overlay="#middle-center-modal-C008">
            <span class="icon-[tabler--x] size-4"></span>
          </button>
        </div>
        <!-- Modal Form Body -->
        <form action="/updateStatusServlet" method="post" aria-controls="middle-center-modal-C008">
          <div class="modal-body">
            <!-- Hidden consultation or appointment ID -->
            <input type="hidden" name="id" id="modal-id-C008" value="C008">

            <!-- Dropdown for status -->
            <label for="modal-status-C008" class="block text-sm font-medium text-gray-700">Status</label>
            <select name="status" id="modal-status-C008" class="form-select w-full">
              <option value="Waiting">Waiting</option>
              <option value="In Progress">In Progress</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>

          <div class="modal-footer p-6">
            <button type="button" class="btn btn-soft btn-secondary" data-overlay="#middle-center-modal-C008">Cancel</button>
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>


</main>
</body>
</html>

