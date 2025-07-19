package repositories.Consultation;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;

import java.util.List;

@ApplicationScoped
@Transactional
public class ConsultationRepositoryImpl implements ConsultationRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Consultation> getAvailableSlots() {
    return em.createQuery("SELECT c FROM Consultation c WHERE c.status = 'AVAILABLE'", Consultation.class)
             .getResultList();
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
  public List<Consultation> getUpcoming() {
    return em.createQuery("SELECT c FROM Consultation c WHERE c.status = 'SCHEDULED'", Consultation.class)
             .getResultList();
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

  @Override
  public List<Consultation> findHistory(String id) {
    return em.createQuery("SELECT c FROM Consultation c WHERE c.patient.patientID = :id", Consultation.class)
             .setParameter("id", id)
             .getResultList();
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
}
