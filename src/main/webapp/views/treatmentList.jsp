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
    <title>Treatment Management</title>
    <link href="<%= request.getContextPath() %>/static/output.css" rel="stylesheet">
    <script defer src="<%= request.getContextPath() %>/static/flyonui.js"></script>
</head>
<body class="flex min-h-screen text-base-content">
    <%@ include file="/views/adminSidebar.jsp" %>

    <main class="flex-1 p-6 ml-64 space-y-6">
        <div class="flex justify-between items-center mb-4">
            <h1 class="text-2xl font-bold mb-4">Treatment Management</h1>
        </div>
        
        <div class="overflow-x-auto">
            <table id="treatmentTable" class="display">
                <thead>
                    <tr>
                        <th>Treatment ID</th>
                        <th>Consultation ID</th>
                        <th>Patient</th>
                        <th>Treatment Type</th>
                        <th>Treatment Name</th>
                        <th>Date & Time</th>
                        <th>Status</th>
                        <th>Outcome</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Data will be loaded dynamically -->
                </tbody>
            </table>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.3.2/js/dataTables.tailwindcss.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.tailwindcss.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <script>
        function formatDateTime(dateTimeString) {
            if (!dateTimeString) return 'N/A';
            try {
                const date = new Date(dateTimeString);
                if (isNaN(date.getTime())) return 'N/A';
                
                // Format as dd/mm/yyyy, time
                const day = date.getDate().toString().padStart(2, '0');
                const month = (date.getMonth() + 1).toString().padStart(2, '0');
                const year = date.getFullYear();
                const hours = date.getHours().toString().padStart(2, '0');
                const minutes = date.getMinutes().toString().padStart(2, '0');
                
                return day + '/' + month + '/' + year + ', ' + hours + ':' + minutes;
            } catch (error) {
                console.error('Error formatting date:', error);
                return 'N/A';
            }
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

        function getActionButtons(treatmentId) {
            return '<div class="flex space-x-2">' +
                '<a href="treatmentDetail.jsp?id=' + treatmentId + '" class="btn btn-sm btn-info" onclick="event.stopPropagation();">' +
                    '<i class="fas fa-eye"></i>' +
                '</a>' +
                '<a href="treatmentEdit.jsp?id=' + treatmentId + '" class="btn btn-sm btn-warning" onclick="event.stopPropagation();">' +
                    '<i class="fas fa-edit"></i>' +
                '</a>' +
                '<button onclick="event.stopPropagation(); deleteTreatment(\'' + treatmentId + '\');" class="btn btn-sm btn-error">' +
                    '<i class="fas fa-trash"></i>' +
                '</button>' +
            '</div>';
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
                            Swal.fire('Deleted!', 'Treatment has been deleted.', 'success');
                            location.reload();
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

        new DataTable('#treatmentTable', {
            ajax: {
                url: '<%= request.getContextPath() %>/api/treatments',
                dataSrc: function(json) {
                    // Handle both array and object with elements property
                    let data = [];
                    if (json && json.elements) {
                        data = json.elements;
                    } else if (Array.isArray(json)) {
                        data = json;
                    }
                    
                    // Filter out null values
                    return data.filter(item => item !== null && item !== undefined);
                },
                error: function(xhr, error, thrown) {
                    console.error('DataTables AJAX error:', error, thrown);
                    $('#treatmentTable').html('<tr><td colspan="8" class="text-center text-red-500">Error loading data</td></tr>');
                }
            },
            columns: [
                { 
                    data: 'treatmentID', 
                    title: 'Treatment ID',
                    render: function(data, type, row) {
                        return data || 'N/A';
                    }
                },
                { 
                    data: 'consultationID', 
                    title: 'Consultation ID',
                    render: function(data, type, row) {
                        if (data) {
                            return '<a href="<%= request.getContextPath() %>/views/consultationDetail.jsp?id=' + data + '" class="link link-primary hover:underline">' + data + '</a>';
                        }
                        return 'N/A';
                    }
                },
                { 
                    data: 'patientID', 
                    title: 'Patient',
                    render: function(data, type, row) {
                        return data || 'N/A';
                    }
                },
                { 
                    data: 'treatmentType', 
                    title: 'Treatment Type',
                    render: function(data, type, row) {
                        return data || 'N/A';
                    }
                },
                { 
                    data: 'treatmentName', 
                    title: 'Treatment Name',
                    render: function(data, type, row) {
                        return data || 'N/A';
                    }
                },
                { 
                    data: 'treatmentDate', 
                    title: 'Date & Time',
                    render: function(data, type, row) {
                        // For sorting, return the original date string
                        if (type === 'sort') {
                            return data;
                        }
                        // For display, use the formatDateTime function
                        return formatDateTime(data);
                    },
                    type: 'date'
                },
                { 
                    data: 'status', 
                    title: 'Status',
                    render: function(data, type, row) {
                        return getStatusBadge(data);
                    }
                },
                { 
                    data: 'outcome', 
                    title: 'Outcome',
                    render: function(data, type, row) {
                        return getOutcomeBadge(data);
                    }
                }
            ],
            order: [[5, 'desc']], // Sort by date descending (now column 5 is Date & Time)
            rowCallback: function(row, data) {
                if (data && data.treatmentID) {
                    row.addEventListener('click', function() {
                        window.location.href = '<%= request.getContextPath() %>/views/treatmentDetail.jsp?id=' + data.treatmentID;
                    });
                    row.classList.add('cursor-pointer', 'hover:bg-gray-100');
                }
            },
            error: function(xhr, error, thrown) {
                console.error('DataTables error:', error, thrown);
            }
        });
    </script>
</body>
</html>
