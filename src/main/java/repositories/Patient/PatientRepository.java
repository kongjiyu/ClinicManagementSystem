package repositories.Patient;

import models.Consultation;
import models.Patient;
import models.Prescription;
import utils.ArrayList;

public interface PatientRepository {
  Patient findById(String id);
  ArrayList<Patient> findAll();
  void save(Patient patient);
  void update(Patient patient);
  void delete(Patient patient);

  // Extra methods based on API list
  ArrayList<Consultation> findMedicalHistoryByPatientId(String patientId);
}
