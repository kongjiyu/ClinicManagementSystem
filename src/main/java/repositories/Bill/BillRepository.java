package repositories.Bill;

/**
 * Author: Oh Wan Ting
 * Pharmacy Module
 */

import models.Bill;
import utils.List;
import java.time.LocalDate;

public interface BillRepository {
    void create(Bill bill);
    Bill findById(String billID);
    List<Bill> findAll();
    void update(Bill bill);
    void delete(String billID);
    
    // Additional filtering methods
    List<Bill> findByPatientId(String patientId);
    List<Bill> findByDate(LocalDate date);
    Bill findByConsultationId(String consultationId);
}
