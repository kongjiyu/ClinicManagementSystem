package repositories.Patient;

import models.Patient;
import utils.ArrayList;

public interface PatientRepository {
  Patient findById(String id);
  ArrayList<Patient> findAll();
  void save(Patient patient);
  void update(Patient patient);
  void delete(Patient patient);

  // Extra methods based on API list
  ArrayList<Patient> findMedicalHistoryByPatientId(String patientId);
  ArrayList<Patient> findPrescriptionsByPatientId(String patientId);
}
