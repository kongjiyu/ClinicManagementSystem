package repositories.Staff;

/**
 * Author: Kong Ji Yu
 * Doctor Module
 */

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
  
  // Sorting method implementations
  @Override
  public List<Staff> findAllSortedByName() {
    List<Staff> staff = findAll();
    return (List<Staff>) staff.sort((a, b) -> {
      String nameA = (a.getFirstName() + " " + a.getLastName()).toLowerCase();
      String nameB = (b.getFirstName() + " " + b.getLastName()).toLowerCase();
      return nameA.compareTo(nameB); // Alphabetical order
    });
  }
  
  @Override
  public List<Staff> findAllSortedByPosition() {
    List<Staff> staff = findAll();
    return (List<Staff>) staff.sort((a, b) -> {
      if (a.getPosition() == null && b.getPosition() == null) return 0;
      if (a.getPosition() == null) return 1;
      if (b.getPosition() == null) return -1;
      return a.getPosition().compareToIgnoreCase(b.getPosition()); // Alphabetical by position
    });
  }
  
  @Override
  public List<Staff> findAllDoctorsSortedByName() {
    List<Staff> allStaff = findAll();
    List<Staff> doctors = new List<>();
    
    // Filter doctors only
    for (Staff staff : allStaff) {
      if ("Doctor".equalsIgnoreCase(staff.getPosition()) ||
          (staff.getMedicalLicenseNumber() != null && !staff.getMedicalLicenseNumber().trim().isEmpty())) {
        doctors.add(staff);
      }
    }
    
    // Sort doctors by name
    return (List<Staff>) doctors.sort((a, b) -> {
      String nameA = (a.getFirstName() + " " + a.getLastName()).toLowerCase();
      String nameB = (b.getFirstName() + " " + b.getLastName()).toLowerCase();
      return nameA.compareTo(nameB); // Alphabetical order
    });
  }
  
  @Override
  public List<Staff> findAllSortedByEmploymentDate() {
    List<Staff> staff = findAll();
    return (List<Staff>) staff.sort((a, b) -> {
      if (a.getEmploymentDate() == null && b.getEmploymentDate() == null) return 0;
      if (a.getEmploymentDate() == null) return 1;
      if (b.getEmploymentDate() == null) return -1;
      return b.getEmploymentDate().compareTo(a.getEmploymentDate()); // Newest first
    });
  }
}
