package repositories.Medicine;

import models.Medicine;
import java.util.List;

public interface MedicineRepository {

  // Create
  void save(Medicine medicine);

  // Read
  List<Medicine> findAll();
  Medicine findById(String id);
  List<Medicine> findByName(String name);
  List<Medicine> findOutOfStock();
  List<Medicine> findBelowReorderLevel();

  // Update
  void update(Medicine medicine);
  void updateStock(String medicineID, int newStock);

  // Delete (optional, if needed)
  void delete(String id);
}
