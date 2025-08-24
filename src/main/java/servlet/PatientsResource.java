package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Patient;
import models.Appointment;
import models.Prescription;
import models.Consultation;
import models.Staff;
import repositories.Patient.PatientRepository;
import repositories.Prescription.PrescriptionRepository;
import repositories.Appointment.AppointmentRepository;
import repositories.Staff.StaffRepository;
import repositories.Consultation.ConsultationRepository;
import utils.List;
import utils.ErrorResponse;
import DTO.AllergyInput;
import utils.ListAdapter;
import utils.MultiMap;
import java.util.HashMap;
import java.util.Map;

@Path("/patients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PatientsResource {

  Gson gson = new GsonBuilder()
    .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
    .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
     .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
    .registerTypeAdapter(utils.List.class, new ListAdapter())
    .create();

  @Inject
  private PatientRepository patientRepo;

  @Inject
  private PrescriptionRepository prescriptionRepo;

  @Inject
  private AppointmentRepository appointmentRepository;

  @Inject
  private StaffRepository staffRepository;

  @Inject
  private repositories.Medicine.MedicineRepository medicineRepository;

  @Inject
  private ConsultationRepository consultationRepo;

  @GET
  public Response getAllPatients() {
    List<Patient> patients = new List<>();
    patients.addAll(patientRepo.findAll());
    String json = gson.toJson(patients);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @GET
  @Path("/{id}")
  public Response getPatient(@PathParam("id") String id) {
      Patient patient = patientRepo.findById(id);
      if (patient != null) {
          String json = gson.toJson(patient);
          return Response.ok(json, MediaType.APPLICATION_JSON).build();
      } else {
          return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
      }
  }

  @GET
  @Path("/{id}/medical-history")
  public Response getMedicalHistory(@PathParam("id") String id) {
      try {
          List<Prescription> prescriptions = patientRepo.findPrescriptionHistoryByPatientId(id);
          List<Map<String, Object>> enrichedPrescriptions = new List<>();
          
          for (Prescription prescription : prescriptions) {
              Map<String, Object> enrichedPrescription = new HashMap<>();
              
              // Add prescription data
              enrichedPrescription.put("prescriptionID", prescription.getPrescriptionID());
              enrichedPrescription.put("consultationID", prescription.getConsultationID());
              enrichedPrescription.put("medicineID", prescription.getMedicineID());
              enrichedPrescription.put("description", prescription.getDescription());
                             enrichedPrescription.put("dosage", prescription.getDosage());
               
               // Convert instruction to meaningful text
               String instructionText = getInstructionText(prescription.getInstruction());
               enrichedPrescription.put("instruction", instructionText);
               
               enrichedPrescription.put("servingPerDay", prescription.getServingPerDay());
              enrichedPrescription.put("price", prescription.getPrice());
              enrichedPrescription.put("dosageUnit", prescription.getDosageUnit());
              
              // Get medicine name
              models.Medicine medicine = medicineRepository.findById(prescription.getMedicineID());
              enrichedPrescription.put("medicineName", medicine != null ? medicine.getMedicineName() : "Unknown Medicine");
              
              // Get consultation to find doctor
              Consultation consultation = consultationRepo.findById(prescription.getConsultationID());
              if (consultation != null && consultation.getDoctorID() != null) {
                  Staff doctor = staffRepository.findById(consultation.getDoctorID());
                  if (doctor != null) {
                      enrichedPrescription.put("doctorName", "Dr. " + doctor.getFirstName() + " " + doctor.getLastName());
                  } else {
                      enrichedPrescription.put("doctorName", "Unknown Doctor");
                  }
                  enrichedPrescription.put("prescriptionDate", consultation.getConsultationDate());
                  enrichedPrescription.put("status", consultation.getStatus());
              } else {
                  enrichedPrescription.put("doctorName", "Unknown Doctor");
                  enrichedPrescription.put("prescriptionDate", null);
                  enrichedPrescription.put("status", "Unknown");
              }
              
              enrichedPrescriptions.add(enrichedPrescription);
          }
          
          String json = gson.toJson(enrichedPrescriptions);
          return Response.ok(json, MediaType.APPLICATION_JSON).build();
      } catch (Exception e) {
          return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                  .entity(new ErrorResponse("Error loading medical history: " + e.getMessage()))
                  .build();
      }
  }

  @GET
  @Path("/{id}/prescriptions")
  public Response getPrescriptions(@PathParam("id") String id) {
      String json = gson.toJson(prescriptionRepo.findPrescriptionsByPatientId(id));
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @POST
  public Response createPatient(Patient patient) {
    patientRepo.create(patient);
      String json = gson.toJson(patient);
      return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
  }



  @POST
  @Path("/{id}/allergies")
  public Response updateAllergies(@PathParam("id") String id, AllergyInput allergyData) {
      Patient patient = patientRepo.findById(id);
      if (patient != null) {
          patient.setAllergies(allergyData.getAllergies());
        patientRepo.update(patient);
          String json = gson.toJson(patient);
          return Response.ok(json, MediaType.APPLICATION_JSON).build();
      } else {
          return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
      }
  }

  @GET
  @Path("/{id}/dashboard")
  public Response getPatientDashboard(@PathParam("id") String id) {
      try {
          // Get patient information
          Patient patient = patientRepo.findById(id);
          if (patient == null) {
              return Response.status(Response.Status.NOT_FOUND)
                      .entity(new ErrorResponse("Patient not found"))
                      .build();
          }

          // Get upcoming appointments
          List<Appointment> upcomingAppointments = appointmentRepository.findUpcomingByPatientId(id);

          // Create dashboard data using MultiMap
          MultiMap<String, Object> dashboardData = new MultiMap<>();
          dashboardData.put("patient", patient);

          // Add appointment details directly to MultiMap
          for (Appointment appointment : upcomingAppointments) {
              dashboardData.put("appointment", appointment);
          }

          String json = gson.toJson(dashboardData);
          return Response.ok(json, MediaType.APPLICATION_JSON).build();

      } catch (Exception e) {
          return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                  .entity(new ErrorResponse("Error loading dashboard data: " + e.getMessage()))
                  .build();
      }
  }

    @GET
  @Path("/{id}/upcoming-appointments")
  public Response getUpcomingAppointments(@PathParam("id") String id) {
      try {
          List<Appointment> upcomingAppointments = appointmentRepository.findUpcomingByPatientId(id);

          if (upcomingAppointments != null) {
              String json = gson.toJson(upcomingAppointments);
              return Response.ok(json, MediaType.APPLICATION_JSON).build();
          } else {
              return Response.ok(gson.toJson(new List<Appointment>()), MediaType.APPLICATION_JSON).build();
          }
      } catch (Exception e) {
          return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                  .entity(new ErrorResponse("Error loading upcoming appointments: " + e.getMessage()))
                  .build();
      }
  }

  @GET
  @Path("/{id}/appointment-history")
  public Response getAppointmentHistory(@PathParam("id") String id) {
      try {
          List<Appointment> allAppointments = appointmentRepository.findByPatientId(id);

          if (allAppointments != null) {
              String json = gson.toJson(allAppointments);
              return Response.ok(json, MediaType.APPLICATION_JSON).build();
          } else {
              return Response.ok(gson.toJson(new List<Appointment>()), MediaType.APPLICATION_JSON).build();
          }
      } catch (Exception e) {
          return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                  .entity(new ErrorResponse("Error loading appointment history: " + e.getMessage()))
                  .build();
      }
  }

  @PUT
  @Path("/{id}")
  public Response updatePatient(@PathParam("id") String id, Patient updatedPatient) {
      try {
          Patient existingPatient = patientRepo.findById(id);
          if (existingPatient == null) {
              return Response.status(Response.Status.NOT_FOUND)
                      .entity(new ErrorResponse("Patient not found"))
                      .build();
          }

          // Update only editable fields (prevent updating critical fields)
          if (updatedPatient.getFirstName() != null) {
              existingPatient.setFirstName(updatedPatient.getFirstName());
          }
          if (updatedPatient.getLastName() != null) {
              existingPatient.setLastName(updatedPatient.getLastName());
          }
          if (updatedPatient.getContactNumber() != null) {
              existingPatient.setContactNumber(updatedPatient.getContactNumber());
          }
          if (updatedPatient.getEmail() != null) {
              existingPatient.setEmail(updatedPatient.getEmail());
          }
          if (updatedPatient.getAddress() != null) {
              existingPatient.setAddress(updatedPatient.getAddress());
          }
          if (updatedPatient.getEmergencyContactName() != null) {
              existingPatient.setEmergencyContactName(updatedPatient.getEmergencyContactName());
          }
          if (updatedPatient.getEmergencyContactNumber() != null) {
              existingPatient.setEmergencyContactNumber(updatedPatient.getEmergencyContactNumber());
          }
          if (updatedPatient.getAllergies() != null) {
              existingPatient.setAllergies(updatedPatient.getAllergies());
          }

          // Save the updated patient
          patientRepo.update(existingPatient);

          String json = gson.toJson(existingPatient);
          return Response.ok(json, MediaType.APPLICATION_JSON).build();

      } catch (Exception e) {
          return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                  .entity(new ErrorResponse("Error updating patient: " + e.getMessage()))
                  .build();
      }
  }

  // Helper method to convert instruction values to meaningful text
  private String getInstructionText(String instruction) {
      if (instruction == null || instruction.trim().isEmpty()) {
          return "As directed";
      }
      
      // If instruction is already a meaningful string, return it
      if (instruction.toLowerCase().contains("before") || 
          instruction.toLowerCase().contains("after") ||
          instruction.toLowerCase().contains("with") ||
          instruction.toLowerCase().contains("empty") ||
          instruction.toLowerCase().contains("bedtime")) {
          return instruction;
      }
      
      // Convert numeric values to meaningful text (for backward compatibility)
      try {
          int instructionValue = Integer.parseInt(instruction);
          switch (instructionValue) {
              case 1: return "Take with food";
              case 2: return "Take before meals";
              case 3: return "Take after meals";
              case 4: return "Take on empty stomach";
              case 5: return "Take with plenty of water";
              default: return "As directed";
          }
      } catch (NumberFormatException e) {
          // If it's not a number, return as is
          return instruction;
      }
  }
}
