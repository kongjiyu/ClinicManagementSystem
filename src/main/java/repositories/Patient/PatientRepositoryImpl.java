package repositories.Patient;

import jakarta.annotation.Resource;
import jakarta.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;
import java.sql.*;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Patient;
import utils.ArrayList;

@ApplicationScoped
@Transactional
public class PatientRepositoryImpl implements PatientRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public Patient findById(String id) {
    return em.find(Patient.class, id);
  }

  @Override
  public ArrayList<Patient> findAll() {
      return new ArrayList<>(em.createQuery("select p from Patient p", Patient.class)
        .getResultList());
  }

  @Override
  public void save(Patient patient){
    em.persist(patient);
  }

  @Override
  public void update(Patient patient) {
    em.merge(patient);
  }

  @Override
  public void delete(Patient patient) {
    em.remove(patient);
  }

  @Override
  public ArrayList<Patient> findMedicalHistoryByPatientId(String patientId) {
    return new ArrayList<>(em.createQuery("SELECT p FROM Patient p JOIN FETCH p.consultations WHERE p.patientID = :id", Patient.class)
             .setParameter("id", patientId)
             .getResultList());
  }

  @Override
  public ArrayList<Patient> findPrescriptionsByPatientId(String patientId) {
    return new ArrayList<>(em.createQuery("SELECT DISTINCT p FROM Patient p JOIN FETCH p.consultations c JOIN FETCH c.prescriptions WHERE p.patientID = :id", Patient.class)
             .setParameter("id", patientId)
             .getResultList());
  }
}
