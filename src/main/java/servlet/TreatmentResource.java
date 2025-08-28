package servlet;

/**
 * Author: Oh Wan Ting
 * Treatment Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Treatment;
import repositories.Treatment.TreatmentRepository;
import utils.LocalDateTimeAdapter;

import java.time.LocalDateTime;

@Path("/treatments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TreatmentResource {

    @Inject
    private TreatmentRepository treatmentRepository;

    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();

    @GET
    public Response getAllTreatments() {
        try {
            return Response.ok(gson.toJson(treatmentRepository.findAllSortedByDate())).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getTreatmentById(@PathParam("id") String id) {
        try {
            Treatment treatment = treatmentRepository.findById(id);
            if (treatment != null) {
                return Response.ok(gson.toJson(treatment)).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Treatment not found").build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatment: " + e.getMessage()).build();
        }
    }

    @POST
    public Response createTreatment(String json) {
        try {
            Treatment treatment = gson.fromJson(json, Treatment.class);
            treatmentRepository.create(treatment);
            return Response.status(Response.Status.CREATED)
                    .entity(gson.toJson(treatment)).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error creating treatment: " + e.getMessage()).build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateTreatment(@PathParam("id") String id, String json) {
        try {
            Treatment existingTreatment = treatmentRepository.findById(id);
            if (existingTreatment == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Treatment not found").build();
            }

            Treatment updatedTreatment = gson.fromJson(json, Treatment.class);
            updatedTreatment.setTreatmentID(id);
            treatmentRepository.update(updatedTreatment);
            
            return Response.ok(gson.toJson(updatedTreatment)).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error updating treatment: " + e.getMessage()).build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteTreatment(@PathParam("id") String id) {
        try {
            Treatment treatment = treatmentRepository.findById(id);
            if (treatment == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Treatment not found").build();
            }

            treatmentRepository.delete(treatment);
            return Response.ok("Treatment deleted successfully").build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error deleting treatment: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/patient/{patientId}")
    public Response getTreatmentsByPatient(@PathParam("patientId") String patientId) {
        try {
            return Response.ok(gson.toJson(treatmentRepository.findByPatientIdSorted(patientId))).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving patient treatments: " + e.getMessage()).build();
        }
    }



    @GET
    @Path("/status/{status}")
    public Response getTreatmentsByStatus(@PathParam("status") String status) {
        try {
            return Response.ok(gson.toJson(treatmentRepository.findByStatusSorted(status))).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments by status: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/type/{treatmentType}")
    public Response getTreatmentsByType(@PathParam("treatmentType") String treatmentType) {
        try {
            return Response.ok(gson.toJson(treatmentRepository.findByTreatmentType(treatmentType))).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments by type: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/grouped/status")
    public Response getTreatmentsGroupedByStatus() {
        try {
            return Response.ok(gson.toJson(treatmentRepository.groupByStatus())).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments grouped by status: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/grouped/type")
    public Response getTreatmentsGroupedByType() {
        try {
            return Response.ok(gson.toJson(treatmentRepository.groupByTreatmentType())).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments grouped by type: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/by-consultation/{consultationId}")
    public Response getTreatmentsByConsultation(@PathParam("consultationId") String consultationId) {
        try {
            return Response.ok(gson.toJson(treatmentRepository.findByConsultationId(consultationId))).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error retrieving treatments by consultation: " + e.getMessage()).build();
        }
    }
}
