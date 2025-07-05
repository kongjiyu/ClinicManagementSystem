package repositories.Patient;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import models.Patient;

public class PatientRepositoryImpl {
  @PersistenceContext
  private EntityManager em;

  public Patient findByName(String name) {
    return em.find(Patient.class, name);
  }
}
