package repositories.Medicine;

import jakarta.enterprise.context.ApplicationScoped;
import models.Medicine;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
@Transactional
public class MedicineRepositoryImpl implements MedicineRepository {

  @PersistenceContext
  private EntityManager em;

  @Transactional
  @Override
  public void save(Medicine medicine) {
    em.persist(medicine);
  }

  @Override
  public List<Medicine> findAll() {
    return em.createQuery("SELECT m FROM Medicine m", Medicine.class).getResultList();
  }

  @Override
  public Medicine findById(String id) {
    return em.find(Medicine.class, id);
  }

  @Override
  public List<Medicine> findByName(String name) {
    return em.createQuery("SELECT m FROM Medicine m WHERE m.medicineName LIKE :name", Medicine.class)
             .setParameter("name", "%" + name + "%")
             .getResultList();
  }

  @Override
  public List<Medicine> findOutOfStock() {
    return em.createQuery("SELECT m FROM Medicine m WHERE m.totalStock = 0", Medicine.class)
             .getResultList();
  }

  @Override
  public List<Medicine> findBelowReorderLevel() {
    return em.createQuery("SELECT m FROM Medicine m WHERE m.totalStock < m.reorderLevel", Medicine.class)
             .getResultList();
  }

  @Transactional
  @Override
  public void update(Medicine medicine) {
    em.merge(medicine);
  }

  @Transactional
  @Override
  public void updateStock(String medicineID, int newStock) {
    Medicine medicine = em.find(Medicine.class, medicineID);
    if (medicine != null) {
      medicine.setTotalStock(newStock);
      em.merge(medicine);
    }
  }

  @Transactional
  @Override
  public void delete(String id) {
    Medicine medicine = em.find(Medicine.class, id);
    if (medicine != null) {
      em.remove(medicine);
    }
  }
}
