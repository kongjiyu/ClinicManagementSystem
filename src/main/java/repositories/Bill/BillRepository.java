package repositories.Bill;

import models.Bill;
import utils.ArrayList;

import java.util.List;

public interface BillRepository {
    void create(Bill bill);
    Bill findById(String billID);
    ArrayList<Bill> findAll();
    void update(Bill bill);
    void delete(String billID);
}
