package servlet;

/**
 * Author: Chia Yu Xin
 * Consultation Module
 */

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
import models.Treatment;
import repositories.Appointment.AppointmentRepository;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Staff.StaffRepository;
import repositories.Treatment.TreatmentRepository;
import servlet.MedicineStockService;
import utils.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import utils.TimeUtils;
import DTO.QueueItem;
import DTO.StatusUpdateRequest;

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

  @Inject
  private MedicineStockService medicineStockService;

  @Inject
  private TreatmentRepository treatmentRepository;


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

      // Group consultations by status and sort them
      List<Consultation> waitingConsultations = consultationRepository.getByStatusSorted("Waiting");
      List<Consultation> inProgressConsultations = consultationRepository.getByStatusSorted("In Progress");
      List<Consultation> billingConsultations = consultationRepository.getByStatusSorted("Billing");
      List<Consultation> completedConsultations = consultationRepository.getByStatusSorted("Completed");
      List<Consultation> cancelledConsultations = consultationRepository.getByStatusSorted("Cancelled");

      // Filter today's consultations only
      waitingConsultations = filterTodayConsultations(waitingConsultations, today);
      inProgressConsultations = filterTodayConsultations(inProgressConsultations, today);
      billingConsultations = filterTodayConsultations(billingConsultations, today);
      completedConsultations = filterTodayConsultations(completedConsultations, today);
      cancelledConsultations = filterTodayConsultations(cancelledConsultations, today);

      // Create DTOs with patient information
      List<QueueItem> appointmentItems = createQueueItemsFromAppointments(todayAppointments);
      List<QueueItem> waitingItems = createQueueItemsFromConsultations(waitingConsultations);
      List<QueueItem> inProgressItems = createQueueItemsFromConsultations(inProgressConsultations);
      List<QueueItem> billingItems = createQueueItemsFromConsultations(billingConsultations);
      List<QueueItem> completedItems = createQueueItemsFromConsultations(completedConsultations);
      List<QueueItem> cancelledItems = createQueueItemsFromConsultations(cancelledConsultations);

      // Create response object
      JsonObject response = new JsonObject();
      response.add("appointments", gson.toJsonTree(appointmentItems));
      response.add("waiting", gson.toJsonTree(waitingItems));
      response.add("inProgress", gson.toJsonTree(inProgressItems));
      response.add("billing", gson.toJsonTree(billingItems));
      response.add("completed", gson.toJsonTree(completedItems));
      response.add("cancelled", gson.toJsonTree(cancelledItems));
      
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

      String oldStatus = consultation.getStatus();
      String newStatus = request.getStatus();

      // Update status
      consultation.setStatus(newStatus);

      // Update check-in time if status is "In Progress" (Malaysia timezone)
      if ("In Progress".equalsIgnoreCase(newStatus) && consultation.getCheckInTime() == null) {
        consultation.setCheckInTime(TimeUtils.nowMalaysia());
      }

      consultationRepository.update(consultationId, consultation);

      // If status changed from "Billing" to "Completed", deduct medicine stock from prescriptions
      if ("Completed".equalsIgnoreCase(newStatus) && "Billing".equalsIgnoreCase(oldStatus)) {
        try {
          boolean stockDeductionSuccess = medicineStockService.deductMedicineStock(consultationId);
          if (!stockDeductionSuccess) {
            return Response.status(Response.Status.BAD_REQUEST)
              .entity(new ErrorResponse("Failed to deduct medicine stock. Please check stock availability."))
              .build();
          }
        } catch (Exception e) {
          return Response.status(Response.Status.BAD_REQUEST)
            .entity(new ErrorResponse("Error processing medicine stock deduction: " + e.getMessage()))
            .build();
        }
      }

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
      consultation.setCheckInTime(TimeUtils.nowMalaysia());

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

      // Get invoice information if consultation has a bill
      if (consultation.getBillID() != null && !consultation.getBillID().isEmpty()) {
        item.setInvoiceID(consultation.getBillID());
        item.setBillID(consultation.getBillID());
      }

      // Get treatment count for this consultation
      try {
        List<Treatment> treatments = treatmentRepository.findByConsultationId(consultation.getConsultationID());
        item.setTreatmentCount(treatments.size());
      } catch (Exception e) {
        // If treatment repository is not available, set count to 0
        item.setTreatmentCount(0);
      }

      items.add(item);
    }
    
    return items;
  }



  @GET
  @Path("/patient/{patientId}")
  public Response getPatientQueueStatus(@PathParam("patientId") String patientId) {
    try {
      LocalDate today = LocalDate.now();
      
      // Get today's appointments for this patient
      List<Appointment> allAppointments = appointmentRepository.findAll();
      List<Appointment> patientAppointments = new List<>();
      
      for (Appointment appointment : allAppointments) {
        if (appointment.getPatientID() != null && 
            appointment.getPatientID().equals(patientId) &&
            appointment.getAppointmentTime() != null &&
            appointment.getAppointmentTime().toLocalDate().equals(today) &&
            "Scheduled".equals(appointment.getStatus())) {
          patientAppointments.add(appointment);
        }
      }
      
      // Get today's consultations for this patient
      List<Consultation> allConsultations = consultationRepository.findAll();
      List<Consultation> patientConsultations = new List<>();
      
      for (Consultation consultation : allConsultations) {
        if (consultation.getPatientID() != null && 
            consultation.getPatientID().equals(patientId) &&
            consultation.getConsultationDate() != null &&
            consultation.getConsultationDate().equals(today)) {
          patientConsultations.add(consultation);
        }
      }
      
      // If patient has no appointments or consultations today, return not found
      if (patientAppointments.isEmpty() && patientConsultations.isEmpty()) {
        return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse("No appointments or consultations found for today"))
                .build();
      }
      
      // Get all appointments and consultations for today to calculate queue position
      List<Appointment> todayAppointments = new List<>();
      for (Appointment appointment : allAppointments) {
        if (appointment.getAppointmentTime() != null &&
            appointment.getAppointmentTime().toLocalDate().equals(today) &&
            "Scheduled".equals(appointment.getStatus())) {
          todayAppointments.add(appointment);
        }
      }
      
      List<Consultation> todayConsultations = new List<>();
      for (Consultation consultation : allConsultations) {
        if (consultation.getConsultationDate() != null &&
            consultation.getConsultationDate().equals(today)) {
          todayConsultations.add(consultation);
        }
      }
      
      // Calculate queue position
      int queuePosition = 0;
      int estimatedWaitTime = 0;
      
      // Check if patient has a consultation today
      if (!patientConsultations.isEmpty()) {
        Consultation patientConsultation = patientConsultations.get(0);
        
        // Only calculate queue position if patient's consultation is in "Waiting" status
        if ("Waiting".equalsIgnoreCase(patientConsultation.getStatus())) {
          // Count consultations in "Waiting" status that checked in before this patient
          for (Consultation consultation : todayConsultations) {
            if (consultation.getConsultationDate().equals(today) && 
                "Waiting".equalsIgnoreCase(consultation.getStatus()) &&
                consultation.getCheckInTime() != null && 
                patientConsultation.getCheckInTime() != null &&
                consultation.getCheckInTime().isBefore(patientConsultation.getCheckInTime())) {
              queuePosition++;
            }
          }
          
          // Estimate wait time (15 minutes per person in queue)
          estimatedWaitTime = queuePosition * 15;
        } else {
          // If consultation is not in "Waiting" status, no queue position
          queuePosition = 0;
          estimatedWaitTime = 0;
        }
      } else if (!patientAppointments.isEmpty()) {
        // Patient has appointment but no consultation yet
        Appointment patientAppointment = patientAppointments.get(0);
        
        // Count appointments before this patient's appointment
        for (Appointment appointment : todayAppointments) {
          if (appointment.getAppointmentTime() != null &&
              appointment.getAppointmentTime().isBefore(patientAppointment.getAppointmentTime())) {
            queuePosition++;
          }
        }
        
        // Estimate wait time (20 minutes per person in queue for appointments)
        estimatedWaitTime = queuePosition * 20;
      }
      
      // Create response object
      JsonObject response = new JsonObject();
      response.addProperty("patientId", patientId);
      response.addProperty("queuePosition", queuePosition);
      response.addProperty("estimatedWaitTime", estimatedWaitTime);
      response.addProperty("hasAppointment", !patientAppointments.isEmpty());
      response.addProperty("hasConsultation", !patientConsultations.isEmpty());
      
      // Add patient's appointment/consultation details
      if (!patientAppointments.isEmpty()) {
        Appointment appointment = patientAppointments.get(0);
        JsonObject appointmentInfo = new JsonObject();
        appointmentInfo.addProperty("appointmentId", appointment.getAppointmentID());
        appointmentInfo.addProperty("appointmentTime", appointment.getAppointmentTime().toString());
        appointmentInfo.addProperty("status", appointment.getStatus());
        response.add("appointment", appointmentInfo);
      }
      
      if (!patientConsultations.isEmpty()) {
        Consultation consultation = patientConsultations.get(0);
        JsonObject consultationInfo = new JsonObject();
        consultationInfo.addProperty("consultationId", consultation.getConsultationID());
        consultationInfo.addProperty("checkInTime", consultation.getCheckInTime() != null ? consultation.getCheckInTime().toString() : "");
        consultationInfo.addProperty("status", consultation.getStatus());
        response.add("consultation", consultationInfo);
      }
      
      String json = gson.toJson(response);
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
      
    } catch (Exception e) {
      return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
              .entity(new ErrorResponse("Error getting patient queue status: " + e.getMessage()))
              .build();
    }
  }
  
  // Helper method to filter consultations for today only
  private List<Consultation> filterTodayConsultations(List<Consultation> consultations, LocalDate today) {
    List<Consultation> todayConsultations = new List<>();
    for (Consultation consultation : consultations) {
      if (consultation.getConsultationDate() != null && 
          consultation.getConsultationDate().equals(today)) {
        todayConsultations.add(consultation);
      }
    }
    return todayConsultations;
  }
}
