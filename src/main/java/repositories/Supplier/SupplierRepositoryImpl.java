package repositories.Supplier;

import models.Supplier;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import utils.List;

@ApplicationScoped
@Transactional
public class SupplierRepositoryImpl implements SupplierRepository {
  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Supplier> findAll() {
    return new List<>(em.createQuery("SELECT s FROM Supplier s", Supplier.class).getResultList());
  }

  @Override
  public Supplier findById(String id) {
    List<Supplier> suppliers = findAll();
    for(Supplier supplier: suppliers){
      if(supplier.getSupplierId().equals(id)){
        return supplier;
      }
    }
    return null;
  }

  @Override
  public void create(Supplier supplier) {
    em.persist(supplier);
  }

  @Override
  public void update(Supplier updatedSupplier) {
    em.merge(updatedSupplier);
  }

  @Override
  public void delete(Supplier deletedSupplier) {
    em.remove(deletedSupplier);
  }
}
