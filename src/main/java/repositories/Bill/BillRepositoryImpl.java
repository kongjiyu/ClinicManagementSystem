package repositories.Bill;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Bill;
import models.Consultation;
import repositories.Consultation.ConsultationRepository;

import utils.List;
import utils.MultiMap;
import java.time.LocalDate;

@ApplicationScoped
@Transactional
public class BillRepositoryImpl implements BillRepository {

  @PersistenceContext
  private EntityManager em;

  @Inject
  private ConsultationRepository consultationRepo;

  @Override
  public void create(Bill bill) {
    em.persist(bill);
  }

  @Override
  public Bill findById(String billID) {
    List<Bill> bills=findAll();
    for (Bill bill : bills) {
      if (bill.getBillID().equals(billID)) {
        return bill;
      }
    }
    return null;
  }

  @Override
  public List<Bill> findAll() {
    return new List<>( em.createQuery("SELECT b FROM Bill b", Bill.class)
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

  @Override
  public List<Bill> findByPatientId(String patientId) {
    // Use ADT to group consultations by patient ID
    MultiMap<String, Consultation> consultationsByPatient = consultationRepo.groupByPatientID();

    // Get consultations for the specific patient
    List<Consultation> patientConsultations = consultationsByPatient.get(patientId);

    List<Bill> patientBills = new List<>();

    if (patientConsultations != null) {
      for (Consultation consultation : patientConsultations) {
        // Filter consultations that have a bill ID
        if (consultation.getBillID() != null && !consultation.getBillID().isEmpty()) {
          Bill bill = findById(consultation.getBillID());
          if (bill != null) {
            patientBills.add(bill);
          }
        }
      }
    }

    return patientBills;
  }



  @Override
  public List<Bill> findByDate(LocalDate date) {
    // Get all consultations using ADT
    List<Consultation> allConsultations = consultationRepo.findAll();

    List<Bill> dateBills = new List<>();

    for (Consultation consultation : allConsultations) {
      // Filter consultations by date and bill ID
      if (consultation.getConsultationDate() != null &&
          consultation.getConsultationDate().equals(date) &&
          consultation.getBillID() != null &&
          !consultation.getBillID().isEmpty()) {

        Bill bill = findById(consultation.getBillID());
        if (bill != null) {
          dateBills.add(bill);
        }
      }
    }

    return dateBills;
  }

  @Override
  public Bill findByConsultationId(String consultationId) {
    Consultation consultation = consultationRepo.findById(consultationId);

    List<Bill> bills = findAll();
    for (Bill bill : bills) {
      if (bill.getBillID().equals(consultation.getBillID())) {
        return bill;
      }
    }
    return null;
  }
}
