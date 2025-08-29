package servlet;

/**
 * Author: Chia Yu Xin
 * Consultation Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Appointment;
import models.Patient;
import models.Schedule;
import models.Staff;
import repositories.Appointment.AppointmentRepository;
import repositories.Patient.PatientRepository;
import repositories.Schedule.ScheduleRepository;
import repositories.Staff.StaffRepository;
import utils.ErrorResponse;
import utils.List;
import utils.ListAdapter;
import DTO.AppointmentWithPatientDTO;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@Path("/appointments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class AppointmentResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
            .registerTypeAdapter(utils.List.class, new ListAdapter())
            .create();

    @Inject
    private AppointmentRepository appointmentRepo;

    @Inject
    private PatientRepository patientRepo;

    @Inject
    private ScheduleRepository scheduleRepo;

    @Inject
    private StaffRepository staffRepo;

    private List<AppointmentWithPatientDTO> convertToDTOWithPatientNames(List<Appointment> appointments) {
        List<AppointmentWithPatientDTO> dtos = new List<>();
        for (Appointment appointment : appointments) {
            // Get patient name
            Patient patient = patientRepo.findById(appointment.getPatientID());
            String patientName = patient != null ?
                patient.getFirstName() + " " + patient.getLastName() :
                "Unknown Patient";

            // Get doctor name from schedule
            String doctorName = "Unknown Doctor";
            String doctorID = null;
            try {
                Schedule schedule = scheduleRepo.findByDateAndTime(
                    appointment.getAppointmentTime().toLocalDate(),
                    appointment.getAppointmentTime()
                );
                if (schedule != null) {
                    // Use doctor 1 as primary doctor, fallback to doctor 2 if doctor 1 is not available
                    doctorID = schedule.getDoctorID1();
                    if (doctorID == null || doctorID.trim().isEmpty()) {
                        doctorID = schedule.getDoctorID2();
                    }
                    Staff doctor = staffRepo.findById(doctorID);
                    if (doctor != null) {
                        doctorName = doctor.getFirstName() + " " + doctor.getLastName();
                    }
                }
            } catch (Exception e) {
                // If there's any error getting doctor info, use default
                doctorName = "Unknown Doctor";
            }

            AppointmentWithPatientDTO dto = AppointmentWithPatientDTO.fromAppointment(appointment, patientName, doctorName);
            dto.setDoctorID(doctorID);
            dtos.add(dto);
        }
        return dtos;
    }

    @POST
    public Response createAppointment(Appointment appointment) {
        try {
            appointmentRepo.create(appointment);
            appointmentRepo.updateStatus(appointment.getAppointmentID(), "Scheduled");
            String json = gson.toJson(appointment);
            return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error creating appointment: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    public Response getAllAppointments() {
        List<Appointment> appointments = appointmentRepo.findAllSortedByDateTime();
        List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointments);
        String json = gson.toJson(dtos);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/{id}")
    public Response getAppointmentById(@PathParam("id") String id) {
        Appointment appointment = appointmentRepo.findById(id);
        if (appointment != null) {
            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }
    }

    @GET
    @Path("/by-patient/{patientid}")
    public Response getAppointment(@PathParam("patientid") String id) {
        List<Appointment> appointment = appointmentRepo.findByPatientId(id);
        if (appointment != null) {
            List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointment);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Appointment not found")).build();
        }
    }

    @GET
    @Path("/upcoming-by-patient/{patientid}")
    public Response getUpComingAppointment(@PathParam("patientid") String id) {
        List<Appointment> appointment = appointmentRepo.findUpcomingByPatientId(id);
        if (appointment != null) {
            List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointment);
            String json = gson.toJson(dtos);
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
            List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointment);
            String json = gson.toJson(dtos);
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
                List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointments);
                String json = gson.toJson(dtos);
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

    @PUT
    @Path("/{id}/reschedule")
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

    @PUT
    @Path("/{id}")
    public Response updateAppointment(@PathParam("id") String id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        try {
            appointment.setAppointmentID(id); // Ensure the ID is set correctly
            appointmentRepo.update(appointment);
            String json = gson.toJson(appointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error updating appointment: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}/cancel")
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

    @PUT
    @Path("/{id}/noshow")
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

    @PUT
    @Path("/{id}/checkin")
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

    @DELETE
    @Path("/{id}")
    public Response deleteAppointment(@PathParam("id") String id) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        try {
            appointmentRepo.delete(id);
            return Response.ok("{\"message\": \"Appointment deleted successfully\"}")
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error deleting appointment: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}/status")
    public Response updateAppointmentStatus(@PathParam("id") String id, String status) {
        Appointment existingAppointment = appointmentRepo.findById(id);
        if (existingAppointment == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Appointment not found"))
                    .build();
        }

        try {
            appointmentRepo.updateStatus(id, status);
            Appointment updatedAppointment = appointmentRepo.findById(id);
            String json = gson.toJson(updatedAppointment);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error updating appointment status: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/today")
    public Response getTodayAppointments() {
        try {
            LocalDate today = LocalDate.now();
            List<Appointment> appointments = appointmentRepo.findByDate(today);
            List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointments);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching today's appointments: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/upcoming")
    public Response getUpcomingAppointments() {
        try {
            List<Appointment> appointments = appointmentRepo.findUpcoming();
            List<AppointmentWithPatientDTO> dtos = convertToDTOWithPatientNames(appointments);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching upcoming appointments: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/can-create/{patientId}")
    public Response canCreateAppointment(@PathParam("patientId") String patientId) {
        try {
            // Get all appointments for this patient
            List<Appointment> patientAppointments = appointmentRepo.findByPatientId(patientId);
            
            if (patientAppointments == null || patientAppointments.isEmpty()) {
                // No appointments found, can create
                return Response.ok("{\"canCreate\": true, \"message\": \"No existing appointments found\"}")
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            
            // Check for active appointments (scheduled, confirmed, check in)
            boolean hasActiveAppointment = false;
            for (Appointment appointment : patientAppointments) {
                String status = appointment.getStatus();
                if (status != null) {
                    String statusLower = status.toLowerCase();
                    if (statusLower.equals("scheduled") || 
                        statusLower.equals("confirmed") || 
                        statusLower.equals("check in") ||
                        statusLower.equals("checked-in")) {
                        hasActiveAppointment = true;
                        break;
                    }
                }
            }
            
            if (hasActiveAppointment) {
                return Response.ok("{\"canCreate\": false, \"message\": \"You already have an active appointment. Please cancel your existing appointment first.\"}")
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            } else {
                return Response.ok("{\"canCreate\": true, \"message\": \"No active appointments found\"}")
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error checking appointment eligibility: " + e.getMessage()))
                    .build();
        }
    }

}
