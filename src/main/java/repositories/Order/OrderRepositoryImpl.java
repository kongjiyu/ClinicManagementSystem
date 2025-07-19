package repositories.Order;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Order;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@ApplicationScoped
@Transactional
public class OrderRepositoryImpl implements OrderRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public void save(Order order) {
    em.persist(order);
  }

  @Override
  public List<Order> findAll() {
    return em.createQuery("SELECT o FROM Order o", Order.class).getResultList();
  }

  @Override
  public Order findById(String id) {
    return em.find(Order.class, id);
  }

  @Override
  public List<Order> findByStatus(String status) {
    return em.createQuery("SELECT o FROM Order o WHERE o.orderStatus = :status", Order.class)
             .setParameter("status", status)
             .getResultList();
  }

  @Override
  public List<Order> findBySupplier(String supplierId) {
    return em.createQuery("SELECT o FROM Order o WHERE o.supplier.supplierId = :supplierId", Order.class)
             .setParameter("supplierId", supplierId)
             .getResultList();
  }

  @Override
  public List<Order> findByMedicine(String medicineId) {
    return em.createQuery("SELECT o FROM Order o WHERE o.medicine.medicineID = :medicineId", Order.class)
             .setParameter("medicineId", medicineId)
             .getResultList();
  }

  @Override
  public void update(Order order) {
    em.merge(order);
  }

  @Override
  public void updateStatus(String orderId, String status) {
    Order order = em.find(Order.class, orderId);
    if (order != null) {
      order.setOrderStatus(status);
      em.merge(order);
    }
  }

  @Override
  public void delete(String id) {
    Order order = em.find(Order.class, id);
    if (order != null) {
      em.remove(order);
    }
  }
}
