package repositories.Order;

import models.Order;
import java.util.List;

public interface OrderRepository {

    // Create
    void save(Order order);

    // Read
    List<Order> findAll();
    Order findById(String id);
    List<Order> findByStatus(String status);
    List<Order> findBySupplier(String supplierId);
    List<Order> findByMedicine(String medicineId);

    // Update
    void update(Order order);
    void updateStatus(String orderId, String status);

    // Delete (optional)
    void delete(String id);
}
