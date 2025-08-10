package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Patient;
import repositories.Patient.PatientRepository;
import repositories.Prescription.PrescriptionRepository;
import utils.List;
import utils.ErrorResponse;
import DTO.AllergyInput;

@Path("/patients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PatientsResource {

  Gson gson = new GsonBuilder()
    .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
    .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
     .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
    .create();

  @Inject
  private PatientRepository patientRepo;

  @Inject
  private PrescriptionRepository prescriptionRepo;

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
      String json = gson.toJson(patientRepo.findMedicalHistoryByPatientId(id));
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
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
  @Path("/{id}")
  public Response updatePatient(@PathParam("id") String id, Patient patient) {
      patient.setPatientID(id);
    patientRepo.update(patient);
      String json = gson.toJson(patient);
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
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
}
