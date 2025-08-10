package servlet;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Appointment;
import repositories.Appointment.AppointmentRepository;
import utils.ErrorResponse;
import utils.List;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@Path("/appoinments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class AppointmentResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
            .create();

    @Inject
    private AppointmentRepository appointmentRepo;

    @POST
    public Response createAppointment(Appointment appointment) {
        appointmentRepo.create(appointment);
        appointmentRepo.updateStatus(appointment.getAppointmentID(),"SCHEDULED");
        String json = gson.toJson(appointment);
        return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
    }

    @GET
    public Response getAllAppointments() {
        List<Appointment> appointments = appointmentRepo.findAll();
        String json = gson.toJson(appointments);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/by-patient/{patientid}")
    public Response getAppointment(@PathParam("patientid") String id) {
        List<Appointment> appointment = appointmentRepo.findByPatientId(id);
        if (appointment != null) {
            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Appointment not found")).build();
        }
    }

    @GET
    @Path("/by-patient/{patientid}")
    public Response getUpComingAppointment(@PathParam("patientid") String id) {
        List<Appointment> appointment = appointmentRepo.findUpcomingByPatientId(id);
        if (appointment != null) {
            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Appointment not found")).build();
        }
    }

    @GET
    @Path("/by-status/{status}")
    public Response getAppointmentByStatus(@PathParam("status") String status) {
        List<Appointment> appointment = appointmentRepo.findByStatus(status);
        if (appointment != null) {
            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Appointment not found")).build();
        }
    }

    @GET
    @Path("/by-date/{date}")
    public Response getAppointmentsByDate(@PathParam("date") String dateStr) {
        try {
            // Parse the string to LocalDate
            LocalDate date = LocalDate.parse(dateStr);

            // Fetch appointments
            List<Appointment> appointments = appointmentRepo.findByDate(date);

            if (appointments != null && !appointments.isEmpty()) {
                String json = gson.toJson(appointments);
                return Response.ok(json, MediaType.APPLICATION_JSON).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("No appointments found for date: " + date))
                        .build();
            }
        } catch (DateTimeParseException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid date format. Use YYYY-MM-DD."))
                    .build();
        }
    }

    @POST
    @Path("/{id}")
    public Response rescheduleAppointment(@PathParam("id") String id, String newTimeStr) {
        try {
            LocalDateTime newTime = LocalDateTime.parse(newTimeStr);
            appointmentRepo.reschedule(id, newTime);
            Appointment appointment = appointmentRepo.findById(id);
            if(appointment == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Appointment not found"))
                        .build();
            }

            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();

        } catch (DateTimeParseException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid date-time format. Use yyyy-MM-ddTHH:mm:ss"))
                    .build();
        }
    }

    @POST
    @Path("/{id}")
    public Response updateAppointment(@PathParam("id") String id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        appointmentRepo.update(appointment);
        String json = gson.toJson(appointment);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response cancelAppointment(@PathParam("id") String id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        appointmentRepo.updateStatus(appointment.getAppointmentID(),"CANCELLED");
        String json = gson.toJson(appointment);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response patientNoShow(@PathParam("id") String id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        appointmentRepo.updateStatus(appointment.getAppointmentID(),"NOSHOW");
        String json = gson.toJson(appointment);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    @Path("/{id}")
    public Response patientCheckIn(@PathParam("id") String id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        appointmentRepo.updateStatus(appointment.getAppointmentID(),"CHECK IN");
        String json = gson.toJson(appointment);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

}
