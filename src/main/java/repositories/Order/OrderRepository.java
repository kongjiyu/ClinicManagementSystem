package repositories.Order;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import models.Order;
import utils.List;
import utils.MultiMap;

import java.time.LocalDate;

public interface OrderRepository {

    // Create
    void create(Order order);

    // Read
    List<Order> findAll();
    Order findById(String id);
    List<Order> findByStatus(String status);
    List<Order> findBySupplier(String supplierId);
    List<Order> findByMedicine(String medicineId);
    List<Order> findByExpireDate(LocalDate date);
    List<Order> findByExpireDateRange(LocalDate dateAfter, LocalDate dateBefore);

    MultiMap<String, Order> groupByOrderID();// using for all order
    MultiMap<String, Order> groupByOrderID(List<Order> orders);// only group the accepted order
    MultiMap<LocalDate, Order> groupByExpireDate();
    MultiMap<String, Order> groupBySupplier();// use when represent data in a table

    // Update
    void update(Order order);
    //void updateStatus(String orderId, String status);

    // Delete (optional)
    void delete(Order order);
}
