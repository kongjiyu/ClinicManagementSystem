package repositories.Order;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Order;

import java.time.LocalDate;
import java.util.Iterator;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import utils.List;
import utils.MultiMap;
import utils.ArraySet;

@ApplicationScoped
@Transactional
public class OrderRepositoryImpl implements OrderRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Order> findAll() {
    return new List<>(em.createQuery("SELECT o FROM Order o", Order.class).getResultList());
  }

  @Override
  public Order findById(String id) {
    List<Order> orders = findAll();
    for(Order order : orders) {
      if(order.getOrdersID().equals(id)) {
        return order;
      }
    }
    return null;

  }

  @Override
  public List<Order> findByStatus(String status) {
    List<Order> orders = findAll();
    List<Order> matchedOrders = new List<>();

    for (Order order : orders) {
      if (order.getOrderStatus().equalsIgnoreCase(status)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  @Override
  public List<Order> findBySupplier(String supplierId) {
    MultiMap<String, Order> orderMap = groupBySupplier();
    if(orderMap.containsKey(supplierId)) {
      return orderMap.get(supplierId);
    }
    else {
      return null;
    }
  }

  @Override
  public List<Order> findByMedicine(String medicineId) {
    List<Order> orders = findAll();
    List<Order> matchedOrders = new List<>();

    for (Order order : orders) {
      if (order.getMedicineID().equals(medicineId)) {
        matchedOrders.add(order);
      }
    }

    return matchedOrders;
  }

  @Override
  public List<Order> findByExpireDate(LocalDate date) {
    MultiMap<LocalDate, Order> orderMap = groupByExpireDate();
    if(orderMap.containsKey(date)){
      return orderMap.get(date);
    }
    else {
      return null;
    }
  }

  @Override
  public List<Order> findByExpireDateRange(LocalDate dateAfter, LocalDate dateBefore) {
    MultiMap<LocalDate, Order> orderMap = groupByExpireDate();
    List<Order> result = new List<>();

    Iterator<LocalDate> keyIterator = orderMap.keyIterator();

    while (keyIterator.hasNext()) {
      LocalDate expireDate = keyIterator.next();

      if ((expireDate.isEqual(dateAfter) || expireDate.isAfter(dateAfter)) &&
              (expireDate.isEqual(dateBefore) || expireDate.isBefore(dateBefore))) {

        Iterator<Order> valuesIt = orderMap.valuesIterator(expireDate);
        while (valuesIt.hasNext()) {
          result.add(valuesIt.next());
        }
      }
    }

    return result;
  }

  @Override
  public MultiMap<String, Order> groupByOrderID(){
    MultiMap<String, Order> orderMap = new MultiMap<>();
    List<Order> orders = findAll();
    for (Order order : orders) {
      orderMap.put(order.getOrdersID(), order);
    }
    return orderMap;
  }

  @Override
  public MultiMap<String, Order> groupByOrderID(List<Order> orders){
    MultiMap<String, Order> orderMap = new MultiMap<>();
    for (Order order : orders) {
      orderMap.put(order.getOrdersID(), order);
    }
    return orderMap;
  }

  @Override
  public MultiMap<LocalDate, Order> groupByExpireDate(){
    MultiMap<LocalDate, Order> medicineExpireDateMap = new MultiMap<>();
    List<Order> orders = findAll();
    for (Order order : orders) {
      medicineExpireDateMap.put(order.getExpiryDate(), order);
    }
    return medicineExpireDateMap;
  }

  @Override
  public MultiMap<String, Order> groupBySupplier(){
    MultiMap<String, Order> supplierOrderMap = new MultiMap<>();
    List<Order> orders = findAll();
    for (Order order : orders) {
      supplierOrderMap.put(order.getSupplierID(), order);
    }
    return supplierOrderMap;
  }

  @Override
  public void create(Order order) {
    em.persist(order);
  }

  @Override
  public void update(Order order) {
    em.merge(order);
  }

  @Override
  public void delete(Order order) {em.remove(order);}
}
