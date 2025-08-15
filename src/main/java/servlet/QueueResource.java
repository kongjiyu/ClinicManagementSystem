package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Appointment;
import models.Consultation;
import models.Patient;
import repositories.Appointment.AppointmentRepository;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Staff.StaffRepository;
import utils.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Path("/queue")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class QueueResource {

  Gson gson = new GsonBuilder()
    .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
    .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
    .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
    .registerTypeAdapter(List.class, new ListAdapter())
    .registerTypeAdapter(MultiMap.class, new MultiMapAdapter())
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
  public Response getAllQueues() {
    try {
      LocalDate today = LocalDate.now();

      // Get today's appointments with patient information
      List<Appointment> allAppointments = appointmentRepository.findAll();
      List<Appointment> todayAppointments = new List<>();

      for (Appointment appointment : allAppointments) {
        if (appointment.getAppointmentTime() != null &&
          appointment.getAppointmentTime().toLocalDate().equals(today) &&
          "Scheduled".equals(appointment.getStatus())) {
          // Fetch patient information for this appointment
          if (appointment.getPatientID() != null) {
            Patient patient = patientRepository.findById(appointment.getPatientID());
            if (patient != null) {
              // Set the patient object in the appointment (if your model supports it)
              // For now, we'll create a simple DTO approach
            }
          }
          todayAppointments.add(appointment);
        }
      }

      // Get today's consultations with patient information
      List<Consultation> allConsultations = consultationRepository.findAll();
      List<Consultation> todayConsultations = new List<>();

      for (Consultation consultation : allConsultations) {
        if (consultation.getConsultationDate() != null &&
          consultation.getConsultationDate().equals(today)) {
          // Fetch patient information for this consultation
          if (consultation.getPatientID() != null) {
            Patient patient = patientRepository.findById(consultation.getPatientID());
            if (patient != null) {
              // Set the patient object in the consultation (if your model supports it)
              // For now, we'll create a simple DTO approach
            }
          }
          todayConsultations.add(consultation);
        }
      }

      // Group consultations by status
      List<Consultation> waitingConsultations = new List<>();
      List<Consultation> inProgressConsultations = new List<>();
      List<Consultation> billingConsultations = new List<>();
      List<Consultation> completedConsultations = new List<>();

      for (Consultation consultation : todayConsultations) {
        String status = consultation.getStatus();
        if (status == null) {
          status = "Waiting";
        }

        switch (status.toLowerCase()) {
          case "waiting":
            waitingConsultations.add(consultation);
            break;
          case "in progress":
            inProgressConsultations.add(consultation);
            break;
          case "billing":
            billingConsultations.add(consultation);
            break;
          case "completed":
            completedConsultations.add(consultation);
            break;
          default:
            waitingConsultations.add(consultation);
            break;
        }
      }

      // Create DTOs with patient information
      List<QueueItem> appointmentItems = createQueueItemsFromAppointments(todayAppointments);
      List<QueueItem> waitingItems = createQueueItemsFromConsultations(waitingConsultations);
      List<QueueItem> inProgressItems = createQueueItemsFromConsultations(inProgressConsultations);
      List<QueueItem> billingItems = createQueueItemsFromConsultations(billingConsultations);
      List<QueueItem> completedItems = createQueueItemsFromConsultations(completedConsultations);

      // Create response object
      JsonObject response = new JsonObject();
      response.add("appointments", gson.toJsonTree(appointmentItems));
      response.add("waiting", gson.toJsonTree(waitingItems));
      response.add("inProgress", gson.toJsonTree(inProgressItems));
      response.add("billing", gson.toJsonTree(billingItems));
      response.add("completed", gson.toJsonTree(completedItems));

      String json = gson.toJson(response);
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
    } catch (Exception e) {
      return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
        .entity(new ErrorResponse("Error loading queue data: " + e.getMessage()))
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







  // DTO class for queue items with patient information
  public static class QueueItem {
    private String consultationId;
    private String patientName;
    private String patientId;
    private String status;
    private LocalDate consultationDate;
    private LocalDateTime checkInTime;
    private String waitingTime;

    // Getters and setters
    public String getConsultationId() {
      return consultationId;
    }

    public void setConsultationId(String consultationId) {
      this.consultationId = consultationId;
    }

    public String getPatientName() {
      return patientName;
    }

    public void setPatientName(String patientName) {
      this.patientName = patientName;
    }

    public String getPatientId() {
      return patientId;
    }

    public void setPatientId(String patientId) {
      this.patientId = patientId;
    }

    public String getStatus() {
      return status;
    }

    public void setStatus(String status) {
      this.status = status;
    }

    public LocalDate getConsultationDate() {
      return consultationDate;
    }

    public void setConsultationDate(LocalDate consultationDate) {
      this.consultationDate = consultationDate;
    }

    public LocalDateTime getCheckInTime() {
      return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
      this.checkInTime = checkInTime;
    }

    public String getWaitingTime() {
      return waitingTime;
    }

    public void setWaitingTime(String waitingTime) {
      this.waitingTime = waitingTime;
    }
  }

  // Helper method to create QueueItems from Appointments
  private List<QueueItem> createQueueItemsFromAppointments(List<Appointment> appointments) {
    List<QueueItem> items = new List<>();
    
    for (Appointment appointment : appointments) {
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
        } else {
          item.setPatientName("Unknown");
          item.setPatientId(appointment.getPatientID());
        }
      } else {
        item.setPatientName("Unknown");
      }

      items.add(item);
    }
    
    return items;
  }

  // Helper method to create QueueItems from Consultations
  private List<QueueItem> createQueueItemsFromConsultations(List<Consultation> consultations) {
    List<QueueItem> items = new List<>();
    
    for (Consultation consultation : consultations) {
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
        } else {
          item.setPatientName("Unknown");
          item.setPatientId(consultation.getPatientID());
        }
      } else {
        item.setPatientName("Unknown");
      }

      items.add(item);
    }
    
    return items;
  }

  public static class StatusUpdateRequest {
    private String status;

    public String getStatus() {
      return status;
    }

    public void setStatus(String status) {
      this.status = status;
    }
  }
}
