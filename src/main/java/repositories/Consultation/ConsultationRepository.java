package repositories.Consultation;

/**
 * Author: Yap Yu Xin
 * Consultation Module
 */

import models.Consultation;
import utils.List;
import utils.MultiMap;

import java.time.LocalDate;

public interface ConsultationRepository {
    List<Consultation> getByStatus(String status);
    MultiMap<String, Consultation> groupByStatus();
    Consultation create(Consultation consultation);
    Consultation update(String id, Consultation consultation);
    boolean reschedule(String id, Consultation consultation);
    boolean cancel(String id);

    boolean updateStatus(String id, String status);
    List<Consultation> getUpcoming();
    boolean checkInPatient(String id);
    List<Consultation> findHistory(String id);
    boolean storeConsultationData(String id, Consultation consultation);
    List<Consultation> findAll();
    MultiMap<String, Consultation> groupByPatientID();
    Consultation findById(String id);
    List<Consultation> findByPatientID(String id);
    Consultation findByMcID(String id);
    List<Consultation> findAllMc();
    List<Consultation> findByMcStartDate(LocalDate startDate);
    List<Consultation> findByMcDuration(Integer duration);
    List<Consultation> findByMcDateRange(LocalDate startDate, LocalDate endDate);
    Consultation findByBillId(String billId);
    
    // Sorting methods
    List<Consultation> findAllSortedByDate();
    List<Consultation> getByStatusSorted(String status);
    List<Consultation> findPatientHistorySorted(String patientId);
  }
