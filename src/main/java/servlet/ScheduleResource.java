
package servlet;

/**
 * Author: Kong Ji Yu
 * Consultation Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Schedule;
import repositories.Schedule.ScheduleRepository;
import repositories.Staff.StaffRepository;
import utils.List;
import utils.ListAdapter;
import DTO.ScheduleAssignmentRequest;

import java.time.LocalDate;

@Path("/schedules")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ScheduleResource {
  Gson gson = new GsonBuilder()
    .registerTypeAdapter(java.time.LocalDate.class,     new utils.LocalDateAdapter())
    .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
    .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
    .registerTypeAdapter(utils.List.class, new ListAdapter())
    .create();

  @Inject
  ScheduleRepository scheduleRepository;

  @Inject
  StaffRepository staffRepository;

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public Response GetAllSchedules() {
    List<Schedule> schedules = scheduleRepository.findAll();
    String json = gson.toJson(schedules);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @GET
  @Path("/month/{year}/{month}")
  public Response getSchedulesByMonth(@PathParam("year") int year, @PathParam("month") int month) {
    List<Schedule> schedules = scheduleRepository.findByMonth(year, month);
    String json = gson.toJson(schedules);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @POST
  public Response createSchedule(Schedule schedule) {
    scheduleRepository.create(schedule);
    String json = gson.toJson(schedule);
    return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
  }

  @PUT
  @Path("/{id}")
  public Response updateSchedule(@PathParam("id") String id, Schedule schedule) {
    schedule.setScheduleID(id);
    scheduleRepository.update(schedule);
    String json = gson.toJson(schedule);
    return Response.ok(json).type(MediaType.APPLICATION_JSON).build();
  }

  @POST
  @Path("/assign")
  public Response assignDoctorToShift(ScheduleAssignmentRequest request) {
    try {
      // Parse the date
      LocalDate date = LocalDate.parse(request.getDate());

      // Find existing schedule for this date and shift
      List<Schedule> existingSchedules = scheduleRepository.findAll();
      Schedule existingSchedule = null;

      for (Schedule s : existingSchedules) {
        if (s.getDate().equals(date) && request.getShift().equals(s.getShift())) {
          existingSchedule = s;
          break;
        }
      }

      if (existingSchedule != null) {
        // Update existing schedule with new doctor assignments
        if (request.getDoctorID1() != null && !request.getDoctorID1().trim().isEmpty()) {
          existingSchedule.setDoctorID1(request.getDoctorID1());
        }
        if (request.getDoctorID2() != null && !request.getDoctorID2().trim().isEmpty()) {
          existingSchedule.setDoctorID2(request.getDoctorID2());
        }
        scheduleRepository.update(existingSchedule);
        return Response.ok(gson.toJson(existingSchedule)).type(MediaType.APPLICATION_JSON).build();
      } else {
        // Create new schedule
        Schedule newSchedule = new Schedule();
        newSchedule.setDate(date);
        newSchedule.setShift(request.getShift());
        newSchedule.setDoctorID1(request.getDoctorID1());
        newSchedule.setDoctorID2(request.getDoctorID2());

        // Set start and end times based on shift
        if ("morning".equals(request.getShift())) {
          newSchedule.setStartTime(date.atTime(8, 0));
          newSchedule.setEndTime(date.atTime(14, 0));
        } else if ("evening".equals(request.getShift())) {
          newSchedule.setStartTime(date.atTime(14, 0));
          newSchedule.setEndTime(date.atTime(20, 0));
        }

        scheduleRepository.create(newSchedule);
        return Response.status(Response.Status.CREATED).entity(gson.toJson(newSchedule)).type(MediaType.APPLICATION_JSON).build();
      }
    } catch (Exception e) {
      return Response.status(Response.Status.BAD_REQUEST)
        .entity("{\"error\": \"" + e.getMessage() + "\"}")
        .type(MediaType.APPLICATION_JSON).build();
    }
  }

  @DELETE
  @Path("/assign")
  public Response clearAssignment(@QueryParam("date") String dateStr, @QueryParam("shift") String shift) {
    try {
      LocalDate date = LocalDate.parse(dateStr);

      List<Schedule> schedules = scheduleRepository.findAll();
      for (Schedule s : schedules) {
        if (s.getDate().equals(date) && shift.equals(s.getShift())) {
          scheduleRepository.delete(s.getScheduleID());
          return Response.ok("{\"message\": \"Assignment cleared successfully\"}")
            .type(MediaType.APPLICATION_JSON).build();
        }
      }

      return Response.status(Response.Status.NOT_FOUND)
        .entity("{\"error\": \"Schedule not found\"}")
        .type(MediaType.APPLICATION_JSON).build();
    } catch (Exception e) {
      return Response.status(Response.Status.BAD_REQUEST)
        .entity("{\"error\": \"" + e.getMessage() + "\"}")
        .type(MediaType.APPLICATION_JSON).build();
    }
  }


}
