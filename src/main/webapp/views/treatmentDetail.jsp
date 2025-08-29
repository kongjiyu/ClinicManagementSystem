<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
  Author: Oh Wan Ting
  Treatment Module
-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatment Details</title>
    <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
    <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
  </head>
<body class="flex min-h-screen text-base-content">
    <%@ include file="/views/adminSidebar.jsp" %>

    <main class="flex-1 p-6 ml-64 space-y-6">
        <div class="bg-base-200 rounded-lg p-6 shadow space-y-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Treatment Details</h1>
                <div class="flex gap-2">
                    <button class="btn btn-outline" onclick="window.location.href='<%= request.getContextPath() %>/views/treatmentList.jsp'">
                        <span class="icon-[tabler--arrow-left] size-4 mr-2"></span>
                        Back to List
                    </button>
                    <button id="editBtn" class="btn btn-primary">
                        <span class="icon-[tabler--edit] size-4 mr-2"></span>
                        Edit
                    </button>
                </div>
            </div>

            <div id="loadingSpinner" class="flex justify-center items-center py-8">
                <div class="loading loading-spinner loading-lg"></div>
            </div>

            <div id="treatmentDetails" class="hidden">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
                    <div class="form-control" id="outcomeSection" style="display: none;">
                        <label class="label">
                            <span class="label-text font-semibold">Outcome</span>
                        </label>
                        <div id="outcomeBadge" class="mt-2"></div>
                    </div>
                </div>

                <!-- Description -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Description</span>
                    </label>
                    <textarea id="description" class="textarea textarea-bordered h-24" readonly></textarea>
                </div>

                <!-- Procedure -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Procedure</span>
                    </label>
                    <textarea id="procedure" class="textarea textarea-bordered h-24" readonly></textarea>
                </div>

                <!-- Notes -->
                <div class="form-control">
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



    <script>
        let treatmentData = {};
        let patientData = {};
        let doctorData = {};

        document.addEventListener('DOMContentLoaded', function() {
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
                fetch('<%= request.getContextPath() %>/api/consultations/' + treatment.consultationID)
            ])
            .then(responses => Promise.all(responses.map(r => r.json())))
            .then(([patient, consultation]) => {
                patientData = patient;
                // Get doctor from consultation
                if (consultation && consultation.doctorID) {
                    return fetch('<%= request.getContextPath() %>/api/staff/' + consultation.doctorID)
                        .then(response => response.json())
                        .then(doctor => {
                            doctorData = doctor;
                            displayTreatmentDetails(treatment, patient, doctor);
                        })
                        .catch(error => {
                            console.error('Error loading doctor data:', error);
                            displayTreatmentDetails(treatment, patient, null);
                        });
                } else {
                    displayTreatmentDetails(treatment, patient, null);
                }
            })
            .catch(error => {
                console.error('Error loading patient/consultation data:', error);
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

            // Disable edit button if treatment is completed
            const editBtn = document.getElementById('editBtn');
            if (treatment.status === 'Completed') {
                editBtn.disabled = true;
                editBtn.title = 'Cannot edit completed treatments';
                editBtn.classList.add('btn-disabled');
                editBtn.innerHTML = '<span class="icon-[tabler--edit] size-4 mr-2"></span>Edit (Completed)';
            }

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
                document.getElementById('doctorInfo').value = 'Doctor not found';
            }

            // Status badge
            const statusBadge = document.getElementById('statusBadge');
            statusBadge.innerHTML = getStatusBadge(treatment.status);

            // Outcome badge - only show when status is Completed
            const outcomeSection = document.getElementById('outcomeSection');
            const outcomeBadge = document.getElementById('outcomeBadge');
            
            if (treatment.status === 'Completed') {
                outcomeSection.style.display = 'block';
                outcomeBadge.innerHTML = getOutcomeBadge(treatment.outcome);
            } else {
                outcomeSection.style.display = 'none';
            }
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
            if (!status) return '<span class="badge badge-soft badge-secondary">N/A</span>';
            
            const statusClasses = {
                'In Progress': 'badge badge-soft badge-warning',
                'Completed': 'badge badge-soft badge-success',
                'Cancelled': 'badge badge-soft badge-error'
            };
            
            const className = statusClasses[status] || 'badge badge-soft badge-secondary';
            return '<span class="' + className + '">' + status + '</span>';
        }

        function getOutcomeBadge(outcome) {
            if (!outcome) return '<span class="badge badge-soft badge-secondary">N/A</span>';
            
            const outcomeClasses = {
                'Successful': 'badge badge-soft badge-success',
                'Failed': 'badge badge-soft badge-error',
                'Partial Success': 'badge badge-soft badge-warning'
            };
            
            const className = outcomeClasses[outcome] || 'badge badge-soft badge-secondary';
            return '<span class="' + className + '">' + outcome + '</span>';
        }



        function showError(message) {
            document.getElementById('loadingSpinner').classList.add('hidden');
            document.getElementById('errorMessage').classList.remove('hidden');
            document.getElementById('errorText').textContent = message;
        }
    </script>
</body>
</html>
