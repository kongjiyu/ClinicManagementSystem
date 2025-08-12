package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Staff;
import repositories.Staff.StaffRepository;
import utils.List;
import utils.ErrorResponse;

@Path("/staff")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class StaffResource {

  Gson gson = new GsonBuilder()
    .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
    .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
    .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
    .registerTypeAdapter(utils.List.class, new utils.UtilsListAdapter())
    .create();

  @Inject
  private StaffRepository staffRepository;

  @GET
  public Response getAllStaff() {
    List<Staff> staff = staffRepository.findAll();
    String json = gson.toJson(staff);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @GET
  @Path("/doctors")
  public Response getAllDoctors() {
    List<Staff> allStaff = staffRepository.findAll();
    List<Staff> doctors = new List<>();
    
    for (Staff staff : allStaff) {
      if ("Doctor".equalsIgnoreCase(staff.getPosition()) || 
          staff.getMedicalLicenseNumber() != null && !staff.getMedicalLicenseNumber().trim().isEmpty()) {
        doctors.add(staff);
      }
    }
    
    String json = gson.toJson(doctors);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @GET
  @Path("/{id}")
  public Response getStaff(@PathParam("id") String id) {
    Staff staff = staffRepository.findById(id);
    if (staff != null) {
      String json = gson.toJson(staff);
      return Response.ok(json, MediaType.APPLICATION_JSON).build();
    } else {
      return Response.status(Response.Status.NOT_FOUND)
        .entity(new ErrorResponse("Staff member not found"))
        .build();
    }
  }

  @POST
  public Response createStaff(Staff staff) {
    staffRepository.create(staff);
    String json = gson.toJson(staff);
    return Response.status(Response.Status.CREATED)
      .entity(json)
      .type(MediaType.APPLICATION_JSON)
      .build();
  }

  @PUT
  @Path("/{id}")
  public Response updateStaff(@PathParam("id") String id, Staff staff) {
    Staff existingStaff = staffRepository.findById(id);
    if (existingStaff == null) {
      return Response.status(Response.Status.NOT_FOUND)
        .entity(new ErrorResponse("Staff member not found"))
        .build();
    }
    
    staff.setStaffID(id);
    staffRepository.update(id, staff);
    String json = gson.toJson(staff);
    return Response.ok(json, MediaType.APPLICATION_JSON).build();
  }

  @DELETE
  @Path("/{id}")
  public Response deleteStaff(@PathParam("id") String id) {
    Staff existingStaff = staffRepository.findById(id);
    if (existingStaff == null) {
      return Response.status(Response.Status.NOT_FOUND)
        .entity(new ErrorResponse("Staff member not found"))
        .build();
    }
    
    staffRepository.delete(id);
    return Response.ok("{\"message\": \"Staff member deleted successfully\"}")
      .type(MediaType.APPLICATION_JSON)
      .build();
  }
} 