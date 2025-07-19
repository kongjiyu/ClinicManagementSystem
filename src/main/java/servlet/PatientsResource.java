package servlet;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Patient;
import repositories.Patient.PatientRepository;
import utils.ArrayList;
import utils.ErrorResponse;
import DTO.AllergyInput;

@Path("/patients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PatientsResource {
  @Inject
  private PatientRepository repo;

  @GET
  public Response getAllPatients() {
      ArrayList<Patient> patients = new ArrayList<>();
      patients.addAll(repo.findAll());
      return Response.ok(patients.toList()).build();
  }

  @GET
  @Path("/{id}")
  public Response getPatient(@PathParam("id") String id) {
      Patient patient = repo.findById(id);
      if (patient != null) {
          return Response.ok(patient).build();
      } else {
          return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
      }
  }

  @GET
  @Path("/{id}/medical-history")
  public Response getMedicalHistory(@PathParam("id") String id) {
      return Response.ok(repo.findMedicalHistoryByPatientId(id)).build();
  }

  @GET
  @Path("/{id}/prescriptions")
  public Response getPrescriptions(@PathParam("id") String id) {
      return Response.ok(repo.findPrescriptionsByPatientId(id)).build();
  }

  @POST
  public Response createPatient(Patient patient) {
      repo.save(patient);
      return Response.status(Response.Status.CREATED).entity(patient).build();
  }

  @POST
  @Path("/{id}")
  public Response updatePatient(@PathParam("id") String id, Patient patient) {
      patient.setPatientID(id);
      repo.update(patient);
      return Response.ok(patient).build();
  }

  @POST
  @Path("/{id}/allergies")
  public Response updateAllergies(@PathParam("id") String id, AllergyInput allergyData) {
      Patient patient = repo.findById(id);
      if (patient != null) {
          patient.setAllergies(allergyData.getAllergies());
          repo.update(patient);
          return Response.ok(patient).build();
      } else {
          return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
      }
  }
}
