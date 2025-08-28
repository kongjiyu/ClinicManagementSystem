package repositories.Patient;

/**
 * Author: Yap Ern Tong
 * Patient Module
 */

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
import models.Prescription;
import repositories.Consultation.ConsultationRepository;
import repositories.Prescription.PrescriptionRepository;
import utils.List;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class PatientRepositoryImpl implements PatientRepository {

  @PersistenceContext
  private EntityManager em;

  @Inject
  private ConsultationRepository consultationRepository;

  @Inject
  private PrescriptionRepository prescriptionRepository;

  @Override
  public Patient findById(String id) {
    List<Patient> patients = findAll();
    for(Patient patient : patients){
      if(patient.getPatientID().equals(id)){
        return patient;
      }
    }
    return null;
  }

  @Override
  public List<Patient> findAll() {
      return new List<>(em.createQuery("select p from Patient p", Patient.class)
        .getResultList());
  }

  @Override
  public void create(Patient patient){
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
  public List<Prescription>  findPrescriptionHistoryByPatientId(String patientId) {
    return prescriptionRepository.findByPatientId(patientId);
  }
  
  // Sorting method implementations
  @Override
  public List<Patient> findAllSortedByName() {
    List<Patient> patients = findAll();
    return (List<Patient>) patients.sort((a, b) -> {
      String nameA = (a.getFirstName() + " " + a.getLastName()).toLowerCase();
      String nameB = (b.getFirstName() + " " + b.getLastName()).toLowerCase();
      return nameA.compareTo(nameB); // Alphabetical order
    });
  }
  
  @Override
  public List<Patient> findAllSortedByAge() {
    List<Patient> patients = findAll();
    return (List<Patient>) patients.sort((a, b) -> {
      return Integer.compare(a.getAge(), b.getAge()); // Youngest first
    });
  }
}
