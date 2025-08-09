package repositories.Bill;

import models.Bill;
import utils.List;

public interface BillRepository {
    void create(Bill bill);
    Bill findById(String billID);
    List<Bill> findAll();
    void update(Bill bill);
    void delete(String billID);
}
