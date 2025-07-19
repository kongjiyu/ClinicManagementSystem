package repositories.Supplier;

import models.Supplier;
import java.util.List;

public interface SupplierRepository {
    List<Supplier> findAll();
    Supplier findById(String id);
    void save(Supplier supplier);
    void update(String id, Supplier updatedSupplier);
    void delete(String id);
}
