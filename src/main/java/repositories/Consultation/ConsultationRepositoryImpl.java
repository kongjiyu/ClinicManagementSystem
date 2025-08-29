package repositories.Consultation;

/**
 * Author: Chia Yu Xin
 * Consultation Module
 */

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;
import models.Patient;
import utils.List;
import utils.MultiMap;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@ApplicationScoped
@Transactional
public class ConsultationRepositoryImpl implements ConsultationRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public MultiMap<String, Consultation> groupByStatus() {
    List<Consultation> consultations = findAll();
    MultiMap<String, Consultation> consultationStatusMap = new MultiMap<>();
    for(Consultation consultation : consultations){
      consultationStatusMap.put(consultation.getStatus(), consultation);
    }
    return consultationStatusMap;
  }

  @Override
  public List<Consultation> getByStatus(String status){
    MultiMap<String, Consultation> consultationStatusMap = groupByStatus();
    return consultationStatusMap.get(status);
  }

  @Override
  public Consultation create(Consultation consultation) {
    em.persist(consultation);
    return consultation;
  }

  @Override
  public Consultation update(String id, Consultation consultation) {
    Consultation existing = em.find(Consultation.class, id);
    if (existing != null) {
      consultation.setConsultationID(id);
      return em.merge(consultation);
    }
    return null;
  }

  //Can remove
  @Override
  public boolean reschedule(String id, Consultation consultation) {
    Consultation existing = em.find(Consultation.class, id);
    if (existing != null) {
      existing.setConsultationDate(consultation.getConsultationDate());
      existing.setCheckInTime(consultation.getCheckInTime());
      return true;
    }
    return false;
  }

  @Override
  public boolean cancel(String id) {
    Consultation consultation = em.find(Consultation.class, id);
    if (consultation != null) {
      consultation.setStatus("CANCELLED");
      return true;
    }
    return false;
  }

  @Override
  public boolean updateStatus(String id, String status) {
    Consultation consultation = em.find(Consultation.class, id);
    if (consultation != null) {
      consultation.setStatus(status);
      return true;
    }
    return false;
  }

//  @Override
//  public List<Consultation> getUpcoming() {
//    return em.createQuery("SELECT c FROM Consultation c WHERE c.status = 'Scheduled'", Consultation.class)
//             .getResultList();
//  }

  @Override
  public List<Consultation> getUpcoming() {
    List<Consultation> consultations = findAll();
    List<Consultation> upcoming = new List<>();
    for (Consultation consultation : consultations) {
      if ("Scheduled".equalsIgnoreCase(consultation.getStatus())) {
        upcoming.add(consultation);
      }
    }
    return upcoming;
  }


  @Override
  public boolean checkInPatient(String id) {
    Consultation consultation = em.find(Consultation.class, id);
    if (consultation != null) {
      consultation.setStatus("CHECKED_IN");
      return true;
    }
    return false;
  }

//  @Override
//  public List<Consultation> findHistory(String id) {
//    return em.createQuery("SELECT c FROM Consultation c WHERE c.patient.patientID = :id", Consultation.class)
//             .setParameter("id", id)
//             .getResultList();
//  }

  @Override
  public List<Consultation> findHistory(String id) {
    MultiMap<String, Consultation> historyMap = groupByPatientID();
    return historyMap.get(id);
  }


  @Override
  public boolean storeConsultationData(String id, Consultation consultation) {
    Consultation existing = em.find(Consultation.class, id);
    if (existing != null) {
      existing.setSymptoms(consultation.getSymptoms());
      existing.setDiagnosis(consultation.getDiagnosis());
      existing.setStatus(consultation.getStatus());
      return true;
    }
    return false;
  }

  @Override
  public List<Consultation> findAll() {
    return new List<>(em.createQuery("SELECT c FROM Consultation c", Consultation.class)
      .getResultList());
  }

  public MultiMap<String, Consultation> groupByPatientID() {
    List<Consultation> consultations = findAll();
    MultiMap<String, Consultation> patientConsultationMap = new MultiMap<>();

    for (Consultation consultation : consultations) {
      String patientID = consultation.getPatientID();
      patientConsultationMap.put(patientID, consultation);
    }

    return patientConsultationMap;
  }

  @Override
  public Consultation findById(String id) {
    List<Consultation> consultations = findAll();
    for (Consultation consultation : consultations) {
      if (consultation.getConsultationID().equals(id)) {
        return consultation;
      }
    }
    return null;
  }

  @Override
  public List<Consultation> findByPatientID(String id) {
    MultiMap<String, Consultation> patientConsultationMap = groupByPatientID();
    if(patientConsultationMap.containsKey(id)){
      return patientConsultationMap.get(id);
    }
    else {
      return null;
    }
  }

  @Override
  public Consultation findByMcID(String id){
    List<Consultation> consultations = findAll();
    for (Consultation consultation : consultations) {
      if (consultation.getMcID().equals(id)) {
        return consultation;
      }
    }
    return null;
  }

  @Override
  public List<Consultation> findAllMc(){
    List<Consultation> consultations = findAll();
    List<Consultation> consultationWithMc = new List<>();
    for (Consultation consultation : consultations) {
      if (consultation.getMcID() != null) {
        consultationWithMc.add(consultation);
      }
    }
    return consultationWithMc;
  }

  @Override
  public List<Consultation> findByMcStartDate(LocalDate startDate){
    List<Consultation> consultations = findAll();
    List<Consultation> mcAtStartDate = new List<>();
    for (Consultation consultation : consultations) {
      if (consultation.getStartDate().isEqual(startDate)) {
        mcAtStartDate.add(consultation);
      }
    }
    return mcAtStartDate;
  }

  @Override
  public List<Consultation> findByMcDuration(Integer duration){
    List<Consultation> consultations = findAll();
    List<Consultation> consultationWithDuration = new List<>();
    for (Consultation consultation : consultations) {
      if (consultation.getStartDate() != null && consultation.getEndDate() != null) {
        long days = ChronoUnit.DAYS.between(consultation.getStartDate(), consultation.getEndDate());
        if (days == duration) {
          consultationWithDuration.add(consultation);
        }
      }
    }
    return consultationWithDuration;
  }

  @Override
  public List<Consultation> findByMcDateRange(LocalDate startDate, LocalDate endDate){
    List<Consultation> consultations = findAll();
    List<Consultation> consultationsInRange = new List<>();
    for (Consultation consultation : consultations) {
      if (consultation.getStartDate() != null &&
              consultation.getEndDate() != null &&
              !consultation.getEndDate().isBefore(startDate) &&
              !consultation.getStartDate().isAfter(endDate)) {
        consultationsInRange.add(consultation);
      }
    }
    return consultationsInRange;
  }

  @Override
  public Consultation findByBillId(String billId) {
    List<Consultation> consultations = findAll();
    for (Consultation consultation : consultations) {
      if (billId.equals(consultation.getBillID())) {
        return consultation;
      }
    }
    return null;
  }
  
  // Sorting method implementations
  @Override
  public List<Consultation> findAllSortedByDate() {
    List<Consultation> consultations = findAll();
    return (List<Consultation>) consultations.sort((a, b) -> {
      if (a.getConsultationDate() == null && b.getConsultationDate() == null) return 0;
      if (a.getConsultationDate() == null) return 1;
      if (b.getConsultationDate() == null) return -1;
      return b.getConsultationDate().compareTo(a.getConsultationDate()); // Newest first
    });
  }
  
  @Override
  public List<Consultation> getByStatusSorted(String status) {
    List<Consultation> consultations = getByStatus(status);
    return (List<Consultation>) consultations.sort((a, b) -> {
      if (a.getCheckInTime() == null && b.getCheckInTime() == null) return 0;
      if (a.getCheckInTime() == null) return 1;
      if (b.getCheckInTime() == null) return -1;
      return a.getCheckInTime().compareTo(b.getCheckInTime()); // Earliest check-in first (FIFO)
    });
  }
  
  @Override
  public List<Consultation> findPatientHistorySorted(String patientId) {
    List<Consultation> history = findByPatientID(patientId);
    if (history == null) {
      return new List<>();
    }
    return (List<Consultation>) history.sort((a, b) -> {
      if (a.getConsultationDate() == null && b.getConsultationDate() == null) return 0;
      if (a.getConsultationDate() == null) return 1;
      if (b.getConsultationDate() == null) return -1;
      return b.getConsultationDate().compareTo(a.getConsultationDate()); // Newest first for history
    });
  }

}
