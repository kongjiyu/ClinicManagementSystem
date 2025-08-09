package repositories.Patient;

import models.Consultation;
import models.Patient;
import models.Prescription;
import utils.List;

public interface PatientRepository {
  Patient findById(String id);
  List<Patient> findAll();
  void create(Patient patient);
  void update(Patient patient);
  void delete(Patient patient);

  // Extra methods based on API list
  List<Consultation> findMedicalHistoryByPatientId(String patientId);
}
