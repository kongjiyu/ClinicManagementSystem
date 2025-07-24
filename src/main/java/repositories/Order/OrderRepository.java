package repositories.Order;

import models.Order;
import utils.ArrayList;
import utils.MultiMap;

import java.time.LocalDate;
import java.util.List;

public interface OrderRepository {

    // Create
    void save(Order order);

    // Read
    ArrayList<Order> findAll();
    Order findById(String id);
    ArrayList<Order> findByStatus(String status);
    ArrayList<Order> findBySupplier(String supplierId);
    ArrayList<Order> findByMedicine(String medicineId);
    ArrayList<Order> findByExpireDate(LocalDate date); // use when find a specific date

    MultiMap<String, Order> groupByOrderID();// using for all order
    MultiMap<String, Order> groupByOrderID(ArrayList<Order> orders);// only group the accepted order
    MultiMap<LocalDate, Order> groupByExpireDate();// use when represent data in a table
    MultiMap<String, Order> groupBySupplier();// use when represent data in a table

    // Update
    void update(Order order);
    //void updateStatus(String orderId, String status);

    // Delete (optional)
    void delete(Order order);
}
