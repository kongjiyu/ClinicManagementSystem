package repositories.Consultation;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;
import models.Patient;
import utils.ArrayList;
import utils.MultiMap;

import java.util.List;

@ApplicationScoped
@Transactional
public class ConsultationRepositoryImpl implements ConsultationRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public MultiMap<String, Consultation> groupByAvailability() {
    ArrayList<Consultation> consultations = findAll();
    MultiMap<String, Consultation> availabilityConsultationMap = new MultiMap<>();
    for(Consultation consultation : consultations){
      availabilityConsultationMap.put(consultation.getStatus(), consultation);
    }
    return availabilityConsultationMap;
  }

  @Override
  public ArrayList<Consultation> getAvailableSlots(){
    MultiMap<String, Consultation> availabilityConsultationMap = groupByAvailability();
    return availabilityConsultationMap.get("Done");
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

//  @Override
//  public List<Consultation> getUpcoming() {
//    return em.createQuery("SELECT c FROM Consultation c WHERE c.status = 'SCHEDULED'", Consultation.class)
//             .getResultList();
//  }

  @Override
  public ArrayList<Consultation> getUpcoming() {
    ArrayList<Consultation> consultations = findAll();
    ArrayList<Consultation> upcoming = new ArrayList<>();
    for (Consultation consultation : consultations) {
      if ("SCHEDULED".equalsIgnoreCase(consultation.getStatus())) {
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
  public ArrayList<Consultation> findHistory(String id) {
    MultiMap<String, Consultation> historyMap = groupByPatientID();
    return historyMap.get(id);
  }
  

  @Override
  public boolean storeConsultationData(String id, Consultation consultation) {
    Consultation existing = em.find(Consultation.class, id);
    if (existing != null) {
      existing.setSymptoms(consultation.getSymptoms());
      existing.setDiagnosis(consultation.getDiagnosis());
      existing.setFollowUpRequired(consultation.isFollowUpRequired());
      existing.setFollowUpDate(consultation.getFollowUpDate());
      existing.setStatus(consultation.getStatus());
      return true;
    }
    return false;
  }

  @Override
  public ArrayList<Consultation> findAll() {
    return new ArrayList<>(em.createQuery("SELECT c FROM Consultation c", Consultation.class)
      .getResultList());
  }

  public MultiMap<String, Consultation> groupByPatientID() {
    ArrayList<Consultation> consultations = findAll();
    MultiMap<String, Consultation> patientConsultationMap = new MultiMap<>();

    for (Consultation consultation : consultations) {
      String patientID = consultation.getPatientID();
      patientConsultationMap.put(patientID, consultation);
    }

    return patientConsultationMap;
  }


}
