package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.*;
import repositories.Patient.PatientRepository;
import repositories.Consultation.ConsultationRepository;
import repositories.Prescription.PrescriptionRepository;
import repositories.Medicine.MedicineRepository;
import repositories.Order.OrderRepository;
import repositories.Bill.BillRepository;
import repositories.Treatment.TreatmentRepository;
import utils.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Path("/reports")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ReportResource {

    Gson gson = new GsonBuilder()
        .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
        .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
        .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
        .registerTypeAdapter(utils.List.class, new ListAdapter())
        .create();

    @Inject
    private PatientRepository patientRepository;

    @Inject
    private ConsultationRepository consultationRepository;

    @Inject
    private PrescriptionRepository prescriptionRepository;

    @Inject
    private MedicineRepository medicineRepository;

    @Inject
    private OrderRepository orderRepository;

    @Inject
    private BillRepository billRepository;

    @Inject
    private repositories.Staff.StaffRepository staffRepository;

    @Inject
    private repositories.Treatment.TreatmentRepository treatmentRepository;

    // ===== PHASE 1 REPORTS =====

    // 1. Patient Registration Trends Report
    @GET
    @Path("/patient-registration")
    public Response getPatientRegistrationReport(
            @QueryParam("period") String period, // daily, weekly, monthly, yearly
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Patient Registration Trends");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all patients
            List<Patient> allPatients = patientRepository.findAll();
            
            // Filter patients by date range (assuming patient creation date is available)
            List<Patient> filteredPatients = new List<>();
            for (Patient patient : allPatients) {
                // For now, we'll include all patients since we don't have creation date
                // In a real system, you'd filter by patient creation date
                filteredPatients.add(patient);
            }

            // Calculate statistics
            int totalPatients = filteredPatients.size();
            int newPatientsThisMonth = 0; // Would calculate based on creation date
            int newPatientsThisWeek = 0;  // Would calculate based on creation date

            // Gender distribution using MultiMap
            MultiMap<String, Integer> genderDistribution = new MultiMap<>();
            MultiMap<String, Integer> ageDistribution = new MultiMap<>();
            MultiMap<String, Integer> bloodTypeDistribution = new MultiMap<>();
            MultiMap<String, Integer> nationalityDistribution = new MultiMap<>();

            for (Patient patient : filteredPatients) {
                // Gender distribution
                String gender = patient.getGender() != null ? patient.getGender() : "Unknown";
                genderDistribution.put(gender, 1);

                // Age distribution
                String ageGroup = getAgeGroup(patient.getAge());
                ageDistribution.put(ageGroup, 1);

                // Blood type distribution
                String bloodType = patient.getBloodType() != null ? patient.getBloodType() : "Unknown";
                bloodTypeDistribution.put(bloodType, 1);

                // Nationality distribution
                String nationality = patient.getNationality() != null ? patient.getNationality() : "Unknown";
                nationalityDistribution.put(nationality, 1);
            }

            // Build response
            JsonObject data = new JsonObject();
            data.addProperty("totalPatients", totalPatients);
            data.addProperty("newPatientsThisMonth", newPatientsThisMonth);
            data.addProperty("newPatientsThisWeek", newPatientsThisWeek);
            data.add("genderDistribution", gson.toJsonTree(multiMapToCountMap(genderDistribution)));
            data.add("ageDistribution", gson.toJsonTree(multiMapToCountMap(ageDistribution)));
            data.add("bloodTypeDistribution", gson.toJsonTree(multiMapToCountMap(bloodTypeDistribution)));
            data.add("nationalityDistribution", gson.toJsonTree(multiMapToCountMap(nationalityDistribution)));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating patient registration report: " + e.getMessage()))
                .build();
        }
    }

    // 2. Consultation Volume Report
    @GET
    @Path("/consultation-volume")
    public Response getConsultationVolumeReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Consultation Volume Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all consultations
            List<Consultation> allConsultations = consultationRepository.findAll();
            
            // Filter consultations by date range
            List<Consultation> filteredConsultations = new List<>();
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    filteredConsultations.add(consultation);
                }
            }

            // Calculate statistics
            int totalConsultations = filteredConsultations.size();
            
            // Status distribution using MultiMap
            MultiMap<String, Integer> statusDistribution = new MultiMap<>();
            MultiMap<String, Integer> dailyConsultations = new MultiMap<>();
            MultiMap<String, Integer> hourlyConsultations = new MultiMap<>();

            for (Consultation consultation : filteredConsultations) {
                // Status distribution
                String status = consultation.getStatus() != null ? consultation.getStatus() : "Unknown";
                statusDistribution.put(status, 1);

                // Daily distribution
                String dateKey = consultation.getConsultationDate().toString();
                dailyConsultations.put(dateKey, 1);

                // Hourly distribution (if check-in time is available)
                if (consultation.getCheckInTime() != null) {
                    String hourKey = String.valueOf(consultation.getCheckInTime().getHour());
                    hourlyConsultations.put(hourKey, 1);
                }
            }

            // Calculate averages
            int uniqueDaysCount = dailyConsultations.keySet().size();
            double avgConsultationsPerDay = uniqueDaysCount > 0 ? 
                (double) totalConsultations / uniqueDaysCount : 0;

            // Build response
            JsonObject data = new JsonObject();
            data.addProperty("totalConsultations", totalConsultations);
            data.addProperty("averageConsultationsPerDay", avgConsultationsPerDay);
            data.add("statusDistribution", gson.toJsonTree(multiMapToCountMap(statusDistribution)));
            data.add("dailyConsultations", gson.toJsonTree(multiMapToCountMap(dailyConsultations)));
            data.add("hourlyConsultations", gson.toJsonTree(multiMapToCountMap(hourlyConsultations)));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating consultation volume report: " + e.getMessage()))
                .build();
        }
    }

    // 3.1. Consultation Daily Trends Report
    @GET
    @Path("/consultation-daily-trends")
    public Response getConsultationDailyTrendsReport(
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusWeeks(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            List<Consultation> allConsultations = consultationRepository.findAll();
            MultiMap<String, Integer> dailyTrends = new MultiMap<>();

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    String dayOfWeek = consultation.getConsultationDate().getDayOfWeek().toString();
                    String shortDay = dayOfWeek.substring(0, 3);
                    dailyTrends.put(shortDay, 1);
                }
            }

            String json = gson.toJson(multiMapToCountMap(dailyTrends));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating daily trends report: " + e.getMessage()))
                .build();
        }
    }

    // 3.2. Doctor Performance Report
    @GET
    @Path("/consultation-doctor-performance")
    public Response getDoctorPerformanceReport(
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            List<Consultation> allConsultations = consultationRepository.findAll();
            List<Staff> allStaff = staffRepository.findAll();
            MultiMap<String, Integer> doctorPerformance = new MultiMap<>();

            // Create a map of doctor IDs to names
            MultiMap<String, String> doctorNames = new MultiMap<>();
            for (Staff staff : allStaff) {
                if ("Doctor".equalsIgnoreCase(staff.getPosition())) {
                    doctorNames.put(staff.getStaffID(), staff.getFirstName() + " " + staff.getLastName());
                }
            }

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end) &&
                    consultation.getDoctorID() != null) {
                    
                    List<String> nameList = doctorNames.get(consultation.getDoctorID());
                    String doctorName = nameList.isEmpty() ? "Unknown Doctor" : "Dr. " + nameList.get(0);
                    doctorPerformance.put(doctorName, 1);
                }
            }

            String json = gson.toJson(multiMapToCountMap(doctorPerformance));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating doctor performance report: " + e.getMessage()))
                .build();
        }
    }

    // 3.3. Consultation Duration Analysis Report
    @GET
    @Path("/consultation-duration-analysis")
    public Response getConsultationDurationReport(
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            List<Consultation> allConsultations = consultationRepository.findAll();
            MultiMap<String, Integer> durationAnalysis = new MultiMap<>();

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    
                    // Calculate duration based on check-in time and current time or estimated duration
                    // For now, we'll use a simple distribution based on consultation type or status
                    String duration = getDurationCategory(consultation);
                    durationAnalysis.put(duration, 1);
                }
            }

            String json = gson.toJson(multiMapToCountMap(durationAnalysis));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating duration analysis report: " + e.getMessage()))
                .build();
        }
    }

    // 3.4. Monthly Consultation Comparison Report
    @GET
    @Path("/consultation-monthly-comparison")
    public Response getMonthlyComparisonReport(
            @QueryParam("months") String months) {
        try {
            int numMonths = months != null ? Integer.parseInt(months) : 6;
            LocalDate end = LocalDate.now();
            LocalDate start = end.minusMonths(numMonths - 1);

            List<Consultation> allConsultations = consultationRepository.findAll();
            MultiMap<String, Integer> monthlyComparison = new MultiMap<>();

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    String monthKey = consultation.getConsultationDate().getMonth().toString().substring(0, 3);
                    monthlyComparison.put(monthKey, 1);
                }
            }

            String json = gson.toJson(multiMapToCountMap(monthlyComparison));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating monthly comparison report: " + e.getMessage()))
                .build();
        }
    }

    // Helper method to categorize consultation duration
    private String getDurationCategory(Consultation consultation) {
        // This is a simplified approach - in a real system, you'd calculate actual duration
        // For now, we'll categorize based on consultation characteristics
        if (consultation.getStatus() != null) {
            switch (consultation.getStatus().toLowerCase()) {
                case "completed":
                    return "16-30 min";
                case "in progress":
                    return "31-45 min";
                case "waiting":
                    return "0-15 min";
                case "billing":
                    return "46-60 min";
                default:
                    return "16-30 min";
            }
        }
        return "16-30 min";
    }

    // 3.5. Medicine Category Analysis Report
    @GET
    @Path("/medicine-category-analysis")
    public Response getMedicineCategoryAnalysis(
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            // Get all medicines and prescriptions
            List<Medicine> allMedicines = medicineRepository.findAll();
            List<Prescription> allPrescriptions = prescriptionRepository.findAll();
            List<Consultation> allConsultations = consultationRepository.findAll();
            
            // Create consultation date mapping
            MultiMap<String, LocalDate> consultationDates = new MultiMap<>();
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null) {
                    consultationDates.put(consultation.getConsultationID(), consultation.getConsultationDate());
                }
            }

            // Analyze by medicine categories (simplified categorization)
            MultiMap<String, Integer> categoryAnalysis = new MultiMap<>();
            
            for (Prescription prescription : allPrescriptions) {
                List<LocalDate> dates = consultationDates.get(prescription.getConsultationID());
                if (!dates.isEmpty()) {
                    LocalDate consultationDate = dates.get(0);
                    if (consultationDate != null &&
                        !consultationDate.isBefore(start) &&
                        !consultationDate.isAfter(end)) {
                        
                        // Find medicine and categorize
                        for (Medicine medicine : allMedicines) {
                            if (medicine.getMedicineID().equals(prescription.getMedicineID())) {
                                String category = categorizeMedicine(medicine.getMedicineName());
                                categoryAnalysis.put(category, prescription.getQuantityDispensed());
                                break;
                            }
                        }
                    }
                }
            }

            String json = gson.toJson(multiMapToCountMap(categoryAnalysis));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating medicine category analysis: " + e.getMessage()))
                .build();
        }
    }

    // 3.6. Medicine Monthly Trends Report
    @GET
    @Path("/medicine-monthly-trends")
    public Response getMedicineMonthlyTrends(
            @QueryParam("months") String months) {
        try {
            int numMonths = months != null ? Integer.parseInt(months) : 6;
            LocalDate end = LocalDate.now();
            LocalDate start = end.minusMonths(numMonths - 1);

            List<Prescription> allPrescriptions = prescriptionRepository.findAll();
            List<Consultation> allConsultations = consultationRepository.findAll();
            
            // Create consultation date mapping
            MultiMap<String, LocalDate> consultationDates = new MultiMap<>();
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null) {
                    consultationDates.put(consultation.getConsultationID(), consultation.getConsultationDate());
                }
            }

            MultiMap<String, Double> monthlyTrends = new MultiMap<>();

            for (Prescription prescription : allPrescriptions) {
                List<LocalDate> dates = consultationDates.get(prescription.getConsultationID());
                if (!dates.isEmpty()) {
                    LocalDate consultationDate = dates.get(0);
                    if (consultationDate != null &&
                        !consultationDate.isBefore(start) &&
                        !consultationDate.isAfter(end)) {
                        String monthKey = consultationDate.getMonth().toString().substring(0, 3);
                        double revenue = prescription.getQuantityDispensed() * prescription.getPrice();
                        monthlyTrends.put(monthKey, revenue);
                    }
                }
            }

            String json = gson.toJson(multiMapToSumMap(monthlyTrends));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating medicine monthly trends: " + e.getMessage()))
                .build();
        }
    }

    // Helper method to categorize medicines
    private String categorizeMedicine(String medicineName) {
        String name = medicineName.toLowerCase();
        if (name.contains("pain") || name.contains("paracetamol") || name.contains("ibuprofen") || name.contains("aspirin")) {
            return "Pain Relief";
        } else if (name.contains("antibiotic") || name.contains("amoxicillin") || name.contains("penicillin")) {
            return "Antibiotics";
        } else if (name.contains("vitamin") || name.contains("supplement")) {
            return "Vitamins";
        } else if (name.contains("heart") || name.contains("cardio") || name.contains("blood pressure")) {
            return "Cardiovascular";
        } else if (name.contains("cough") || name.contains("respiratory") || name.contains("asthma")) {
            return "Respiratory";
        } else {
            return "General Medicine";
        }
    }

    // Helper method to categorize diagnosis
    private String categorizeDiagnosis(String diagnosis) {
        if (diagnosis == null || diagnosis.trim().isEmpty()) return "Unspecified";
        
        String diag = diagnosis.toLowerCase();
        if (diag.contains("cold") || diag.contains("flu") || diag.contains("influenza") || 
            diag.contains("bronchitis") || diag.contains("pneumonia") || diag.contains("sinusitis") ||
            diag.contains("asthma") || diag.contains("allergic rhinitis")) {
            return "Respiratory";
        } else if (diag.contains("hypertension") || diag.contains("blood pressure")) {
            return "Cardiovascular";
        } else if (diag.contains("diabetes")) {
            return "Endocrine";
        } else if (diag.contains("gastritis") || diag.contains("stomach")) {
            return "Gastrointestinal";
        } else if (diag.contains("urinary") || diag.contains("uti")) {
            return "Urological";
        } else if (diag.contains("migraine") || diag.contains("headache")) {
            return "Neurological";
        } else if (diag.contains("anxiety") || diag.contains("depression")) {
            return "Mental Health";
        } else if (diag.contains("arthritis") || diag.contains("back pain") || diag.contains("joint")) {
            return "Musculoskeletal";
        } else if (diag.contains("rash") || diag.contains("skin")) {
            return "Dermatological";
        } else if (diag.contains("ear") || diag.contains("throat")) {
            return "ENT";
        } else {
            return "Other";
        }
    }

    // 3. Medicine Sales Report
    @GET
    @Path("/medicine-sales")
    public Response getMedicineSalesReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Medicine Sales Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all prescriptions
            List<Prescription> allPrescriptions = prescriptionRepository.findAll();
            
            // Get all consultations to filter by date
            List<Consultation> allConsultations = consultationRepository.findAll();
            MultiMap<String, LocalDate> consultationDates = new MultiMap<>();
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null) {
                    consultationDates.put(consultation.getConsultationID(), consultation.getConsultationDate());
                }
            }

            // Filter prescriptions by consultation date
            List<Prescription> filteredPrescriptions = new List<>();
            MultiMap<String, Integer> medicineSales = new MultiMap<>();
            MultiMap<String, Double> medicineRevenue = new MultiMap<>();
            double totalRevenue = 0;

            for (Prescription prescription : allPrescriptions) {
                List<LocalDate> dates = consultationDates.get(prescription.getConsultationID());
                if (!dates.isEmpty()) {
                    LocalDate consultationDate = dates.get(0); // Get first date
                    if (consultationDate != null &&
                        !consultationDate.isBefore(start) &&
                        !consultationDate.isAfter(end)) {
                        filteredPrescriptions.add(prescription);

                        // Calculate sales by medicine
                        String medicineId = prescription.getMedicineID();
                        int quantity = prescription.getQuantityDispensed();
                        double price = prescription.getPrice();
                        double revenue = quantity * price;

                        medicineSales.put(medicineId, quantity);
                        medicineRevenue.put(medicineId, revenue);
                        totalRevenue += revenue;
                    }
                }
            }

            // Get medicine names
            MultiMap<String, String> medicineNames = new MultiMap<>();
            List<Medicine> allMedicines = medicineRepository.findAll();
            for (Medicine medicine : allMedicines) {
                medicineNames.put(medicine.getMedicineID(), medicine.getMedicineName());
            }

            // Create summary data for response
            List<MedicineSalesData> topSellingMedicinesList = new List<>();
            ArraySet<String> medicineKeys = medicineSales.keySet();
            Object[] keyArray = medicineKeys.toArray();
            for (int i = 0; i < keyArray.length; i++) {
                String medicineId = (String) keyArray[i];
                List<String> nameList = medicineNames.get(medicineId);
                String medicineName = nameList.isEmpty() ? "Unknown Medicine" : nameList.get(0);
                
                // Sum up quantities and revenue for this medicine
                int totalQuantity = 0;
                double totalMedicineRevenue = 0;
                
                for (Integer quantity : medicineSales.get(medicineId)) {
                    totalQuantity += quantity;
                }
                for (Double revenue : medicineRevenue.get(medicineId)) {
                    totalMedicineRevenue += revenue;
                }
                
                MedicineSalesData salesData = new MedicineSalesData();
                salesData.medicineId = medicineId;
                salesData.medicineName = medicineName;
                salesData.quantitySold = totalQuantity;
                salesData.revenue = totalMedicineRevenue;
                
                topSellingMedicinesList.add(salesData);
            }

            // Build response
            JsonObject data = new JsonObject();
            data.addProperty("totalPrescriptions", filteredPrescriptions.size());
            data.addProperty("totalRevenue", totalRevenue);
            data.addProperty("averageRevenuePerPrescription", 
                filteredPrescriptions.size() > 0 ? totalRevenue / filteredPrescriptions.size() : 0);
            data.add("topSellingMedicines", gson.toJsonTree(topSellingMedicinesList));
            data.add("medicineSales", gson.toJsonTree(multiMapToCountMap(medicineSales)));
            data.add("medicineRevenue", gson.toJsonTree(multiMapToSumMap(medicineRevenue)));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating medicine sales report: " + e.getMessage()))
                .build();
        }
    }

    // 4. Inventory Management Report
    @GET
    @Path("/inventory-management")
    public Response getInventoryManagementReport() {
        try {
            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Inventory Management Report");
            report.addProperty("generatedDate", LocalDate.now().toString());

            // Get all medicines
            List<Medicine> allMedicines = medicineRepository.findAll();
            List<Order> allOrders = orderRepository.findAll();

            // Calculate inventory statistics
            int totalMedicines = allMedicines.size();
            int lowStockMedicines = 0;
            int outOfStockMedicines = 0;
            double totalStockValue = 0;

            List<InventoryData> medicineInventoryList = new List<>();

            for (Medicine medicine : allMedicines) {
                int currentStock = medicine.getTotalStock();
                int reorderLevel = medicine.getReorderLevel();
                double stockValue = currentStock * medicine.getSellingPrice();

                if (currentStock <= 0) {
                    outOfStockMedicines++;
                } else if (currentStock <= reorderLevel) {
                    lowStockMedicines++;
                }

                totalStockValue += stockValue;

                // Get order information for this medicine
                List<Order> medicineOrders = new List<>();
                for (Order order : allOrders) {
                    if (order.getMedicineID().equals(medicine.getMedicineID())) {
                        medicineOrders.add(order);
                    }
                }

                // Calculate order statistics
                int pendingOrders = 0;
                int completedOrders = 0;
                for (Order order : medicineOrders) {
                    if ("Pending".equals(order.getOrderStatus()) || "Shipped".equals(order.getOrderStatus())) {
                        pendingOrders++;
                    } else if ("Completed".equals(order.getOrderStatus())) {
                        completedOrders++;
                    }
                }

                InventoryData inventoryData = new InventoryData();
                inventoryData.medicineId = medicine.getMedicineID();
                inventoryData.medicineName = medicine.getMedicineName();
                inventoryData.currentStock = currentStock;
                inventoryData.reorderLevel = reorderLevel;
                inventoryData.stockValue = stockValue;
                inventoryData.pendingOrders = pendingOrders;
                inventoryData.completedOrders = completedOrders;
                inventoryData.status = currentStock <= 0 ? "Out of Stock" : 
                    currentStock <= reorderLevel ? "Low Stock" : "In Stock";

                medicineInventoryList.add(inventoryData);
            }

            // Build response
            JsonObject data = new JsonObject();
            data.addProperty("totalMedicines", totalMedicines);
            data.addProperty("lowStockMedicines", lowStockMedicines);
            data.addProperty("outOfStockMedicines", outOfStockMedicines);
            data.addProperty("totalStockValue", totalStockValue);
            data.addProperty("averageStockValue", totalMedicines > 0 ? totalStockValue / totalMedicines : 0);
            data.add("medicineInventory", gson.toJsonTree(medicineInventoryList));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating inventory management report: " + e.getMessage()))
                .build();
        }
    }

    // Helper method to get age group
    private String getAgeGroup(int age) {
        if (age < 18) return "0-17";
        else if (age < 30) return "18-29";
        else if (age < 50) return "30-49";
        else if (age < 70) return "50-69";
        else return "70+";
    }

    // Helper method to convert MultiMap<String, Integer> to simple Map for JSON
    private java.util.Map<String, Integer> multiMapToCountMap(MultiMap<String, Integer> multiMap) {
        java.util.Map<String, Integer> result = new java.util.HashMap<>();
        ArraySet<String> keys = multiMap.keySet();
        Object[] keyArray = keys.toArray();
        for (int i = 0; i < keyArray.length; i++) {
            String key = (String) keyArray[i];
            int count = 0;
            List<Integer> values = multiMap.get(key);
            for (int j = 0; j < values.size(); j++) {
                count += values.get(j);
            }
            result.put(key, count);
        }
        return result;
    }

    // Helper method to convert MultiMap<String, Double> to simple Map for JSON
    private java.util.Map<String, Double> multiMapToSumMap(MultiMap<String, Double> multiMap) {
        java.util.Map<String, Double> result = new java.util.HashMap<>();
        ArraySet<String> keys = multiMap.keySet();
        Object[] keyArray = keys.toArray();
        for (int i = 0; i < keyArray.length; i++) {
            String key = (String) keyArray[i];
            double sum = 0.0;
            List<Double> values = multiMap.get(key);
            for (int j = 0; j < values.size(); j++) {
                sum += values.get(j);
            }
            result.put(key, sum);
        }
        return result;
    }

    // Data classes for structured responses
    public static class MedicineSalesData {
        public String medicineId;
        public String medicineName;
        public int quantitySold;
        public double revenue;
    }

    public static class InventoryData {
        public String medicineId;
        public String medicineName;
        public int currentStock;
        public int reorderLevel;
        public double stockValue;
        public int pendingOrders;
        public int completedOrders;
        public String status;
    }

    // 6. Diagnosis Analysis Report
    @GET
    @Path("/diagnosis-analysis")
    public Response getDiagnosisAnalysisReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Diagnosis Analysis Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all consultations with diagnoses
            List<Consultation> allConsultations = consultationRepository.findAll();
            
            // Filter consultations by date and collect diagnosis data
            MultiMap<String, Integer> diagnosisCounts = new MultiMap<>();
            MultiMap<String, Integer> categoryCounts = new MultiMap<>();
            MultiMap<String, Integer> doctorDiagnosisCounts = new MultiMap<>();
            MultiMap<String, Integer> monthlyDiagnosisCounts = new MultiMap<>();
            
            int totalConsultations = 0;
            int consultationsWithDiagnosis = 0;

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    
                    totalConsultations++;
                    String diagnosis = consultation.getDiagnosis();
                    
                    if (diagnosis != null && !diagnosis.trim().isEmpty()) {
                        consultationsWithDiagnosis++;
                        
                        // Count by specific diagnosis
                        diagnosisCounts.put(diagnosis, 1);
                        
                        // Count by category
                        String category = categorizeDiagnosis(diagnosis);
                        categoryCounts.put(category, 1);
                        
                        // Count by doctor
                        String doctorId = consultation.getDoctorID();
                        if (doctorId != null) {
                            doctorDiagnosisCounts.put(doctorId, 1);
                        }
                        
                        // Count by month
                        String monthKey = consultation.getConsultationDate().getMonth().toString();
                        monthlyDiagnosisCounts.put(monthKey, 1);
                    }
                }
            }

            // Get doctor names
            MultiMap<String, String> doctorNames = new MultiMap<>();
            List<Staff> allDoctors = staffRepository.findAll();
            for (Staff doctor : allDoctors) {
                if ("Doctor".equals(doctor.getPosition())) {
                    doctorNames.put(doctor.getStaffID(), doctor.getFirstName() + " " + doctor.getLastName());
                }
            }

            // Build response data
            JsonObject data = new JsonObject();
            data.addProperty("totalConsultations", totalConsultations);
            data.addProperty("consultationsWithDiagnosis", consultationsWithDiagnosis);
            data.addProperty("diagnosisRate", totalConsultations > 0 ? (double) consultationsWithDiagnosis / totalConsultations * 100 : 0);
            
            // Top diagnoses
            data.add("topDiagnoses", gson.toJsonTree(multiMapToCountMap(diagnosisCounts)));
            
            // Diagnosis categories
            data.add("diagnosisCategories", gson.toJsonTree(multiMapToCountMap(categoryCounts)));
            
            // Doctor diagnosis counts
            data.add("doctorDiagnosisCounts", gson.toJsonTree(multiMapToCountMap(doctorDiagnosisCounts)));
            
            // Monthly trends
            data.add("monthlyDiagnosisTrends", gson.toJsonTree(multiMapToCountMap(monthlyDiagnosisCounts)));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating diagnosis analysis report: " + e.getMessage()))
                .build();
        }
    }

    // 7. Diagnosis Category Report
    @GET
    @Path("/diagnosis-categories")
    public Response getDiagnosisCategoryReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Diagnosis Category Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all consultations
            List<Consultation> allConsultations = consultationRepository.findAll();
            
            // Analyze by category
            MultiMap<String, Integer> categoryCounts = new MultiMap<>();
            MultiMap<String, Integer> categoryByMonth = new MultiMap<>();
            MultiMap<String, Integer> categoryByDoctor = new MultiMap<>();

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    
                    String diagnosis = consultation.getDiagnosis();
                    if (diagnosis != null && !diagnosis.trim().isEmpty()) {
                        String category = categorizeDiagnosis(diagnosis);
                        
                        // Count by category
                        categoryCounts.put(category, 1);
                        
                        // Count by category and month
                        String monthKey = category + "_" + consultation.getConsultationDate().getMonth().toString();
                        categoryByMonth.put(monthKey, 1);
                        
                        // Count by category and doctor
                        String doctorId = consultation.getDoctorID();
                        if (doctorId != null) {
                            String doctorCategoryKey = category + "_" + doctorId;
                            categoryByDoctor.put(doctorCategoryKey, 1);
                        }
                    }
                }
            }

            // Build response data
            JsonObject data = new JsonObject();
            data.add("categoryDistribution", gson.toJsonTree(multiMapToCountMap(categoryCounts)));
            data.add("categoryByMonth", gson.toJsonTree(multiMapToCountMap(categoryByMonth)));
            data.add("categoryByDoctor", gson.toJsonTree(multiMapToCountMap(categoryByDoctor)));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating diagnosis category report: " + e.getMessage()))
                .build();
        }
    }

    // 8. Doctor Management Report
    @GET
    @Path("/doctor-management")
    public Response getDoctorManagementReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Doctor Management Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all doctors
            List<Staff> allStaff = staffRepository.findAll();
            List<Staff> doctors = new List<>();
            for (Staff staff : allStaff) {
                if ("Doctor".equals(staff.getPosition())) {
                    doctors.add(staff);
                }
            }

            // Get all consultations for the date range
            List<Consultation> allConsultations = consultationRepository.findAll();
            MultiMap<String, Integer> doctorConsultationCounts = new MultiMap<>();
            MultiMap<String, Integer> doctorDiagnosisCounts = new MultiMap<>();
            MultiMap<String, Integer> doctorSpecialtyCounts = new MultiMap<>();
            MultiMap<String, Integer> doctorMonthlyCounts = new MultiMap<>();

            int totalConsultations = 0;
            int consultationsWithDiagnosis = 0;

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    !consultation.getConsultationDate().isBefore(start) &&
                    !consultation.getConsultationDate().isAfter(end)) {
                    
                    String doctorId = consultation.getDoctorID();
                    if (doctorId != null) {
                        totalConsultations++;
                        
                        // Count consultations by doctor
                        doctorConsultationCounts.put(doctorId, 1);
                        
                        // Count diagnoses by doctor
                        String diagnosis = consultation.getDiagnosis();
                        if (diagnosis != null && !diagnosis.trim().isEmpty()) {
                            consultationsWithDiagnosis++;
                            doctorDiagnosisCounts.put(doctorId, 1);
                            
                            // Count specialties by doctor
                            String specialty = categorizeDiagnosis(diagnosis);
                            doctorSpecialtyCounts.put(doctorId + "_" + specialty, 1);
                        }
                        
                        // Count monthly consultations by doctor
                        String monthKey = doctorId + "_" + consultation.getConsultationDate().getMonth().toString();
                        doctorMonthlyCounts.put(monthKey, 1);
                    }
                }
            }

            // Calculate statistics
            int totalDoctors = doctors.size();
            int activeDoctors = doctorConsultationCounts.keySet().size();
            double avgConsultationsPerDoctor = totalDoctors > 0 ? (double) totalConsultations / totalDoctors : 0;
            double diagnosisRate = totalConsultations > 0 ? (double) consultationsWithDiagnosis / totalConsultations * 100 : 0;

            // Build doctor performance data
            List<DoctorPerformanceData> doctorPerformanceList = new List<>();
            for (Staff doctor : doctors) {
                String doctorId = doctor.getStaffID();
                int consultationCount = 0;
                int diagnosisCount = 0;
                
                List<Integer> consultationCounts = doctorConsultationCounts.get(doctorId);
                if (!consultationCounts.isEmpty()) {
                    for (Integer count : consultationCounts) {
                        consultationCount += count;
                    }
                }
                
                List<Integer> diagnosisCounts = doctorDiagnosisCounts.get(doctorId);
                if (!diagnosisCounts.isEmpty()) {
                    for (Integer count : diagnosisCounts) {
                        diagnosisCount += count;
                    }
                }
                
                double doctorDiagnosisRate = consultationCount > 0 ? (double) diagnosisCount / consultationCount * 100 : 0;
                
                // Calculate top diagnosis for this doctor
                String topDiagnosis = "N/A";
                MultiMap<String, Integer> doctorDiagnosisCategories = new MultiMap<>();
                
                for (Consultation consultation : allConsultations) {
                    if (consultation.getConsultationDate() != null &&
                        !consultation.getConsultationDate().isBefore(start) &&
                        !consultation.getConsultationDate().isAfter(end) &&
                        doctorId.equals(consultation.getDoctorID())) {
                        
                        String diagnosis = consultation.getDiagnosis();
                        if (diagnosis != null && !diagnosis.trim().isEmpty()) {
                            String category = categorizeDiagnosis(diagnosis);
                            doctorDiagnosisCategories.put(category, 1);
                        }
                    }
                }
                
                // Find the category with highest count
                if (doctorDiagnosisCategories.keySet().size() > 0) {
                    String topCategory = null;
                    int maxCount = 0;
                    
                    ArraySet<String> categories = doctorDiagnosisCategories.keySet();
                    Object[] categoryArray = categories.toArray();
                    for (int i = 0; i < categoryArray.length; i++) {
                        String category = (String) categoryArray[i];
                        int count = 0;
                        List<Integer> counts = doctorDiagnosisCategories.get(category);
                        for (int j = 0; j < counts.size(); j++) {
                            count += counts.get(j);
                        }
                        if (count > maxCount) {
                            maxCount = count;
                            topCategory = category;
                        }
                    }
                    topDiagnosis = topCategory != null ? topCategory : "N/A";
                }
                
                DoctorPerformanceData performanceData = new DoctorPerformanceData();
                performanceData.doctorId = doctorId;
                performanceData.doctorName = doctor.getFirstName() + " " + doctor.getLastName();
                performanceData.consultations = consultationCount;
                performanceData.diagnoses = diagnosisCount;
                performanceData.diagnosisRate = doctorDiagnosisRate;
                performanceData.position = doctor.getPosition();
                performanceData.contactNumber = doctor.getContactNumber();
                performanceData.topDiagnosis = topDiagnosis;
                
                doctorPerformanceList.add(performanceData);
            }

            // Build response data
            JsonObject data = new JsonObject();
            data.addProperty("totalDoctors", totalDoctors);
            data.addProperty("activeDoctors", activeDoctors);
            data.addProperty("totalConsultations", totalConsultations);
            data.addProperty("avgConsultationsPerDoctor", avgConsultationsPerDoctor);
            data.addProperty("diagnosisRate", diagnosisRate);
            
            // Doctor consultation counts for charts
            java.util.Map<String, String> doctorNames = new java.util.HashMap<>();
            for (Staff doctor : doctors) {
                doctorNames.put(doctor.getStaffID(), doctor.getFirstName() + " " + doctor.getLastName());
            }
            
            java.util.Map<String, Integer> doctorConsultationMap = new java.util.HashMap<>();
            ArraySet<String> doctorKeys = doctorConsultationCounts.keySet();
            Object[] keyArray = doctorKeys.toArray();
            for (int i = 0; i < keyArray.length; i++) {
                String doctorId = (String) keyArray[i];
                String doctorName = doctorNames.get(doctorId);
                if (doctorName != null) {
                    int totalCount = 0;
                    List<Integer> counts = doctorConsultationCounts.get(doctorId);
                    for (int j = 0; j < counts.size(); j++) {
                        totalCount += counts.get(j);
                    }
                    doctorConsultationMap.put(doctorName, totalCount);
                }
            }
            
            data.add("doctorConsultationCounts", gson.toJsonTree(doctorConsultationMap));
            data.add("doctorPerformance", gson.toJsonTree(doctorPerformanceList));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating doctor management report: " + e.getMessage()))
                .build();
        }
    }

    // 9. Medicine Performance Analysis Report
    @GET
    @Path("/medicine-performance-analysis")
    public Response getMedicinePerformanceAnalysis(
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            // Get all prescriptions and consultations
            List<Prescription> allPrescriptions = prescriptionRepository.findAll();
            List<Consultation> allConsultations = consultationRepository.findAll();
            List<Medicine> allMedicines = medicineRepository.findAll();
            
            // Create consultation date mapping
            MultiMap<String, LocalDate> consultationDates = new MultiMap<>();
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null) {
                    consultationDates.put(consultation.getConsultationID(), consultation.getConsultationDate());
                }
            }

            // Analyze medicine performance
            MultiMap<String, Integer> medicineQuantities = new MultiMap<>();
            MultiMap<String, Double> medicineRevenues = new MultiMap<>();

            for (Prescription prescription : allPrescriptions) {
                List<LocalDate> dates = consultationDates.get(prescription.getConsultationID());
                if (!dates.isEmpty()) {
                    LocalDate consultationDate = dates.get(0);
                    if (consultationDate != null &&
                        !consultationDate.isBefore(start) &&
                        !consultationDate.isAfter(end)) {
                        
                        String medicineId = prescription.getMedicineID();
                        int quantity = prescription.getQuantityDispensed();
                        double revenue = quantity * prescription.getPrice();
                        
                        medicineQuantities.put(medicineId, quantity);
                        medicineRevenues.put(medicineId, revenue);
                    }
                }
            }

            // Categorize medicines by performance
            MultiMap<String, Integer> performanceCategories = new MultiMap<>();
            
            ArraySet<String> medicineKeys = medicineQuantities.keySet();
            Object[] keyArray = medicineKeys.toArray();
            for (int i = 0; i < keyArray.length; i++) {
                String medicineId = (String) keyArray[i];
                
                int totalQuantity = 0;
                List<Integer> quantities = medicineQuantities.get(medicineId);
                for (Integer quantity : quantities) {
                    totalQuantity += quantity;
                }
                
                String category;
                if (totalQuantity > 200) {
                    category = "High Performers (>200 units)";
                } else if (totalQuantity > 100) {
                    category = "Medium Performers (100-200)";
                } else {
                    category = "Low Performers (<100)";
                }
                
                performanceCategories.put(category, 1);
            }

            String json = gson.toJson(multiMapToCountMap(performanceCategories));
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating medicine performance analysis: " + e.getMessage()))
                .build();
        }
    }

    // Data class for doctor performance
    public static class DoctorPerformanceData {
        public String doctorId;
        public String doctorName;
        public int consultations;
        public int diagnoses;
        public double diagnosisRate;
        public String position;
        public String contactNumber;
        public String topDiagnosis;
    }

    // 10. Treatment Analytics Report
    @GET
    @Path("/treatment-analytics")
    public Response getTreatmentAnalyticsReport(
            @QueryParam("period") String period,
            @QueryParam("startDate") String startDate,
            @QueryParam("endDate") String endDate) {
        try {
            LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

            JsonObject report = new JsonObject();
            report.addProperty("reportType", "Treatment Analytics Report");
            report.addProperty("period", period != null ? period : "monthly");
            report.addProperty("startDate", start.toString());
            report.addProperty("endDate", end.toString());

            // Get all treatments
            List<Treatment> allTreatments = treatmentRepository.findAll();
            
            // Filter treatments by date range
            List<Treatment> filteredTreatments = new List<>();
            for (Treatment treatment : allTreatments) {
                if (treatment.getTreatmentDate() != null) {
                    LocalDate treatmentDate = treatment.getTreatmentDate().toLocalDate();
                    if (!treatmentDate.isBefore(start) && !treatmentDate.isAfter(end)) {
                        filteredTreatments.add(treatment);
                    }
                }
            }

            // Calculate statistics
            int totalTreatments = filteredTreatments.size();
            int completedTreatments = 0;
            int scheduledTreatments = 0;
            int successfulTreatments = 0;

            // Data collection for charts
            MultiMap<String, Integer> treatmentTypes = new MultiMap<>();
            MultiMap<String, Integer> doctorTreatments = new MultiMap<>();
            MultiMap<String, Integer> treatmentOutcomes = new MultiMap<>();
            MultiMap<String, Integer> monthlyTrends = new MultiMap<>();

            for (Treatment treatment : filteredTreatments) {
                // Count by status
                if ("Completed".equals(treatment.getStatus())) {
                    completedTreatments++;
                } else if ("Scheduled".equals(treatment.getStatus())) {
                    scheduledTreatments++;
                }

                // Count by outcome
                if ("Successful".equals(treatment.getOutcome())) {
                    successfulTreatments++;
                }

                // Chart 1: Treatment Types Distribution
                String treatmentType = treatment.getTreatmentType() != null ? treatment.getTreatmentType() : "Unknown";
                treatmentTypes.put(treatmentType, 1);

                // Chart 2: Doctor Treatment Performance
                String doctorId = treatment.getDoctorID() != null ? treatment.getDoctorID() : "Unknown";
                doctorTreatments.put(doctorId, 1);

                // Chart 3: Treatment Outcomes Analysis
                String outcome = treatment.getOutcome() != null ? treatment.getOutcome() : "No Outcome";
                treatmentOutcomes.put(outcome, 1);

                // Chart 4: Monthly Treatment Trends
                if (treatment.getTreatmentDate() != null) {
                    String monthKey = treatment.getTreatmentDate().getMonth().toString().substring(0, 3) + 
                                    " " + treatment.getTreatmentDate().getYear();
                    monthlyTrends.put(monthKey, 1);
                }
            }

            // Calculate success rate
            double successRate = totalTreatments > 0 ? ((double) successfulTreatments / totalTreatments) * 100 : 0;

            // Get doctor names for better display
            MultiMap<String, String> doctorNames = new MultiMap<>();
            List<Staff> allStaff = staffRepository.findAll();
            for (Staff staff : allStaff) {
                if ("Doctor".equals(staff.getPosition())) {
                    doctorNames.put(staff.getStaffID(), staff.getFirstName() + " " + staff.getLastName());
                }
            }

            // Create doctor performance data
            List<TreatmentDoctorData> doctorPerformanceList = new List<>();
            ArraySet<String> doctorKeys = doctorTreatments.keySet();
            Object[] keyArray = doctorKeys.toArray();
            for (int i = 0; i < keyArray.length; i++) {
                String doctorId = (String) keyArray[i];
                List<String> nameList = doctorNames.get(doctorId);
                String doctorName = nameList.isEmpty() ? doctorId : "Dr. " + nameList.get(0);
                
                int treatmentCount = 0;
                List<Integer> counts = doctorTreatments.get(doctorId);
                for (Integer count : counts) {
                    treatmentCount += count;
                }

                // Calculate doctor's success rate
                int doctorSuccessful = 0;
                int doctorTotal = 0;
                for (Treatment treatment : filteredTreatments) {
                    if (doctorId.equals(treatment.getDoctorID())) {
                        doctorTotal++;
                        if ("Successful".equals(treatment.getOutcome())) {
                            doctorSuccessful++;
                        }
                    }
                }
                double doctorSuccessRate = doctorTotal > 0 ? ((double) doctorSuccessful / doctorTotal) * 100 : 0;

                // Find top treatment type for this doctor
                MultiMap<String, Integer> doctorTreatmentTypes = new MultiMap<>();
                for (Treatment treatment : filteredTreatments) {
                    if (doctorId.equals(treatment.getDoctorID())) {
                        String type = treatment.getTreatmentType() != null ? treatment.getTreatmentType() : "Unknown";
                        doctorTreatmentTypes.put(type, 1);
                    }
                }

                String topTreatmentType = "N/A";
                if (doctorTreatmentTypes.keySet().size() > 0) {
                    String topType = null;
                    int maxCount = 0;
                    ArraySet<String> typeKeys = doctorTreatmentTypes.keySet();
                    Object[] typeArray = typeKeys.toArray();
                    for (int j = 0; j < typeArray.length; j++) {
                        String type = (String) typeArray[j];
                        int count = 0;
                        List<Integer> typeCounts = doctorTreatmentTypes.get(type);
                        for (Integer typeCount : typeCounts) {
                            count += typeCount;
                        }
                        if (count > maxCount) {
                            maxCount = count;
                            topType = type;
                        }
                    }
                    topTreatmentType = topType != null ? topType : "N/A";
                }

                TreatmentDoctorData doctorData = new TreatmentDoctorData();
                doctorData.doctorId = doctorId;
                doctorData.doctorName = doctorName;
                doctorData.totalTreatments = treatmentCount;
                doctorData.completedTreatments = doctorSuccessful;
                doctorData.successRate = doctorSuccessRate;
                doctorData.topTreatmentType = topTreatmentType;

                doctorPerformanceList.add(doctorData);
            }

            // Build response data
            JsonObject data = new JsonObject();
            data.addProperty("totalTreatments", totalTreatments);
            data.addProperty("completedTreatments", completedTreatments);
            data.addProperty("scheduledTreatments", scheduledTreatments);
            data.addProperty("successRate", successRate);
            
            // Chart data
            data.add("treatmentTypes", gson.toJsonTree(multiMapToCountMap(treatmentTypes)));
            data.add("doctorTreatments", gson.toJsonTree(multiMapToCountMap(doctorTreatments)));
            data.add("treatmentOutcomes", gson.toJsonTree(multiMapToCountMap(treatmentOutcomes)));
            data.add("monthlyTrends", gson.toJsonTree(multiMapToCountMap(monthlyTrends)));
            data.add("doctorPerformance", gson.toJsonTree(doctorPerformanceList));

            report.add("data", data);

            String json = gson.toJson(report);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error generating treatment analytics report: " + e.getMessage()))
                .build();
        }
    }

    // Data class for treatment doctor performance
    public static class TreatmentDoctorData {
        public String doctorId;
        public String doctorName;
        public int totalTreatments;
        public int completedTreatments;
        public double successRate;
        public String topTreatmentType;
    }
}
