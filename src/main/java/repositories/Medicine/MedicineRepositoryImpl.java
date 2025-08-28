package repositories.Medicine;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import jakarta.enterprise.context.ApplicationScoped;
import models.Medicine;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import utils.List;

@ApplicationScoped
@Transactional
public class MedicineRepositoryImpl implements MedicineRepository {

  @PersistenceContext
  private EntityManager em;

  @Transactional
  @Override
  public void create(Medicine medicine) {
    em.persist(medicine);
  }

  @Override
  public List<Medicine> findAll() {
    return new List<>(em.createQuery("SELECT m FROM Medicine m", Medicine.class)
            .getResultList());
  }

  @Override
  public Medicine findById(String id) {
    List<Medicine> medicines = findAll();
    for(Medicine medicine: medicines) {
      if(medicine.getMedicineID().equals(id)) {
        return medicine;
      }
    }
    return null;
  }

  @Override
  public List<Medicine> findByName(String name) {
    List<Medicine> matchedMedicines = new List<>();
    List<Medicine> medicines = findAll();

    for (Medicine medicine : medicines) {
      if (medicine.getMedicineName().toLowerCase().contains(name.toLowerCase())) {
        matchedMedicines.add(medicine);
      }
    }
    return matchedMedicines;
  }

  @Override
  public List<Medicine> findOutOfStock() {
    List<Medicine> medicines = findAll();
    List<Medicine> outOfStock = new List<>();

    for (Medicine medicine : medicines) {
      if (medicine.getTotalStock() == 0) {
        outOfStock.add(medicine);
      }
    }

    return outOfStock;
  }

  @Override
  public List<Medicine> findBelowReorderLevel() {
    List<Medicine> medicines = findAll();
    List<Medicine> belowReorder = new List<>();

    for (Medicine medicine : medicines) {
      if (medicine.getTotalStock() < medicine.getReorderLevel()) {
        belowReorder.add(medicine);
      }
    }

    return belowReorder;
  }

  @Transactional
  @Override
  public void update(Medicine medicine) {
    em.merge(medicine);
  }

//  @Transactional
//  @Override
//  public void updateStock(String medicineID, int newStock) {
//    Medicine medicine = em.find(Medicine.class, medicineID);
//    if (medicine != null) {
//      medicine.setTotalStock(newStock);
//      em.merge(medicine);
//    }
//  }

  @Override
  public void delete(Medicine medicine) {
    em.remove(medicine);
  }
  
  // Sorting method implementations
  @Override
  public List<Medicine> findAllSortedByName() {
    List<Medicine> medicines = findAll();
    return (List<Medicine>) medicines.sort((a, b) -> {
      if (a.getMedicineName() == null && b.getMedicineName() == null) return 0;
      if (a.getMedicineName() == null) return 1;
      if (b.getMedicineName() == null) return -1;
      return a.getMedicineName().compareToIgnoreCase(b.getMedicineName()); // Alphabetical order
    });
  }
  
  @Override
  public List<Medicine> findAllSortedByStock() {
    List<Medicine> medicines = findAll();
    return (List<Medicine>) medicines.sort((a, b) -> {
      return Integer.compare(a.getTotalStock(), b.getTotalStock()); // Lowest stock first
    });
  }
  
  @Override
  public List<Medicine> findLowStockSorted() {
    List<Medicine> lowStock = findBelowReorderLevel();
    return (List<Medicine>) lowStock.sort((a, b) -> {
      return Integer.compare(a.getTotalStock(), b.getTotalStock()); // Lowest stock first
    });
  }
}
