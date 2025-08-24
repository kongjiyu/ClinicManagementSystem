<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Medical Certificate Detail</title>
    <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
    <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        .doctor-signature {
            font-family: 'Pacifico', cursive;
            font-size: 1.5rem;
            color: #1f2937;
        }
        @media print {
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
<main class="p-6 space-y-8">
    <div class="flex justify-between items-center">
        <h1 class="text-3xl font-bold">Medical Certificate</h1>
        <div class="flex gap-2 no-print">
            <button class="btn btn-primary" onclick="downloadPDF()">
                <span class="icon-[tabler--download] size-4 mr-2"></span>
                Download PDF
            </button>
            <button class="btn btn-outline" onclick="window.print()">
                <span class="icon-[tabler--printer] size-4 mr-2"></span>
                Print
            </button>
        </div>
    </div>

    <div id="mc-content" class="bg-white rounded-lg p-8 shadow-lg max-w-4xl mx-auto">
        <!-- Header -->
        <div class="text-center border-b-2 border-gray-300 pb-6 mb-6">
            <h2 class="text-2xl font-bold text-gray-800">MEDICAL CERTIFICATE</h2>
            <p class="text-gray-600 mt-2">Clinic Management System</p>
        </div>

        <!-- MC Information -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">MC ID</label>
                <p class="text-lg font-semibold text-gray-900" id="mc-id">Loading...</p>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Issue Date</label>
                <p class="text-lg text-gray-900" id="issue-date">Loading...</p>
            </div>
        </div>

        <!-- Patient Information -->
        <div class="bg-gray-50 rounded-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Patient Information</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Patient Name</label>
                    <p class="text-gray-900" id="patient-name">Loading...</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Patient IC</label>
                    <p class="text-gray-900" id="patient-ic">Loading...</p>
                </div>
            </div>
        </div>

        <!-- Doctor Information -->
        <div class="bg-gray-50 rounded-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Doctor Information</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Doctor Name</label>
                    <p class="text-gray-900" id="doctor-name">Loading...</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Medical License</label>
                    <p class="text-gray-900" id="doctor-license">Loading...</p>
                </div>
            </div>
        </div>

        <!-- MC Period -->
        <div class="bg-blue-50 rounded-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Medical Leave Period</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
                    <p class="text-lg font-semibold text-blue-900" id="start-date">Loading...</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">End Date</label>
                    <p class="text-lg font-semibold text-blue-900" id="end-date">Loading...</p>
                </div>
            </div>
        </div>

        <!-- Medical Details -->
        <div class="mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Medical Details</h3>
            <div class="bg-gray-50 rounded-lg p-4 space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Diagnosis</label>
                    <p class="text-gray-900" id="diagnosis">Loading...</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Symptoms</label>
                    <p class="text-gray-900" id="symptoms">Loading...</p>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="border-t-2 border-gray-300 pt-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="text-center">
                    <div class="mt-4">
                        <p class="doctor-signature mb-2" id="doctor-signature">Loading...</p>
                        <div class="border-t-2 border-gray-400 pt-2 w-48 mx-auto">
                            <p class="text-sm text-gray-600">Doctor's Signature</p>
                        </div>
                    </div>
                </div>
                <div class="text-center">
                    <div class="mt-4">
                        <p class="text-sm font-semibold text-gray-800 mb-2" id="mc-date">Loading...</p>
                        <div class="border-t-2 border-gray-400 pt-2 w-48 mx-auto">
                            <p class="text-sm text-gray-600">Date</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    const API_BASE = '<%= request.getContextPath() %>/api';
    
    // Format date for display
    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    };
    
    // Get consultation ID from URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const consultationId = urlParams.get('consultationId');
    
    if (!consultationId) {
        alert('No consultation ID provided');
        window.close();
    }

    async function loadMCData() {
        try {
            const response = await fetch(API_BASE + '/consultations/' + consultationId + '/mc');
            
            if (!response.ok) {
                if (response.status === 404) {
                    alert('No medical certificate found for this consultation');
                    window.close();
                    return;
                }
                throw new Error('Failed to load MC data');
            }

            const consultation = await response.json();
            
            // Load patient data
            const patientResponse = await fetch(API_BASE + '/patients/' + consultation.patientID);
            const patient = await patientResponse.json();
            
            // Load doctor data
            const doctorResponse = await fetch(API_BASE + '/staff/' + consultation.doctorID);
            const doctor = await doctorResponse.json();

            // Populate the page
            document.getElementById('mc-id').textContent = consultation.mcID || 'N/A';
            document.getElementById('issue-date').textContent = consultation.consultationDate || 'N/A';
            document.getElementById('patient-name').textContent = patient.firstName + ' ' + patient.lastName;
            document.getElementById('patient-ic').textContent = patient.idNumber || 'N/A';
            document.getElementById('doctor-name').textContent = doctor.firstName + ' ' + doctor.lastName;
            document.getElementById('doctor-license').textContent = doctor.medicalLicenseNumber || 'N/A';
            document.getElementById('start-date').textContent = formatDate(consultation.startDate);
            document.getElementById('end-date').textContent = formatDate(consultation.endDate);
            document.getElementById('diagnosis').textContent = consultation.diagnosis || 'N/A';
            document.getElementById('symptoms').textContent = consultation.symptoms || 'N/A';
            document.getElementById('doctor-signature').textContent = doctor.firstName + ' ' + doctor.lastName;
            document.getElementById('mc-date').textContent = formatDate(consultation.consultationDate);
            document.getElementById('issue-date').textContent = formatDate(consultation.consultationDate);

        } catch (error) {
            console.error('Error loading MC data:', error);
            alert('Error loading medical certificate data: ' + error.message);
        }
    }

    // Download PDF function
    async function downloadPDF() {
        try {
            // Show loading state
            const downloadBtn = document.querySelector('button[onclick="downloadPDF()"]');
            const originalText = downloadBtn.innerHTML;
            downloadBtn.innerHTML = '<span class="loading loading-spinner loading-sm mr-2"></span>Generating PDF...';
            downloadBtn.disabled = true;

            // Get the MC content element
            const element = document.getElementById('mc-content');
            
            // Configure PDF options
            const opt = {
                margin: [10, 10, 10, 10],
                filename: 'medical_certificate_' + consultationId + '.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { 
                    scale: 2,
                    useCORS: true,
                    allowTaint: true
                },
                jsPDF: { 
                    unit: 'mm', 
                    format: 'a4', 
                    orientation: 'portrait' 
                }
            };

            // Generate and download PDF
            await html2pdf().set(opt).from(element).save();
            
            // Reset button state
            downloadBtn.innerHTML = originalText;
            downloadBtn.disabled = false;
            
        } catch (error) {
            console.error('Error generating PDF:', error);
            alert('Error generating PDF: ' + error.message);
            
            // Reset button state on error
            const downloadBtn = document.querySelector('button[onclick="downloadPDF()"]');
            downloadBtn.innerHTML = '<span class="icon-[tabler--download] size-4 mr-2"></span>Download PDF';
            downloadBtn.disabled = false;
        }
    }

    // Load data when page loads
    document.addEventListener('DOMContentLoaded', loadMCData);
</script>


</body>
</html>
