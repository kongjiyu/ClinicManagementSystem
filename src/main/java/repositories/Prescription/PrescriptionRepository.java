package repositories.Prescription;

import models.Prescription;
import java.util.List;

public interface PrescriptionRepository {
  void save(Prescription prescription);
  Prescription findById(String id);
  List<Prescription> findAll();
  List<Prescription> findByPatientId(String patientId);
  void update(Prescription prescription);
  void delete(String id);
}
