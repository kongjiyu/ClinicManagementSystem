package servlet;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Medicine;
import repositories.Medicine.MedicineRepository;
import utils.ErrorResponse;
import utils.List;
import utils.ListAdapter;
import DTO.MedicineResponse;
import DTO.StockInfo;

@Path("/medicines")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class MedicineResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class,  new utils.LocalTimeAdapter())
            .registerTypeAdapter(utils.List.class, new ListAdapter())
            .create();

    @Inject
    private MedicineRepository medicineRepo;

    @Inject
    private MedicineStockService medicineStockService;

    @GET
    public Response getAllMedicine() {
        List<Medicine> allMedicines = medicineRepo.findAllSortedByName();
        List<MedicineResponse> medicineResponses = new utils.List<>();

        for (Medicine medicine : allMedicines) {
            StockInfo stockInfo = medicineStockService.getStockInfo(medicine.getMedicineID());
            medicineResponses.add(new MedicineResponse(medicine, stockInfo));
        }

        String json = gson.toJson(medicineResponses);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @GET
    @Path("/{id}")
    public Response getMedicine(@PathParam("id") String id) {
        Medicine medicine = medicineRepo.findById(id);
        if (medicine != null) {
            // Calculate current stock information
            StockInfo stockInfo = medicineStockService.getStockInfo(id);

            // Create a response object with calculated stock
            MedicineResponse response = new MedicineResponse(medicine, stockInfo);

            String json = gson.toJson(response);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity(new ErrorResponse("Medicine not found")).build();
        }
    }

    @GET
    @Path("/{id}/stock")
    public Response getMedicineStock(@PathParam("id") String id) {
        Medicine medicine = medicineRepo.findById(id);
        if (medicine != null) {
            StockInfo stockInfo = medicineStockService.getStockInfo(id);
            String json = gson.toJson(stockInfo);
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
    public Response deleteMedicine(@PathParam("id") String id) {
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

    @POST
    public Response createMedicine(Medicine medicine) {
        try {
            medicineRepo.create(medicine);
            String json = gson.toJson(medicine);
            return Response.status(Response.Status.CREATED)
                    .entity(json)
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error creating medicine: " + e.getMessage()))
                    .build();
        }
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

        medicine.setMedicineID(id);
        medicineRepo.update(medicine);
        String json = gson.toJson(medicine);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }



}
