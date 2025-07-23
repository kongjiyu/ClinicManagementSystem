package repositories.Medicine;

import jakarta.enterprise.context.ApplicationScoped;
import models.Medicine;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import utils.ArrayList;

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
  public ArrayList<Medicine> findAll() {
    return new ArrayList<>(em.createQuery("SELECT m FROM Medicine m", Medicine.class)
            .getResultList());
  }

  @Override
  public Medicine findById(String id) {
    ArrayList<Medicine> medicines = findAll();
    for(Medicine medicine: medicines) {
      if(medicine.getMedicineID().equals(id)) {
        return medicine;
      }
    }
    return null;
  }

  @Override
  public ArrayList<Medicine> findByName(String name) {
    ArrayList<Medicine> matchedMedicines = new ArrayList<>();
    ArrayList<Medicine> medicines = findAll();

    for (Medicine medicine : medicines) {
      if (medicine.getMedicineName().toLowerCase().contains(name.toLowerCase())) {
        matchedMedicines.add(medicine);
      }
    }
    return matchedMedicines;
  }

  @Override
  public ArrayList<Medicine> findOutOfStock() {
    ArrayList<Medicine> medicines = findAll();
    ArrayList<Medicine> outOfStock = new ArrayList<>();

    for (Medicine medicine : medicines) {
      if (medicine.getTotalStock() == 0) {
        outOfStock.add(medicine);
      }
    }

    return outOfStock;
  }

  @Override
  public ArrayList<Medicine> findBelowReorderLevel() {
    ArrayList<Medicine> medicines = findAll();
    ArrayList<Medicine> belowReorder = new ArrayList<>();

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

  @Transactional
  @Override
  public void delete(Medicine medicine) {em.remove(medicine);}
}
