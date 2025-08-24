<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatment Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/daisyui@3.9.0/dist/full.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
    <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  </head>
<body class="bg-gray-100">
    <%@ include file="/views/adminSidebar.jsp" %>

    <main class="ml-64 p-6">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Treatment Details</h1>
                <div class="flex space-x-2">
                    <a href="<%= request.getContextPath() %>/views/treatmentList.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>Back to List
                    </a>
                    <button id="editBtn" class="btn btn-warning">
                        <i class="fas fa-edit mr-2"></i>Edit
                    </button>
                    <button id="deleteBtn" class="btn btn-error">
                        <i class="fas fa-trash mr-2"></i>Delete
                    </button>
                </div>
            </div>

            <div id="loadingSpinner" class="flex justify-center items-center py-8">
                <div class="loading loading-spinner loading-lg"></div>
            </div>

            <div id="treatmentDetails" class="hidden">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Treatment ID -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment ID</span>
                        </label>
                        <input type="text" id="treatmentID" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Treatment Name -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Name</span>
                        </label>
                        <input type="text" id="treatmentName" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Patient -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Patient</span>
                        </label>
                        <input type="text" id="patientInfo" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Doctor -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Doctor</span>
                        </label>
                        <input type="text" id="doctorInfo" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Treatment Type -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Type</span>
                        </label>
                        <input type="text" id="treatmentType" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Status -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Status</span>
                        </label>
                        <div id="statusBadge" class="mt-2"></div>
                    </div>

                    <!-- Treatment Date -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Date & Time</span>
                        </label>
                        <input type="text" id="treatmentDate" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Duration -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Duration</span>
                        </label>
                        <input type="text" id="duration" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Outcome -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Outcome</span>
                        </label>
                        <div id="outcomeBadge" class="mt-2"></div>
                    </div>
                </div>

                <!-- Description -->
                <div class="form-control mb-6">
                    <label class="label">
                        <span class="label-text font-semibold">Description</span>
                    </label>
                    <textarea id="description" class="textarea textarea-bordered h-24" readonly></textarea>
                </div>

                <!-- Procedure -->
                <div class="form-control mb-6">
                    <label class="label">
                        <span class="label-text font-semibold">Procedure</span>
                    </label>
                    <textarea id="procedure" class="textarea textarea-bordered h-24" readonly></textarea>
                </div>

                <!-- Notes -->
                <div class="form-control mb-6">
                    <label class="label">
                        <span class="label-text font-semibold">Notes</span>
                    </label>
                    <textarea id="notes" class="textarea textarea-bordered h-24" readonly></textarea>
                </div>
            </div>

            <div id="errorMessage" class="hidden">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span id="errorText">Treatment not found</span>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        let treatmentData = {};
        let patientData = {};
        let doctorData = {};

        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const treatmentId = urlParams.get('id');
            
            if (treatmentId) {
                loadTreatmentDetails(treatmentId);
            } else {
                showError('No treatment ID provided');
            }

            // Event listeners
            document.getElementById('editBtn').addEventListener('click', function() {
                window.location.href = '<%= request.getContextPath() %>/views/treatmentEdit.jsp?id=' + treatmentData.treatmentID;
            });

            document.getElementById('deleteBtn').addEventListener('click', function() {
                deleteTreatment(treatmentData.treatmentID);
            });
        });

        function loadTreatmentDetails(treatmentId) {
            fetch('<%= request.getContextPath() %>/api/treatments/' + treatmentId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Treatment not found');
                    }
                    return response.json();
                })
                .then(treatment => {
                    treatmentData = treatment;
                    loadPatientAndDoctorData(treatment);
                })
                .catch(error => {
                    console.error('Error loading treatment:', error);
                    showError('Failed to load treatment details');
                });
        }

        function loadPatientAndDoctorData(treatment) {
            Promise.all([
                fetch('<%= request.getContextPath() %>/api/patients/' + treatment.patientID),
                fetch('<%= request.getContextPath() %>/api/staff/' + treatment.doctorID)
            ])
            .then(responses => Promise.all(responses.map(r => r.json())))
            .then(([patient, doctor]) => {
                patientData = patient;
                doctorData = doctor;
                displayTreatmentDetails(treatment, patient, doctor);
            })
            .catch(error => {
                console.error('Error loading patient/doctor data:', error);
                displayTreatmentDetails(treatment, null, null);
            });
        }

        function displayTreatmentDetails(treatment, patient, doctor) {
            // Hide loading spinner and show details
            document.getElementById('loadingSpinner').classList.add('hidden');
            document.getElementById('treatmentDetails').classList.remove('hidden');

            // Fill in the form fields
            document.getElementById('treatmentID').value = treatment.treatmentID;
            document.getElementById('treatmentName').value = treatment.treatmentName;
            document.getElementById('treatmentType').value = treatment.treatmentType;
            document.getElementById('treatmentDate').value = formatDateTime(treatment.treatmentDate);
            document.getElementById('duration').value = treatment.duration + ' minutes';
            document.getElementById('description').value = treatment.description || 'N/A';
            document.getElementById('procedure').value = treatment.treatmentProcedure || 'N/A';
            document.getElementById('notes').value = treatment.notes || 'N/A';

            // Patient info
            if (patient) {
                document.getElementById('patientInfo').value = patient.patientID + ' - ' + patient.firstName + ' ' + patient.lastName;
            } else {
                document.getElementById('patientInfo').value = treatment.patientID + ' - Patient not found';
            }

            // Doctor info
            if (doctor) {
                document.getElementById('doctorInfo').value = doctor.staffID + ' - Dr. ' + doctor.firstName + ' ' + doctor.lastName;
            } else {
                document.getElementById('doctorInfo').value = treatment.doctorID + ' - Doctor not found';
            }

            // Status badge
            const statusBadge = document.getElementById('statusBadge');
            statusBadge.innerHTML = getStatusBadge(treatment.status);

            // Outcome badge
            const outcomeBadge = document.getElementById('outcomeBadge');
            outcomeBadge.innerHTML = getOutcomeBadge(treatment.outcome);
        }

        function formatDateTime(dateTimeString) {
            if (!dateTimeString) return 'N/A';
            const date = new Date(dateTimeString);
            return date.toLocaleString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        function getStatusBadge(status) {
            // Handle null, undefined, or boolean values
            if (!status || status === 'false' || status === false || status === '') {
                return '<span style="background-color: #e5e7eb; color: #374151; padding: 4px 8px; border-radius: 9999px; font-size: 12px; font-weight: 500;">Unknown</span>';
            }
            
            const statusStyles = {
                'Scheduled': 'background-color: #dbeafe; color: #1e40af;',
                'In Progress': 'background-color: #fef3c7; color: #d97706;',
                'Completed': 'background-color: #d1fae5; color: #065f46;',
                'Cancelled': 'background-color: #fee2e2; color: #dc2626;'
            };
            
            const style = statusStyles[status] || 'background-color: #e5e7eb; color: #374151;';
            return '<span style="' + style + ' padding: 4px 8px; border-radius: 9999px; font-size: 12px; font-weight: 500;">' + status + '</span>';
        }

        function getOutcomeBadge(outcome) {
            // Handle null, undefined, or boolean values
            if (!outcome || outcome === 'false' || outcome === false || outcome === '') {
                return '<span style="background-color: #e5e7eb; color: #374151; padding: 4px 8px; border-radius: 9999px; font-size: 12px; font-weight: 500;">N/A</span>';
            }
            
            const outcomeStyles = {
                'Successful': 'background-color: #d1fae5; color: #065f46;',
                'Failed': 'background-color: #fee2e2; color: #dc2626;',
                'Partial Success': 'background-color: #fef3c7; color: #d97706;'
            };
            
            const style = outcomeStyles[outcome] || 'background-color: #e5e7eb; color: #374151;';
            return '<span style="' + style + ' padding: 4px 8px; border-radius: 9999px; font-size: 12px; font-weight: 500;">' + outcome + '</span>';
        }

        function deleteTreatment(treatmentId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('<%= request.getContextPath() %>/api/treatments/' + treatmentId, {
                        method: 'DELETE'
                    })
                    .then(response => {
                        if (response.ok) {
                            Swal.fire('Deleted!', 'Treatment has been deleted.', 'success')
                                .then(() => {
                                    window.location.href = '<%= request.getContextPath() %>/views/treatmentList.jsp';
                                });
                        } else {
                            throw new Error('Failed to delete treatment');
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting treatment:', error);
                        Swal.fire('Error', 'Failed to delete treatment', 'error');
                    });
                }
            });
        }

        function showError(message) {
            document.getElementById('loadingSpinner').classList.add('hidden');
            document.getElementById('errorMessage').classList.remove('hidden');
            document.getElementById('errorText').textContent = message;
        }
    </script>
</body>
</html>
