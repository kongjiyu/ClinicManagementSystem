package repositories.Supplier;

import models.Supplier;

import java.util.List;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

@ApplicationScoped
@Transactional
public class SupplierRepositoryImpl implements SupplierRepository {
  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Supplier> findAll() {
    return em.createQuery("SELECT s FROM Supplier s", Supplier.class).getResultList();
  }

  @Override
  public Supplier findById(String id) {
    return em.find(Supplier.class, id);
  }

  @Override
  public void save(Supplier supplier) {
    em.persist(supplier);
  }

  @Override
  public void update(String id, Supplier updatedSupplier) {
    em.merge(updatedSupplier);
  }

  @Override
  public void delete(String id) {
    Supplier supplier = em.find(Supplier.class, id);
    if (supplier != null) {
      em.remove(supplier);
    }
  }
}
