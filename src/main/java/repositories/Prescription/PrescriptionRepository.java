package repositories.Prescription;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import models.Prescription;
import utils.List;
import utils.MultiMap;

public interface PrescriptionRepository {
  void create(Prescription prescription);
  Prescription findById(String id);
  List<Prescription> findAll();
  List<Prescription> findByPatientId(String patientId);
  List<Prescription> findByMedicineId(String medicineId);
  List<Prescription> findByConsultationId(String consultationId);
  MultiMap<String, Prescription> groupByMedicineId();
  MultiMap<String, Prescription> groupByConsultationId();
  MultiMap<String, Prescription> groupByPatientId();
  void update(Prescription prescription);
  void delete(String id);

  List<Prescription> findHistory(String id);
  List<Prescription> findPrescriptionsByPatientId(String patientId);
  Prescription findByConsultationIdAndMedicineId(String consultationId, String medicineId);
  
  // Sorting methods
  List<Prescription> findAllSortedByDate();
  List<Prescription> findByPatientIdSorted(String patientId);
  List<Prescription> findByConsultationIdSorted(String consultationId);
}
