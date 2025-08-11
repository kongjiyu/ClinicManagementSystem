package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Consultation;
import models.Patient;
import models.Staff;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Staff.StaffRepository;
import utils.List;
import utils.ErrorResponse;

import java.time.LocalDate;

@Path("/consultations")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ConsultationResource {

    Gson gson = new GsonBuilder()
        .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
        .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
        .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
        .create();

    @Inject
    private ConsultationRepository consultationRepository;

    @Inject
    private PatientRepository patientRepository;

    @Inject
    private StaffRepository staffRepository;

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
        Consultation existingConsultation = consultationRepository.findById(id);
        if (existingConsultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("Consultation not found"))
                .build();
        }

        consultation.setConsultationID(id);
        consultationRepository.update(id, consultation);
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
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
}
