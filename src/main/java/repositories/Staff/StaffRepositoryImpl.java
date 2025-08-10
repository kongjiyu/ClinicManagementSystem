package repositories.Staff;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Staff;

import utils.List;

@ApplicationScoped
@Transactional
public class StaffRepositoryImpl implements StaffRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Staff> findAll() {
    return new List<>(em.createQuery("SELECT s FROM Staff s", Staff.class).getResultList());
  }

  @Override
  public Staff findById(String id) {
    return em.find(Staff.class, id);
  }

  @Override
  public void create(Staff staff) {
    em.persist(staff);
  }

  @Override
  public void update(String id, Staff updatedStaff) {
    em.merge(updatedStaff);
  }

  @Override
  public void delete(String id) {
    Staff staff = em.find(Staff.class, id);
    if (staff != null) {
      em.remove(staff);
    }
  }
}
