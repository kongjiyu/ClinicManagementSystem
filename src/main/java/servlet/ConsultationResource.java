package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Consultation;
import models.Prescription;
import models.Medicine;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Staff.StaffRepository;
import repositories.Prescription.PrescriptionRepository;
import repositories.Medicine.MedicineRepository;
import utils.List;
import utils.ErrorResponse;
import utils.ListAdapter;
import servlet.MedicineStockService;

import java.time.LocalDate;
import utils.TimeUtils;

@Path("/consultations")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ConsultationResource {

    Gson gson = new GsonBuilder()
        .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
        .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
        .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
        .registerTypeAdapter(utils.List.class, new ListAdapter())
        .create();

    @Inject
    private ConsultationRepository consultationRepository;

    @Inject
    private PatientRepository patientRepository;

    @Inject
    private StaffRepository staffRepository;

    @Inject
    private PrescriptionRepository prescriptionRepository;

    @Inject
    private MedicineRepository medicineRepository;

    @Inject
    private MedicineStockService medicineStockService;

    @GET
    public Response getAllConsultations() {
        List<Consultation> consultations = consultationRepository.findAll();
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/{id}")
    public Response getConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepository.findById(id);
        if (consultation != null) {
            String json = gson.toJson(consultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("Consultation not found"))
                .build();
        }
    }

    @GET
    @Path("/patient/{patientId}")
    public Response getConsultationsByPatient(@PathParam("patientId") String patientId) {
        List<Consultation> consultations = consultationRepository.groupByPatientID().get(patientId);
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    public Response createConsultation(Consultation consultation) {
        try {
            // Set check-in time when consultation is created (Malaysia timezone)
            if (consultation.getCheckInTime() == null) {
                consultation.setCheckInTime(TimeUtils.nowMalaysia());
            }
            
            consultationRepository.create(consultation);
            String json = gson.toJson(consultation);
            return Response.status(Response.Status.CREATED)
                .entity(json)
                .type(MediaType.APPLICATION_JSON)
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error creating consultation: " + e.getMessage()))
                .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateConsultation(@PathParam("id") String id, Consultation consultation) {
        try {
            Consultation existingConsultation = consultationRepository.findById(id);
            if (existingConsultation == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
            }

            // Preserve existing data that shouldn't be changed
            consultation.setConsultationID(id);
            consultation.setPatientID(existingConsultation.getPatientID());
            consultation.setCheckInTime(existingConsultation.getCheckInTime());
            consultation.setStatus(existingConsultation.getStatus());
            
            // Handle doctor assignment - map doctorID to staffID if provided
            try {
                if (consultation.getDoctorID() != null && !consultation.getDoctorID().trim().isEmpty()) {
                    consultation.setStaffID(consultation.getDoctorID());
                    consultation.setDoctorID(consultation.getDoctorID()); // Also set doctorID for consistency
                } else {
                    // Preserve existing staffID if no new doctor is selected
                    consultation.setStaffID(existingConsultation.getStaffID());
                    consultation.setDoctorID(existingConsultation.getDoctorID());
                }
            } catch (Exception e) {
                // Fallback to preserving existing data
                consultation.setStaffID(existingConsultation.getStaffID());
                consultation.setDoctorID(existingConsultation.getDoctorID());
            }
            
            // Preserve MC data if it exists
            if (existingConsultation.getMcID() != null) {
                consultation.setMcID(existingConsultation.getMcID());
                consultation.setStartDate(existingConsultation.getStartDate());
                consultation.setEndDate(existingConsultation.getEndDate());
            }

            Consultation updatedConsultation = consultationRepository.update(id, consultation);
            
            if (updatedConsultation == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to update consultation"))
                    .build();
            }

            String json = gson.toJson(updatedConsultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error updating consultation: " + e.getMessage()))
                .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteConsultation(@PathParam("id") String id) {
        Consultation existingConsultation = consultationRepository.findById(id);
        if (existingConsultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("Consultation not found"))
                .build();
        }

        consultationRepository.cancel(id);
        return Response.ok("{\"message\": \"Consultation cancelled successfully\"}")
            .type(MediaType.APPLICATION_JSON)
            .build();
    }

    // MC-specific endpoints
    @POST
    @Path("/{id}/mc")
    public Response createMC(@PathParam("id") String consultationId, MCDto mcData) {
        try {
            Consultation consultation = consultationRepository.findById(consultationId);
            if (consultation == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
            }

            // Validate MC data
            if (mcData.getStartDate() == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Start date is required"))
                    .build();
            }
            if (mcData.getEndDate() == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("End date is required"))
                    .build();
            }
            if (mcData.getStartDate().isAfter(mcData.getEndDate())) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Start date cannot be after end date"))
                    .build();
            }

            // Generate MC ID (MC + consultation ID)
            String mcId = "MC" + consultationId;

            // Update consultation with MC data
            consultation.setMcID(mcId);
            consultation.setStartDate(mcData.getStartDate());
            consultation.setEndDate(mcData.getEndDate());
            // Use diagnosis and symptoms as description for MC
            String mcDescription = "Diagnosis: " + (consultation.getDiagnosis() != null ? consultation.getDiagnosis() : "N/A") +
                                 "\nSymptoms: " + (consultation.getSymptoms() != null ? consultation.getSymptoms() : "N/A");
            if (mcData.getDescription() != null && !mcData.getDescription().trim().isEmpty()) {
                mcDescription += "\nAdditional Notes: " + mcData.getDescription();
            }

            consultationRepository.update(consultationId, consultation);

            String json = gson.toJson(consultation);
            return Response.status(Response.Status.CREATED)
                .entity(json)
                .type(MediaType.APPLICATION_JSON)
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error creating MC: " + e.getMessage()))
                .build();
        }
    }

    @GET
    @Path("/{id}/mc")
    public Response getMC(@PathParam("id") String consultationId) {
        Consultation consultation = consultationRepository.findById(consultationId);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("Consultation not found"))
                .build();
        }

        if (consultation.getMcID() == null || consultation.getMcID().isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("No MC found for this consultation"))
                .build();
        }

        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @DELETE
    @Path("/{id}/mc")
    public Response deleteMC(@PathParam("id") String consultationId) {
        Consultation consultation = consultationRepository.findById(consultationId);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("Consultation not found"))
                .build();
        }

        // Clear MC data
        consultation.setMcID(null);
        consultation.setStartDate(null);
        consultation.setEndDate(null);

        consultationRepository.update(consultationId, consultation);

        return Response.ok("{\"message\": \"MC deleted successfully\"}")
            .type(MediaType.APPLICATION_JSON)
            .build();
    }

    // DTO for MC creation
    public static class MCDto {
        private LocalDate startDate;
        private LocalDate endDate;
        private String description;

        // Getters and setters
        public LocalDate getStartDate() { return startDate; }
        public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

        public LocalDate getEndDate() { return endDate; }
        public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }

    // Prescription endpoints
    @GET
    @Path("/{id}/prescriptions")
    public Response getPrescriptionsByConsultation(@PathParam("id") String consultationId) {
        try {
            List<Prescription> prescriptions = prescriptionRepository.findByConsultationId(consultationId);
            String json = gson.toJson(prescriptions);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error loading prescriptions: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/{id}/prescriptions")
    public Response createPrescription(@PathParam("id") String consultationId, Prescription prescription) {
        try {
            prescription.setConsultationID(consultationId);
            
            // Auto-populate price from medicine selling price
            Medicine medicine = medicineRepository.findById(prescription.getMedicineID());
            if (medicine != null) {
                prescription.setPrice(medicine.getSellingPrice());
            }
            
            // Check if prescription already exists for this consultation and medicine
            Prescription existingPrescription = prescriptionRepository.findByConsultationIdAndMedicineId(consultationId, prescription.getMedicineID());
            
            if (existingPrescription != null) {
                // Update existing prescription
                existingPrescription.setDosage(prescription.getDosage());
                existingPrescription.setDosageUnit(prescription.getDosageUnit());
                existingPrescription.setServingPerDay(prescription.getServingPerDay());
                existingPrescription.setQuantityDispensed(prescription.getQuantityDispensed());
                existingPrescription.setInstruction(prescription.getInstruction());
                existingPrescription.setDescription(prescription.getDescription());
                existingPrescription.setPrice(prescription.getPrice()); // Use auto-populated price
                
                prescriptionRepository.update(existingPrescription);
                String json = gson.toJson(existingPrescription);
                return Response.ok(json, MediaType.APPLICATION_JSON).build();
            } else {
                // Create new prescription
                prescriptionRepository.create(prescription);
                String json = gson.toJson(prescription);
                return Response.status(Response.Status.CREATED)
                    .entity(json)
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error creating prescription: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/prescriptions")
    public Response createPrescriptionGeneral(Prescription prescription) {
        try {
            prescriptionRepository.create(prescription);
            String json = gson.toJson(prescription);
            return Response.status(Response.Status.CREATED)
                .entity(json)
                .type(MediaType.APPLICATION_JSON)
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error creating prescription: " + e.getMessage()))
                .build();
        }
    }

    @DELETE
    @Path("/{consultationId}/prescriptions/{medicineId}")
    public Response deletePrescription(@PathParam("consultationId") String consultationId, @PathParam("medicineId") String medicineId) {
        try {
            Prescription prescription = prescriptionRepository.findByConsultationIdAndMedicineId(consultationId, medicineId);
            if (prescription != null) {
                prescriptionRepository.delete(prescription.getPrescriptionID());
                return Response.ok("{\"message\": \"Prescription deleted successfully\"}")
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Prescription not found"))
                    .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error deleting prescription: " + e.getMessage()))
                .build();
        }
    }
}
