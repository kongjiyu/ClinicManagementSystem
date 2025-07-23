package repositories.Supplier;

import models.Supplier;
import utils.ArrayList;

import java.util.List;

public interface SupplierRepository {
    ArrayList<Supplier> findAll();
    Supplier findById(String id);
    void save(Supplier supplier);
    void update(Supplier updatedSupplier);
    void delete(Supplier deletedSupplier);
}
