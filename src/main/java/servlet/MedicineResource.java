package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Medicine;
import models.Patient;
import models.Staff;
import repositories.Medicine.MedicineRepository;
import utils.ErrorResponse;
import utils.List;

@Path("/medicine")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class MedicineResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
            .create();

    @Inject
    private MedicineRepository medicineRepo;

    @GET
    public Response getAllMedicine() {
        List<Medicine> medicine = new List<>();
        medicine.addAll(medicineRepo.findAll());
        String json = gson.toJson(medicine);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/{id}")
    public Response getMedicine(@PathParam("id") String id) {
        Medicine medicine = medicineRepo.findById(id);
        if (medicine != null) {
            String json = gson.toJson(medicine);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Medicine not found")).build();
        }
    }

    @GET
    @Path("/by-name/{name}")
    public Response getMedicineByName(@PathParam("name") String name) {
        List<Medicine> medicine = medicineRepo.findByName(name);
        if (medicine != null) {
            String json = gson.toJson(medicine);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Medicine not found")).build();
        }
    }

    @GET
    @Path("/out-of-stock")
    public Response getMedicineOutOfStock() {
        List<Medicine> medicine = medicineRepo.findOutOfStock();
        if (medicine != null) {
            String json = gson.toJson(medicine);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Medicine not found")).build();
        }
    }

    @GET
    @Path("/below-reorder-level")
    public Response getMedicineBelowReorderLevel() {
        List<Medicine> medicine = medicineRepo.findBelowReorderLevel();
        if (medicine != null) {
            String json = gson.toJson(medicine);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Medicine not found")).build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteStaff(@PathParam("id") String id) {
        Medicine medicine = medicineRepo.findById(id);
        if (medicine == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Medicine not found"))
                    .build();
        }

        medicineRepo.delete(medicine);
        return Response.ok("{\"message\": \"Medicine Record deleted successfully\"}")
                .type(MediaType.APPLICATION_JSON)
                .build();
    }

    @PUT
    @Path("/{id}")
    public Response updateMedicine(@PathParam("id") String id, Medicine medicine) {
        Medicine existingMedicine = medicineRepo.findById(id);
        if (existingMedicine == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Medicine not found"))
                    .build();
        }

        medicineRepo.update(medicine);
        String json = gson.toJson(medicine);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }


}
