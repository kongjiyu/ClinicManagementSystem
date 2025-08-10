package repositories.Supplier;

import models.Supplier;
import utils.List;

public interface SupplierRepository {
    List<Supplier> findAll();
    Supplier findById(String id);
    void create(Supplier supplier);
    void update(Supplier updatedSupplier);
    void delete(Supplier deletedSupplier);
}
