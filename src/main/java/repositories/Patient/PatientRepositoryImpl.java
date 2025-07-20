package repositories.Patient;

import jakarta.annotation.Resource;
import jakarta.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;
import java.sql.*;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;
import models.Patient;
import repositories.Consultation.ConsultationRepository;
import utils.ArrayList;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class PatientRepositoryImpl implements PatientRepository {

  @PersistenceContext
  private EntityManager em;

  @Inject
  private ConsultationRepository consultationRepository;

  @Override
  public Patient findById(String id) {
    ArrayList<Patient> patients = findAll();
    for(Patient patient : patients){
      if(patient.getPatientID().equals(id)){
        return patient;
      }
    }
    return null;
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
  public ArrayList<Consultation> findMedicalHistoryByPatientId(String patientId) {
    MultiMap<String, Consultation> patientConsultationMap = consultationRepository.findAll();
    return patientConsultationMap.get(patientId);
  }

  @Override
  public ArrayList<Patient> findPrescriptionsByPatientId(String patientId) {
    return new ArrayList<>(em.createQuery("SELECT DISTINCT p FROM Patient p JOIN FETCH p.consultations c JOIN FETCH c.prescriptions WHERE p.patientID = :id", Patient.class)
             .setParameter("id", patientId)
             .getResultList());
  }


}
