package repositories.Medicine;

import models.Medicine;
import utils.ArrayList;

import java.util.List;

public interface MedicineRepository {

  // Create
  void save(Medicine medicine);

  // Read
  ArrayList<Medicine> findAll();
  Medicine findById(String id);
  ArrayList<Medicine> findByName(String name);
  ArrayList<Medicine> findOutOfStock();
  ArrayList<Medicine> findBelowReorderLevel();

  // Update
  void update(Medicine medicine);
  //void updateStock(String medicineID, int newStock);

  // Delete (optional, if needed)
  void delete(Medicine medicine);
}
