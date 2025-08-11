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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Path("/queue")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class QueueResource {

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
    public Response getTodayQueue() {
        try {
            LocalDate today = LocalDate.now();
            List<Consultation> allConsultations = consultationRepository.findAll();
            List<Consultation> todayConsultations = new List<>();

            // Filter consultations for today
            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null && 
                    consultation.getConsultationDate().equals(today)) {
                    todayConsultations.add(consultation);
                }
            }

            // Group by status
            Map<String, List<QueueItem>> queueData = new HashMap<>();
            queueData.put("appointments", new List<>());
            queueData.put("waiting", new List<>());
            queueData.put("inProgress", new List<>());
            queueData.put("billing", new List<>());
            queueData.put("completed", new List<>());

            for (Consultation consultation : todayConsultations) {
                QueueItem item = createQueueItem(consultation);
                
                switch (consultation.getStatus() != null ? consultation.getStatus().toLowerCase() : "waiting") {
                    case "waiting":
                        queueData.get("waiting").add(item);
                        break;
                    case "in progress":
                        queueData.get("inProgress").add(item);
                        break;
                    case "billing":
                        queueData.get("billing").add(item);
                        break;
                    case "completed":
                        queueData.get("completed").add(item);
                        break;
                    default:
                        queueData.get("appointments").add(item);
                        break;
                }
            }

            String json = gson.toJson(queueData);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Error loading queue: " + e.getMessage()))
                .build();
        }
    }

    @PUT
    @Path("/{id}/status")
    public Response updateStatus(@PathParam("id") String consultationId, StatusUpdateRequest request) {
        try {
            Consultation consultation = consultationRepository.findById(consultationId);
            if (consultation == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
            }

            // Update status
            consultation.setStatus(request.getStatus());
            
            // Update check-in time if status is "In Progress"
            if ("In Progress".equalsIgnoreCase(request.getStatus()) && consultation.getCheckInTime() == null) {
                consultation.setCheckInTime(LocalDateTime.now());
            }

            consultationRepository.update(consultationId, consultation);

            String json = gson.toJson(consultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error updating status: " + e.getMessage()))
                .build();
        }
    }

    private QueueItem createQueueItem(Consultation consultation) {
        QueueItem item = new QueueItem();
        item.setConsultationId(consultation.getConsultationID());
        item.setStatus(consultation.getStatus());
        item.setConsultationDate(consultation.getConsultationDate());
        item.setCheckInTime(consultation.getCheckInTime());

        // Get patient information
        if (consultation.getPatientID() != null) {
            Patient patient = patientRepository.findById(consultation.getPatientID());
            if (patient != null) {
                item.setPatientName(patient.getFirstName() + " " + patient.getLastName());
                item.setPatientId(patient.getPatientID());
            }
        }

        // Calculate waiting time
        if (consultation.getCheckInTime() != null) {
            LocalDateTime now = LocalDateTime.now();
            long minutes = java.time.Duration.between(consultation.getCheckInTime(), now).toMinutes();
            item.setWaitingTime(formatWaitingTime(minutes));
        } else {
            item.setWaitingTime("00:00");
        }

        return item;
    }

    private String formatWaitingTime(long minutes) {
        long hours = minutes / 60;
        long remainingMinutes = minutes % 60;
        return String.format("%02d:%02d", hours, remainingMinutes);
    }

    // DTO classes
    public static class QueueItem {
        private String consultationId;
        private String patientName;
        private String patientId;
        private String status;
        private LocalDate consultationDate;
        private LocalDateTime checkInTime;
        private String waitingTime;

        // Getters and setters
        public String getConsultationId() { return consultationId; }
        public void setConsultationId(String consultationId) { this.consultationId = consultationId; }

        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }

        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public LocalDate getConsultationDate() { return consultationDate; }
        public void setConsultationDate(LocalDate consultationDate) { this.consultationDate = consultationDate; }

        public LocalDateTime getCheckInTime() { return checkInTime; }
        public void setCheckInTime(LocalDateTime checkInTime) { this.checkInTime = checkInTime; }

        public String getWaitingTime() { return waitingTime; }
        public void setWaitingTime(String waitingTime) { this.waitingTime = waitingTime; }
    }

    public static class StatusUpdateRequest {
        private String status;

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}
