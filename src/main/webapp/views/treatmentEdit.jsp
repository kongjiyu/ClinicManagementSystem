<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Treatment</title>
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
                <h1 class="text-2xl font-bold text-gray-800">Edit Treatment</h1>
                <a href="<%= request.getContextPath() %>/views/treatmentList.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-2"></i>Back to List
                </a>
            </div>

            <div id="loadingSpinner" class="flex justify-center items-center py-8">
                <div class="loading loading-spinner loading-lg"></div>
            </div>

            <form id="treatmentForm" class="space-y-6 hidden">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Treatment ID (Read-only) -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment ID</span>
                        </label>
                        <input type="text" id="treatmentID" class="input input-bordered w-full" readonly>
                    </div>

                    <!-- Patient Selection -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Patient *</span>
                        </label>
                        <select id="patientID" name="patientID" class="select select-bordered w-full" required>
                            <option value="">Select Patient</option>
                        </select>
                    </div>

                    <!-- Doctor Selection -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Doctor *</span>
                        </label>
                        <select id="doctorID" name="doctorID" class="select select-bordered w-full" required>
                            <option value="">Select Doctor</option>
                        </select>
                    </div>

                    <!-- Treatment Type -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Type *</span>
                        </label>
                        <select id="treatmentType" name="treatmentType" class="select select-bordered w-full" required>
                            <option value="">Select Treatment Type</option>
                            <option value="Surgery">Surgery</option>
                            <option value="Physical Therapy">Physical Therapy</option>
                            <option value="Vaccination">Vaccination</option>
                            <option value="Laboratory Test">Laboratory Test</option>
                            <option value="Emergency Treatment">Emergency Treatment</option>
                            <option value="Preventive Care">Preventive Care</option>
                            <option value="Diagnostic Procedure">Diagnostic Procedure</option>
                            <option value="Therapeutic Procedure">Therapeutic Procedure</option>
                        </select>
                    </div>

                    <!-- Treatment Name -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Name *</span>
                        </label>
                        <input type="text" id="treatmentName" name="treatmentName" 
                               class="input input-bordered w-full" 
                               placeholder="e.g., Appendectomy, Flu Shot" required>
                    </div>

                    <!-- Treatment Date & Time -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Treatment Date & Time *</span>
                        </label>
                        <input type="datetime-local" id="treatmentDate" name="treatmentDate" 
                               class="input input-bordered w-full" required>
                    </div>

                    <!-- Duration -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Duration (minutes) *</span>
                        </label>
                        <input type="number" id="duration" name="duration" 
                               class="input input-bordered w-full" 
                               placeholder="e.g., 60" min="1" required>
                    </div>

                    <!-- Status -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Status *</span>
                        </label>
                        <select id="status" name="status" class="select select-bordered w-full" required>
                            <option value="">Select Status</option>
                            <option value="Scheduled">Scheduled</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>

                    <!-- Outcome -->
                    <div class="form-control">
                        <label class="label">
                            <span class="label-text font-semibold">Outcome</span>
                        </label>
                        <select id="outcome" name="outcome" class="select select-bordered w-full">
                            <option value="">Select Outcome</option>
                            <option value="Successful">Successful</option>
                            <option value="Failed">Failed</option>
                            <option value="Partial Success">Partial Success</option>
                        </select>
                    </div>
                </div>

                <!-- Description -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Description</span>
                    </label>
                    <textarea id="description" name="description" 
                              class="textarea textarea-bordered h-24" 
                              placeholder="Detailed description of the treatment..."></textarea>
                </div>

                <!-- Procedure -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Procedure</span>
                    </label>
                    <textarea id="procedure" name="procedure" 
                              class="textarea textarea-bordered h-24" 
                              placeholder="Step-by-step procedure details..."></textarea>
                </div>

                <!-- Notes -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Notes</span>
                    </label>
                    <textarea id="notes" name="notes" 
                              class="textarea textarea-bordered h-24" 
                              placeholder="Additional notes or observations..."></textarea>
                </div>

                <!-- Submit Buttons -->
                <div class="flex justify-end space-x-4">
                    <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/views/treatmentList.jsp'" 
                            class="btn btn-secondary">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-2"></i>Update Treatment
                    </button>
                </div>
            </form>

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

        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const treatmentId = urlParams.get('id');
            
            if (treatmentId) {
                loadTreatmentData(treatmentId);
            } else {
                showError('No treatment ID provided');
            }
        });

        function loadTreatmentData(treatmentId) {
            fetch('<%= request.getContextPath() %>/api/treatments/' + treatmentId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Treatment not found');
                    }
                    return response.json();
                })
                .then(treatment => {
                    treatmentData = treatment;
                    loadPatientsAndDoctors(treatment);
                })
                .catch(error => {
                    console.error('Error loading treatment:', error);
                    showError('Failed to load treatment data');
                });
        }

        function loadPatientsAndDoctors(treatment) {
            Promise.all([
                fetch('<%= request.getContextPath() %>/api/patients'),
                fetch('<%= request.getContextPath() %>/api/staff')
            ])
            .then(responses => Promise.all(responses.map(r => r.json())))
            .then(([patients, staff]) => {
                populatePatientSelect(patients, treatment.patientID);
                populateDoctorSelect(staff, treatment.doctorID);
                populateFormFields(treatment);
            })
            .catch(error => {
                console.error('Error loading patients/doctors:', error);
                populateFormFields(treatment);
            });
        }

        function populatePatientSelect(patients, selectedPatientId) {
            const select = document.getElementById('patientID');
            if (patients && patients.elements) {
                patients.elements.forEach(patient => {
                    const option = document.createElement('option');
                    option.value = patient.patientID;
                    option.textContent = patient.patientID + ' - ' + patient.firstName + ' ' + patient.lastName;
                    if (patient.patientID === selectedPatientId) {
                        option.selected = true;
                    }
                    select.appendChild(option);
                });
            }
        }

        function populateDoctorSelect(staff, selectedDoctorId) {
            const select = document.getElementById('doctorID');
            if (staff && staff.elements) {
                staff.elements.forEach(doctor => {
                    if (doctor.position && doctor.position.toLowerCase().includes('doctor')) {
                        const option = document.createElement('option');
                        option.value = doctor.staffID;
                        option.textContent = doctor.staffID + ' - Dr. ' + doctor.firstName + ' ' + doctor.lastName;
                        if (doctor.staffID === selectedDoctorId) {
                            option.selected = true;
                        }
                        select.appendChild(option);
                    }
                });
            }
        }

        function populateFormFields(treatment) {
            // Hide loading spinner and show form
            document.getElementById('loadingSpinner').classList.add('hidden');
            document.getElementById('treatmentForm').classList.remove('hidden');

            // Fill in the form fields
            document.getElementById('treatmentID').value = treatment.treatmentID;
            document.getElementById('treatmentName').value = treatment.treatmentName;
            document.getElementById('treatmentType').value = treatment.treatmentType;
            document.getElementById('duration').value = treatment.duration;
            document.getElementById('status').value = treatment.status;
            document.getElementById('outcome').value = treatment.outcome || '';
            document.getElementById('description').value = treatment.description || '';
            document.getElementById('procedure').value = treatment.treatmentProcedure || '';
            document.getElementById('notes').value = treatment.notes || '';

            // Format datetime for input field
            if (treatment.treatmentDate) {
                const date = new Date(treatment.treatmentDate);
                const localDateTime = new Date(date.getTime() - date.getTimezoneOffset() * 60000)
                    .toISOString()
                    .slice(0, 16);
                document.getElementById('treatmentDate').value = localDateTime;
            }
        }

        document.getElementById('treatmentForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!validateForm()) {
                return;
            }

            const formData = collectFormData();
            
            fetch('<%= request.getContextPath() %>/api/treatments/' + treatmentData.treatmentID, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Failed to update treatment');
                }
            })
            .then(data => {
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: 'Treatment updated successfully',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    window.location.href = '<%= request.getContextPath() %>/views/treatmentDetail.jsp?id=' + treatmentData.treatmentID;
                });
            })
            .catch(error => {
                console.error('Error updating treatment:', error);
                Swal.fire('Error', 'Failed to update treatment', 'error');
            });
        });

        function validateForm() {
            const requiredFields = ['patientID', 'doctorID', 'treatmentType', 'treatmentName', 'treatmentDate', 'duration', 'status'];
            
            for (const fieldId of requiredFields) {
                const field = document.getElementById(fieldId);
                if (!field.value.trim()) {
                    Swal.fire('Validation Error', fieldId + ' is required', 'error');
                    field.focus();
                    return false;
                }
            }

            const duration = parseInt(document.getElementById('duration').value);
            if (duration <= 0) {
                Swal.fire('Validation Error', 'Duration must be greater than 0', 'error');
                return false;
            }

            return true;
        }

        function collectFormData() {
            return {
                patientID: document.getElementById('patientID').value,
                doctorID: document.getElementById('doctorID').value,
                treatmentType: document.getElementById('treatmentType').value,
                treatmentName: document.getElementById('treatmentName').value,
                treatmentDate: document.getElementById('treatmentDate').value,
                duration: parseInt(document.getElementById('duration').value),
                status: document.getElementById('status').value,
                outcome: document.getElementById('outcome').value || null,
                description: document.getElementById('description').value || null,
                treatmentProcedure: document.getElementById('procedure').value || null,
                notes: document.getElementById('notes').value || null
            };
        }

        function showError(message) {
            document.getElementById('loadingSpinner').classList.add('hidden');
            document.getElementById('errorMessage').classList.remove('hidden');
            document.getElementById('errorText').textContent = message;
        }
    </script>
</body>
</html>
