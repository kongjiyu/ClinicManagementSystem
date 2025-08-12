package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Appointment;
import models.Consultation;
import models.Patient;
import models.Staff;
import repositories.Appointment.AppointmentRepository;
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
        .registerTypeAdapter(utils.List.class, new utils.UtilsListAdapter())
        .create();

    @Inject
    private ConsultationRepository consultationRepository;

    @Inject
    private AppointmentRepository appointmentRepository;

    @Inject
    private PatientRepository patientRepository;

    @Inject
    private StaffRepository staffRepository;



    @GET
    public Response getTodayQueue() {
        try {
            LocalDate today = LocalDate.now();

            // Get today's appointments
            List<Appointment> allAppointments = appointmentRepository.findAll();
            List<Appointment> todayAppointments = new List<>();

            for (Appointment appointment : allAppointments) {
                if (appointment.getAppointmentTime() != null &&
                    appointment.getAppointmentTime().toLocalDate().equals(today) &&
                    "Checked-in".equals(appointment.getStatus())) {
                    todayAppointments.add(appointment);
                }
            }

            // Get today's consultations
            List<Consultation> allConsultations = consultationRepository.findAll();
            List<Consultation> todayConsultations = new List<>();

            for (Consultation consultation : allConsultations) {
                if (consultation.getConsultationDate() != null &&
                    consultation.getConsultationDate().equals(today)) {
                    todayConsultations.add(consultation);
                }
            }

            // Group by status - Use custom List implementation
            Map<String, List<QueueItem>> queueData = new HashMap<>();
            queueData.put("appointments", new List<>());
            queueData.put("waiting", new List<>());
            queueData.put("inProgress", new List<>());
            queueData.put("billing", new List<>());
            queueData.put("completed", new List<>());

            // Process appointments (these go to "appointments" queue)
            for (Appointment appointment : todayAppointments) {
                QueueItem item = createQueueItemFromAppointment(appointment);
                queueData.get("appointments").add(item);
            }

            // Process consultations
            for (Consultation consultation : todayConsultations) {
                QueueItem item = createQueueItemFromConsultation(consultation);

                String status = consultation.getStatus();
                if (status == null) {
                    status = "Waiting";
                }
                
                switch (status.toLowerCase()) {
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
                        queueData.get("waiting").add(item);
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

    @POST
    @Path("/checkin-appointment/{appointmentId}")
    public Response checkInAppointment(@PathParam("appointmentId") String appointmentId) {
        try {
            Appointment appointment = appointmentRepository.findById(appointmentId);
            if (appointment == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
            }

            // Update appointment status to "Checked-in"
            appointment.setStatus("Checked-in");
            appointmentRepository.update(appointment);

            // Create a new consultation from the appointment
            Consultation consultation = new Consultation();
            consultation.setPatientID(appointment.getPatientID());
            consultation.setConsultationDate(appointment.getAppointmentTime().toLocalDate());
            consultation.setStatus("Waiting");
            consultation.setCheckInTime(LocalDateTime.now());

            // ID will be automatically generated by Hibernate using @GeneratedValue

            consultationRepository.create(consultation);

            String json = gson.toJson(consultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Error checking in appointment: " + e.getMessage()))
                .build();
        }
    }



    private QueueItem createQueueItemFromAppointment(Appointment appointment) {
        QueueItem item = new QueueItem();
        item.setConsultationId(appointment.getAppointmentID());
        item.setStatus("Appointment");
        item.setConsultationDate(appointment.getAppointmentTime().toLocalDate());
        item.setCheckInTime(appointment.getAppointmentTime());

        // Get patient information
        if (appointment.getPatientID() != null) {
            Patient patient = patientRepository.findById(appointment.getPatientID());
            if (patient != null) {
                item.setPatientName(patient.getFirstName() + " " + patient.getLastName());
                item.setPatientId(patient.getPatientID());
            }
        }

        // Calculate waiting time from appointment time
        LocalDateTime now = LocalDateTime.now();
        long minutes = java.time.Duration.between(appointment.getAppointmentTime(), now).toMinutes();
        // Use absolute value to avoid negative times
        item.setWaitingTime(formatWaitingTime(Math.abs(minutes)));

        return item;
    }

    private QueueItem createQueueItemFromConsultation(Consultation consultation) {
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
            // Use absolute value to avoid negative times
            item.setWaitingTime(formatWaitingTime(Math.abs(minutes)));
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
