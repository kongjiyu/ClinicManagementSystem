package repositories.Order;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Order;

import java.time.LocalDate;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import utils.ArrayList;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class OrderRepositoryImpl implements OrderRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public ArrayList<Order> findAll() {
    return new ArrayList<>(em.createQuery("SELECT o FROM Order o", Order.class).getResultList());
  }

  @Override
  public Order findById(String id) {
    ArrayList<Order> orders = findAll();
    for(Order order : orders) {
      if(order.getOrdersID().equals(id)) {
        return order;
      }
    }
    return null;

  }

  @Override
  public ArrayList<Order> findByStatus(String status) {
    ArrayList<Order> orders = findAll();
    ArrayList<Order> matchedOrders = new ArrayList<>();

    for (Order order : orders) {
      if (order.getOrderStatus().equalsIgnoreCase(status)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  @Override
  public ArrayList<Order> findBySupplier(String supplierId) {
    ArrayList<Order> orders = findAll();
    ArrayList<Order> matchedOrders = new ArrayList<>();

    for (Order order : orders) {
      if (order.getSupplierID().equals(supplierId)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  @Override
  public ArrayList<Order> findByMedicine(String medicineId) {
    ArrayList<Order> orders = findAll();
    ArrayList<Order> matchedOrders = new ArrayList<>();

    for (Order order : orders) {
      if (order.getMedicineID().equals(medicineId)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  @Override
  public ArrayList<Order> findByExpireDate(LocalDate date) {
    ArrayList<Order> orders = findAll();
    ArrayList<Order> matchedOrders = new ArrayList<>();

    for (Order order : orders) {
      if (order.getExpiryDate().equals(date)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  public MultiMap<String, Order> groupByOrderID(){
    MultiMap<String, Order> orderMap = new MultiMap<>();
    ArrayList<Order> orders = findAll();
    for (Order order : orders) {
      orderMap.put(order.getOrdersID(), order);
    }
    return orderMap;
  }

  public MultiMap<String, Order> groupByOrderID(ArrayList<Order> orders){
    MultiMap<String, Order> orderMap = new MultiMap<>();
    for (Order order : orders) {
      orderMap.put(order.getOrdersID(), order);
    }
    return orderMap;
  }

  public MultiMap<LocalDate, Order> groupByExpireDate(){
    MultiMap<LocalDate, Order> medicineExpireDateMap = new MultiMap<>();
    ArrayList<Order> orders = findAll();
    for (Order order : orders) {
      medicineExpireDateMap.put(order.getExpiryDate(), order);
    }
    return medicineExpireDateMap;
  }

  public MultiMap<String, Order> groupBySupplier(){
    MultiMap<String, Order> supplierOrderMap = new MultiMap<>();
    ArrayList<Order> orders = findAll();
    for (Order order : orders) {
      supplierOrderMap.put(order.getSupplierID(), order);
    }
    return supplierOrderMap;
  }

  @Override
  public void save(Order order) {
    em.persist(order);
  }

  @Override
  public void update(Order order) {
    em.merge(order);
  }

  @Override
  public void delete(Order order) {em.remove(order);}
}
