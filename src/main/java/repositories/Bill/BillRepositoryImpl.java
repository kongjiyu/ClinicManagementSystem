package repositories.Bill;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Bill;

import utils.ArrayList;
import java.util.List;

@ApplicationScoped
@Transactional
public class BillRepositoryImpl implements BillRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public void create(Bill bill) {
    em.persist(bill);
  }

  @Override
  public Bill findById(String billID) {
    ArrayList<Bill> bills=findAll();
    for (Bill bill : bills) {
      if (bill.getBillID().equals(billID)) {
        return bill;
      }
    }
    return null;
  }

  @Override
  public ArrayList<Bill> findAll() {
    return new ArrayList<>( em.createQuery("SELECT b FROM Bill b", Bill.class)
            .getResultList());
  }

  @Override
  public void update(Bill bill) {
    em.merge(bill);
  }

  @Override
  public void delete(String billID) {
    Bill bill = em.find(Bill.class, billID);
    if (bill != null) {
        em.remove(bill);
    }
  }
}
