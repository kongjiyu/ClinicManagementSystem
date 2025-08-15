package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Supplier;
import repositories.Supplier.SupplierRepository;
import utils.ErrorResponse;
import utils.List;
import utils.ListAdapter;

@Path("/suppliers")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class SupplierResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
            .registerTypeAdapter(utils.List.class, new ListAdapter())
            .create();

    @Inject
    private SupplierRepository supplierRepo;

    @GET
    @Path("/{id}")
    public Response getSupplier(@PathParam("id") String id) {
        Supplier supplier = supplierRepo.findById(id);
        if (supplier != null) {
            String json = gson.toJson(supplier);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Supplier not found"))
                    .build();
        }
    }

    @GET
    public Response getAllSupplier() {
        List<Supplier> suppliers = supplierRepo.findAll();
        String json = gson.toJson(suppliers);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @POST
    public Response createSupplier(Supplier supplier) {
       supplierRepo.create(supplier);
        String json = gson.toJson(supplier);
        return Response.status(Response.Status.CREATED)
                .entity(json)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }

    @PUT
    @Path("/{id}")
    public Response updateSupplier(@PathParam("id") String id, Supplier supplier) {
        Supplier existingSupplier = supplierRepo.findById(id);
        if (existingSupplier == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Supplier not found"))
                    .build();
        }

        supplierRepo.update(supplier);
        String json = gson.toJson(supplier);
        return Response.ok(json, MediaType.APPLICATION_JSON).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteSupplier(@PathParam("id") String id) {
        Supplier existingSupplier = supplierRepo.findById(id);
        if (existingSupplier == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Supplier not found"))
                    .build();
        }

        supplierRepo.delete(existingSupplier);
        return Response.ok("{\"message\": \"Supplier deleted successfully\"}")
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}
