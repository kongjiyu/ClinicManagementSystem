package repositories.Bill;

import models.Bill;
import java.util.List;

public interface BillRepository {
    void create(Bill bill);
    Bill findById(String billID);
    List<Bill> findAll();
    void update(Bill bill);
    void delete(String billID);
}
