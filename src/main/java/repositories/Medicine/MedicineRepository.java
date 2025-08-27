package repositories.Medicine;

import models.Medicine;
import utils.List;

public interface MedicineRepository {

  // Create
  void create(Medicine medicine);

  // Read
  List<Medicine> findAll();
  Medicine findById(String id);
  List<Medicine> findByName(String name);
  List<Medicine> findOutOfStock();
  List<Medicine> findBelowReorderLevel();

  // Update
  void update(Medicine medicine);
  //void updateStock(String medicineID, int newStock);

  // Delete (optional, if needed)
  void delete(Medicine medicine);
  
  // Sorting methods
  List<Medicine> findAllSortedByName();
  List<Medicine> findAllSortedByStock();
  List<Medicine> findLowStockSorted();
}
