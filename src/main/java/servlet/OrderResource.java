package servlet;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Order;
import models.Medicine;
import models.Supplier;
import models.Staff;
import repositories.Order.OrderRepository;
import repositories.Medicine.MedicineRepository;
import repositories.Supplier.SupplierRepository;
import repositories.Staff.StaffRepository;
import utils.ErrorResponse;
import utils.List;
import utils.ListAdapter;
import utils.TimeUtils;
import DTO.OrderWithDetailsDTO;
import DTO.StatusUpdateRequest;

import java.time.LocalDate;

@Path("/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Transactional
public class OrderResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
            .registerTypeAdapter(utils.List.class, new ListAdapter())
            .create();

    @Inject
    private OrderRepository orderRepo;

    @Inject
    private MedicineRepository medicineRepo;

    @Inject
    private SupplierRepository supplierRepo;

    @Inject
    private StaffRepository staffRepo;

    @POST
    public Response createOrder(Order order) {
        try {
            // Set order date to current date (Malaysia timezone)
            if (order.getOrderDate() == null) {
                order.setOrderDate(LocalDate.now());
            }

            // Set default status if not provided
            if (order.getOrderStatus() == null || order.getOrderStatus().isEmpty()) {
                order.setOrderStatus("Pending");
            }

            // Calculate total amount if not provided
            if (order.getTotalAmount() == 0 && order.getUnitPrice() > 0 && order.getQuantity() > 0) {
                order.setTotalAmount(order.getUnitPrice() * order.getQuantity());
            }

            orderRepo.create(order);
            String json = gson.toJson(order);
            return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error creating order: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    public Response getAllOrders() {
        try {
            List<Order> orders = orderRepo.findAll();
            List<OrderWithDetailsDTO> dtos = convertToDTOWithDetails(orders);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching orders: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getOrderById(@PathParam("id") String id) {
        try {
            Order order = orderRepo.findById(id);
            if (order != null) {
                OrderWithDetailsDTO dto = convertToDTOWithDetails(order);
                String json = gson.toJson(dto);
                return Response.ok(json, MediaType.APPLICATION_JSON).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Order not found"))
                        .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching order: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateOrder(@PathParam("id") String id, Order order) {
        try {
            Order existingOrder = orderRepo.findById(id);
            if (existingOrder == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Order not found"))
                        .build();
            }

            order.setOrdersID(id);
            orderRepo.update(order);
            String json = gson.toJson(order);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error updating order: " + e.getMessage()))
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteOrder(@PathParam("id") String id) {
        try {
            Order existingOrder = orderRepo.findById(id);
            if (existingOrder == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Order not found"))
                        .build();
            }

            orderRepo.delete(existingOrder);
            return Response.ok("{\"message\": \"Order deleted successfully\"}")
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error deleting order: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/status/{status}")
    public Response getOrdersByStatus(@PathParam("status") String status) {
        try {
            List<Order> orders = orderRepo.findByStatus(status);
            List<OrderWithDetailsDTO> dtos = convertToDTOWithDetails(orders);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching orders by status: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/supplier/{supplierId}")
    public Response getOrdersBySupplier(@PathParam("supplierId") String supplierId) {
        try {
            List<Order> orders = orderRepo.findBySupplier(supplierId);
            if (orders != null) {
                List<OrderWithDetailsDTO> dtos = convertToDTOWithDetails(orders);
                String json = gson.toJson(dtos);
                return Response.ok(json, MediaType.APPLICATION_JSON).build();
            } else {
                return Response.ok("[]", MediaType.APPLICATION_JSON).build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching orders by supplier: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/medicines/{medicineId}")
    public Response getOrdersByMedicine(@PathParam("medicineId") String medicineId) {
        try {
            List<Order> orders = orderRepo.findByMedicine(medicineId);
            List<OrderWithDetailsDTO> dtos = convertToDTOWithDetails(orders);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching orders by medicine: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}/status")
    public Response updateOrderStatus(@PathParam("id") String id, StatusUpdateRequest request) {
        try {
            Order order = orderRepo.findById(id);
            if (order == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Order not found"))
                        .build();
            }

            order.setOrderStatus(request.getStatus());
            
            // If order is completed, update medicine stock
            if ("Completed".equalsIgnoreCase(request.getStatus())) {
                updateMedicineStock(order);
            }

            orderRepo.update(order);
            String json = gson.toJson(order);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error updating order status: " + e.getMessage()))
                    .build();
        }
    }

    // Helper method to update medicine stock when order is received
    private void updateMedicineStock(Order order) {
        // Set the order's stock to the quantity when delivered
        order.setStock(order.getQuantity());
        
        // Update the medicine's total stock to include this new batch
        Medicine medicine = medicineRepo.findById(order.getMedicineID());
        if (medicine != null) {
            // Calculate total stock from all completed orders
            int totalStock = 0;
            List<Order> allOrders = orderRepo.findAll();
            for (Order o : allOrders) {
                if (o.getMedicineID().equals(order.getMedicineID()) && 
                    "Completed".equals(o.getOrderStatus())) {
                    totalStock += o.getStock();
                }
            }
            medicine.setTotalStock(totalStock);
            medicineRepo.update(medicine);
        }
    }

    // Helper method to convert Order to DTO with details
    private List<OrderWithDetailsDTO> convertToDTOWithDetails(List<Order> orders) {
        List<OrderWithDetailsDTO> dtos = new List<>();
        for (Order order : orders) {
            dtos.add(convertToDTOWithDetails(order));
        }
        return dtos;
    }

    private OrderWithDetailsDTO convertToDTOWithDetails(Order order) {
        // Get medicine information
        Medicine medicine = medicineRepo.findById(order.getMedicineID());
        String medicineName = medicine != null ? medicine.getMedicineName() : "Unknown Medicine";

        // Get supplier information
        Supplier supplier = supplierRepo.findById(order.getSupplierID());
        String supplierName = supplier != null ? supplier.getSupplierName() : "Unknown Supplier";

        // Get staff information
        Staff staff = staffRepo.findById(order.getStaffID());
        String staffName = staff != null ? 
            staff.getFirstName() + " " + staff.getLastName() : "Unknown Staff";

        return new OrderWithDetailsDTO(
            order.getOrdersID(),
            order.getMedicineID(),
            medicineName,
            order.getSupplierID(),
            supplierName,
            order.getStaffID(),
            staffName,
            order.getOrderDate(),
            order.getOrderStatus(),
            order.getUnitPrice(),
            order.getQuantity(),
            order.getTotalAmount(),
            order.getExpiryDate(),
            order.getStock()
        );
    }


}
