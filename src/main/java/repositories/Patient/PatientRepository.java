package repositories.Patient;

import models.Patient;
import java.util.List;

public interface PatientRepository {
  Patient findById(String id);
  List<Patient> findAll();
  void save(Patient patient);
  void update(Patient patient);
  void delete(Patient patient);

  // Extra methods based on API list
  List<Patient> findMedicalHistoryByPatientId(String patientId);
  List<Patient> findPrescriptionsByPatientId(String patientId);
}
