package repositories.Prescription;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Prescription;

import java.util.List;

@ApplicationScoped
@Transactional
public class PrescriptionRepositoryImpl implements PrescriptionRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public void save(Prescription prescription) {
    em.persist(prescription);
  }

  @Override
  public Prescription findById(String id) {
    return em.find(Prescription.class, id);
  }

  @Override
  public List<Prescription> findAll() {
    return em.createQuery("SELECT p FROM Prescription p", Prescription.class).getResultList();
  }

  @Override
  public List<Prescription> findByPatientId(String patientId) {
    return em.createQuery(
      "SELECT pr FROM Prescription pr WHERE pr.consultation.patient.patientID = :patientId",
      Prescription.class
    ).setParameter("patientId", patientId).getResultList();
  }

  @Override
  public void update(Prescription prescription) {
    em.merge(prescription);
  }

  @Override
  public void delete(String id) {
    Prescription prescription = em.find(Prescription.class, id);
    if (prescription != null) {
      em.remove(prescription);
    }
  }
}
