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
import repositories.Consultation.ConsultationRepository;
import utils.ErrorResponse;
import utils.List;
import utils.MultiMap;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@Path("/consultation")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ConsultationResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
            .create();

    @Inject
    private ConsultationRepository consultationRepo;

    @POST
    public Response createConsultation(Consultation consultation) {
       consultationRepo.create(consultation);
        String json = gson.toJson(consultation);
        return Response.status(Response.Status.CREATED)
                .entity(json)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") String id, Consultation consultation) {
       Consultation existingConsultation = consultationRepo.findById(id);
        if (existingConsultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation Record not found"))
                    .build();
        }

        consultationRepo.update(id,consultation);
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/{id}")
    public Response getConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation != null) {
            String json = gson.toJson(consultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
        }
    }

    @GET
    public Response getAllConsultations() {
        List<Consultation> consultations = new List<>();
        consultations.addAll(consultationRepo.findAll());
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-patient/{id}")
    public Response getConsultationsByPatient(@PathParam("id") String id) {
        List<Consultation> consultations = new List<>();
        consultations.addAll(consultationRepo.findByPatientID(id));
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-status/{status}")
    public Response getConsultationsByStatus(@PathParam("status") String status) {
        List<Consultation> consultations = new List<>();
        consultations.addAll(consultationRepo.getByStatus(status));
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    public Response getUpComingConsultation() {
        List<Consultation> consultations = new List<>();
        consultations.addAll(consultationRepo.getUpcoming());
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-mc")
    public Response getAllMc() {
        List<Consultation> consultations = new List<>();
        consultations.addAll(consultationRepo.findAllMc());
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-mc/{id}")
    public Response getConsultationsByMcId(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findByMcID(id);
        if (consultation != null) {
            String json = gson.toJson(consultation);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Patient not found")).build();
        }
    }


    @GET
    @Path("/by-mc/startdate/{date}")
    public Response getConsultationsByMcStartDate(@PathParam("date") String dateStr) {
        try {
            LocalDate date = LocalDate.parse(dateStr);
            List<Consultation> consultations = consultationRepo.findByMcStartDate(date);
            String json = gson.toJson(consultations);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (DateTimeParseException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(gson.toJson(new ErrorResponse("Invalid date format. Use YYYY-MM-DD")))
                    .build();
        }
    }

    @GET
    @Path("/by-mc/duration/{days}")
    public Response getConsultationsByMcDuration(@PathParam("days") Integer durationDays) {
        List<Consultation> consultations = consultationRepo.findByMcDuration(durationDays);
        String json = gson.toJson(consultations);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-mc/daterange/{start}/{end}")
    public Response getConsultationsByMcDateRange(@PathParam("start") String startStr, @PathParam("end") String endStr) {
        try {
            LocalDate startDate = LocalDate.parse(startStr);
            LocalDate endDate = LocalDate.parse(endStr);
            List<Consultation> consultations = consultationRepo.findByMcDateRange(startDate, endDate);
            String json = gson.toJson(consultations);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (DateTimeParseException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(gson.toJson(new ErrorResponse("Invalid date format. Use YYYY-MM-DD")))
                    .build();
        }
    }

    @POST
    @Path("/{id}")
    public Response cancelConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
        }

        consultationRepo.cancel(consultation.getConsultationID());
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response patientInQueue(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
        }

        consultationRepo.updateStatus(consultation.getConsultationID(), "WAITING");
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response patientInConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
        }

        consultationRepo.updateStatus(consultation.getConsultationID(), "CONSULTING");
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response billConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
        }

        consultationRepo.updateStatus(consultation.getConsultationID(), "BILL");
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response finishConsultation(@PathParam("id") String id) {
        Consultation consultation = consultationRepo.findById(id);
        if (consultation == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Consultation not found"))
                    .build();
        }

        consultationRepo.updateStatus(consultation.getConsultationID(), "COMPLETED");
        String json = gson.toJson(consultation);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

}
